import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/extension/context_x.dart';
import 'package:hankan/app/feature/auth/confirm/confirmation_page.dart';
import 'package:hankan/app/feature/auth/login/login_page.dart';
import 'package:hankan/app/feature/auth/nickname/nickname_input_page.dart';
import 'package:hankan/app/feature/auth/otp/otp_verification_page.dart';
import 'package:hankan/app/feature/auth/phone/phone_input_page.dart';
import 'package:hankan/app/feature/auth/region/region_select_page.dart';
import 'package:hankan/app/feature/auth/register/register_page.dart';
import 'package:hankan/app/feature/auth/welcome/welcome_page.dart';
import 'package:hankan/app/feature/error/error_page.dart';
import 'package:hankan/app/feature/faq/faq_page.dart';
import 'package:hankan/app/feature/history/history_page.dart';
import 'package:hankan/app/feature/home/home_page.dart';
import 'package:hankan/app/feature/home/screens/message/chat_screen.dart';
import 'package:hankan/app/feature/profile_edit/profile_edit_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
  static const String register = '/register';
  static const String welcome = '/auth/welcome';
  static const String phoneInput = '/auth/phone';
  static const String otpVerification = '/auth/otp';
  static const String nicknameInput = '/auth/nickname';
  static const String regionSelect = '/auth/region';
  static const String confirmation = '/auth/confirm';
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

  void showNotification({
    required String title,
    required String message,
    bool isError = false,
  }) {
    final context = router.context;
    if (context == null) return;
    if (isError) {
      ShadToaster.of(context).show(
        ShadToast.destructive(
          title: Text(title),
          description: Text(message),
        ),
      );
      return;
    } else {
      ShadToaster.of(context).show(
        ShadToast(
          title: Text(title),
          description: Text(message),
        ),
      );
      return;
    }
  }

  void init() {
    router = GoRouter(
      initialLocation: Routes.welcome,
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            // var args = state.extra;
            return const HomePage();
          },
        ),
        GoRoute(
          path: Routes.welcome,
          builder: (context, state) {
            return const WelcomePage();
          },
        ),
        GoRoute(
          path: Routes.phoneInput,
          builder: (context, state) {
            return const PhoneInputPage();
          },
        ),
        GoRoute(
          path: Routes.otpVerification,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return OtpVerificationPage(
              phone: extra?['phone'] ?? '',
            );
          },
        ),
        GoRoute(
          path: Routes.nicknameInput,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return NicknameInputPage(
              phone: extra?['phone'] ?? '',
            );
          },
        ),
        GoRoute(
          path: Routes.regionSelect,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return RegionSelectPage(
              phone: extra?['phone'] ?? '',
              nickname: extra?['nickname'] ?? '',
            );
          },
        ),
        GoRoute(
          path: Routes.confirmation,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return ConfirmationPage(
              phone: extra?['phone'] ?? '',
              nickname: extra?['nickname'] ?? '',
              region: extra?['region'] ?? '',
              detailAddress: extra?['detailAddress'],
            );
          },
        ),
        GoRoute(
          path: Routes.login,
          builder: (context, state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: Routes.register,
          builder: (context, state) {
            return const RegisterPage();
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
            return const ProfileEditPage();
          },
        ),
      ],
      errorBuilder: (context, state) {
        return const ErrorPage();
      },
    );
  }
}
