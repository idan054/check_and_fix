import 'package:files_sync/View/call_logs.dart';
import 'package:files_sync/View/contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

import '../main.dart';

class Records extends StatefulWidget {
  final String userName;
  const Records({Key? key, required this.userName}) : super(key: key);

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {

  final FirebaseAuthenticationService firebaseAuthenticationService = FirebaseAuthenticationService();


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Records'),
          actions: [
            IconButton(onPressed: (){
              logoutSocialPlatForm();
            }, icon: const Icon(Icons.logout, color: Colors.white,)),
          ],
          bottom: const TabBar(
            tabs: [
              Text(
                'Contacts',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              Text(
                'Call Logs',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: MyContactList(),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: MyCallLog(),
            ),
          ],
        ),
      ),
    );
  }

  logoutSocialPlatForm() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Login')),
    );
    await firebaseAuthenticationService.logout();
  }





}
