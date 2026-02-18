# Contributing to Costy

Thank you for considering contributing to Costy! 🎉

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:
- A clear title and description
- Steps to reproduce the issue
- Expected vs actual behavior
- Screenshots if applicable
- Device and OS information

### Suggesting Features

We welcome feature suggestions! Please:
- Check if the feature has already been suggested
- Provide a clear description of the feature
- Explain why it would be useful
- Include mockups or examples if possible

### Pull Requests

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/costy.git
   cd costy
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **Make your changes**
   - Follow the existing code style
   - Use the centralized theme system (see `lib/theme/app_theme.dart`)
   - Add comments for complex logic
   - Update documentation if needed

4. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   ```

5. **Commit your changes**
   ```bash
   git commit -m "Add amazing feature"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/amazing-feature
   ```

7. **Open a Pull Request**
   - Provide a clear description of the changes
   - Reference any related issues
   - Include screenshots for UI changes

## Code Style Guidelines

### Flutter/Dart Conventions

- Follow the official [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` to check for issues
- Run `dart format .` before committing
- Avoid unnecessary comments - code should be self-explanatory

### Theme System

Always use the centralized theme constants instead of hardcoded values:

✅ **Good:**
```dart
Container(
  color: AppColors.primary,
  padding: EdgeInsets.all(AppSpacing.lg),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(AppRadius.medium),
  ),
)
```

❌ **Bad:**
```dart
Container(
  color: Color(0xFF137FEC),
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
  ),
)
```

### File Organization

```
lib/
├── main.dart
├── models/          # Data models
├── screens/         # Full-screen pages
├── widgets/         # Reusable components
├── services/        # Business logic & data services
├── utils/           # Utility functions & helpers
└── theme/           # Theme configuration
```

## Development Setup

1. **Install Flutter**
   - Follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install)

2. **Clone and setup**
   ```bash
   git clone https://github.com/yourusername/costy.git
   cd costy
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## What to Work On

Check the [Issues](https://github.com/yourusername/costy/issues) page for:
- `good first issue` - Great for newcomers
- `help wanted` - We'd love your help on these
- `bug` - Bug fixes are always appreciated
- `enhancement` - New features to implement

## Questions?

Feel free to open an issue with the `question` label if you need help!

## Code of Conduct

Be respectful and constructive. We're all here to build something great together! 🚀
