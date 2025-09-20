import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/auth/auth_service.dart';
import 'package:hankan/app/model/user.dart';
import 'package:hankan/app/routing/router_service.dart';
import 'package:hankan/app/provider/user_provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class MypageScreen extends ConsumerWidget {
  const MypageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ShadTheme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileCard(context, user),
                const SizedBox(height: 24),
                Divider(),
                _buildMenuSection(context, user),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, User user) {
    log('user profile image: ${user.nickname}');
    final displayName =
        user.nickname.isNotEmpty == true ? user.nickname : 'Guest';
    final hasProfileImage = user.profile_image.isNotEmpty;

    return GestureDetector(
      onTap: () => context.push(Routes.profileEdit),
      child: ShadCard(
        child: Row(
          children: [
            if (hasProfileImage)
              ShadAvatar(
                user.profile_image,
                placeholder: Text(displayName.substring(0, 1).toUpperCase()),
                size: const Size.square(80),
                fit: BoxFit.cover,
              )
            else
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ShadTheme.of(context).colorScheme.muted,
                ),
                child: Center(
                  child: Icon(
                    Symbols.person,
                    size: 40,
                    color: ShadTheme.of(context).colorScheme.mutedForeground,
                  ),
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: ShadTheme.of(context).textTheme.h4,
                  ),
                  const SizedBox(height: 4),
                  ShadBadge(
                    child: Text('${user.rating}℃'),
                  ),
                ],
              ),
            ),
            Icon(
              Symbols.arrow_forward_ios,
              size: 24,
              color: ShadTheme.of(context).colorScheme.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, User user) {
    return Column(
      children: [
        _buildMenuItem(
          context: context,
          icon: Symbols.description,
          title: '이용 약관',
          onTap: () {
            launchUrl(Uri.parse('https://www.example.com/terms'));
          },
        ),
        _buildMenuItem(
          context: context,
          icon: Symbols.help,
          title: '자주 묻는 질문(FAQ)',
          onTap: () => context.push(Routes.mypageFaq),
        ),
        _buildMenuItem(
          context: context,
          icon: Symbols.article,
          title: '라이센스',
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const LicensePage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOutCubic;

                  var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve),
                  );

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Divider(),
        const SizedBox(height: 16),
        _buildMenuItem(
          context: context,
          icon: Symbols.logout,
          title: '로그아웃',
          isDestructive: true,
          onTap: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final colorScheme = ShadTheme.of(context).colorScheme;
    final textColor = isDestructive ? colorScheme.destructive : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: textColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: ShadTheme.of(context).textTheme.p.copyWith(
                      color: textColor,
                    ),
              ),
            ),
            Icon(
              Symbols.chevron_right,
              size: 20,
              color: ShadTheme.of(context).colorScheme.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('로그아웃'),
        description: const Text('정말로 로그아웃 하시겠습니까?'),
        actions: [
          ShadButton.outline(
            child: const Text('취소'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ShadButton.destructive(
            child: const Text('로그아웃'),
            onPressed: () {
              Navigator.of(context).pop();

              AuthService.I.logout();
            },
          ),
        ],
      ),
    );
  }
}
