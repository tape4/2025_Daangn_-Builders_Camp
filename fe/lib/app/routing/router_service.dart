import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/feature/auth/confirm/confirmation_page.dart';
import 'package:hankan/app/feature/auth/nickname/nickname_input_page.dart';
import 'package:hankan/app/feature/auth/otp/otp_verification_page.dart';
import 'package:hankan/app/feature/auth/phone/phone_input_page.dart';

import 'package:hankan/app/feature/auth/register/register_page.dart';
import 'package:hankan/app/feature/error/error_page.dart';
import 'package:hankan/app/feature/faq/faq_page.dart';
import 'package:hankan/app/feature/home/home_page.dart';
import 'package:hankan/app/feature/home/screens/message/chat_screen.dart';
import 'package:hankan/app/feature/profile_edit/profile_edit_page.dart';
import 'package:hankan/app/feature/item_storage/item_storage_page.dart';
import 'package:hankan/app/feature/space_rental/space_rental_page.dart';
import 'package:hankan/app/feature/space_rental/space_detail_page.dart';
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
  static const String phoneInput = '/auth/phone';
  static const String otpVerification = '/auth/otp';
  static const String nicknameInput = '/auth/nickname';
  static const String confirmation = '/auth/confirm';
  static const String error = '/error';
  static const String mypageHistory = '/mypage/history';
  static const String mypageFaq = '/mypage/faq';
  static const String profileEdit = '/profile_edit';
  static const String chat = '/chat/:channelUrl';
  static const String spaceRental = '/space-rental';
  static const String spaceDetail = '/space/:id';
  static const String itemStorage = '/item-storage';
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
      initialLocation: Routes.home,
      routes: [
        GoRoute(
          path: Routes.home,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  ),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: Routes.phoneInput,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const PhoneInputPage(),
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
            );
          },
        ),
        GoRoute(
          path: Routes.otpVerification,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: OtpVerificationPage(
                phone: extra?['phone'] ?? '',
              ),
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
            );
          },
        ),
        GoRoute(
          path: Routes.nicknameInput,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: NicknameInputPage(
                phone: extra?['phone'] ?? '',
              ),
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
            );
          },
        ),
        GoRoute(
          path: Routes.confirmation,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: ConfirmationPage(
                phone: extra?['phone'] ?? '',
                nickname: extra?['nickname'] ?? '',
                region: extra?['region'] ?? '',
                detailAddress: extra?['detailAddress'],
              ),
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
            );
          },
        ),
        GoRoute(
          path: Routes.register,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const RegisterPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  ),
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.95,
                      end: 1.0,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      ),
                    ),
                    child: child,
                  ),
                );
              },
            );
          },
        ),
        GoRoute(
          path: Routes.mypageFaq,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const FaqPage(),
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
            );
          },
        ),
        GoRoute(
          path: Routes.chat,
          pageBuilder: (context, state) {
            final channelUrl = state.pathParameters['channelUrl']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: ChatScreen(channelUrl: channelUrl),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
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
            );
          },
        ),
        GoRoute(
          path: Routes.profileEdit,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const ProfileEditPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
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
            );
          },
        ),
        GoRoute(
          path: Routes.spaceRental,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const SpaceRentalPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
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
            );
          },
        ),
        GoRoute(
          path: Routes.spaceDetail,
          pageBuilder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return CustomTransitionPage(
              key: state.pageKey,
              child: SpaceDetailPage(spaceId: id),
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
            );
          },
        ),
        GoRoute(
          path: Routes.itemStorage,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const ItemStoragePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
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
            );
          },
        ),
      ],
      errorBuilder: (context, state) {
        return const ErrorPage();
      },
    );
  }
}
