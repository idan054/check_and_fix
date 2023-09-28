// ignore_for_file: unnecessary_string_interpolations

import 'package:check_and_fix/core/constants/constants_colors.dart';
import 'package:check_and_fix/presentation/pages/page_main/page_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  final Widget? body;
  final String? title;

  const SettingsPage({this.title, this.body, super.key});

  @override
  ConsumerState<SettingsPage> createState() => _PageMainState();
}

class _PageMainState extends ConsumerState<SettingsPage> {
  bool switch1Value = false;
  bool switch2Value = true;
  bool switch3Value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstantsColors.colorIndigoAccent,
        appBar: commonAppBar(false, widget.title),
        body: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: const BoxDecoration(
              color: Color(0xfff6f6f6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Scaffold(
              body: ListView(
                children: <Widget>[
                  ListTile(
                    title: const Text('Automatic Backup mode'),
                    trailing: Switch.adaptive(
                      value: switch1Value,
                      onChanged: (newValue) {
                        switch1Value = newValue;
                        setState(() {});
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Backup when app opened'),
                    trailing: Switch.adaptive(
                      value: switch2Value,
                      onChanged: (newValue) {
                        switch2Value = newValue;
                        setState(() {});
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Remind a weekly backup'),
                    trailing: Switch.adaptive(
                      value: switch3Value,
                      onChanged: (newValue) {
                        switch3Value = newValue;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            )));
  }
}
