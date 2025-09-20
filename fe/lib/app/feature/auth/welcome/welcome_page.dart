import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  'assets/logo.png',
                  height: 120,
                  width: 120,
                ),
                const SizedBox(height: 32),
                Text(
                  '한칸',
                  style: ShadTheme.of(context).textTheme.h1Large,
                ),
                const SizedBox(height: 16),
                Text(
                  '우리 동네 이웃들과\n함께하는 공간',
                  style: ShadTheme.of(context).textTheme.lead,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                ShadButton(
                  onPressed: () {
                    context.push('/auth/phone');
                  },
                  size: ShadButtonSize.lg,
                  child: const Text('시작하기'),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}