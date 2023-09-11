import 'package:check_and_fix/presentation/providers/provider_main.dart';
import 'package:check_and_fix/presentation/widgets/common_bottom_sheet.dart';
import 'package:check_and_fix/services/api_services.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CardActions {
  static void onRestore(BuildContext context, String mainTitle) async {
    final mainScope = providerMainScope(context);
    mainScope.isShowMessagesBackup = true;
    EasyLoading.showSuccess('Restoring completed!',
        dismissOnTap: true,
        duration: const Duration(milliseconds: 2000),
        maskType: EasyLoadingMaskType.custom);
    Api().updateCallLogs(context, false);

    if (mainTitle == 'Contacts') {
      for (var c in mainScope.contacts) {
        await ContactsService.addContact(c);
      }
    }
  }

  static Future onBackup(BuildContext context, String mainTitle) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26.0), topRight: Radius.circular(26.0)),
      ),
      builder: (BuildContext context) => CustomBottomSheet(title: 'Backup $mainTitle'),
    );
  }
}
