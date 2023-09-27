import 'dart:developer';

import 'package:check_and_fix/presentation/pages/page_main/bottom_navigation_bar_views/calender_view.dart';
import 'package:check_and_fix/presentation/pages/page_main/page_main.dart';
import 'package:check_and_fix/presentation/providers/uni_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString("passKey") == "" || prefs.getString("passKey") == null) {
    await prefs.setString("passKey", UniqueKey().toString().substring(1, 7));
  }

  if (!kIsWeb) {
    final dbDir = await getApplicationDocumentsDirectory();
    Hive.init(dbDir.path);
  }

  runApp(
    p.MultiProvider(
      providers: [
        p.ChangeNotifierProvider(create: (_) => UniProvider()),
      ],
      child: const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: const PageMain(),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.dualRing
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..maskColor = Colors.black.withOpacity(0.20)
    ..progressColor = Colors.blue
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.red
    ..textColor = Colors.yellow
    ..userInteractions = false
    ..dismissOnTap = false;
}
