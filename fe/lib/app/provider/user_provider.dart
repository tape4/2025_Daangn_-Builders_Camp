import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/api/api_service.dart';
import 'package:hankan/app/model/user.dart';

final userProvider = NotifierProvider<UserProvider, User>(
  UserProvider.new,
);

class UserProvider extends Notifier<User> {
  @override
  build() {
    return User(
      id: 0,
      nickname: 'Guest',
      phoneNumber: '',
    );
  }

  void getUser() async {
    final response = await ApiService.I.getUser();
    response.fold(
      onSuccess: (user) {
        state = user;
        log(user.toString());
      },
      onFailure: (error) {
        log('Failed to fetch user: $error');
      },
    );
  }
}
