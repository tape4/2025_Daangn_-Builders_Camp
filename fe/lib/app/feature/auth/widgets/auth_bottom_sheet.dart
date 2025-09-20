import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/feature/auth/widgets/auth_guestmode_dialog.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AuthBottomSheet extends StatefulWidget {
  const AuthBottomSheet({Key? key}) : super(key: key);

  @override
  State<AuthBottomSheet> createState() => _AuthBottomSheetState();
}

class _AuthBottomSheetState extends State<AuthBottomSheet> {
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: ShadTheme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ShadTheme.of(context).colorScheme.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 17),

              // Logo and title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '한칸',
                    style: ShadTheme.of(context).textTheme.h2,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Toggle between login and register
              Container(
                decoration: BoxDecoration(
                  color:
                      ShadTheme.of(context).colorScheme.muted.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildToggleButton(
                            context: context,
                            title: '로그인',
                            isSelected: _isLogin,
                            onTap: () {
                              if (!_isLogin) {
                                setState(() => _isLogin = true);
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: _buildToggleButton(
                            context: context,
                            title: '회원가입',
                            isSelected: !_isLogin,
                            onTap: () {
                              if (_isLogin) {
                                setState(() => _isLogin = false);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      alignment: _isLogin
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        child: Container(
                          margin: const EdgeInsets.only(top: 50),
                          height: 8,
                          decoration: BoxDecoration(
                            color: ShadTheme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Content based on selection - Fixed height container
              SizedBox(
                width: double.infinity,
                height: 120, // Fixed height to prevent jumping
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isLogin
                      ? _buildLoginContent(context)
                      : _buildRegisterContent(context),
                ),
              ),

              const SizedBox(height: 24),

              // Primary action button
              ShadButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push('/auth/phone', extra: {'isLogin': _isLogin});
                },
                size: ShadButtonSize.lg,
                child: Text(_isLogin ? '로그인 계속하기' : '회원가입 시작하기'),
              ),

              const SizedBox(height: 12),

              // Guest mode button - Same size as primary button
              ShadButton.outline(
                onPressed: () {
                  _showGuestModeInfo(context);
                },
                size: ShadButtonSize.lg,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.visibility_outlined, size: 16),
                    SizedBox(width: 8),
                    Text('먼저 둘러보기'),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 60,
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: ShadTheme.of(context).textTheme.p.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? ShadTheme.of(context).colorScheme.foreground
                        : ShadTheme.of(context).colorScheme.mutedForeground,
                  ),
              child: Text(title),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginContent(BuildContext context) {
    return Column(
      key: const ValueKey('login'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '다시 만나서 반가워요!',
          style: ShadTheme.of(context).textTheme.h3,
        ),
        const SizedBox(height: 8, width: double.maxFinite),
        Text(
          '전화번호로 간편하게 로그인하세요.',
          style: ShadTheme.of(context).textTheme.muted,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildFeatureChip(
              context: context,
              icon: Icons.speed,
              text: '빠른 로그인',
            ),
            const SizedBox(width: 8),
            _buildFeatureChip(
              context: context,
              icon: Icons.security,
              text: '안전한 인증',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterContent(BuildContext context) {
    return Column(
      key: const ValueKey('register'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '한칸에 오신 것을 환영해요!',
          style: ShadTheme.of(context).textTheme.h3,
        ),
        const SizedBox(height: 8, width: double.maxFinite),
        Text(
          '간단한 가입으로 이웃들과 소통해보세요.',
          style: ShadTheme.of(context).textTheme.muted,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildFeatureChip(
              context: context,
              icon: Icons.timer,
              text: '1분 가입',
            ),
            _buildFeatureChip(
              context: context,
              icon: Icons.people,
              text: '동네 이웃',
            ),
            _buildFeatureChip(
              context: context,
              icon: Icons.verified_user,
              text: '안전 인증',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureChip({
    required BuildContext context,
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ShadTheme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: ShadTheme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: ShadTheme.of(context).textTheme.small.copyWith(
                  color: ShadTheme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  void _showGuestModeInfo(BuildContext context) {
    showShadDialog(
      context: context,
      builder: (context) => AuthGuestmodeDialog(),
    );
  }
}
