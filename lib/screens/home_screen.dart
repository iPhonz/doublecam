import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:doublecam/providers/camera_provider.dart';
import 'package:doublecam/widgets/capture_button.dart';
import 'package:doublecam/widgets/camera_controls.dart';
import 'package:doublecam/widgets/mode_selector.dart';
import 'package:doublecam/widgets/preview_overlay.dart';
import 'package:doublecam/utils/media_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late CameraProvider _cameraProvider;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize cameras after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cameraProvider = Provider.of<CameraProvider>(context, listen: false);
      _cameraProvider.initializeCameras();
    });
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes
    if (state == AppLifecycleState.inactive) {
      // App is inactive, dispose cameras
      _cameraProvider.disposeCameras();
    } else if (state == AppLifecycleState.resumed) {
      // App is resumed, reinitialize cameras
      _cameraProvider.initializeCameras();
    }
  }
  
  // Build the timer display
  Widget _buildTimerDisplay() {
    return Consumer<CameraProvider>(
      builder: (context, provider, _) {
        final timeString = provider.isRecording
            ? MediaUtils.formatDuration(provider.recordingDuration)
            : '00:00:00';
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            timeString,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
  
  // Build the zoom indicator
  Widget _buildZoomIndicator() {
    return Consumer<CameraProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          child: Text(
            '${provider.currentZoom.toStringAsFixed(1)}x',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        );
      },
    );
  }
  
  // Build camera preview widgets
  Widget _buildCameraPreview() {
    return Consumer<CameraProvider>(
      builder: (context, provider, _) {
        if (!provider.areCamerasInitialized) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return Column(
          children: [
            // Back camera preview (top half)
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CameraPreview(provider.backController!),
              ),
            ),
            const SizedBox(height: 4),
            // Front camera preview (bottom half)
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CameraPreview(provider.frontController!),
              ),
            ),
          ],
        );
      },
    );
  }
  
  // Build upgrade banner
  Widget _buildUpgradeBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            '3 Minutes Max',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Upgrade',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer<CameraProvider>(
          builder: (context, provider, _) {
            return Stack(
              children: [
                // Camera preview
                _buildCameraPreview(),
                
                // Timer display
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _buildTimerDisplay(),
                  ),
                ),
                
                // Zoom indicator
                Positioned(
                  bottom: 140,
                  right: 16,
                  child: _buildZoomIndicator(),
                ),
                
                // Camera controls (capture button, gallery, settings, etc.)
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CameraControls(),
                ),
                
                // Mode selector
                const Positioned(
                  bottom: 120,
                  left: 0,
                  right: 0,
                  child: ModeSelector(),
                ),
                
                // Upgrade banner
                Positioned(
                  bottom: 140,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _buildUpgradeBanner(),
                  ),
                ),
                
                // Preview overlay
                if (provider.isPreviewing && provider.lastMediaPath != null)
                  PreviewOverlay(
                    mediaPath: provider.lastMediaPath!,
                    onClose: provider.closePreview,
                  ),
                
                // Loading overlay
                if (provider.isSaving)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
