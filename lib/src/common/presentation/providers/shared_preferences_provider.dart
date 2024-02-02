import 'package:openlib/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (_) => LocalStorage().getSharedPreferences()!,
);
