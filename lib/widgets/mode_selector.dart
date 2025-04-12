import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doublecam/providers/camera_provider.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraProvider>(
      builder: (context, provider, _) {
        return Container(
          height: 40,
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Group Photo Mode
              TextButton(
                onPressed: () {
                  if (provider.isRecording) return;
                  provider.setCaptureMode(CaptureMode.group);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    provider.isGroupMode ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                  ),
                ),
                child: Text(
                  'GROUP PHOTO',
                  style: TextStyle(
                    color: provider.isGroupMode ? Colors.blue : Colors.white,
                    fontWeight: provider.isGroupMode ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
              
              // Photo Mode
              TextButton(
                onPressed: () {
                  if (provider.isRecording) return;
                  provider.setCaptureMode(CaptureMode.photo);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    provider.isPhotoMode ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                  ),
                ),
                child: Text(
                  'PHOTO',
                  style: TextStyle(
                    color: provider.isPhotoMode ? Colors.blue : Colors.white,
                    fontWeight: provider.isPhotoMode ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
              
              // Video Mode
              TextButton(
                onPressed: () {
                  if (provider.isRecording) return;
                  provider.setCaptureMode(CaptureMode.video);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    provider.isVideoMode ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                  ),
                ),
                child: Text(
                  'VIDEO',
                  style: TextStyle(
                    color: provider.isVideoMode ? Colors.blue : Colors.white,
                    fontWeight: provider.isVideoMode ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
              
              // Switch Screen button
              TextButton(
                onPressed: () {
                  // Toggle which camera preview is on top
                  // This functionality would need to be added to the CameraProvider
                },
                child: const Text(
                  'SWITCH SCREEN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}