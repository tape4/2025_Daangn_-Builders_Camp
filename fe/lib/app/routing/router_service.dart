import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/feature/error/error_page.dart';
import 'package:hankan/app/feature/faq/faq_page.dart';
import 'package:hankan/app/feature/history/history_page.dart';
import 'package:hankan/app/feature/home/home_page.dart';
import 'package:hankan/app/feature/home/screens/message/chat_screen.dart';
import 'package:hankan/app/feature/profile_edit/profile_edit_page.dart';

extension GoRouterX on GoRouter {
  BuildContext? get context => configuration.navigatorKey.currentContext;
  OverlayState? get overlayState {
    final context = this.context;
    if (context == null) return null;
    return Overlay.of(context);
  }

  Uri get currentUri {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri;
  }
}

abstract class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String error = '/error';
  static const String mypageHistory = '/mypage/history';
  static const String mypageFaq = '/mypage/faq';
  static const String profileEdit = '/profile_edit';
  static const String chat = '/chat/:channelUrl';
}

class RouterService {
  static RouterService get I => GetIt.I<RouterService>();

  late final GoRouter router;

  String? queryParameter(String key) => router.currentUri.queryParameters[key];

  void init() {
    router = GoRouter(
      initialLocation: Routes.home,
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            // var args = state.extra;
            return const HomePage();
          },
        ),
        GoRoute(
          path: Routes.mypageHistory,
          builder: (context, state) {
            return const HistoryPage();
          },
        ),
        GoRoute(
          path: Routes.mypageFaq,
          builder: (context, state) {
            return const FaqPage();
          },
        ),
        GoRoute(
          path: Routes.chat,
          builder: (context, state) {
            final channelUrl = state.pathParameters['channelUrl']!;
            return ChatScreen(channelUrl: channelUrl);
          },
        ),
        GoRoute(
          path: Routes.profileEdit,
          builder: (context, state) {
            return ProfileEditPage();
          },
        ),
      ],
      errorBuilder: (context, state) {
        return const ErrorPage();
      },
    );
  }
}
