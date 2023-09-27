import 'package:flutter/material.dart';

import '../../core/constants/constants_colors.dart';
import '../../services/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    print('START: LoginPage()');

    return Scaffold(
      // backgroundColor: ConstantsColors.darkBg,
      body: Center(
        child: Column(
          children: [
            Spacer(flex: 4),
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: Image.asset('assets/logo.png', height: 115)),
            Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Text('To be able to Backup & Sync Data, Please login',
                  textAlign: TextAlign.center, style: CommonStyles.mainTitle),
            ),
            // Center(child: FlutterLogo(size: 150)),
            Spacer(flex: 2),
            ElevatedButton(
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text('Login with Apple', style: CommonStyles.mainTitle),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await AuthService.signInWith(context,
                    autoSignIn: false, applePopup: false);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text('Login with Google', style: CommonStyles.mainTitle),
              ),
            ),
            const SizedBox(height: 10),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: CommonStyles.clickable),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
