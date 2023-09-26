import 'package:check_and_fix/firebase_options.dart';
import 'package:check_and_fix/presentation/auth/login_screen.dart';
import 'package:check_and_fix/presentation/widgets/permission_handler_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


String email = '';

Future<void> verifyUserExistence()async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  email = sp.getString('email') ?? '';
}
Future<void> addUser(value)async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString('email', value);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  verifyUserExistence();
  final dbDir = await getApplicationDocumentsDirectory();
  Hive.init(dbDir.path);
  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      home: (email == null || email.isEmpty) ? const LoginScreen() : const PermissionHandlerWidget(),
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
