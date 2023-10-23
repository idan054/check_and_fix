import 'dart:io';

import 'package:phone_backup/core/constants/constants_colors.dart';
import 'package:phone_backup/presentation/providers/provider_main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet extends StatefulWidget {
  final String? title;
  final String? desc;
  final VoidCallback? action;

  const CustomBottomSheet(
      {super.key, required this.action, required this.desc, this.title});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final providerMainRead = providerMainScope(context);
    final title = widget.title;
    final desc = widget.desc;
    var fullDesc =
        // 'Total ${200 + Random().nextInt(2000 - 200 + 1)} $desc Found.'
        'Agree to '
        '${!kIsWeb && Platform.isIOS ? 'sync' : 'backup'}'
        ' all $desc logs '
        '${desc == 'contacts' && !kIsWeb && Platform.isIOS ? 'to secure website?' : 'in your default directory?'}';
    final locationMode = (desc ?? '').contains('Location');

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
          if (!locationMode)
            Text(
              title ??
                  '${!kIsWeb && Platform.isIOS ? 'Sync ' : 'Backup '}'
                      '${desc!.toCapitalized()}',
              style: CommonStyles.mainTitle,
            ),
          const SizedBox(height: 16.0),
          const Divider(height: 2.0, color: Colors.grey),
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
                // providerMainRead.getImage(title!),
                (locationMode ? Icons.place : Icons.backup),
                color: ConstantsColors.colorWhite,
              ),
            ),
            // title: Text('$desc Available', style: CommonStyles.mainTitle),
            // title: Text(desc, style: CommonStyles.mainTitle),
            title: Text(
              (locationMode || title != null ? desc ?? '' : fullDesc),
              style: const TextStyle(fontSize: 16.0, color: ConstantsColors.colorBlack54),
            ),
          ),
          const SizedBox(height: 6.0),
          // Container(
          //   alignment: Alignment.centerLeft,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         desc,
          //         style: const TextStyle(
          //             fontSize: 16.0, color: ConstantsColors.colorBlack54),
          //       ),
          //     ],
          //   ),
          // ),
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
                  style: CommonStyles.mainTitle,
                ),
              ),
              TextButton(
                onPressed: widget.action,
                child: const Text(
                  'OK',
                  style: CommonStyles.mainTitle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
