import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../extensions/unified_extensions.dart';
import '../enums/image_type.dart';
import 'cache_network_image.dart';

/// Network / SVG / file / asset image with disk-cached network loading
/// (trimmed port of the HopOn Driver `CustomImage`; [onTap] replaces the
/// "view full image" route).
class CustomImage extends StatelessWidget {
  final double? height, width;
  final String? url;
  final bool isFile;
  final BoxFit fit;
  final BoxBorder? border;
  final Widget? child;

  final Color? blurColor, color, backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final bool matchDirection;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final String? fallbackText;
  final String? fallbackName;

  const CustomImage(
    this.url, {
    super.key,
    this.height,
    this.width,
    this.isFile = false,
    this.borderRadius,
    BoxFit? fit,
    this.color,
    this.backgroundColor,
    this.border,
    this.child,
    bool? matchDirection,
    this.blurColor,
    this.padding,
    this.onTap,
    this.fallbackText,
    this.fallbackName,
  })  : fit = fit ?? BoxFit.contain,
        matchDirection = matchDirection ?? false;

  // "John Smith" -> "JS" — fallback shown when an image fails to load.
  static String? _initials(String? name) {
    if (name == null || name.trim().isEmpty) return null;
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length >= 2) {
      String i1 = words[0].isNotEmpty ? words[0] : '';
      String i2 = words[1].isNotEmpty ? words[1][0] : '';
      return (i1 + i2).toUpperCase();
    }
    final w = words[0];
    if (w.isEmpty) return null;
    return w.substring(0, 1).toUpperCase();
  }

  String? get _effectiveFallback => _initials(fallbackName ?? fallbackText);

  ImageType _getImageType() => resolveImageType(url, isFile: isFile);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.zero,
          color: backgroundColor,
          border: border,
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              _buildImage(context),
              if (blurColor != null)
                Container(
                  height: height,
                  width: width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius ?? BorderRadius.zero,
                    color: blurColor,
                  ),
                ),
              if (child != null) child!,
            ],
          ),
        ),
      ),
    );
  }

  // Dispatches to the right image widget based on source type.
  Widget _buildImage(BuildContext context) {
    switch (_getImageType()) {
      case ImageType.network:
        return CacheNetworkImage(
          url!,
          height: height,
          width: width,
          fit: fit,
          color: color,
          borderRadius: borderRadius,
          fallbackText: _effectiveFallback,
        );
      case ImageType.networkSvg:
        return SvgPicture.network(
          url!,
          height: height,
          width: width,
          fit: fit,
          placeholderBuilder: (context) =>
              Icon(Icons.broken_image, color: context.hoverColor),
        );
      case ImageType.assetSvg:
        return SvgPicture.asset(
          url!,
          height: height,
          matchTextDirection: matchDirection,
          width: width,
          fit: fit,
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        );
      case ImageType.file:
        return Image.file(
          File(url!),
          height: height,
          width: width,
          fit: fit,
          color: color,
          errorBuilder: (context, error, stackTrace) => _errorWidget(context),
        );
      case ImageType.asset:
        return Image.asset(
          url!,
          width: width,
          height: height,
          fit: fit,
          color: color,
          errorBuilder: (context, error, stackTrace) => _errorWidget(context),
        );
      case ImageType.error:
        return _errorWidget(context);
    }
  }

  Widget _errorWidget(BuildContext context) {
    final initials = _effectiveFallback;
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: initials != null
            ? null
            : (border ?? Border.all(color: context.hoverColor)),
        color: initials != null ? context.placeholderColor : null,
      ),
      height: height,
      width: width,
      alignment: Alignment.center,
      child: initials != null
          ? Text(
              initials,
              style: context.semiBold.copyWith(
                fontSize: (((height ?? 40) < (width ?? 40)
                        ? (height ?? 40)
                        : (width ?? 40)) *
                    0.35),
                color: context.onPrimary,
              ),
            )
          : FittedBox(
              fit: BoxFit.fill,
              child: Icon(
                Icons.broken_image_outlined,
                color: context.hoverColor,
                size: AppSize.s30.r,
              ),
            ),
    );
  }
}
