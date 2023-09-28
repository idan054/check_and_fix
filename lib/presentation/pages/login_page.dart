import 'dart:io' show Platform;

import 'package:check_and_fix/presentation/pages/page_main/page_main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../core/constants/constants_colors.dart';
import '../../firebase_options.dart';
import '../utils/init_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Init().initConnection(context);
    // if (!kIsWeb) WidgetsBinding.instance.addPostFrameCallback((_) =>);
  }

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
            TextButton(
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(99), // <-- Radius
                  )),
              onPressed: () async {
                final appleProvider = await SignInWithApple.getAppleIDCredential(scopes: [
                  AppleIDAuthorizationScopes.email,
                  AppleIDAuthorizationScopes.fullName,
                ]);

                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const PageMain()));
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text('Login with Apple',
                    style: CommonStyles.mainTitle.copyWith(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(99), // <-- Radius
                  )),
              onPressed: () async {
                // await AuthService.signInWith(context,
                //     autoSignIn: false, applePopup: false);
                final googleProvider = await GoogleSignIn(
                        clientId: !kIsWeb && Platform.isIOS
                            ? DefaultFirebaseOptions.currentPlatform.iosClientId
                            : DefaultFirebaseOptions.currentPlatform.androidClientId)
                    .signIn();

                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const PageMain()));
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text('Login with Google',
                    style: CommonStyles.mainTitle.copyWith(color: Colors.black)),
              ),
            ),
            const SizedBox(height: 10),

            TextButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const PageMain())),
              child: const Text('Cancel', style: CommonStyles.clickable),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
