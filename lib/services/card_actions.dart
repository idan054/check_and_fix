// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:phone_backup/core/constants/constants_colors.dart';
import 'package:phone_backup/presentation/providers/provider_main.dart';
import 'package:phone_backup/presentation/providers/uni_provider.dart';
import 'package:phone_backup/presentation/widgets/common_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lastech_services/lastech_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/utils/init_service.dart';

class CardActions {
  static Future bottomLocationTag(BuildContext context, {Function? postAction}) async {
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26.0), topRight: Radius.circular(26.0)),
    );
    await showModalBottomSheet(
      context: context,
      shape: shape,
      builder: (BuildContext context) => CustomBottomSheet(
        desc: 'Add Location Tag to this '
            '${(!kIsWeb && Platform.isIOS ? 'sync?' : 'Backup?')}',
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

          if (postAction != null) postAction();
        },
      ),
    );
  }

  static void onRestore(BuildContext context, String mainTitle) async {
    final mainScope = providerMainScope(context);
    mainScope.isShowMessagesBackup = true;
    EasyLoading.showSuccess('Restoring completed!',
        dismissOnTap: true,
        duration: const Duration(milliseconds: 2000),
        maskType: EasyLoadingMaskType.custom);
    // Api().updateCallLogs(context, false);

    if (mainTitle == 'Contacts') {
      for (var c in mainScope.contacts) {
        await ContactsService.addContact(c);
      }
    }
  }

  // static dialog(BuildContext context) async {
  //   SharedPreferences? preferences = await SharedPreferences.getInstance();
  //   final passkey = preferences.getString('passKey');
  //   // log("Contacts backup ${passkey}");
  //   // ignore: use_build_context_synchronously
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Backup Done'),
  //         content: Text(
  //             "To view ur data on the Web use the pass key below: $passkey"),
  //         actions: [
  //           TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: const Text('Ok'))
  //         ],
  //       );
  //     },
  //   );
  // }

  static Future onBackupOrSync(BuildContext context, String mainTitle) async {
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

            List calendarsData = [];
            for (Calendar cal in c.data?.toList() ?? []) {
              calendarsData.add(
                {"name": '${cal.name}', "accountName": cal.accountName},
              );
            }
            await FirebaseFirestore.instance
                .collection('Calenders')
                .doc(passkey)
                .set({'items': calendarsData});
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
            // await dialog(context);
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
                    desc:
                        'CODE: $passkey\n Click "OK" to copy it. Use the code in https://bit.ly/3rzJRYZ',
                    action: () async {
                      Clipboard.setData(ClipboardData(text: '$passkey'));
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$passkey Code copied to clipboard')),);
                      await EasyLoading.showSuccess('$passkey Code copied to clipboard',
                          dismissOnTap: false,
                          duration: const Duration(milliseconds: 2000),
                          maskType: EasyLoadingMaskType.custom);

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
