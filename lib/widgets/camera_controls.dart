import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doublecam/providers/camera_provider.dart';
import 'package:doublecam/widgets/capture_button.dart';

class CameraControls extends StatelessWidget {
  const CameraControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraProvider>(
      builder: (context, provider, _) {
        return Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Gallery thumbnail
              GestureDetector(
                onTap: () {
                  // Open gallery view
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    image: provider.lastMediaPath != null
                        ? DecorationImage(
                            image: FileImage(File(provider.lastMediaPath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: provider.lastMediaPath == null
                      ? const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              
              // Settings button
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Open settings dialog
                  _showSettingsDialog(context);
                },
              ),
              
              // Capture button
              const CaptureButton(),
              
              // Switch camera mode
              IconButton(
                icon: Icon(
                  provider.isPhotoMode ? Icons.videocam : Icons.photo_camera,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (provider.isRecording) return;
                  
                  if (provider.isPhotoMode) {
                    provider.setCaptureMode(CaptureMode.video);
                  } else {
                    provider.setCaptureMode(CaptureMode.photo);
                  }
                },
              ),
              
              // Flash toggle
              IconButton(
                icon: Icon(
                  provider.flashEnabled ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  provider.toggleFlash();
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Settings dialog
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.aspect_ratio),
              title: const Text('Resolution'),
              subtitle: const Text('High'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Timer'),
              subtitle: const Text('Off'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_on),
              title: const Text('Grid'),
              subtitle: const Text('Off'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Location tagging'),
              subtitle: const Text('Off'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}