import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/feature/auth/register/register_provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late TextEditingController _phoneController;
  late TextEditingController _usernameController;
  late TextEditingController _otpController;
  final _formKey = GlobalKey<ShadFormState>();

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _usernameController = TextEditingController();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _usernameController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);

    return Scaffold(
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: ShadTheme.of(context).colorScheme.foreground,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '한칸과 함께 시작하세요',
                    style: ShadTheme.of(context).textTheme.h2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.otpSent
                        ? '인증번호를 입력하세요'
                        : '계정을 만들고 공간을 공유해보세요',
                    style: ShadTheme.of(context).textTheme.muted,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ShadCard(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ShadForm(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (!state.otpSent) ...[
                              _buildUsernameField(context, notifier),
                              const SizedBox(height: 16),
                              _buildPhoneField(context, notifier),
                              const SizedBox(height: 20),
                              _buildTermsCheckbox(context, state, notifier),
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
                  _buildLoginLink(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField(BuildContext context, RegisterNotifier notifier) {
    return ShadInputFormField(
      id: 'username',
      controller: _usernameController,
      label: Text(
        '사용자명',
        style: ShadTheme.of(context).textTheme.small.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      placeholder: const Text('사용자명'),
      textInputAction: TextInputAction.next,
      prefix: const Icon(Icons.person_outline, size: 18),
      onChanged: notifier.updateUsername,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '사용자명을 입력해주세요.';
        }
        if (value.trim().length < 2) {
          return '사용자명은 2자 이상이어야 합니다.';
        }
        if (value.trim().length > 20) {
          return '사용자명은 20자 이하여야 합니다.';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField(BuildContext context, RegisterNotifier notifier) {
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

  Widget _buildTermsCheckbox(
    BuildContext context,
    state,
    RegisterNotifier notifier,
  ) {
    return Row(
      children: [
        ShadCheckbox(
          value: state.agreeTerms,
          onChanged: (_) => notifier.toggleAgreeTerms(),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: notifier.toggleAgreeTerms,
            child: RichText(
              text: TextSpan(
                style: ShadTheme.of(context).textTheme.small,
                children: [
                  const TextSpan(text: '한칸의 '),
                  TextSpan(
                    text: '이용약관',
                    style: TextStyle(
                      color: ShadTheme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' 및 '),
                  TextSpan(
                    text: '개인정보처리방침',
                    style: TextStyle(
                      color: ShadTheme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: '에 동의합니다'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSendOtpButton(
    BuildContext context,
    state,
    RegisterNotifier notifier,
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
    RegisterNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ShadTheme.of(context).colorScheme.muted.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: ShadTheme.of(context).colorScheme.mutedForeground,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    state.username,
                    style: ShadTheme.of(context).textTheme.small.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.phone_android,
                    size: 16,
                    color: ShadTheme.of(context).colorScheme.mutedForeground,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    state.phone,
                    style: ShadTheme.of(context).textTheme.small.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: ShadButton.link(
            onPressed: notifier.resetToPhoneInput,
            child: const Text('정보 수정'),
          ),
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
                              description:
                                  const Text('인증번호를 다시 전송했습니다.'),
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
                    final success = await notifier.verifyOtpAndRegister();
                    if (success && mounted) {
                      ShadToaster.of(context).show(
                        ShadToast(
                          title: const Text('환영합니다!'),
                          description: const Text('회원가입이 완료되었습니다.'),
                        ),
                      );
                    }
                  } else {
                    notifier.updateOtp('');
                    await notifier.verifyOtpAndRegister();
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
              : const Text('회원가입'),
        ),
      ],
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '이미 계정이 있으신가요?',
          style: ShadTheme.of(context).textTheme.muted,
        ),
        const SizedBox(width: 4),
        ShadButton.link(
          child: const Text('로그인'),
          onPressed: () => context.go('/login'),
        ),
      ],
    );
  }
}