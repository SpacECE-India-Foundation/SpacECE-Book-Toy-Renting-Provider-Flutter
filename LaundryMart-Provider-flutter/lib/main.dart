import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_seller/config/app_constants.dart';
import 'package:laundry_seller/config/theme.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/routes.dart';
import 'package:laundry_seller/utils/global_function.dart';
import 'package:laundry_seller/views/profile/components/language.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.appSettingsBox);
  await Hive.openBox(AppConstants.userBox);
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  await FlutterDownloader.registerCallback(downloadCallback);
  runApp(const ProviderScope(child: MyApp())
      // DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => const ProviderScope(
      //     child: MyApp(),
      //   ),
      // ),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Locale resolveLocal({required String langCode}) {
    return Locale(langCode);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // XD Design Sizes
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: false,
      builder: (context, child) {
        return ValueListenableBuilder(
            valueListenable: Hive.box(AppConstants.appSettingsBox).listenable(),
            builder: (context, appSettingsBox, _) {
              final selectedLocal = appSettingsBox.get(AppConstants.appLocal);
              final bool? isDark =
                  appSettingsBox.get(AppConstants.isDarkTheme) ?? false;
              if (isDark == null) {
                appSettingsBox.put(AppConstants.isDarkTheme, false);
              }

              if (selectedLocal == null) {
                appSettingsBox.put(
                  AppConstants.appLocal,
                  AppLanguage(name: '\ud83c\uddfa\ud83c\uddf8 ENG', value: 'en')
                      .toMap(),
                );
              }

              GlobalFunction.changeStatusBarTheme(isDark: isDark);
              return MaterialApp(
                title: 'LaundrySeller',
                navigatorKey: GlobalFunction.navigatorKey,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  FormBuilderLocalizations.delegate,
                ],
                locale: resolveLocal(
                    langCode:
                        selectedLocal == null ? 'en' : selectedLocal['value']),
                localeResolutionCallback: (deviceLocal, supportedLocales) {
                  for (final locale in supportedLocales) {
                    if (locale.languageCode == deviceLocal!.languageCode) {
                      return deviceLocal;
                    }
                  }
                  return supportedLocales.first;
                },
                supportedLocales: S.delegate.supportedLocales,
                theme:
                    getAppTheme(context: context, isDarkTheme: isDark ?? false),
                onGenerateRoute: generatedRoutes,
                initialRoute: Routes.splash,
              );
            });
      },
    );
  }
}

void downloadCallback(String id, int status, int progress) async {
  final taskStatus = DownloadTaskStatus.values[status];
  if (taskStatus == DownloadTaskStatus.running) {
    print('Download in progress: $progress%');
  } else if (taskStatus == DownloadTaskStatus.complete) {
    print('Download complete');
  } else if (taskStatus == DownloadTaskStatus.failed) {
    print('Download failed');
  }
}
