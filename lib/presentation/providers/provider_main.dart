import 'package:flutter/material.dart';
import 'package:check_and_fix/presentation/pages/page_main/bottom_navigation_bar_views/bottom_navigation_bar_view.dart';
import 'package:check_and_fix/presentation/utils/services.dart';
import 'package:check_and_fix/data/models/list_main_model.dart';
import 'package:check_and_fix/data/models/main_model/main_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final providerMain =
    StateNotifierProvider<ProviderMain, MainModel>((ref) => ProviderMain());

class ProviderMain extends StateNotifier<MainModel> {
  ProviderMain() : super(const MainModel());

  void updateCurrentTabIndex(int index) =>
      state = state.copyWith(currentTabIndex: index);

  final List<Widget> tabs = [
    const BottomNavigationBarView(bnbType: BNBType.location),
    const BottomNavigationBarView(bnbType: BNBType.contacts),
    const BottomNavigationBarView(bnbType: BNBType.storage),
    const BottomNavigationBarView(bnbType: BNBType.microphone),
  ];

  List<ListMainModel> getListMainModelList() {
    List<ListMainModel> listMainModelList = [];

    listMainModelList.add(ListMainModel(
      icon: Icons.person,
      title: 'Backup',
      subtitle: 'Take all contacts backup in your directory.',
    ));

    listMainModelList.add(ListMainModel(
      icon: Icons.restore,
      title: 'Restore',
      subtitle: 'Restore your contacts backup from directory files.',
    ));

    listMainModelList.add(ListMainModel(
      icon: Icons.folder,
      title: 'View Backups',
      subtitle:
          'View your saved backup files. you can delete or share your backup files.',
    ));

    return listMainModelList;
  }

  String getTitlePage(BNBType bnbType) {
    String titlePage = '';

    switch (bnbType) {
      case BNBType.location:
        titlePage = 'Location';
        break;
      case BNBType.contacts:
        titlePage = 'Contacts';
        break;
      case BNBType.storage:
        titlePage = 'Storage';
        break;
      case BNBType.microphone:
        titlePage = 'Microphone';
        break;
    }

    return titlePage;
  }
}
