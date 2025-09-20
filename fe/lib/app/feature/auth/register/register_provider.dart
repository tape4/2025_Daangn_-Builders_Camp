import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/auth/auth_service.dart';
import 'package:hankan/app/feature/auth/register/register_state.dart';
import 'package:hankan/app/routing/router_service.dart';

final registerProvider = NotifierProvider<RegisterNotifier, RegisterState>(
  RegisterNotifier.new,
);

class RegisterNotifier extends Notifier<RegisterState> {
  late final AuthService _authService;
  Timer? _resendTimer;

  @override
  RegisterState build() {
    _authService = AuthService.I;
    ref.onDispose(() {
      _resendTimer?.cancel();
    });
    return RegisterState();
  }

  void updatePhone(String phone) {
    state = state.copyWith(phone: phone, errorMessage: null);
  }

  void updateUsername(String username) {
    state = state.copyWith(username: username, errorMessage: null);
  }

  void updateOtp(String otp) {
    state = state.copyWith(otp: otp, errorMessage: null);
  }

  void toggleAgreeTerms() {
    state = state.copyWith(agreeTerms: !state.agreeTerms);
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

    if (state.username.trim().length < 2) {
      state = state.copyWith(
        errorMessage: '사용자명은 2자 이상이어야 합니다.',
      );
      return false;
    }

    if (!state.agreeTerms) {
      state = state.copyWith(
        errorMessage: '이용약관에 동의해주세요.',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _authService.sendOtp(
        phone: phone,
        purpose: 'register',
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

  Future<bool> verifyOtpAndRegister() async {
    if (state.otp.trim().length != 6) {
      state = state.copyWith(
        errorMessage: '6자리 인증번호를 입력해주세요.',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _authService.verifyOtpRegister(
        phone: state.phone,
        otp: state.otp.trim(),
        username: state.username.trim(),
      );

      return result.fold(
        onSuccess: (user) {
          state = state.copyWith(isLoading: false);
          RouterService.I.router.go(Routes.home);
          return true;
        },
        onFailure: (error) {
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
        errorMessage: '회원가입 중 오류가 발생했습니다. 다시 시도해주세요.',
      );
      return false;
    }
  }

  void resetToPhoneInput() {
    _resendTimer?.cancel();
    state = RegisterState(
      username: state.username,
      agreeTerms: state.agreeTerms,
    );
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
      case 409:
        return '이미 사용 중인 전화번호입니다.';
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
      case 409:
        return '이미 가입된 전화번호입니다.';
      case 404:
        return '인증 요청을 찾을 수 없습니다. SMS를 다시 요청해주세요.';
      default:
        return '회원가입에 실패했습니다. 다시 시도해주세요.';
    }
  }
}