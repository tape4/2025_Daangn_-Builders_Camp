import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/auth/auth_state.dart';
import 'package:hankan/app/feature/auth/widgets/auth_bottom_sheet.dart';

class AuthHelper {
  static Future<bool> checkAuthAndShowBottomSheet({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final authState = ref.read(authStateProvider);

    if (!authState.isLoggedIn) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const AuthBottomSheet(),
      );
      return false;
    }

    return true;
  }
}