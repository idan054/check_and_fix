// ignore_for_file: use_build_context_synchronously

import 'package:check_and_fix/core/constants/constants_colors.dart';
import 'package:check_and_fix/presentation/providers/provider_main.dart';
import 'package:check_and_fix/presentation/providers/uni_provider.dart';
import 'package:check_and_fix/presentation/widgets/common_bottom_sheet.dart';
import 'package:check_and_fix/services/api_services.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';

import '../presentation/utils/init_service.dart';

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
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26.0), topRight: Radius.circular(26.0)),
    );
    await showModalBottomSheet(
      context: context,
      shape: shape,
      builder: (BuildContext context) => CustomBottomSheet(
        title: mainTitle,
        action: () async {
          final mainTitleX = mainTitle.toCapitalized();
          await Init.dummyLoader(mainTitleX);
          await Future.delayed(const Duration(milliseconds: 1500));

          if (mainTitleX == "Files") {
            FilePickerResult? result =
                await FilePicker.platform.pickFiles(allowMultiple: true);
            context.uniProvider.filesUpdate(result?.files ?? []);
          }
          if (mainTitleX == "Call Records") {
            await Api.sendCallLogs(context, '', '');
            //
          } else if (mainTitleX == "Calender") {
            await DeviceCalendarPlugin().requestPermissions();
            final c = await DeviceCalendarPlugin().retrieveCalendars();
            context.uniProvider.calendersUpdate(c.data?.toList() ?? []);
          }
          Navigator.pop(context);

          //? Also add Location tag?
          showModalBottomSheet(
            context: context,
            shape: shape,
            builder: (BuildContext context) => CustomBottomSheet(
              title: 'Add Location Tag to this Backup?',
              action: () async {
                await Geolocator.requestPermission();
                final locationData = await Geolocator.getCurrentPosition();
                print('locationData.longitude ${locationData.longitude}');
                print('locationData.latitude ${locationData.latitude}');
                await EasyLoading.showSuccess('Location tag added!',
                    dismissOnTap: false,
                    duration: const Duration(milliseconds: 1250),
                    maskType: EasyLoadingMaskType.custom);
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
