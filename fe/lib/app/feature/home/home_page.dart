import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hankan/app/auth/auth_helper.dart';
import 'package:hankan/app/auth/auth_service.dart';
import 'package:hankan/app/extension/context_x.dart';
import 'package:hankan/app/feature/home/screens/home/home_screen.dart';
import 'package:hankan/app/feature/home/screens/history/history_screen.dart';
import 'package:hankan/app/feature/home/screens/message/message_screen.dart';
import 'package:hankan/app/feature/home/screens/mypage/mypage_screen.dart';
import 'package:hankan/app/provider/user_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late PersistentTabController _controller;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _controller.addListener(_handleTabChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider.notifier).getUser();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTabChange);
    _controller.dispose();
    super.dispose();
  }

  void _handleTabChange() async {
    final currentIndex = _controller.index;
    if ((currentIndex == 1 || currentIndex == 2 || currentIndex == 3) &&
        currentIndex != _previousIndex) {
      final isAuthenticated = await AuthHelper.checkAuthAndShowBottomSheet(
        context: context,
        ref: ref,
      );
      if (!isAuthenticated) {
        _controller.jumpToTab(0);
        return;
      }
    }
    _previousIndex = currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        controller: _controller,
        tabs: [
          PersistentTabConfig(
            screen: HomeScreen(),
            item: ItemConfig(
              icon: Icon(Icons.home),
              activeForegroundColor: context.colorScheme.primary,
              title: "Home",
            ),
          ),
          PersistentTabConfig(
            screen: MessageScreen(),
            item: ItemConfig(
              icon: Icon(Icons.send),
              activeForegroundColor: context.colorScheme.primary,
              title: "Messages",
            ),
          ),
          PersistentTabConfig(
            screen: HistoryScreen(),
            item: ItemConfig(
              icon: Icon(Symbols.contract),
              activeForegroundColor: context.colorScheme.primary,
              title: "Listup",
            ),
          ),
          PersistentTabConfig(
            screen: MypageScreen(),
            item: ItemConfig(
              icon: Icon(Icons.person),
              activeForegroundColor: context.colorScheme.primary,
              title: "MyPage",
            ),
          ),
        ],
        navBarBuilder: (navBarConfig) => Style5BottomNavBar(
          navBarConfig: navBarConfig,
        ),
      ),
    );
  }
}
