import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PreviewOverlay extends StatefulWidget {
  final String mediaPath;
  final Function onClose;
  
  const PreviewOverlay({
    Key? key,
    required this.mediaPath,
    required this.onClose,
  }) : super(key: key);

  @override
  _PreviewOverlayState createState() => _PreviewOverlayState();
}

class _PreviewOverlayState extends State<PreviewOverlay> {
  VideoPlayerController? _videoController;
  bool _isVideo = false;
  
  @override
  void initState() {
    super.initState();
    _initializeMedia();
  }
  
  void _initializeMedia() {
    // Check if the media is a video
    final isVideoFile = widget.mediaPath.toLowerCase().endsWith('.mp4');
    
    setState(() {
      _isVideo = isVideoFile;
    });
    
    if (isVideoFile) {
      _videoController = VideoPlayerController.file(
        File(widget.mediaPath),
      );
      
      _videoController!.initialize().then((_) {
        setState(() {});
        _videoController!.play();
        _videoController!.setLooping(true);
      });
    }
  }
  
  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.9),
      child: Stack(
        children: [
          // Media preview
          Center(
            child: _isVideo
                ? _buildVideoPreview()
                : _buildImagePreview(),
          ),
          
          // Close button
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                widget.onClose();
              },
            ),
          ),
          
          // Action buttons
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.share,
                  label: 'Share',
                  onTap: () {
                    // Share media functionality
                  },
                ),
                _buildActionButton(
                  icon: Icons.edit,
                  label: 'Edit',
                  onTap: () {
                    // Edit media functionality
                  },
                ),
                _buildActionButton(
                  icon: Icons.delete,
                  label: 'Delete',
                  onTap: () {
                    // Delete media functionality
                    widget.onClose();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Build image preview
  Widget _buildImagePreview() {
    return InteractiveViewer(
      child: Image.file(
        File(widget.mediaPath),
        fit: BoxFit.contain,
      ),
    );
  }
  
  // Build video preview
  Widget _buildVideoPreview() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_videoController!),
          
          // Play/pause button
          GestureDetector(
            onTap: () {
              setState(() {
                if (_videoController!.value.isPlaying) {
                  _videoController!.pause();
                } else {
                  _videoController!.play();
                }
              });
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Build action button
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}