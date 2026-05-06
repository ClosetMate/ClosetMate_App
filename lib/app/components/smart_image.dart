import 'package:flutter/material.dart';

/// A smart image widget that automatically handles both asset paths and network URLs
class SmartImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const SmartImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  /// Check if the image path is an asset path
  bool get _isAssetPath {
    return imageUrl.startsWith('assets/');
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_isAssetPath) {
      // Use Image.asset for local assets
      // Note: Image.asset loads synchronously, so no loadingBuilder needed
      imageWidget = Image.asset(
        imageUrl,
        fit: fit ?? BoxFit.cover,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ??
              Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 50,
                ),
              );
        },
      );
    } else {
      // Use Image.network for network URLs
      imageWidget = Image.network(
        imageUrl,
        fit: fit ?? BoxFit.cover,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ??
              Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 50,
                ),
              );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ??
              Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
        },
      );
    }

    // Apply border radius if provided
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

