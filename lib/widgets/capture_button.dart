import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doublecam/providers/camera_provider.dart';

class CaptureButton extends StatelessWidget {
  const CaptureButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraProvider>(
      builder: (context, provider, _) {
        // Handle tap based on current mode
        void onTap() {
          if (provider.captureMode == CaptureMode.photo) {
            provider.captureImage();
          } else if (provider.captureMode == CaptureMode.video) {
            if (provider.isRecording) {
              provider.stopRecording();
            } else {
              provider.startRecording();
            }
          }
        }

        return GestureDetector(
          onTap: provider.isSaving ? null : onTap,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            child: provider.isRecording
                ? const Icon(
                    Icons.stop,
                    color: Colors.white,
                    size: 32,
                  )
                : Container(),
          ),
        );
      },
    );
  }
}
