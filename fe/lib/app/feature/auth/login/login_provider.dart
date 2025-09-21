import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/auth/auth_service.dart';
import 'package:hankan/app/feature/auth/login/login_state.dart';
import 'package:hankan/app/provider/user_provider.dart';
import 'package:hankan/app/routing/router_service.dart';

final loginProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);

class LoginNotifier extends Notifier<LoginState> {
  late final AuthService _authService;
  Timer? _resendTimer;

  @override
  LoginState build() {
    _authService = AuthService.I;
    ref.onDispose(() {
      _resendTimer?.cancel();
    });
    return LoginState();
  }

  void updatePhone(String phone) {
    state = state.copyWith(phone: phone, errorMessage: null);
  }

  void updateOtp(String otp) {
    state = state.copyWith(otp: otp, errorMessage: null);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    state = state.copyWith(resendTimer: 60, canResend: false);

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendTimer > 1) {
        state = state.copyWith(resendTimer: state.resendTimer - 1);
      } else {
        timer.cancel();
        state = state.copyWith(canResend: true, resendTimer: 0);
      }
    });
  }

  Future<bool> sendOtp() async {
    final phone = _formatPhoneNumber(state.phone.trim());

    if (!_validatePhone(phone)) {
      state = state.copyWith(
        errorMessage: '올바른 전화번호를 입력해주세요. (예: 010-1234-5678)',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _authService.sendOtp(
        phone: phone,
      );

      return result.fold(
        onSuccess: (response) {
          state = state.copyWith(
            isLoading: false,
            otpSent: true,
            phone: phone,
          );
          _startResendTimer();
          return true;
        },
        onFailure: (error) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: _getErrorMessage(error.statusCode),
          );
          return false;
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'SMS 전송 중 오류가 발생했습니다. 다시 시도해주세요.',
      );
      return false;
    }
  }

  Future<bool> verifyOtp() async {
    if (state.otp.trim().length != 6) {
      state = state.copyWith(
        errorMessage: '6자리 인증번호를 입력해주세요.',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _authService.verifyOtpLogin(
        phone: state.phone,
        otp: state.otp.trim(),
      );

      return result.fold(
        onSuccess: (user) {
          state = state.copyWith(isLoading: false);

          RouterService.I.router.go(Routes.home);
          ref.read(userProvider.notifier).getUser();
          RouterService.I.showNotification(
            title: '환영합니다!',
            message: '로그인에 성공했습니다.',
          );
          return true;
        },
        onFailure: (error) {
          if (error.statusCode == 404) {
            log('User not found, navigating to registration');
            RouterService.I.router.push(
              Routes.nicknameInput,
              extra: {'phone': state.phone},
            );
            RouterService.I.showNotification(
              title: '회원가입',
              message: '해당 번호로 가입할 수 있습니다.',
            );
            return false;
          }
          state = state.copyWith(
            isLoading: false,
            errorMessage: _getOtpErrorMessage(error.statusCode),
          );
          return false;
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '인증 중 오류가 발생했습니다. 다시 시도해주세요.',
      );
      return false;
    }
  }

  void resetToPhoneInput() {
    _resendTimer?.cancel();
    state = LoginState();
  }

  String _formatPhoneNumber(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length == 11 && digitsOnly.startsWith('010')) {
      return '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 7)}-${digitsOnly.substring(7)}';
    } else if (digitsOnly.length == 10 && digitsOnly.startsWith('10')) {
      return '0${digitsOnly.substring(0, 2)}-${digitsOnly.substring(2, 6)}-${digitsOnly.substring(6)}';
    }

    return phone;
  }

  bool _validatePhone(String phone) {
    final phoneRegex = RegExp(r'^010-\d{4}-\d{4}$');
    return phoneRegex.hasMatch(phone);
  }

  String _getErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 404:
        return '등록되지 않은 전화번호입니다. 회원가입을 먼저 진행해주세요.';
      case 429:
        return 'SMS 발송 한도를 초과했습니다. 잠시 후 다시 시도해주세요.';
      case 500:
        return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
      default:
        return 'SMS 전송에 실패했습니다. 다시 시도해주세요.';
    }
  }

  String _getOtpErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 401:
        return '인증번호가 일치하지 않습니다.';
      case 408:
        return '인증번호가 만료되었습니다. 다시 요청해주세요.';
      case 404:
        return '인증 요청을 찾을 수 없습니다. SMS를 다시 요청해주세요.';
      default:
        return '인증에 실패했습니다. 다시 시도해주세요.';
    }
  }
}
