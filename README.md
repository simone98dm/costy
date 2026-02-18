# Costy 💰

A beautiful and intuitive Flutter app for tracking your subscription expenses. Stay on top of your recurring payments with smart notifications, detailed insights, and an elegant dark theme interface.

## ✨ Features

- **📊 Dashboard** - View all your active subscriptions at a glance with an interactive donut chart
- **🔔 Smart Reminders** - Get notified before your subscriptions renew
- **📅 History** - Track both active and inactive subscriptions with filtering options
- **💳 Multiple Billing Cycles** - Support for daily, weekly, monthly, and yearly subscriptions
- **🎨 Beautiful UI** - Smooth animations and a modern dark theme interface
- **💾 Local Storage** - All data is stored securely on your device using SharedPreferences

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.10.8 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/costy.git
cd costy
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📱 Screenshots

<!-- Add your screenshots here -->

## 🏗️ Architecture

The app follows a clean architecture pattern with:

- **Models** - Data structures for subscriptions
- **Services** - Storage service using SharedPreferences
- **Screens** - Main UI screens (Dashboard, History, etc.)
- **Widgets** - Reusable UI components
- **Theme** - Centralized theme system for consistent styling
- **Utils** - Animation utilities and helpers

## 🎨 Theme System

Costy uses a centralized theme system for easy customization:

```dart
import 'package:costy/theme/app_theme.dart';

// Use predefined colors
Container(color: AppColors.primary)

// Use text styles
Text('Title', style: AppTextStyles.h1)

// Use spacing constants
SizedBox(height: AppSpacing.lg)
```

See [lib/theme/README.md](lib/theme/README.md) for complete documentation.

## 📦 Dependencies

- `shared_preferences` - Local data storage
- `google_fonts` - Manrope font family
- `intl` - Date and number formatting
- `uuid` - Generate unique IDs for subscriptions

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👨‍💻 Author

Built with ❤️ using Flutter

## 🙏 Acknowledgments

- Design inspiration from modern fintech apps
- Icons from Material Design Icons
- Font: Manrope by Google Fonts
