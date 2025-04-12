# DoubleCam

A mobile app that allows users to take split screen photos or videos using the front and back cameras simultaneously.

## Features

- Capture photos with front and back cameras simultaneously
- Record videos with split-screen view
- Easy switching between camera modes
- Save media to device gallery
- Multiple capture modes (Photo, Video, Group)
- Customizable interface

## Requirements

- Flutter 3.19 or higher
- iOS 12.0+ / Android API 21+
- Xcode 14.0+ (for iOS builds)
- Android Studio (for Android builds)

## Installation

1. Clone the repository
   ```
   git clone https://github.com/iPhonz/doublecam.git
   ```

2. Navigate to the project directory
   ```
   cd doublecam
   ```

3. Install dependencies
   ```
   flutter pub get
   ```

4. Run the app
   ```
   flutter run
   ```

## Build for Production

### iOS
```
flutter build ios --release
```

### Android
```
flutter build appbundle --release
```

## Privacy & Permissions

This app requires the following permissions:
- Camera access
- Microphone access
- Storage access (to save photos and videos)

## License

MIT License

## Attribution

Design inspired by the SPILL social media app.