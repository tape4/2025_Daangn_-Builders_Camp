import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hankan/app/routing/router_service.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hankan/app/api/api_service.dart';
import 'package:hankan/app/auth/auth_service.dart';
import 'package:hankan/app/service/secure_storage_service.dart';
import 'package:hankan/app/service/sendbird_service.dart';
import 'package:hankan/app/service/gps_service.dart';

part 'service.dart';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      await Service.initFlutter();
      await Service.initEnv();
      final serviceProviderContainer = Service.registerServices();

      final router = RouterService.I.router;
      runApp(UncontrolledProviderScope(
        container: serviceProviderContainer,
        child: ShadApp.router(
          title: '한칸 | Han:Kan',
          routerConfig: router,
          themeMode: ThemeMode.light,
          theme: ShadThemeData(
            colorScheme: const ShadBlueColorScheme.light(),
            brightness: Brightness.light,
          ),
          debugShowCheckedModeBanner: false,
          locale: const Locale('ko', 'KR'),
          supportedLocales: const [
            Locale('ko', 'KR'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          builder: (context, child) {
            return Overlay(
              initialEntries: [
                OverlayEntry(builder: (context) => child!),
              ],
            );
          },
        ),
      ));
    },
    (error, stackTrace) {
      log('runZonedGuarded: ', error: error, stackTrace: stackTrace);
      debugPrint('runZonedGuarded: $error');
    },
  );
}
