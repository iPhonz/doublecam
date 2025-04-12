import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

class MediaUtils {
  // Combine front and back camera images into a single split-screen image
  static Future<String> combineImages({
    required String frontPath,
    required String backPath,
    required int timestamp,
    required String directory,
  }) async {
    try {
      // Read front camera image
      final frontBytes = await File(frontPath).readAsBytes();
      final frontImage = img.decodeImage(frontBytes);
      
      if (frontImage == null) {
        throw Exception('Failed to decode front image');
      }
      
      // Read back camera image
      final backBytes = await File(backPath).readAsBytes();
      final backImage = img.decodeImage(backBytes);
      
      if (backImage == null) {
        throw Exception('Failed to decode back image');
      }
      
      // Get dimensions
      final width = frontImage.width;
      final height = frontImage.height * 2; // Double height for stacking
      
      // Create a new image for the combined result
      final combinedImage = img.Image(width: width, height: height);
      
      // Copy back camera image to top half
      for (int y = 0; y < backImage.height; y++) {
        for (int x = 0; x < backImage.width; x++) {
          combinedImage.setPixel(x, y, backImage.getPixel(x, y));
        }
      }
      
      // Copy front camera image to bottom half
      for (int y = 0; y < frontImage.height; y++) {
        for (int x = 0; x < frontImage.width; x++) {
          combinedImage.setPixel(x, y + backImage.height, frontImage.getPixel(x, y));
        }
      }
      
      // Create output file path
      final outputPath = path.join(directory, 'doublecam_${timestamp}.jpg');
      
      // Encode and save the combined image
      final encodedImage = img.encodeJpg(combinedImage, quality: 90);
      await File(outputPath).writeAsBytes(encodedImage);
      
      return outputPath;
    } catch (e) {
      debugPrint('Error combining images: $e');
      
      // If combining fails, return the back image as fallback
      return backPath;
    }
  }
  
  // Combine front and back camera videos into a single split-screen video
  static Future<String> combineVideos({
    required String frontPath,
    required String backPath,
    required int timestamp,
    required String directory,
  }) async {
    try {
      // Create output file path
      final outputPath = path.join(directory, 'doublecam_${timestamp}.mp4');
      
      // FFmpeg command to combine videos side by side
      final command = '''
        -i "$backPath" -i "$frontPath" 
        -filter_complex "[0:v]scale=iw:ih/2[top]; [1:v]scale=iw:ih/2[bottom]; [top][bottom]vstack=inputs=2[v]; [0:a]volume=1[a]" 
        -map "[v]" -map "[a]" 
        -c:v h264 -preset fast -crf 23 
        -c:a aac -b:a 128k 
        "$outputPath"
      ''';
      
      // Execute FFmpeg command
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();
      
      if (ReturnCode.isSuccess(returnCode)) {
        return outputPath;
      } else {
        debugPrint('FFmpeg process exited with error');
        return backPath; // Return back video as fallback
      }
    } catch (e) {
      debugPrint('Error combining videos: $e');
      
      // If combining fails, return the back video as fallback
      return backPath;
    }
  }
  
  // Format recording duration as HH:MM:SS
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
  
  // Get thumbnail from video file
  static Future<File?> getVideoThumbnail(String videoPath) async {
    try {
      final thumbnailPath = videoPath.replaceAll('.mp4', '_thumb.jpg');
      
      // FFmpeg command to extract thumbnail
      final command = '''
        -i "$videoPath" 
        -ss 00:00:01 
        -vframes 1 
        "$thumbnailPath"
      ''';
      
      // Execute FFmpeg command
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();
      
      if (ReturnCode.isSuccess(returnCode)) {
        return File(thumbnailPath);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getting video thumbnail: $e');
      return null;
    }
  }
}
