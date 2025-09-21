# API Handling Guide

## Overview
API handling is done through 3 layers:
- UI Layer ↔ Logic Layer ↔ ApiService

Error handling uses Result objects with Rust's Some/Error concepts, eliminating the need for try-catch blocks. Server errors are handled through interceptors and delivered as Result objects.

## UI Layer

The UI layer refers to code inside widgets that directly handles BuildContext.

### Key Rules
- **Never pass BuildContext to the business logic layer**
- Handle dialogs by receiving response results from the logic layer
- Routing should only be done in this layer

### Example Code

```dart
final res = await AuthService.I.setInquire( // res is bool
  title,
  text,
  phoneNum.formatPhoneNumber(),
);

if (res) {
  showCustomSuccessDialog(
    context: context,
    title: "1:1 문의 등록 완료!",
    content: "고객님의 문의내역이\n 정상적으로 접수되었습니다.",
    buttonText: "마이페이지로 돌아가기",
    onPressed: () {
      Navigator.pop(context); // Close dialog
    },
  );
}
```

## Logic Layer

The logic layer handles specific screen logic (button clicks, non-service related operations).

### Key Principles
- Usually managed by Riverpod with provider pattern
- **Never handle BuildContext**
- Process/store data based on Result responses from ApiService layer
- **Never make direct server requests**
- Parse Result responses and use fromJson for data transformation

### Example Code

```dart
Future<bool> deleteAccount(List<bool> selectedList) async {
  List<String> selectedReasons = deleteReasons
      .asMap()
      .entries
      .where((entry) => selectedList[entry.key])
      .map((entry) => entry.value)
      .toList();

  Map<String, dynamic> requestBody = {"reason": selectedReasons.join(", ")};

  final result = await api.deleteAccount(requestBody);
  final isSucceed = result.isSuccess && (result.data["isSuccess"] == true);

  secureStorageService.deleteAll();
  return isSucceed;
}
```

## ApiService Layer

This layer contains all API code for server communication.

### Responsibilities
- All server communication code
- Return values must be in `Future<Result>` format
- Keep code minimal - leave formatting and data creation to logic layer

### Example Code

```dart
Future<Result<bool>> deleteAccount(dynamic body) =>
    _authDio.patch('/user/leave', data: body);

Future<Result<User>> getUserByEmail(String email) =>
    _noAuthDio.get('/user/email/$email', fromJson: User.fromJson);
```

## Result Object

All APIs are wrapped with the Result object.

### Features
- Generic implementation: `Result<SuccessDataType, Error>`
- Returned from ApiService layer with explicit type
- JSON results are mapped using fromJson

### Usage Methods

#### Using isSuccess field
```dart
final result = await api.deleteAccount(requestBody);
final isSucceed = result.isSuccess && (result.data["isSuccess"] == true);
secureStorageService.deleteAll();
return isSucceed;
```

#### Using fold function (Recommended)
```dart
final result = await api.deleteAccount(requestBody);
return result.fold(
  onSuccess: (data) {
    secureStorageService.deleteAll();
    return data["isSuccess"];
  },
  onFailure: (e) {
    return false;
  },
);
```

### Additional Functions
- `map`, `asyncMap` functions for easier fromJson usage
- Reduces repetitive try-catch code