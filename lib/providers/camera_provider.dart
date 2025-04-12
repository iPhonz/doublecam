import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:doublecam/utils/media_utils.dart';

enum CaptureMode { photo, video, group }

class CameraProvider extends ChangeNotifier {
  CameraController? _frontController;
  CameraController? _backController;
  bool _isFrontCamInitialized = false;
  bool _isBackCamInitialized = false;
  bool _isRecording = false;
  bool _flashEnabled = false;
  CaptureMode _captureMode = CaptureMode.photo;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 8.0;
  double _currentZoom = 1.0;
  List<CameraDescription> _cameras = [];
  String? _lastMediaPath;
  Duration _recordingDuration = Duration.zero;
  bool _isSaving = false;
  bool _isPreviewing = false;
  
  // Getters
  CameraController? get frontController => _frontController;
  CameraController? get backController => _backController;
  bool get isFrontCamInitialized => _isFrontCamInitialized;
  bool get isBackCamInitialized => _isBackCamInitialized;
  bool get isRecording => _isRecording;
  bool get flashEnabled => _flashEnabled;
  CaptureMode get captureMode => _captureMode;
  double get minAvailableZoom => _minAvailableZoom;
  double get maxAvailableZoom => _maxAvailableZoom;
  double get currentZoom => _currentZoom;
  String? get lastMediaPath => _lastMediaPath;
  Duration get recordingDuration => _recordingDuration;
  bool get isSaving => _isSaving;
  bool get isPreviewing => _isPreviewing;
  bool get areCamerasInitialized => _isFrontCamInitialized && _isBackCamInitialized;
  bool get isPhotoMode => _captureMode == CaptureMode.photo;
  bool get isVideoMode => _captureMode == CaptureMode.video;
  bool get isGroupMode => _captureMode == CaptureMode.group;
  
  // Initialize cameras
  Future<void> initializeCameras() async {
    // Request permissions first
    await requestPermissions();
    
    // Get available cameras
    _cameras = await availableCameras();
    
    // Find front camera
    final frontCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras.first,
    );
    
    // Find back camera
    final backCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => _cameras.last,
    );
    
    // Initialize front camera
    _frontController = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    
    try {
      await _frontController!.initialize();
      
      if (_frontController!.value.isInitialized) {
        // Get zoom range for front camera
        _minAvailableZoom = await _frontController!.getMinZoomLevel();
        _maxAvailableZoom = await _frontController!.getMaxZoomLevel();
        
        _isFrontCamInitialized = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error initializing front camera: $e');
    }
    
    // Initialize back camera
    _backController = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false, // Only use audio from one controller
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    
    try {
      await _backController!.initialize();
      
      if (_backController!.value.isInitialized) {
        _isBackCamInitialized = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error initializing back camera: $e');
    }
  }
  
  // Dispose cameras
  void disposeCameras() {
    _frontController?.dispose();
    _backController?.dispose();
    _isFrontCamInitialized = false;
    _isBackCamInitialized = false;
    notifyListeners();
  }
  
  // Toggle flash
  Future<void> toggleFlash() async {
    if (_backController != null && _backController!.value.isInitialized) {
      _flashEnabled = !_flashEnabled;
      await _backController!.setFlashMode(
        _flashEnabled ? FlashMode.torch : FlashMode.off,
      );
      notifyListeners();
    }
  }
  
  // Set zoom level
  Future<void> setZoom(double zoom) async {
    if (_backController != null && _backController!.value.isInitialized) {
      // Ensure zoom is within range
      zoom = zoom.clamp(_minAvailableZoom, _maxAvailableZoom);
      
      _currentZoom = zoom;
      await _backController!.setZoomLevel(zoom);
      
      // Also set zoom on front camera
      if (_frontController != null && _frontController!.value.isInitialized) {
        await _frontController!.setZoomLevel(zoom);
      }
      
      notifyListeners();
    }
  }
  
  // Change capture mode
  void setCaptureMode(CaptureMode mode) {
    if (_captureMode != mode) {
      _captureMode = mode;
      notifyListeners();
    }
  }
  
  // Take photo
  Future<String?> captureImage() async {
    if (!areCamerasInitialized) return null;
    
    try {
      _isSaving = true;
      notifyListeners();
      
      // Capture from both cameras
      final frontImage = await _frontController!.takePicture();
      final backImage = await _backController!.takePicture();
      
      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      // Combine images
      final combinedImagePath = await MediaUtils.combineImages(
        frontPath: frontImage.path,
        backPath: backImage.path,
        timestamp: timestamp,
        directory: directory.path,
      );
      
      // Save to gallery
      final result = await ImageGallerySaver.saveFile(combinedImagePath);
      
      _lastMediaPath = combinedImagePath;
      _isPreviewing = true;
      _isSaving = false;
      notifyListeners();
      
      return combinedImagePath;
    } catch (e) {
      debugPrint('Error capturing image: $e');
      _isSaving = false;
      notifyListeners();
      return null;
    }
  }
  
  // Start recording video
  Future<void> startRecording() async {
    if (!areCamerasInitialized || _isRecording) return;
    
    try {
      await _frontController!.startVideoRecording();
      await _backController!.startVideoRecording();
      
      _isRecording = true;
      _recordingDuration = Duration.zero;
      notifyListeners();
      
      // Start timer
      _startRecordingTimer();
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }
  
  // Stop recording video
  Future<String?> stopRecording() async {
    if (!_isRecording) return null;
    
    try {
      _isSaving = true;
      notifyListeners();
      
      final frontVideo = await _frontController!.stopVideoRecording();
      final backVideo = await _backController!.stopVideoRecording();
      
      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      // Combine videos
      final combinedVideoPath = await MediaUtils.combineVideos(
        frontPath: frontVideo.path,
        backPath: backVideo.path,
        timestamp: timestamp,
        directory: directory.path,
      );
      
      // Save to gallery
      final result = await ImageGallerySaver.saveFile(combinedVideoPath);
      
      _isRecording = false;
      _lastMediaPath = combinedVideoPath;
      _isPreviewing = true;
      _isSaving = false;
      notifyListeners();
      
      return combinedVideoPath;
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      _isRecording = false;
      _isSaving = false;
      notifyListeners();
      return null;
    }
  }
  
  // Recording timer
  void _startRecordingTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      
      if (_isRecording) {
        _recordingDuration = _recordingDuration + const Duration(seconds: 1);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    });
  }
  
  // Close preview
  void closePreview() {
    _isPreviewing = false;
    notifyListeners();
  }
  
  // Request required permissions
  Future<void> requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();
    final storageStatus = await Permission.storage.request();
    
    if (cameraStatus.isDenied || microphoneStatus.isDenied || storageStatus.isDenied) {
      debugPrint('Camera, microphone, or storage permission denied');
    }
  }
}
