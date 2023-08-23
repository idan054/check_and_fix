// ignore_for_file: unnecessary_string_interpolations

import 'package:check_and_fix/core/constants/constants_colors.dart';
import 'package:check_and_fix/presentation/pages/page_main/page_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewBackupPage extends ConsumerStatefulWidget {
  final Widget? body;
  final String? title;

  const ViewBackupPage({this.title, this.body, super.key});

  @override
  ConsumerState<ViewBackupPage> createState() => _PageMainState();
}

class _PageMainState extends ConsumerState<ViewBackupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.colorIndigoAccent,
      appBar: commonAppBar(widget.title),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          decoration: const BoxDecoration(
            color: Color(0xfff6f6f6),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: widget.body),
    );
  }
}
