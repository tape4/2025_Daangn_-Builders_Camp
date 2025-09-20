import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/routing/router_service.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class MypageScreen extends ConsumerWidget {
  const MypageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ShadTheme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileCard(context),
                const SizedBox(height: 24),
                Divider(),
                _buildMenuSection(context, ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return ShadCard(
      child: Row(
        children: [
          ShadAvatar(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTF_IdW_JHgWJh_GBrudxZXPOFfdf5598pnew&s',
            placeholder: const Text('JD'),
            size: const Size.square(80),
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: ShadTheme.of(context).textTheme.h4,
                ),
                const SizedBox(height: 4),
                ShadBadge(
                  child: const Text('36.5℃'),
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
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildMenuItem(
          context: context,
          icon: Symbols.history,
          title: 'History',
          onTap: () => context.push(Routes.mypageHistory),
        ),
        _buildMenuItem(
          context: context,
          icon: Symbols.description,
          title: 'Terms & Policy',
          onTap: () {
            launchUrl(Uri.parse('https://www.example.com/terms'));
          },
        ),
        _buildMenuItem(
          context: context,
          icon: Symbols.help,
          title: 'FAQ',
          onTap: () => context.push(Routes.mypageFaq),
        ),
        _buildMenuItem(
          context: context,
          icon: Symbols.article,
          title: 'License',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LicensePage(),
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
          title: 'Logout',
          isDestructive: true,
          onTap: () => _showLogoutDialog(context, ref),
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

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
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
              context.go('/');
            },
          ),
        ],
      ),
    );
  }
}
