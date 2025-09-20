import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/feature/auth/login/login_provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class OtpVerificationPage extends ConsumerStatefulWidget {
  final String phone;

  const OtpVerificationPage({
    Key? key,
    required this.phone,
  }) : super(key: key);

  @override
  ConsumerState<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _secondsRemaining = 180; // 3 minutes
  bool _canResend = false;
  bool _otpSent = false;

  @override
  void initState() {
    super.initState();
    _sendOtp();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 180;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  String get _timerText {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _sendOtp() async {
    final notifier = ref.read(loginProvider.notifier);
    notifier.updatePhone(widget.phone);
    final success = await notifier.sendOtp();

    if (success) {
      setState(() {
        _otpSent = true;
      });
      _startTimer();
      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast(
            title: const Text('인증번호 전송'),
            description: const Text('SMS로 인증번호를 전송했습니다.'),
          ),
        );
      }
    }
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        // All 6 digits entered, auto-verify
        _verifyOtp();
      }
    }
  }

  void _onOtpKeyDown(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_otpControllers[index].text.isEmpty && index > 0) {
          FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
        }
      }
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 6) return;

    final notifier = ref.read(loginProvider.notifier);
    notifier.updateOtp(otp);
    final success = await notifier.verifyOtp();

    if (success && mounted) {
      // Check if new user (needs registration)
      // For now, we'll assume new users need to register
      final isNewUser = true; // This should be determined from API response

      if (isNewUser) {
        context.push('/auth/nickname', extra: {'phone': widget.phone});
      } else {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);

    return Scaffold(
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: ShadButton.ghost(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                '인증번호를 입력해주세요',
                style: ShadTheme.of(context).textTheme.h2,
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.phone}로 전송된\n6자리 인증번호를 입력해주세요',
                style: ShadTheme.of(context).textTheme.muted,
              ),
              const SizedBox(height: 40),

              // OTP Input Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    height: 60,
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (event) => _onOtpKeyDown(event, index),
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: _otpControllers[index].text.isNotEmpty
                              ? ShadTheme.of(context).colorScheme.primary.withOpacity(0.1)
                              : ShadTheme.of(context).colorScheme.muted.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: ShadTheme.of(context).colorScheme.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: ShadTheme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: ShadTheme.of(context).colorScheme.border,
                            ),
                          ),
                        ),
                        style: ShadTheme.of(context).textTheme.h3,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) => _onOtpChanged(value, index),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // Timer and Resend
              if (_otpSent) ...[
                Center(
                  child: Column(
                    children: [
                      Text(
                        _timerText,
                        style: ShadTheme.of(context).textTheme.h3.copyWith(
                          color: _secondsRemaining > 30
                              ? ShadTheme.of(context).colorScheme.primary
                              : ShadTheme.of(context).colorScheme.destructive,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_canResend) ...[
                        ShadButton.outline(
                          onPressed: state.isLoading ? null : _sendOtp,
                          child: const Text('인증번호 재발송'),
                        ),
                      ] else ...[
                        Text(
                          '인증번호를 받지 못하셨나요?',
                          style: ShadTheme.of(context).textTheme.muted,
                        ),
                        ShadButton.link(
                          onPressed: null,
                          child: Text('${_secondsRemaining}초 후 재발송 가능'),
                        ),
                      ],
                    ],
                  ),
                ),
              ],

              if (state.errorMessage != null) ...[
                const SizedBox(height: 16),
                ShadAlert.destructive(
                  icon: const Icon(Icons.error_outline),
                  title: const Text('오류'),
                  description: Text(state.errorMessage!),
                ),
              ],

              const Spacer(),

              ShadButton(
                onPressed: state.isLoading ? null : _verifyOtp,
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
                    : const Text('확인'),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}