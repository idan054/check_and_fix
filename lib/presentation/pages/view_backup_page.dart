// ignore_for_file: unnecessary_string_interpolations

import 'package:phone_backup/core/constants/constants_colors.dart';
import 'package:phone_backup/presentation/pages/page_main/page_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/provider_main.dart';

class ViewBackupPage extends ConsumerStatefulWidget {
  final Widget? body;
  final String? title;
  final Widget? appBarButton;

  const ViewBackupPage({this.appBarButton, this.title, this.body, super.key});

  @override
  ConsumerState<ViewBackupPage> createState() => _PageMainState();
}

class _PageMainState extends ConsumerState<ViewBackupPage> {
  @override
  Widget build(BuildContext context) {
    final isShowMessagesBackup = providerMainScope(context).isShowMessagesBackup;
    print('isShowMessagesBackup $isShowMessagesBackup');

    return Scaffold(
      backgroundColor: ConstantsColors.colorIndigoAccent,
      appBar: commonAppBar(false, widget.title, widget.appBarButton),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          decoration: const BoxDecoration(
            color: Color(0xfff6f6f6),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: isShowMessagesBackup
              ? widget.body
              : const Center(child: Text('No Data Found'))),
    );
  }
}
