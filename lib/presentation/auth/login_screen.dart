import 'package:check_and_fix/main.dart';
import 'package:check_and_fix/presentation/widgets/button.dart';
import 'package:check_and_fix/presentation/widgets/permission_handler_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuthenticationService firebaseAuthenticationService = FirebaseAuthenticationService();

  googleAuthentication() async {
    final result = await firebaseAuthenticationService.signInWithGoogle();
    handleResult(result);
  }
  appleAuthentication() async {
    final result = await firebaseAuthenticationService.signInWithApple(
      appleRedirectUri: 'https://phone-backup-free.firebaseapp.com/__/auth/handler',
      appleClientId: 'com.files.service.filessync',
    );
    handleResult(result);
  }

  handleResult(FirebaseAuthenticationResult result){
    if(result.hasError){
      SnackBar snackBar = SnackBar(
        content: Text(result.errorMessage!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      addUser(result.user!.email!);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PermissionHandlerWidget()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Login'),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomizedButton(
              image: 'assets/images/apple.png',
              title: 'Continue with Apple',
              function: appleAuthentication,
            ),
            const Gap(
              height: 15,
            ),
            CustomizedButton(
                image: 'assets/images/google.png',
                title: 'Continue with Google',
                function: googleAuthentication
            ),
          ],
        ),
      ),
    );
  }
}
