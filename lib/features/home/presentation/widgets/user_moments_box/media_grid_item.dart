import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// A single media item widget for grid display
/// Can be reused in any media grid/gallery
class MediaGridItem extends StatelessWidget {
  final XFile file;
  final VoidCallback onRemove;
  final BorderRadius? borderRadius;
  final bool showRemoveButton;
  final Color removeButtonColor;
  final double removeButtonSize;

  const MediaGridItem({
    super.key,
    required this.file,
    required this.onRemove,
    this.borderRadius,
    this.showRemoveButton = true,
    this.removeButtonColor = Colors.black54,
    this.removeButtonSize = 16,
  });

  bool get isVideo {
    final ext = file.path.toLowerCase();
    return ext.endsWith('.mp4') ||
        ext.endsWith('.mov') ||
        ext.endsWith('.avi') ||
        ext.endsWith('.mkv') ||
        ext.endsWith('.webm');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: isVideo
              ? Container(
                  color: Colors.brown.shade100,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.videocam,
                          size: 32,
                          color: Colors.brown.shade600,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Video',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.brown.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Image.file(File(file.path), fit: BoxFit.cover),
        ),
        if (showRemoveButton)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: removeButtonColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: removeButtonSize,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
