import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
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
            colorScheme: const ShadGreenColorScheme.light(),
            brightness: Brightness.light,
          ),
          debugShowCheckedModeBanner: false,
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
