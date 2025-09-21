# Coding Style Guide

## File Naming Rules

- Use lowercase letters and underscores (_)
- Use meaningful names that clearly indicate the file's purpose

```dart
// Good examples
influencer_profile_screen.dart
product_matching_service.dart

// Bad examples
screen.dart
service.dart
```

## Variable Naming Rules

- Use camelCase for variables

```dart
// Good examples
int userId = 10;
String userName = 'John Doe';

// Bad examples
int userid = 10;
String username = 'John Doe';
```

## Function Naming Rules

- Use camelCase starting with lowercase
- Start with a verb to clearly indicate the function's action

```dart
// Good examples
void fetchUserData() { ... }
Future<List<Product>> getRecommendedProducts() { ... }
bool isValidEmail(String email) { ... }

// Bad examples
void data() { ... }
Future<List<Product>> products() { ... }
```

## Class Naming Rules

- Use PascalCase for classes
- Use nouns to clearly represent the object the class represents

```dart
// Good examples
class InfluencerProfile { ... }
class ProductService { ... }
class AuthenticationRepository { ... }

// Bad examples
class manage_users { ... }
class doThings { ... }
```

## Additional Guidelines

1. **Constants**: Use uppercase letters with underscores for static constants

```dart
const int MAX_RETRY_COUNT = 3;

List<String> categories = [
  'Fashion',
  'Beauty',
  'Lifestyle',
  'Tech',
];
```

2. **Indentation**: Use 2 spaces for indentation

3. **Comments**: Write comments only when necessary. Aim for self-explanatory code that doesn't require comments