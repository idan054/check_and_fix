import 'dart:io';

import 'package:check_and_fix/core/constants/constants_colors.dart';
import 'package:check_and_fix/presentation/providers/provider_main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_services.dart';
import '../settings_page.dart';
import 'bottom_navigation_bar_views/bottom_navigation_bar_view.dart';

class PageMain extends ConsumerStatefulWidget {
  const PageMain({super.key});

  @override
  ConsumerState<PageMain> createState() => _PageMainState();
}

class _PageMainState extends ConsumerState<PageMain> {
  @override
  Widget build(BuildContext context) {
    final providerMainWatch = ref.watch(providerMain);
    final providerMainRead = ref.read(providerMain.notifier);
    final tabIndex = providerMainWatch.currentTabIndex;

    List<Widget> tabs = providerMainRead.bnbList
        .map((type) => BottomNavigationBarView(bnbType: type))
        .toList();

    return Scaffold(
      backgroundColor: ConstantsColors.colorIndigoAccent,
      appBar: commonAppBar(),
      body: tabs[tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: ConstantsColors.colorIndigoAccent,
        selectedIconTheme: const IconThemeData(color: ConstantsColors.colorWhite),
        unselectedIconTheme: const IconThemeData(color: ConstantsColors.colorWhite60),
        selectedItemColor: ConstantsColors.colorWhite,
        unselectedItemColor: ConstantsColors.colorWhite60,
        currentIndex: tabIndex,
        onTap: (int index) => providerMainRead.updateCurrentTabIndex(index),
        items: [
          // Call Records, SMS, Contacts, Files)
          if (!kIsWeb && Platform.isAndroid) ...[
            const BottomNavigationBarItem(icon: Icon(Icons.phone), label: 'Call Records'),
            const BottomNavigationBarItem(icon: Icon(Icons.message), label: 'SMS'),
          ] else ...[
            // const BottomNavigationBarItem(icon: Icon(Icons.place), label: 'Location'),
            const BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Calender'),
          ],
          const BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Contacts'),
          const BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Files'),
        ],
      ),
    );
  }
}

class commonAppBar extends StatefulWidget implements PreferredSizeWidget {
  String? title;
  bool showButton;
  Widget? customButton;

  commonAppBar([this.showButton = true, this.title, this.customButton]);

  @override
  State<commonAppBar> createState() => _commonAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _commonAppBarState extends State<commonAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ConstantsColors.colorIndigoAccent,
      centerTitle: true,
      elevation: 0,
      title: Text(
        widget.title ??
            (!kIsWeb && Platform.isIOS ? 'CONTACTS COPY & SYNC' : 'Phone Backup'),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: [
        if (widget.customButton != null) widget.customButton!,
        if (widget.showButton)
          widget.title == null
              ? kIsWeb
                  ? const Offstage()
                  : InkWell(
                      onTap: () async {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const SettingsPage()));
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      ),
                    )
              : InkWell(
                  onTap: () async {
                    EasyLoading.showSuccess('delete completed!',
                        dismissOnTap: true,
                        duration: const Duration(milliseconds: 1250),
                        maskType: EasyLoadingMaskType.custom);

                    providerMainScope(context).isShowMessagesBackup = false;

                    if (widget.title == 'Call Records Backup') {
                      Api().updateCallLogs(context, true);
                    }

                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                )
      ],
    );
  }
}

// AppBar commonAppBar([String? title, context]) => AppBar(
//       backgroundColor: ConstantsColors.colorIndigoAccent,
//       centerTitle: true,
//       elevation: 0,
//       title: Text(
//         title ?? 'Phone Backup',
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//       actions: [
//         if (title == 'Call Records Backup')
//           GestureDetector(
//             onTap: () async {
//
//
//               EasyLoading.showSuccess('delete completed!',
//                   dismissOnTap: true,
//                   duration: const Duration(milliseconds: 1250),
//                   maskType: EasyLoadingMaskType.custom);
//               Api().updateCallLogs(context, true);
//             },
//             child: const Padding(
//               padding: EdgeInsets.only(right: 20.0),
//               child: Icon(
//                 Icons.delete,
//                 color: Colors.red,
//               ),
//             ),
//           )
//       ],
//     );
