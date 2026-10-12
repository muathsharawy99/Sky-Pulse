import 'dart:convert';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

import '../../extensions/unified_extensions.dart';
import 'base_shimmer.dart';

/// Disk-cached network image loader with corruption checks and retries.
/// Used by [CustomImage] for [ImageType.network] sources.
class CacheNetworkImage extends StatefulWidget {
  final String url;
  final double? height, width;
  final BoxBorder? border;
  final BoxFit fit;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final String? fallbackText;

  const CacheNetworkImage(
    this.url, {
    super.key,
    this.height,
    this.width,
    BoxFit? fit,
    this.color,
    this.borderRadius,
    this.border,
    this.fallbackText,
  }) : fit = fit ?? BoxFit.contain;

  @override
  State<CacheNetworkImage> createState() => _CacheNetworkImageState();
}

class _CacheNetworkImageState extends State<CacheNetworkImage> {
  final _dio = Dio();
  Directory? _cacheDirectory;
  bool _isLoading = true;
  String? _path;

  // Cached files older than a week get re-downloaded.
  static const int _maxCacheAge = 7;
  int _retryCount = 0;
  static const int _maxRetries = 2;
  bool _hasError = false;

  // Downloads (or reuses a cached copy of) the image at [url]. MD5 of the
  // URL is used as the filename.
  Future<String?> _downloadImage(String url) async {
    try {
      _isLoading = true;
      _hasError = false;
      if (mounted) setState(() {});

      _cacheDirectory ??= await getApplicationCacheDirectory();
      final fileName = md5.convert(utf8.encode(url)).toString();
      final savePath = '${_cacheDirectory!.path}/$fileName';

      final file = File(savePath);
      if (await file.exists()) {
        final fileStats = await file.stat();
        final age = DateTime.now().difference(fileStats.modified).inDays;

        if (age > _maxCacheAge) {
          await file.delete();
        } else {
          // Verify it's a real image before trusting the cached file.
          if (await _isValidImageFile(file)) {
            _isLoading = false;
            if (mounted) setState(() {});
            return _path = savePath;
          } else {
            await file.delete();
          }
        }
      }

      await _dio.download(url, savePath);

      final downloadedFile = File(savePath);
      if (await _isValidImageFile(downloadedFile)) {
        _isLoading = false;
        if (mounted) setState(() {});
        return _path = savePath;
      } else {
        await downloadedFile.delete();
        throw Exception('Downloaded file is corrupted');
      }
    } catch (e) {
      _hasError = true;
      _isLoading = false;
      if (mounted) setState(() {});
      return null;
    }
  }

  // Checks the file's magic-number header to confirm it's a real
  // JPEG/PNG/GIF/WebP, not a truncated/corrupted download.
  Future<bool> _isValidImageFile(File file) async {
    try {
      final fileSize = await file.length();

      if (fileSize == 0) return false;
      if (fileSize < 100) return false;

      final bytes = await file.openRead(0, 16).toList();
      final headerBytes = bytes.expand((x) => x).toList();

      if (headerBytes.isEmpty) return false;

      // JPEG: FF D8 FF
      if (headerBytes.length >= 3 &&
          headerBytes[0] == 0xFF &&
          headerBytes[1] == 0xD8 &&
          headerBytes[2] == 0xFF) {
        return true;
      }

      // PNG: 89 50 4E 47
      if (headerBytes.length >= 8 &&
          headerBytes[0] == 0x89 &&
          headerBytes[1] == 0x50 &&
          headerBytes[2] == 0x4E &&
          headerBytes[3] == 0x47) {
        return true;
      }

      // GIF: 47 49 46 38
      if (headerBytes.length >= 4 &&
          headerBytes[0] == 0x47 &&
          headerBytes[1] == 0x49 &&
          headerBytes[2] == 0x46 &&
          headerBytes[3] == 0x38) {
        return true;
      }

      // WebP: 52 49 46 46 (RIFF) + WEBP at offset 8
      if (headerBytes.length >= 12 &&
          headerBytes[0] == 0x52 &&
          headerBytes[1] == 0x49 &&
          headerBytes[2] == 0x46 &&
          headerBytes[3] == 0x46 &&
          headerBytes[8] == 0x57 &&
          headerBytes[9] == 0x45 &&
          headerBytes[10] == 0x42 &&
          headerBytes[11] == 0x50) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Deletes a bad cached file and retries the download, up to _maxRetries.
  Future<void> _handleCorruptedImage() async {
    if (_path != null) {
      try {
        final file = File(_path!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Error deleting corrupted file: $e');
        }
      }

      _path = null;

      if (_retryCount < _maxRetries) {
        _retryCount++;
        await _downloadImage(widget.url);
      } else {
        _hasError = true;
        _isLoading = false;
        if (mounted) setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _downloadImage(widget.url);
    _cleanupOldCache();
  }

  Future<void> _cleanupOldCache() async {
    try {
      _cacheDirectory ??= await getApplicationCacheDirectory();
      final dir = Directory(_cacheDirectory!.path);
      await for (final file in dir.list()) {
        if (file is File) {
          final stats = await file.stat();
          final age = DateTime.now().difference(stats.modified).inDays;
          if (age > _maxCacheAge) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error during cache cleanup: $e');
      }
    }
  }

  // Cached file ready -> show it; still downloading -> shimmer; else -> error.
  @override
  Widget build(BuildContext context) {
    if (_path != null && !_hasError) {
      return Image.file(
        File(_path!),
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
        color: widget.color,
        errorBuilder: (context, error, stackTrace) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleCorruptedImage();
          });
          return _buildLoadingWidget();
        },
      );
    } else if (_isLoading) {
      return _buildLoadingWidget();
    } else {
      return _buildErrorWidget();
    }
  }

  Widget _buildLoadingWidget() => Container(
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.zero,
        ),
        child: BaseShimmer(
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: context.hoverColor,
              borderRadius: widget.borderRadius ?? BorderRadius.zero,
            ),
          ),
        ),
      );

  Widget _buildErrorWidget() => Container(
        margin: EdgeInsets.all(AppSize.s3.w),
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(AppSize.s4.r),
          border: widget.fallbackText != null
              ? null
              : (widget.border ?? Border.all(color: context.borderLightColor)),
          color: widget.fallbackText != null ? context.placeholderColor : null,
        ),
        height: widget.height,
        width: widget.width,
        alignment: Alignment.center,
        child: widget.fallbackText != null
            ? Text(
                widget.fallbackText!,
                style: context.semiBold.copyWith(
                  fontSize: ((widget.height ?? 40) < (widget.width ?? 40)
                          ? (widget.height ?? 40)
                          : (widget.width ?? 40)) *
                      0.35,
                  color: context.onPrimary,
                ),
              )
            : Container(
                constraints: BoxConstraints(
                  maxWidth: AppSize.s30.w,
                  maxHeight: AppSize.s30.w,
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(Icons.broken_image, color: context.borderLightColor),
                ),
              ),
      );

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }
}
