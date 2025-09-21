# Code Generation Guide

## Freezed

This project uses the Freezed package to generate immutable data models.

### Features

- **Immutable Objects**
  - Objects cannot be modified once created
  - Development is done by copying existing objects with modifications and discarding the old ones

- **fromJson/toJson**
  - Essential methods for receiving data from the server
  - Freezed automatically implements these methods

- **Equality Check**
  - Objects are compared by their elements rather than just hashcode
  - Automatic implementation for element-wise comparison

### VSCode Extension Setup

Install the Freezed package by Blaxou.

### Creating Freezed Classes

Right-click on the desired directory to create a new Freezed class.

### Object Implementation

Add properties to the factory constructor's parameters:
- Use `required` for mandatory properties
- Use nullable type `?` for nullable properties

Field names are reflected directly in fromJson/toJson methods.

#### Example with Server JSON Response

```json
{
  "id": 1,
  "nickname": "Bob",
  "result": null,
  "profile_image": "https://..."
}
```

#### Corresponding Freezed Model

```dart
@freezed
class User with _$User {
  factory User({
    required int id,
    required String nickname,
    ResultType? result,
    @Default("") String profile_image,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}
```

**Important Notes:**
- Keep field names exactly as they appear in the JSON (e.g., `profile_image`)
- `@Default("")` annotation provides a default value when the field is missing

## Code Generation

### Running Code Generation

After modifying or adding model classes, run the following command:

```bash
flutter pub run build_runner build
```

### VSCode Extension for Code Generation

Install the package by Gaëtan Schwartz.

#### Keyboard Shortcuts
- **CTRL+SHIFT+B** (Mac: CMD+SHIFT+B): Run `build_runner build`
- **CTRL+ALT+B** (Mac: CMD+ALT+B): Run `build_runner build` with `--build-filter` for selected file only (much faster)

### Code Generation Workflow

1. Make changes to your model files
2. Open the modified file
3. Use **CTRL+ALT+B** (Mac: CMD+ALT+B) to rebuild only the selected file
4. If full rebuild is needed (e.g., after `flutter clean`), use **CTRL+SHIFT+B** (Mac: CMD+SHIFT+B)

### Important Warning

**Never modify generated code files** (`.g.dart`, `.freezed.dart` files)