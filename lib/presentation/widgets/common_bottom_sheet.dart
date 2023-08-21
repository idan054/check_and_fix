import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/constants_colors.dart';
import '../providers/provider_main.dart';
import '../utils/init_service.dart';

class CustomBottomSheet extends ConsumerWidget {
  final String? title;

  const CustomBottomSheet({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerMainRead = ref.read(providerMain.notifier);
    final desc = (title == 'Messages') ? 'Conversations' : title;

    return Container(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26.0),
          topRight: Radius.circular(26.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 6.0),
          Text(
            'Backup ${title!} Logs',
            style: CommonStyles.titleStyle,
          ),
          const SizedBox(height: 16.0),
          const Divider(
            height: 2.0,
            color: Colors.grey,
          ),
          const SizedBox(height: 16.0),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: ConstantsColors.colorIndigo,
              ),
              child: Icon(
                providerMainRead.getImage(title!),
                color: ConstantsColors.colorWhite,
              ),
            ),
            title: Text('Total ${200 + Random().nextInt(2000 - 200 + 1)} $desc Found',
                style: CommonStyles.titleStyle),
          ),
          const SizedBox(height: 14.0),
          Container(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Agree to backup all $desc logs in your default directory?',
                  style: const TextStyle(
                      fontSize: 16.0, color: ConstantsColors.colorBlack54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          const Divider(
            height: 2.0,
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: CommonStyles.titleStyle,
                ),
              ),
              TextButton(
                onPressed: () {
                  Init.dummyLoader();
                  Navigator.pop(context);
                },
                child: const Text(
                  'OK',
                  style: CommonStyles.titleStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
