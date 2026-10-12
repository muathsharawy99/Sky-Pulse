/// How a given image source string should be loaded/rendered — pure
/// classification logic, no widgets here. Used by [CustomImage] to pick
/// which rendering path (network/SVG/file/asset) applies to a given URL.
enum ImageType {
  network,
  networkSvg,
  assetSvg,
  file,
  asset,
  error;

  bool get isNetwork => this == network;
  bool get isAsset => this == asset;
  bool get isFile => this == file;
  bool get isError => this == error;
  bool get isNetworkSvg => this == networkSvg;
  bool get isAssetSvg => this == assetSvg;
}

ImageType resolveImageType(String? url, {bool isFile = false}) {
  if (url == null || url.trim().isEmpty) return ImageType.error;

  final normalizedUrl = url.trim();
  final uri = Uri.tryParse(normalizedUrl);
  final lowerUrl = normalizedUrl.toLowerCase();
  // Strip query/fragment before reading the extension.
  final cleanPath = lowerUrl.split('?').first.split('#').first;
  final extension = cleanPath.split('.').last;
  final isHttp =
      uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  final isLocalFile = isFile ||
      lowerUrl.startsWith('file://') ||
      normalizedUrl.startsWith('/') ||
      normalizedUrl.startsWith('./') ||
      normalizedUrl.startsWith('../');

  // Order matters: check HTTP+svg before plain HTTP.
  if (isHttp && extension == 'svg') return ImageType.networkSvg;
  if (isHttp) return ImageType.network;
  if (extension == 'svg') return ImageType.assetSvg;
  if (isLocalFile) return ImageType.file;
  return ImageType.asset;
}
