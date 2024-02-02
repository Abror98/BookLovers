import 'package:flutter/material.dart';
import 'package:openlib/src/common/common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logman/logman.dart';

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScreenUtil.init(context);
    final currentAppTheme = ref.watch(currentAppThemeNotifierProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: themeData(
        currentAppTheme.value == CurrentAppTheme.dark ? darkTheme : lightTheme,
      ),
      darkTheme: themeData(darkTheme),
      themeMode: currentAppTheme.value?.themeMode,
      routerConfig: _appRouter.config(
        navigatorObservers: () => [
          LogmanNavigatorObserver(),
        ],
      ),
    );
  }

  // Apply font to our app's theme
  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(
        theme.textTheme,
      ),
      colorScheme: theme.colorScheme.copyWith(
        secondary: lightAccent,
      ),
    );
  }
}
