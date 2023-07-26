import 'package:flutter/material.dart';
import 'package:check_and_fix/presentation/pages/page_main/page_main.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbDir = await getApplicationDocumentsDirectory();
  Hive.init(dbDir.path);
  runApp(
    const ProviderScope(
      child: MyApp(),
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
