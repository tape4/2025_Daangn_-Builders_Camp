import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/feature/auth/login/login_provider.dart';
import 'package:hankan/app/routing/router_service.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController _phoneController;
  late TextEditingController _otpController;
  final _formKey = GlobalKey<ShadFormState>();

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);

    return Scaffold(
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 80,
                    width: 80,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '한칸',
                    style: ShadTheme.of(context).textTheme.h1Large,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 17),
                  Text(
                    state.otpSent ? '인증번호를 입력하세요' : '전화번호로 로그인하세요',
                    style: ShadTheme.of(context).textTheme.muted,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ShadCard(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ShadForm(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (!state.otpSent) ...[
                              _buildPhoneField(context, notifier),
                              const SizedBox(height: 24),
                              _buildSendOtpButton(context, state, notifier),
                            ] else ...[
                              _buildOtpSection(context, state, notifier),
                            ],
                            if (state.errorMessage != null) ...[
                              const SizedBox(height: 16),
                              ShadAlert.destructive(
                                icon: const Icon(Icons.error_outline),
                                title: const Text('오류'),
                                description: Text(state.errorMessage!),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildRegisterLink(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField(BuildContext context, LoginNotifier notifier) {
    return ShadInputFormField(
      id: 'phone',
      controller: _phoneController,
      label: Text(
        '전화번호',
        style: ShadTheme.of(context).textTheme.small.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      placeholder: const Text('010-1234-5678'),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      prefix: const Icon(Icons.phone_outlined, size: 18),
      onChanged: notifier.updatePhone,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '전화번호를 입력해주세요.';
        }
        final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
        if (digitsOnly.length < 10 || digitsOnly.length > 11) {
          return '올바른 전화번호를 입력해주세요.';
        }
        return null;
      },
    );
  }

  Widget _buildSendOtpButton(
    BuildContext context,
    state,
    LoginNotifier notifier,
  ) {
    return ShadButton(
      onPressed: state.isLoading
          ? null
          : () async {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                final success = await notifier.sendOtp();
                if (success && mounted) {
                  ShadToaster.of(context).show(
                    ShadToast(
                      title: const Text('인증번호 전송'),
                      description: const Text('SMS로 인증번호를 전송했습니다.'),
                    ),
                  );
                }
              }
            },
      size: ShadButtonSize.lg,
      child: state.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text('인증번호 받기'),
    );
  }

  Widget _buildOtpSection(
    BuildContext context,
    state,
    LoginNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              Icons.phone_android,
              size: 18,
              color: ShadTheme.of(context).colorScheme.mutedForeground,
            ),
            const SizedBox(width: 8),
            Text(
              state.phone,
              style: ShadTheme.of(context).textTheme.small.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Spacer(),
            ShadButton.link(
              onPressed: notifier.resetToPhoneInput,
              child: const Text('번호 변경'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ShadInputFormField(
          id: 'otp',
          controller: _otpController,
          label: Text(
            '인증번호',
            style: ShadTheme.of(context).textTheme.small.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          placeholder: const Text('6자리 숫자'),
          keyboardType: TextInputType.number,
          maxLength: 6,
          prefix: const Icon(Icons.lock_outline, size: 18),
          onChanged: notifier.updateOtp,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '인증번호를 입력해주세요.';
            }
            if (value.length != 6) {
              return '6자리 인증번호를 입력해주세요.';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!state.canResend && state.resendTimer > 0) ...[
              Text(
                '재전송 가능 (${state.resendTimer}초)',
                style: ShadTheme.of(context).textTheme.muted.copyWith(
                      fontSize: 12,
                    ),
              ),
            ] else ...[
              ShadButton.outline(
                size: ShadButtonSize.sm,
                onPressed: state.isLoading
                    ? null
                    : () async {
                        final success = await notifier.sendOtp();
                        if (success && mounted) {
                          ShadToaster.of(context).show(
                            ShadToast(
                              title: const Text('재전송 완료'),
                              description: const Text('인증번호를 다시 전송했습니다.'),
                            ),
                          );
                        }
                      },
                child: const Text('인증번호 재전송'),
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),
        ShadButton(
          onPressed: state.isLoading
              ? null
              : () async {
                  if (_otpController.text.length == 6) {
                    final success = await notifier.verifyOtp();
                    if (success && mounted) {
                      ShadToaster.of(context).show(
                        ShadToast(
                          title: const Text('환영합니다!'),
                          description: const Text('로그인에 성공했습니다.'),
                        ),
                      );
                    }
                  } else {
                    notifier.updateOtp('');
                    await notifier.verifyOtp();
                  }
                },
          size: ShadButtonSize.lg,
          child: state.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('로그인'),
        ),
      ],
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '아직 계정이 없으신가요?',
          style: ShadTheme.of(context).textTheme.muted,
        ),
        const SizedBox(width: 4),
        ShadButton.link(
          child: const Text('회원가입'),
          onPressed: () {
            context.push('/register');
          },
        ),
      ],
    );
  }
}
