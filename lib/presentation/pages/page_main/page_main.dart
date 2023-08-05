import 'package:check_and_fix/core/constants/constants_colors.dart';
import 'package:check_and_fix/presentation/providers/provider_main.dart';
import 'package:check_and_fix/presentation/utils/init_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageMain extends ConsumerStatefulWidget {
  const PageMain({super.key});

  @override
  ConsumerState<PageMain> createState() => _PageMainState();
}

class _PageMainState extends ConsumerState<PageMain> {
  @override
  void initState() {
    super.initState();
    Init().initConnection();
  }

  @override
  Widget build(BuildContext context) {
    final providerMainWatch = ref.watch(providerMain);
    final providerMainRead = ref.read(providerMain.notifier);

    return Scaffold(
      backgroundColor: ConstantsColors.colorIndigoAccent,
      appBar: AppBar(
        backgroundColor: ConstantsColors.colorIndigoAccent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Phone Backup',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: providerMainRead.tabsList[providerMainWatch.currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: ConstantsColors.colorIndigoAccent,
        selectedIconTheme: const IconThemeData(color: ConstantsColors.colorWhite),
        unselectedIconTheme: const IconThemeData(color: ConstantsColors.colorWhite60),
        selectedItemColor: ConstantsColors.colorWhite,
        unselectedItemColor: ConstantsColors.colorWhite60,
        currentIndex: providerMainWatch.currentTabIndex,
        onTap: (int index) => providerMainRead.updateCurrentTabIndex(index),
        items: const [
          // Call Records, SMS, Contacts, Files)
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'Call Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'SMS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Files',
          ),
        ],
      ),
    );
  }
}
