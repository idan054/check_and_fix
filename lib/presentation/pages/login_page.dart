import 'package:flutter/material.dart';

import '../../core/constants/constants_colors.dart';

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
      body: Column(
        children: [
          Spacer(flex: 4),
          // Image.asset('assets/logo.png'),
          Center(child: FlutterLogo(size: 150)),
          Spacer(flex: 5),
          ElevatedButton(
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text('Login with Apple', style: CommonStyles.mainTitle),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
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
    );
  }
}
