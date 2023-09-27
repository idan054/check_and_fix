// ignore_for_file: use_build_context_synchronously

import 'package:check_and_fix/core/constants/constants_colors.dart';
import 'package:check_and_fix/presentation/providers/provider_main.dart';
import 'package:check_and_fix/presentation/providers/uni_provider.dart';
import 'package:check_and_fix/presentation/widgets/common_bottom_sheet.dart';
import 'package:check_and_fix/services/api_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        desc: mainTitle,
        action: () async {
          final mainTitleX = mainTitle.toCapitalized();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final passkey = prefs.getString('passKey');
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
          if (mainTitleX == "Contacts") {
            List<Contact> contacts = await ContactsService.getContacts();
            // List<User>? phonesData;
            List phonesData = [];

            for (var c in contacts) {
              if ((c.phones ?? []).isNotEmpty) {
                phonesData.add(
                  {
                    "mobileNumber": '${c.phones?.first.value}',
                    "name": c.displayName,
                  },
                );
              }
            }
            await FirebaseFirestore.instance
                .collection('Contacts')
                .doc(passkey)
                .set({'items': phonesData});
          }
          Navigator.pop(context);

          //? Also add Location tag?
          await showModalBottomSheet(
            context: context,
            shape: shape,
            builder: (BuildContext context) => CustomBottomSheet(
              desc: 'Add Location Tag to this Backup?',
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

                await showModalBottomSheet(
                  context: context,
                  shape: shape,
                  builder: (BuildContext context) => CustomBottomSheet(
                    title: 'Your sync code is ready!',
                    desc: 'CODE: $passkey\n Click "OK" to copy it.',
                    action: () async {
                      Clipboard.setData(ClipboardData(text: '$passkey'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Code copied to clipboard')),
                      );
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
