# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Design System
Read @shadcn_guide.md

## Development Commands

### Environment Setup
- **Flutter Version Management**: This project uses FVM. Run `fvm use` to set the correct Flutter version (3.29.2)
- **Install Dependencies**: `flutter pub get`
- **Environment Variables**: Copy `.env` file for environment configuration

### Common Development Commands
- **Run App**: `flutter run`
- **Build APK**: `flutter build apk`
- **Build iOS**: `flutter build ios`
- **Run Tests**: `flutter test`
- **Analyze Code**: `flutter analyze`
- **Format Code**: `dart format .`

### Code Generation
This project uses code generation extensively:
- **Generate all**: `dart run build_runner build`
- **Watch for changes**: `dart run build_runner watch`
- **Clean and rebuild**: `dart run build_runner build --delete-conflicting-outputs`

Run code generation after modifying any files with `@freezed`, `@JsonSerializable()`, or other generation annotations.

## Architecture Overview

### State Management
- **Primary**: Riverpod for reactive state management using NotifierProvider pattern
- **Dependency Injection**: GetIt for service localization (access via ClassName.I)
- **Container**: Uses UncontrolledProviderScope with custom ProviderContainer
- **State Classes**: Use Freezed for immutable state with copyWith functionality
- **Provider Naming**: Omit "Notifier" suffix for cleaner provider names

### Navigation
- **Router**: GoRouter for declarative navigation
- **Service**: RouterService singleton manages routing configuration
- **Routes**: Defined in `lib/app/routing/router_service.dart` with Routes class constants

### API Architecture - Three Layer Pattern
- **UI Layer**: Widget code that handles BuildContext directly
- **Logic Layer**: Business logic using Riverpod providers (no BuildContext)
- **ApiService Layer**: Direct server communication returning Result<T> objects
- **HTTP Client**: Custom MyDio wrapper around Dio
- **Error Handling**: Result<T> pattern with fold, map, asyncMap methods (no try-catch needed)
- **Authentication**: AuthInterceptor automatically handles token management
- **Base URL**: Configured via `.env` file (API_ADDRESS)

### Service Layer Architecture
```
Service (main.dart)
├── ApiService (API calls)
├── AuthService (authentication)
├── SecureStorageService (secure local storage)
└── RouterService (navigation)
```

### Project Structure
```
lib/
├── app/
│   ├── api/          # API client, interceptors, error handling
│   ├── auth/         # Authentication logic and state
│   ├── extension/    # Dart extensions
│   ├── feature/      # Feature modules (home, error, etc.)
│   ├── model/        # Data models with Freezed
│   ├── routing/      # GoRouter configuration
│   └── service/      # Core services
├── main.dart         # App entry point
└── service.dart      # Service registration and initialization
```

### Data Models with Freezed
- **Immutability**: Objects cannot be modified, use copyWith for changes
- **Auto Generation**: fromJson/toJson methods automatically generated
- **Equality**: Deep equality checking implemented automatically
- **Field Naming**: Keep JSON field names exact (e.g., profile_image not profileImage)
- **Default Values**: Use @Default annotation for optional fields
- **Generated Files**: `.freezed.dart` and `.g.dart` files are auto-generated (never edit these)

### Key Patterns
- **Result Pattern**: API calls return `Result<T>` for consistent error handling
- **Service Locator**: GetIt.I for accessing singleton services
- **Feature-based Organization**: Each feature has its own directory with logic, state, and UI
- **Riverpod Providers**: State management organized by feature

## Environment Configuration
- **Environment File**: `.env` contains API_ADDRESS and other environment variables
- **Flutter Dotenv**: Environment variables loaded in Service.initEnv()
- **Secure Storage**: Sensitive data stored using flutter_secure_storage

## Coding Style Guide

### File Naming
- Use lowercase with underscores (e.g., `user_profile_screen.dart`)
- Use meaningful names that clearly indicate purpose
- Use feature name as prefix under the feature folder.

### Variable & Function Naming
- **Variables**: camelCase (e.g., `userId`, `userName`)
- **Functions**: camelCase starting with verb (e.g., `fetchUserData()`, `isValidEmail()`)
- **Classes**: PascalCase with nouns (e.g., `UserProfile`, `AuthService`)
- **Constants**: UPPER_CASE with underscores (e.g., `MAX_RETRY_COUNT`)

### Code Organization
- **Widget Separation**: Keep files under 150 lines by extracting widgets
- **Widget Tree Depth**: Avoid deeply nested widgets, extract into separate components

## Best Practices & Recommendations

### BuildContext Management
- **Never pass BuildContext to business logic layer**
- Show dialogs based on results from logic layer, not directly
- If passing ref, only use ref.read in business logic (ref.watch/select in widgets only)

### Memory Management
- **Always dispose resources** in StatefulWidget:
  - AnimationController, TextEditingController, ScrollController
  - FocusNode, StreamSubscription
- Call dispose in dispose() method to prevent memory leaks

### Responsive Layouts
- **Avoid fixed sizes** from design files
- Use MediaQuery, Expanded, Flexible for responsive design
- Use LayoutBuilder for parent constraints
- Use AspectRatio to maintain proportions

### Development Guidelines
- **Avoid print statements**: Use debugPrint or log instead
- **No try-catch needed**: Result pattern handles errors through interceptors
- **Widget rebuilds**: Use select to observe only needed state parts
- **Provider patterns**:
  - Use ref.watch for reactive rebuilds
  - Use ref.read for one-time reads and event handlers
  - Use ConsumerWidget when entire widget needs Riverpod
  - Use Consumer for partial widget dependencies
- **Do not modify or create "build_runner" generated code**
  - Do not create *.g.dart or .freezed.dart by hand.
  - Do use dart build commands.

## Testing
- **Test Framework**: Standard Flutter testing framework
- **Test Location**: Tests should be placed in `test/` directory
- **Run Tests**: `flutter test`
- **Linting**: Always run `flutter analyze` after completing tasks