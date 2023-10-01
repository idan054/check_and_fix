import 'dart:io';

import 'package:check_and_fix/data/models/card_model.dart';
import 'package:check_and_fix/data/models/card_model/main_model.dart';
import 'package:check_and_fix/data/models/sms_model/sms_model.dart';
import 'package:check_and_fix/services/api_services.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/calls_model/calls_model.dart';

// List<PlatformFile> backupFiles = [];

////

final providerMain =
    StateNotifierProvider<ProviderMain, MainModel>((ref) => ProviderMain());

ProviderMain providerMainScope(BuildContext context) =>
    ProviderScope.containerOf(context, listen: false).read(providerMain.notifier);

class ProviderMain extends StateNotifier<MainModel> {
  ProviderMain() : super(const MainModel());
  final bnbList = [
    if (!kIsWeb && Platform.isAndroid) ...[
      BNBType.callRecords,
      BNBType.sms,
    ] else ...[
      // BNBType.location,
      BNBType.calender,
    ],
    BNBType.contacts,
    BNBType.files,
  ];

  void updateCurrentTabIndex(int index) => state = state.copyWith(currentTabIndex: index);

  List<CallsModel> callLogs = [];
  List<CallsModel> hiveCallLogs = [];
  List<Contact> contacts = [];
  List<SmsModel> smsLogs = [];
  bool isShowMessagesBackup = true;

  List<CardModel> getCardModelList(String title, {bool isContacts = false}) {
    List<CardModel> listMainModelList = [];

    if (!kIsWeb) {
      listMainModelList.add(CardModel(
        // icon: Icons.person,
        icon: isContacts && !kIsWeb && Platform.isIOS
            ? Icons.phonelink_rounded
            : Icons.backup,
        title: 'Backup',
        subtitle: 'Take all $title in your directory.',
      ));

      listMainModelList.add(CardModel(
        icon: isContacts && !kIsWeb && Platform.isIOS
            ? Icons.forward_to_inbox_rounded
            : Icons.restore,
        title: 'Restore',
        subtitle: isContacts && !kIsWeb && Platform.isIOS
            ? 'Transfer your contacts info via mail'
            : 'Restore your $title backup from directory files.',
      ));
    }

    listMainModelList.add(CardModel(
      icon: isContacts && !kIsWeb && Platform.isIOS ? Icons.copy_rounded : Icons.folder,
      title: 'View',
      subtitle: isContacts && !kIsWeb && Platform.isIOS
          ? 'Select contacts to copy to clipboard'
          : 'View your saved backup files',
    ));

    return listMainModelList;
  }

  IconData getImage(String bnbType) {
    IconData image = Icons.phone;

    switch (bnbType) {
      case 'Call Records':
        image = Icons.phone;
        break;
      case 'Messages':
      case 'SMS':
        image = Icons.message;
        break;
      case 'Contacts':
        image = Icons.group;
        break;
      case 'Files':
        image = Icons.folder;
        break;
    }

    return image;
  }
}
