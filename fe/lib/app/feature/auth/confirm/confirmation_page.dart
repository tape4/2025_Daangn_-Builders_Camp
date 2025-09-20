import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/feature/auth/register/register_provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ConfirmationPage extends ConsumerStatefulWidget {
  final String phone;
  final String nickname;
  final String region;
  final String? detailAddress;

  const ConfirmationPage({
    Key? key,
    required this.phone,
    required this.nickname,
    required this.region,
    this.detailAddress,
  }) : super(key: key);

  @override
  ConsumerState<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends ConsumerState<ConfirmationPage> {
  bool _isMyPhone = true;

  Future<void> _completeRegistration() async {
    final notifier = ref.read(registerProvider.notifier);

    // Set registration data
    notifier.updateName(widget.nickname);
    notifier.updateAddress(widget.region);

    // Complete registration
    final success = await notifier.register();

    if (success && mounted) {
      ShadToaster.of(context).show(
        ShadToast(
          title: const Text('환영합니다!'),
          description: const Text('회원가입이 완료되었습니다.'),
        ),
      );
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerProvider);

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
                '입력한 정보를 확인해주세요',
                style: ShadTheme.of(context).textTheme.h2,
              ),
              const SizedBox(height: 8),
              Text(
                '입력하신 정보가 맞는지 확인해주세요',
                style: ShadTheme.of(context).textTheme.muted,
              ),
              const SizedBox(height: 40),

              // Information Summary Card
              ShadCard(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        context,
                        icon: Icons.phone_outlined,
                        label: '전화번호',
                        value: widget.phone,
                      ),
                      const SizedBox(height: 16),
                      Divider(
                        color: ShadTheme.of(context).colorScheme.border,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        context,
                        icon: Icons.person_outline,
                        label: '닉네임',
                        value: widget.nickname,
                      ),
                      const SizedBox(height: 16),
                      Divider(
                        color: ShadTheme.of(context).colorScheme.border,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        context,
                        icon: Icons.location_on_outlined,
                        label: '지역',
                        value: widget.region,
                        subtitle: widget.detailAddress,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Phone ownership disclaimer
              Row(
                children: [
                  ShadCheckbox(
                    value: _isMyPhone,
                    onChanged: (value) {
                      setState(() {
                        _isMyPhone = value;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '본인 명의의 휴대폰입니다',
                      style: ShadTheme.of(context).textTheme.small,
                    ),
                  ),
                ],
              ),

              if (!_isMyPhone) ...[
                const SizedBox(height: 12),
                ShadAlert(
                  icon: const Icon(Icons.info_outline),
                  title: const Text('안내'),
                  description: const Text(
                    '본인 명의의 휴대폰이 아닌 경우 서비스 이용이 제한될 수 있습니다.',
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
                onPressed: _isMyPhone
                    ? (state.isLoading ? null : _completeRegistration)
                    : null,
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

              const SizedBox(height: 12),

              ShadButton.link(
                onPressed: () => context.pop(),
                child: const Text('내 명의의 휴대폰이 아닙니다'),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: ShadTheme.of(context).colorScheme.mutedForeground,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: ShadTheme.of(context).textTheme.small.copyWith(
                      color: ShadTheme.of(context).colorScheme.mutedForeground,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: ShadTheme.of(context).textTheme.p.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                        color: ShadTheme.of(context).colorScheme.mutedForeground,
                      ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}