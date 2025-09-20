import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class NicknameInputPage extends ConsumerStatefulWidget {
  final String phone;

  const NicknameInputPage({
    Key? key,
    required this.phone,
  }) : super(key: key);

  @override
  ConsumerState<NicknameInputPage> createState() => _NicknameInputPageState();
}

class _NicknameInputPageState extends ConsumerState<NicknameInputPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final _formKey = GlobalKey<ShadFormState>();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_validateNickname);
  }

  @override
  void dispose() {
    _nicknameController.removeListener(_validateNickname);
    _nicknameController.dispose();
    super.dispose();
  }

  void _validateNickname() {
    final nickname = _nicknameController.text.trim();
    setState(() {
      _isValid = nickname.length >= 2 && nickname.length <= 15;
    });
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
                '닉네임을 입력해주세요',
                style: ShadTheme.of(context).textTheme.h2,
              ),
              const SizedBox(height: 8),
              Text(
                '한칸에서 사용할 닉네임을 입력해주세요',
                style: ShadTheme.of(context).textTheme.muted,
              ),
              const SizedBox(height: 40),
              ShadForm(
                key: _formKey,
                child: ShadInputFormField(
                  id: 'nickname',
                  controller: _nicknameController,
                  label: Text(
                    '닉네임',
                    style: ShadTheme.of(context).textTheme.small.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  placeholder: const Text('닉네임을 입력하세요'),
                  textInputAction: TextInputAction.done,
                  prefix: const Icon(Icons.person_outline, size: 18),
                  maxLength: 15,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '닉네임을 입력해주세요.';
                    }
                    if (value.trim().length < 2) {
                      return '닉네임은 최소 2자 이상이어야 합니다.';
                    }
                    if (value.trim().length > 15) {
                      return '닉네임은 최대 15자까지 가능합니다.';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  '${_nicknameController.text.trim().length}/15',
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                        color: _nicknameController.text.trim().length > 15
                            ? ShadTheme.of(context).colorScheme.destructive
                            : ShadTheme.of(context).colorScheme.muted,
                      ),
                  textAlign: TextAlign.right,
                ),
              ),
              const Spacer(),
              ShadButton(
                onPressed: _isValid
                    ? () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          context.push(
                            '/auth/confirm',
                            extra: {
                              'phone': widget.phone,
                              'nickname': _nicknameController.text.trim(),
                            },
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
