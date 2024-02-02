import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:openlib/src/app.dart';
import 'package:openlib/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  await ScreenUtil.ensureScreenSize();
  LocalStorage();
  await DatabaseConfig.init(StoreRef<dynamic, dynamic>.main());
  runApp(
    ProviderScope(
      observers: [RiverpodObserver()],
      child: MyApp(),
    ),
  );
}
