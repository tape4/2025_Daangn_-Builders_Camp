import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PhoneInputPage extends ConsumerStatefulWidget {
  const PhoneInputPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PhoneInputPage> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends ConsumerState<PhoneInputPage> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<ShadFormState>();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhone);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_validatePhone);
    _phoneController.dispose();
    super.dispose();
  }

  void _validatePhone() {
    final digitsOnly = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    setState(() {
      _isValid = digitsOnly.length >= 10 && digitsOnly.length <= 11;
    });
  }

  String _formatPhoneNumber(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length <= 3) {
      return digitsOnly;
    } else if (digitsOnly.length <= 7) {
      return '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3)}';
    } else if (digitsOnly.length <= 11) {
      return '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, digitsOnly.length <= 10 ? 6 : 7)}-${digitsOnly.substring(digitsOnly.length <= 10 ? 6 : 7)}';
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
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
                '전화번호를 입력해주세요',
                style: ShadTheme.of(context).textTheme.h2,
              ),
              const SizedBox(height: 8),
              Text(
                '인증번호를 받을 휴대폰 번호를 입력해주세요',
                style: ShadTheme.of(context).textTheme.muted,
              ),
              const SizedBox(height: 40),
              ShadForm(
                key: _formKey,
                child: ShadInputFormField(
                  id: 'phone',
                  controller: _phoneController,
                  label: Text(
                    '휴대폰 번호',
                    style: ShadTheme.of(context).textTheme.small.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  placeholder: const Text('010-1234-5678'),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  prefix: const Icon(Icons.phone_outlined, size: 18),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final newText = _formatPhoneNumber(newValue.text);
                      return TextEditingValue(
                        text: newText,
                        selection: TextSelection.collapsed(offset: newText.length),
                      );
                    }),
                  ],
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
                ),
              ),
              const Spacer(),
              ShadButton(
                onPressed: _isValid
                    ? () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          context.push(
                            '/auth/otp',
                            extra: {'phone': _phoneController.text},
                          );
                        }
                      }
                    : null,
                size: ShadButtonSize.lg,
                child: const Text('다음'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}