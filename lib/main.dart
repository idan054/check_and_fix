import 'dart:developer';
import 'package:files_sync/firebase_options.dart';
import 'package:files_sync/View/record.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
      log(result.errorMessage!);
      SnackBar snackBar = SnackBar(
        content: Text(result.errorMessage!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Records(userName: result.user!.email!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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


class CustomizedButton extends StatelessWidget {
  final String image;
  final String title;
  final Function function;
  const CustomizedButton({Key? key, required this.image, required this.title, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      onPressed: (){
        function();
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Image.asset(image),
            const Gap(
              width: 15,
            ),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Gap extends StatelessWidget {
  final double height;
  final double width;
  const Gap({Key? key, this.height = 0, this.width = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}



