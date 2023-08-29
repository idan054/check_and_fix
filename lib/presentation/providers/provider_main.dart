import 'package:check_and_fix/data/models/card_model.dart';
import 'package:check_and_fix/data/models/card_model/main_model.dart';
import 'package:check_and_fix/data/models/sms_model/sms_model.dart';
import 'package:check_and_fix/presentation/pages/page_main/bottom_navigation_bar_views/bottom_navigation_bar_view.dart';
import 'package:check_and_fix/presentation/utils/services.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/calls_model/calls_model.dart';

final providerMain =
    StateNotifierProvider<ProviderMain, MainModel>((ref) => ProviderMain());

ProviderMain providerMainScope(BuildContext context) =>
    ProviderScope.containerOf(context, listen: false).read(providerMain.notifier);

class ProviderMain extends StateNotifier<MainModel> {
  ProviderMain() : super(const MainModel());
  final bnbList = [BNBType.callRecords, BNBType.sms, BNBType.contacts, BNBType.storage];
  final List<Widget> tabsList = [
    const BottomNavigationBarView(bnbType: BNBType.callRecords),
    const BottomNavigationBarView(bnbType: BNBType.sms),
    const BottomNavigationBarView(bnbType: BNBType.contacts),
    const BottomNavigationBarView(bnbType: BNBType.storage),
  ];

  void updateCurrentTabIndex(int index) => state = state.copyWith(currentTabIndex: index);

  List<CallsModel> callLogs = [];
  List<CallsModel> hiveCallLogs = [];
  Iterable<Contact> contacts = [];
  List<SmsModel> smsLogs = [];

  bool isShowMessagesBackup = true;

  List<CardModel> getCardModelList(String title) {
    List<CardModel> listMainModelList = [];

    listMainModelList.add(CardModel(
      icon: Icons.person,
      title: 'Backup',
      subtitle: 'Take all $title backup in your directory.',
    ));

    listMainModelList.add(CardModel(
      icon: Icons.restore,
      title: 'Restore',
      subtitle: 'Restore your $title backup from directory files.',
    ));

    listMainModelList.add(CardModel(
      icon: Icons.folder,
      title: 'View',
      subtitle: 'View your saved backup files',
    ));

    return listMainModelList;
  }

  String getTitlePage(BNBType bnbType) {
    String titlePage = '';

    switch (bnbType) {
      case BNBType.callRecords:
        titlePage = 'Call Records';
        break;
      case BNBType.contacts:
        titlePage = 'Contacts';
        break;
      case BNBType.storage:
        titlePage = 'Files';
        break;
      case BNBType.sms:
        titlePage = 'Messages';
        break;
    }
    return titlePage;
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
