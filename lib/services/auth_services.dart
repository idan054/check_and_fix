// ignore_for_file: use_build_context_synchronously

import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../firebase_options.dart';
import '../presentation/utils/color_printer.dart';
// import 'package:apple_sign_in/apple_sign_in.dart' as apl;

class AuthService {
  /// streamUsers() Available At [click.Database] // <<---
  static var auth = FirebaseAuth.instance;
  static User? authUser = auth.currentUser;

  /// Google LOGIN
  static Future signInWith(BuildContext context,
      {required bool autoSignIn, bool applePopup = false}) async {
    print('START: signInWith()');

    // Go to LoginRoute() When Err in autoSignIn
    if (autoSignIn && authUser?.email == null) {
      await FirebaseAuth.instance.signOut();
      // context.router.replace(const LoginRoute());
      return;
    }

    // On LoginRoute()
    if (!autoSignIn) {
      authUser = null;
      await FirebaseAuth.instance.signOut();
      if (!applePopup) await GoogleSignIn().signOut();

      await (applePopup ? _appleAuthPopup() : _googleAuthPopup()); // set authUser
      if (authUser?.email == null) return; // When popup canceled
    }

    printWhite('authUser!.email ${authUser!.email}');
    // var userData = await Database.docData('users/${authUser!.email}');
    var userData = {};
    final List<dynamic> userTags = userData?['tags'] ?? [];
    if (userData == null || userTags.isEmpty) {
      printYellow('START: handleNewUser');
      // _handleNewUser(context);
    } else {
      printYellow('START: handleExistUser()');
      // _handleExistUser(context, userData);
    }
  }

  // static void _handleExistUser(
  //     BuildContext context, Map<String, dynamic> userData) async {
  //   var currUser = UserModel.fromJson(userData);
  //   context.uniProvider.currUserUpdate(currUser);
  //
  //   String? fcm = await FirebaseMessaging.instance.getToken();
  //   if (userData['fcm'] != fcm) {
  //     PushNotificationService.updateFcmToken(context, fcm);
  //   }
  //
  //   context.router.replace(DashboardRoute());
  // }
  //
  // static void _handleNewUser(BuildContext context) async {
  //   String? fcm = await FirebaseMessaging.instance.getToken();
  //   var user = context.uniProvider.currUser.copyWith(
  //     name: authUser?.displayName,
  //     uid: authUser!.uid,
  //     email: authUser!.email,
  //     fcm: fcm,
  //   );
  //   context.uniProvider.currUserUpdate(user);
  //   context.router.replace(const OnBoardingRoute());
  //   // Data will upload to server when sign up Done,
  // }

  static Future<User?> _googleAuthPopup() async {
    print('START: _googleAuthPopup()');
    final googleProvider = await GoogleSignIn(
            clientId: !kIsWeb && Platform.isIOS
                ? DefaultFirebaseOptions.currentPlatform.iosClientId
                : DefaultFirebaseOptions.currentPlatform.androidClientId)
        .signIn();
    if (googleProvider == null) return null;

    // Sign in & Create user on firebase console
    final googleAuth = await googleProvider.authentication;
    await auth.signInWithCredential(GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken));

    print('googleProvider.authHeaders ${await googleProvider.authHeaders}');

    authUser = auth.currentUser;
    return authUser;
  }

  /// Apple LOGIN
  static Future<User?> _appleAuthPopup() async {
    print('START: _appleAuthPopup()');

    final appleProvider = await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ]);

    print('appleProvider ${appleProvider.email}');
    print('appleProvider ${appleProvider.familyName}');
    print('appleProvider ${appleProvider.givenName}');
    print('appleProvider ${appleProvider.userIdentifier}');

    final credential = OAuthProvider('apple.com')
        .setScopes(['email', 'fullName']).credential(
            idToken: appleProvider.identityToken,
            accessToken: appleProvider.authorizationCode);
    await auth.signInWithCredential(credential);

    authUser = auth.currentUser;
    if (authUser != null && authUser!.email == null) {
      var mail = appleProvider.email ?? '${authUser!.uid.substring(0, 10)}@apple.com';
      var name = appleProvider.givenName ?? appleProvider.familyName;
      authUser!.updateEmail(mail);
      if (authUser?.displayName == null) authUser!.updateDisplayName(name);
    }

    return authUser;
  }
}

/// Facebook LOGIN

/*  Future signInWithFacebook(context) async {
    await FirebaseAuth.instance.signOut();

    // Trigger the sign-in flow
    // final loginResult = await FacebookAuth.instance.login(); // login based firebase
    final facebookLogin = FacebookLogin();
    var facebookLoginResult =
        await facebookLogin.logIn(permissions: [
          FacebookPermission.email,
          FacebookPermission.publicProfile,
          FacebookPermission.userBirthday,
        ]);

    // Add it to Firebase auth
    final facebookAuthCredential =
         FacebookAuthProvider.credential(facebookLoginResult.accessToken!.token);
    await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    var fireCurrentUser = FirebaseAuth.instance.currentUser;
    await updateUserModel(context, fireCurrentUser, 'Facebook');

  }*/

/*
  Future<void> addUser(String email, String pass, context) async {
    try {
      // var time = DateTime.now();
      await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      // .then((value) => {
      //       FirebaseFirestore.instance
      //           .collection('accounts')
      //           .doc(uid)
      //           .collection('users')
      //           .add({
      //         'email': email,
      //         'password': pass,
      //         'creation': time.toString(),
      //         'id': uid,
      //       })
      //     });
      // await prefs.setString('authToken', uid.toString());
    } catch (e) {
      print('error creating account');
    }
  }
*/

/// Email LOGIN
/*  Future<String> signInWithEmail(
    context, {
    required GlobalKey<FormState> key,
    required String email,
    required bool signup,
    required String pass}) async {


    // SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      key.currentState!.validate();

      signup ? await _auth.createUserWithEmailAndPassword(email: email, password: pass)
      : await _auth.signInWithEmailAndPassword(email: email, password: pass);
      // await _auth.signInWithEmailAndPassword(

      // await prefs.setString('authToken', uid!);

      final fireCurrentUser = FirebaseAuth.instance.currentUser;
      await updateUserModel(context, fireCurrentUser, 'Email');

      return 'Succeed';
    } catch (e) {
        print(e.toString());
      return e.toString();
    }
  }*/

/*  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }*/
