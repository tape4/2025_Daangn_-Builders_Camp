# Hankan - Space Rental & Storage Platform

A modern space rental and item storage platform built with Flutter, enabling users to find and rent storage spaces, manage their items, and connect with space providers.

## 🚀 Features

- **Space Rental**: Browse and rent available storage spaces
- **Item Storage Management**: Track and manage stored items
- **Real-time Chat**: Communicate with space providers via Sendbird
- **Location Services**: Find nearby spaces with integrated maps
- **Secure Authentication**: JWT-based authentication with secure storage
- **Profile Management**: Manage user profiles and preferences
- **FAQ & Support**: Built-in help and support system

## 📱 Screenshots

*(Add screenshots of your app here)*

## 🛠️ Tech Stack

### Frontend
- **Framework**: Flutter 3.5.4+
- **State Management**: Riverpod 2.6.1
- **Navigation**: GoRouter 14.8.1
- **UI Components**: Shadcn UI 0.15.0
- **HTTP Client**: Dio 5.8.0
- **Chat**: Sendbird SDK 4.5.2
- **Maps**: Flutter Map 7.0.2

### Key Libraries
- **Code Generation**: Freezed, JSON Serializable, Build Runner
- **Security**: Flutter Secure Storage
- **Location**: Geolocator, Geocoding
- **Firebase**: Firebase Core
- **Media**: Image Picker, Carousel Slider
- **Address Search**: Kpostal (Korean address search)

## 🏗️ Architecture

The project follows a clean three-layer architecture:

```
├── UI Layer (Widgets & Screens)
├── Logic Layer (Riverpod Providers)
└── API Service Layer (Dio & Interceptors)
```

### Project Structure

```
fe/
├── lib/
│   ├── app/
│   │   ├── api/          # API client, interceptors, error handling
│   │   ├── auth/         # Authentication logic and state
│   │   ├── extension/    # Dart extensions
│   │   ├── feature/      # Feature modules
│   │   │   ├── auth/     # Authentication screens
│   │   │   ├── home/     # Home screen and widgets
│   │   │   ├── space_rental/  # Space rental features
│   │   │   ├── item_storage/  # Item storage management
│   │   │   ├── profile_edit/  # Profile management
│   │   │   ├── history/  # Transaction history
│   │   │   ├── faq/      # FAQ section
│   │   │   └── error/    # Error handling screens
│   │   ├── model/        # Data models with Freezed
│   │   ├── routing/      # GoRouter configuration
│   │   └── service/      # Core services
│   ├── main.dart         # App entry point
│   └── service.dart      # Service registration
├── assets/               # Images, fonts, etc.
├── test/                # Unit and widget tests
└── pubspec.yaml         # Dependencies
```

## 🚦 Getting Started

### Prerequisites

- Flutter SDK 3.5.4 or higher
- Dart SDK
- FVM (Flutter Version Management) - optional but recommended
- Android Studio / Xcode for mobile development

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/builders-camp-team-14.git
cd builders-camp-team-14/fe
```

2. **Set Flutter version (if using FVM)**
```bash
fvm use
```

3. **Install dependencies**
```bash
flutter pub get
```

4. **Set up environment variables**
```bash
# Copy the .env.example to .env
cp .env.example .env
# Edit .env with your configuration
```

5. **Generate code**
```bash
dart run build_runner build --delete-conflicting-outputs
```

6. **Run the app**
```bash
flutter run
```

## 🔧 Development Commands

### Common Commands
- `flutter run` - Run the app in debug mode
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter test` - Run tests
- `flutter analyze` - Analyze code for issues
- `dart format .` - Format code

### Code Generation
- `dart run build_runner build` - Generate code once
- `dart run build_runner watch` - Watch and generate continuously
- `dart run build_runner build --delete-conflicting-outputs` - Clean and rebuild

## 🧪 Testing

Run tests with:
```bash
flutter test
```

For coverage report:
```bash
flutter test --coverage
```

## 📝 Code Style

- **File naming**: lowercase_with_underscores.dart
- **Classes**: PascalCase
- **Variables/Functions**: camelCase
- **Constants**: UPPER_CASE_WITH_UNDERSCORES
- Maximum file length: ~150 lines (extract widgets as needed)

## 🔐 Environment Configuration

Create a `.env` file in the `fe` directory with:

```env
API_ADDRESS=https://your-api-url.com
# Add other environment variables as needed
```

## 📦 State Management

The app uses Riverpod for state management with the following patterns:

- **NotifierProvider**: For complex state logic
- **FutureProvider**: For async data fetching
- **StateProvider**: For simple state
- **Result Pattern**: Consistent error handling without try-catch

Example:
```dart
// In widgets
ref.watch(myProvider);  // For reactive rebuilds
ref.read(myProvider);   // For one-time reads

// In logic layer
ref.read(myProvider);   // Never use watch in logic
```

## 🎨 UI Components

The app uses Shadcn UI for consistent design. Common components:

- `ShadButton` - Buttons with variants
- `ShadCard` - Card containers
- `ShadInput` - Form inputs
- `ShadDialog` - Modal dialogs
- `ShadToast` - Toast notifications

See [shadcn_guide.md](fe/shadcn_guide.md) for detailed usage.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Run tests and linting before committing
4. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
5. Push to the branch (`git push origin feature/AmazingFeature`)
6. Open a Pull Request

### Pre-commit Checklist
- [ ] Code is formatted (`dart format .`)
- [ ] Code passes analysis (`flutter analyze`)
- [ ] All tests pass (`flutter test`)
- [ ] Code generation is up to date
- [ ] No hardcoded secrets or API keys

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

Builders Camp Team 14

## 📞 Support

For support, please open an issue in the GitHub repository or contact the team.

## 🔄 Version History

- **0.1.0** - Initial release with core features

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Shadcn UI for the design system
- All contributors and testers

---

Built with ❤️ by Builders Camp Team 14