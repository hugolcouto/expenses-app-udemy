# Getting Started with the Expenses App

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.11.3 or higher)
- **Dart SDK** (included with Flutter)
- **Git**
- A code editor (VS Code, Android Studio, or IntelliJ IDEA)
- **Android SDK** (for Android development) or **Xcode** (for iOS development)

## Installation Steps

### 1. Set Up Flutter

If you haven't installed Flutter yet, follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).

Verify your installation:

```bash
flutter doctor
```

### 2. Clone or Navigate to the Project

```bash
cd /Users/hugolcouto/Estudos/Flutter/expenses
```

### 3. Install Dependencies

```bash
flutter pub get
```

This command reads the `pubspec.yaml` file and downloads all required packages.

## Project Dependencies

The project uses the following key dependencies:

| Package         | Version | Purpose                                  |
| --------------- | ------- | ---------------------------------------- |
| Flutter         | SDK     | Flutter framework                        |
| Dart            | 3.11.3+ | Dart language SDK                        |
| cupertino_icons | ^1.0.8  | iOS-style icon fonts                     |
| intl            | ^0.20.2 | Internationalization and date formatting |
| flutter_lints   | ^6.0.0  | Code quality and linting rules           |

### Understanding pubspec.yaml

The `pubspec.yaml` file is the configuration file for the project:

```yaml
name: expenses
description: "A new Flutter project."
version: 1.0.0+1

environment:
  sdk: ^3.11.3

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  intl: ^0.20.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

- **name**: Project identifier
- **version**: Semantic versioning (1.0.0 = major.minor.patch, +1 = build number)
- **environment**: Minimum SDK versions required
- **dependencies**: Packages your app uses
- **dev_dependencies**: Packages only used during development/testing

## Running the Application

### Run on iOS Simulator (macOS)

```bash
flutter run -d 'iPhone 14 Pro'
```

Or list available devices:

```bash
flutter devices
```

### Run on Android Emulator

```bash
flutter emulators --launch Pixel_5_API_30
flutter run
```

### Run in Debug Mode

```bash
flutter run
```

The app will hot-reload when you save file changes.

### Build for Production

**Android:**

```bash
flutter build apk
flutter build appbundle
```

**iOS:**

```bash
flutter build ios
```

## Project Structure

```
expenses/
├── lib/                          # Main application code
│   ├── main.dart                # Entry point and root widgets
│   ├── models/                  # Data models
│   │   └── transaction.dart     # Transaction DTO
│   └── components/              # UI components
│       ├── graph.dart
│       ├── transaction_form.dart
│       └── transaction_list.dart
├── test/                        # Unit and widget tests
├── assets/                      # Images, fonts, etc.
│   └── fonts/                   # Custom fonts
│       ├── Domine/
│       └── Quicksand/
├── android/                     # Android-specific code
├── ios/                         # iOS-specific code
├── linux/                       # Linux-specific code
├── macos/                       # macOS-specific code
├── windows/                     # Windows-specific code
├── web/                         # Web-specific code
├── pubspec.yaml                 # Project configuration
├── pubspec.lock                 # Dependency lock file
└── analysis_options.yaml        # Lint rules
```

## Custom Fonts

The project includes two custom fonts in the `assets/fonts/` directory:

- **Quicksand**: Primary font used throughout the app (configured in theme)
- **Domine**: Alternative font available for use

To use custom fonts in Flutter, ensure they're configured in `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: Quicksand
      fonts:
        - asset: assets/fonts/Quicksand/Quicksand-Regular.ttf
        - asset: assets/fonts/Quicksand/Quicksand-Bold.ttf
          weight: 700
    - family: Domine
      fonts:
        - asset: assets/fonts/Domine/Domine-Regular.ttf
```

## Useful Commands

| Command                                  | Purpose                 |
| ---------------------------------------- | ----------------------- |
| `flutter pub get`                        | Get dependencies        |
| `flutter pub upgrade`                    | Upgrade dependencies    |
| `flutter run`                            | Run in debug mode       |
| `flutter run --release`                  | Run in release mode     |
| `flutter analyze`                        | Analyze code for issues |
| `flutter format lib/`                    | Format code             |
| `flutter test`                           | Run tests               |
| `flutter clean`                          | Clean build artifacts   |
| `flutter pub get && flutter pub upgrade` | Full dependency refresh |

## Troubleshooting

### Issue: "Flutter not found"

**Solution**: Add Flutter to your PATH environment variable.

```bash
export PATH="$PATH:[FLUTTER_INSTALLATION_PATH]/bin"
```

### Issue: "Pod install failed" (iOS)

**Solution**:

```bash
cd ios
rm -rf Pods
rm Podfile.lock
cd ..
flutter pub get
flutter run
```

### Issue: "Android SDK not found"

**Solution**: Set up Android SDK path:

```bash
flutter config --android-sdk [ANDROID_SDK_PATH]
```

### Issue: Hot reload not working

**Solution**: Restart the application:

```bash
flutter run --no-fast-start
```

## Next Steps

1. Read [Project Architecture](./Architecture.md) to understand the project layout
2. Learn about [Widgets](./Widgets.md) - the building blocks of Flutter apps
3. Explore [Components](./Components.md) to understand each UI element
4. Study the [Theme System](./Themes.md) to customize styles
5. Check [Modals & Navigation](./Modals.md) for user interaction patterns

---

**Note**: The project uses Material Design 3, Flutter's latest design system. Make sure your understanding of Material guidelines aligns with the implementation.
