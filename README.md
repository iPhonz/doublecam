# DoubleCam

DoubleCam is a powerful mobile application that allows users to capture photos and videos using both front and back cameras simultaneously. It creates split-screen content with the front camera (selfie) view on the bottom and the rear camera view on top.

![DoubleCam Logo](assets/images/splash.png)

## Features

- **Simultaneous Capture**: Take photos or record videos using both cameras at once
- **Split-Screen Layout**: View content with back camera on top, front camera on bottom
- **Multiple Modes**: Photo mode, Video mode, and Group mode
- **Smart Processing**: Automated image and video stitching
- **Camera Controls**: Flash control, zoom, and settings access
- **Media Gallery**: Easy access to captured photos and videos
- **Video Recording Timer**: Track recording duration with on-screen timer
- **Easy Sharing**: Share your split-screen content directly to social media

## Screenshots

(Coming soon)

## Installation

### From App Stores

- iOS App Store: (Coming soon)
- Google Play Store: (Coming soon)

### Development Build

1. Clone the repository:
   ```bash
   git clone https://github.com/iPhonz/doublecam.git
   ```

2. Navigate to the project directory:
   ```bash
   cd doublecam
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Requirements

- Flutter 3.19.0 or higher
- Dart 3.0.0 or higher
- iOS 12.0+ / Android API 21+
- Device with both front and back cameras

## Tech Stack

- **Flutter**: UI framework
- **Provider**: State management
- **Camera**: Device camera access
- **FFmpeg**: Video processing
- **Image**: Image manipulation
- **Path Provider**: File system access
- **Permission Handler**: Device permissions

## Architecture

DoubleCam follows a clean architecture pattern with:

- **Providers**: State management using the Provider package
- **Screens**: UI implementation
- **Widgets**: Reusable UI components
- **Utils**: Helper functions and utilities
- **Models**: Data models

## Privacy

DoubleCam is committed to user privacy:
- Camera and microphone access is used only for capture functionality
- No data is collected or shared with third parties
- All media is stored locally on the device

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- Design inspiration from the SPILL social media app
- The Flutter team for their excellent framework
- All our contributors and supporters

## Contact

For support or inquiries, please open an issue on GitHub.

---

Made with ❤️ by iPhonz
