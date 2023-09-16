import 'package:flutter/material.dart';

import '../../core/constants/constants_colors.dart';
import '../providers/provider_main.dart';

class CustomBottomSheet extends StatefulWidget {
  final String? title;
  final VoidCallback? action;

  const CustomBottomSheet({super.key, required this.action, required this.title});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final providerMainRead = providerMainScope(context);
    final title = widget.title;
    var desc =
        // 'Total ${200 + Random().nextInt(2000 - 200 + 1)} $title Found.'
        'Agree to backup all $title logs in your default directory?';
    final locationMode = (title ?? '').contains('Location');

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
              'Backup '
              '${title!.toCapitalized()}',
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
              (locationMode ? title ?? '' : desc),
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
