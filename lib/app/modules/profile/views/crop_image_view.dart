import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class CropImageView extends StatefulWidget {
  final dynamic imageSource; // Can be File (mobile) or Uint8List (web) or String (path)
  
  const CropImageView({
    super.key,
    required this.imageSource,
  });

  @override
  State<CropImageView> createState() => _CropImageViewState();
}

class _CropImageViewState extends State<CropImageView> {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey<ExtendedImageEditorState>();
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
      appBar: AppBar(
        title: Text(
          'Crop Avatar',
          style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
        ),
        backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
        iconTheme: IconThemeData(color: ThemeColors.getTextPrimary(isLightTheme)),
        elevation: 0,
        actions: [
          if (isProcessing)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ThemeColors.getPrimary(isLightTheme),
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _cropAndSave,
              child: Text(
                'Done',
                style: TextStyle(
                  color: ThemeColors.getTextPrimary(isLightTheme),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildImageEditor(isLightTheme),
            ),
            Container(
              padding: EdgeInsets.all(16.w),
              color: ThemeColors.getCardBackground(isLightTheme),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Adjust the image to crop',
                    style: TextStyle(
                      color: ThemeColors.getTextSecondary(isLightTheme),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(
                        icon: Icons.rotate_left,
                        onTap: () => editorKey.currentState?.rotate(right: false),
                        isLightTheme: isLightTheme,
                      ),
                      SizedBox(width: 16.w),
                      _buildActionButton(
                        icon: Icons.rotate_right,
                        onTap: () => editorKey.currentState?.rotate(right: true),
                        isLightTheme: isLightTheme,
                      ),
                      SizedBox(width: 16.w),
                      _buildActionButton(
                        icon: Icons.flip,
                        onTap: () => editorKey.currentState?.flip(),
                        isLightTheme: isLightTheme,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageEditor(bool isLightTheme) {
    if (kIsWeb) {
      // On web, imageSource is Uint8List
      if (widget.imageSource is Uint8List) {
        return ExtendedImage.memory(
          widget.imageSource as Uint8List,
          fit: BoxFit.contain,
          mode: ExtendedImageMode.editor,
          extendedImageEditorKey: editorKey,
          initEditorConfigHandler: (state) {
            return EditorConfig(
              maxScale: 8.0,
              cropRectPadding: EdgeInsets.all(20.0),
              hitTestSize: 20.0,
              cropAspectRatio: 1.0, // Square aspect ratio for avatar
              cornerColor: ThemeColors.getPrimary(isLightTheme),
              cornerSize: const Size(20, 5),
              lineColor: ThemeColors.getPrimary(isLightTheme),
              lineHeight: 0.6,
              editorMaskColorHandler: (context, pointerDown) {
                return ThemeColors.getScaffoldBackground(isLightTheme).withOpacity(0.8);
              },
            );
          },
        );
      }
    } else {
      // On mobile, imageSource is File
      if (widget.imageSource is File) {
        final file = widget.imageSource as File;
        return ExtendedImage.file(
          file as dynamic,
          fit: BoxFit.contain,
          mode: ExtendedImageMode.editor,
          extendedImageEditorKey: editorKey,
          initEditorConfigHandler: (state) {
            return EditorConfig(
              maxScale: 8.0,
              cropRectPadding: EdgeInsets.all(20.0),
              hitTestSize: 20.0,
              cropAspectRatio: 1.0, // Square aspect ratio for avatar
              cornerColor: ThemeColors.getPrimary(isLightTheme),
              cornerSize: const Size(20, 5),
              lineColor: ThemeColors.getPrimary(isLightTheme),
              lineHeight: 0.6,
              editorMaskColorHandler: (context, pointerDown) {
                return ThemeColors.getScaffoldBackground(isLightTheme).withOpacity(0.8);
              },
            );
          },
        );
      }
    }

    // Fallback
    return Center(
      child: Text(
        'Unable to load image',
        style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isLightTheme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: ThemeColors.getCardBackground(isLightTheme),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: ThemeColors.getTextSecondary(isLightTheme).withOpacity(0.2),
          ),
        ),
        child: Icon(
          icon,
          color: ThemeColors.getTextPrimary(isLightTheme),
          size: 24.sp,
        ),
      ),
    );
  }

  Future<void> _cropAndSave() async {
    if (isProcessing) return;

    final state = editorKey.currentState;
    if (state == null) {
      Get.snackbar(
        'Error',
        'Unable to crop image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      final rect = state.getCropRect();
      if (rect == null) {
        throw Exception('No crop area selected');
      }
      
      final action = state.editAction;
      final rotateAngle = action?.rotateAngle ?? 0;
      final flip = action?.flipY ?? false;

      // Get cropped image
      final croppedImage = await cropImageData(
        imageSource: widget.imageSource,
        rect: rect,
        rotateAngle: rotateAngle,
        flip: flip,
      );

      if (croppedImage != null) {
        Get.back(result: croppedImage);
      } else {
        throw Exception('Failed to crop image');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to crop image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }

  Future<dynamic> cropImageData({
    required dynamic imageSource,
    required Rect rect,
    required double rotateAngle,
    required bool flip,
  }) async {
    try {
      Uint8List imageBytes;

      // Get image bytes
      if (kIsWeb) {
        if (imageSource is Uint8List) {
          imageBytes = imageSource;
        } else {
          return null;
        }
      } else {
        if (imageSource is File) {
          imageBytes = await imageSource.readAsBytes();
        } else {
          return null;
        }
      }

      // Decode image
      final codec = await ui.instantiateImageCodec(imageBytes);
      final frame = await codec.getNextFrame();
      ui.Image image = frame.image;

      // Apply rotation and flip
      if (rotateAngle != 0 || flip) {
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder);
        final paint = Paint();

        // Calculate center
        final centerX = image.width / 2;
        final centerY = image.height / 2;

        canvas.translate(centerX, centerY);
        if (rotateAngle != 0) {
          canvas.rotate(rotateAngle * math.pi / 180);
        }
        if (flip) {
          canvas.scale(-1, 1);
        }
        canvas.translate(-centerX, -centerY);

        canvas.drawImage(image, Offset.zero, paint);
        final picture = recorder.endRecording();
        final rotatedImage = await picture.toImage(image.width, image.height);
        image.dispose();
        image = rotatedImage;
      }

      // Crop the image
      final croppedBytes = await _cropImageBytes(
        image: image,
        rect: rect,
      );

      image.dispose();

      if (kIsWeb) {
        return croppedBytes;
      } else {
        // Save to temporary file
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/cropped_avatar_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(croppedBytes);
        return file;
      }
    } catch (e) {
      print('Error cropping image: $e');
      return null;
    }
  }

  Future<Uint8List> _cropImageBytes({
    required ui.Image image,
    required Rect rect,
  }) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    // Calculate crop dimensions - ensure they're within image bounds
    final cropLeft = rect.left.clamp(0.0, image.width.toDouble());
    final cropTop = rect.top.clamp(0.0, image.height.toDouble());
    final cropWidth = math.min(rect.width, image.width - cropLeft);
    final cropHeight = math.min(rect.height, image.height - cropTop);

    final cropRect = Rect.fromLTWH(cropLeft, cropTop, cropWidth, cropHeight);

    // Draw cropped portion
    canvas.drawImageRect(
      image,
      cropRect,
      Rect.fromLTWH(0, 0, cropRect.width, cropRect.height),
      Paint(),
    );

    final picture = pictureRecorder.endRecording();
    final croppedImage = await picture.toImage(
      cropRect.width.toInt(),
      cropRect.height.toInt(),
    );
    picture.dispose();

    final byteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    croppedImage.dispose();

    if (byteData == null) {
      throw Exception('Failed to convert cropped image to bytes');
    }

    return byteData.buffer.asUint8List();
  }
}
