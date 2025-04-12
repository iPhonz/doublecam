# Contributing to DoubleCam

Thank you for your interest in contributing to DoubleCam! This document provides guidelines and instructions for contributing to this project.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```
   git clone https://github.com/YOUR-USERNAME/doublecam.git
   ```
3. Add the original repository as an upstream remote:
   ```
   git remote add upstream https://github.com/iPhonz/doublecam.git
   ```
4. Create a new branch for your feature or bugfix:
   ```
   git checkout -b feature/your-feature-name
   ```

## Development Environment Setup

1. Install Flutter (version 3.19.0 or higher)
2. Install the required tools for your platform (Android Studio, Xcode, etc.)
3. Run `flutter pub get` to install dependencies
4. Run the app with `flutter run`

## Making Changes

1. Make your changes to the codebase
2. Write or modify tests as necessary
3. Make sure your code adheres to the project's style guidelines
4. Run tests with `flutter test`

## Committing Changes

1. Keep your changes focused and atomic
2. Write clear commit messages using present tense:
   ```
   Add feature X
   Fix bug in Y
   Update documentation for Z
   ```
3. Push your changes to your fork:
   ```
   git push origin feature/your-feature-name
   ```

## Submitting a Pull Request

1. Go to GitHub and create a new Pull Request from your feature branch
2. Provide a clear description of the changes and reference any related issues
3. Request a review from project maintainers
4. Be prepared to make additional changes if requested

## Style Guidelines

- Follow the [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Document public APIs with dartdoc comments
- Keep lines under 80 characters when possible

## Testing

- Write unit tests for new functionality
- Ensure all existing tests pass before submitting your PR
- Consider writing integration tests for UI components

## Code of Conduct

- Be respectful and inclusive in your communications
- Provide constructive feedback
- Help create a positive environment for all contributors

## Need Help?

If you need help with anything related to the project, please:
- Create an issue on GitHub
- Reach out to the maintainers

Thank you for contributing to DoubleCam!
