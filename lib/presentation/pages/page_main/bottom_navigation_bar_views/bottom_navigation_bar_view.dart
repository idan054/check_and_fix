import 'package:check_and_fix/core/constants/constants_colors.dart';
import 'package:check_and_fix/data/models/card_model.dart';
import 'package:check_and_fix/presentation/providers/provider_main.dart';
import 'package:check_and_fix/presentation/utils/services.dart';
import 'package:check_and_fix/presentation/widgets/common_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view_backup_page.dart';

class BottomNavigationBarView extends StatelessWidget {
  const BottomNavigationBarView({
    super.key,
    required this.bnbType,
  });

  final BNBType bnbType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xfff6f6f6),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _Title(bnbType: bnbType),
          const SizedBox(height: 40),
          const _ActionCardList(),
        ],
      ),
    );
  }
}

class _Title extends ConsumerWidget {
  const _Title({required this.bnbType});

  final BNBType bnbType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerMainRead = ref.read(providerMain.notifier);

    return Text(
      providerMainRead.getTitlePage(bnbType),
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: ConstantsColors.colorBlueGrey,
      ),
    );
  }
}

class _ActionCardList extends ConsumerWidget {
  const _ActionCardList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerMainRead = ref.read(providerMain.notifier);
    final providerMainWatch = ref.watch(providerMain);

    String title = providerMainRead.getTitlePage(
        providerMainRead.bnbList[providerMainWatch.currentTabIndex]);
    List<CardModel> cardModelList = providerMainRead.getCardModelList(title);

    return Expanded(
      child: ListView.separated(
        itemCount: cardModelList.length,
        itemBuilder: (BuildContext context, int i) =>
            _CardItem(cardModelList[i], title),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 20),
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  const _CardItem(this.listMainModelItem, this.mainTitle);

  final CardModel listMainModelItem;
  final String mainTitle;

  @override
  Widget build(BuildContext context) {
    bool isEnable = true;
    // bool isEnable = !(listMainModelItem.title == 'Restore');

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          onTap: isEnable
              ? () {
                  if (listMainModelItem.title == 'Backup') {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(26.0),
                          topRight: Radius.circular(26.0),
                        ),
                      ),
                      builder: (BuildContext context) =>
                          CustomBottomSheet(title: 'Backup $mainTitle Logs'),
                    );
                  }
                  if (listMainModelItem.title == 'Restore') {
                    EasyLoading.showSuccess('Restoring completed!',
                        dismissOnTap: true,
                        duration: const Duration(milliseconds: 1250),
                        maskType: EasyLoadingMaskType.custom);
                    Api().updateCallLogs(context, false);
                  }
                  if (listMainModelItem.title == 'View Backups') {
                    Widget page = ViewBackupPage(
                        title: '$mainTitle Backup',
                        body: const Column(children: [Row()]));

                    if (mainTitle == 'Messages') {
                      page = buildViewMessages(context);
                    } else if (mainTitle == 'Call Records') {
                      page = buildViewCallRecords(context);
                    }

                    // 'Call Records'
                    // 'Contacts'
                    // 'Files'
                    // 'Messages'

                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => page));
                  }
                }
              : null,
          enabled: isEnable,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: ConstantsColors.colorIndigo,
            ),
            child: Icon(
              listMainModelItem.icon,
              color: isEnable
                  ? ConstantsColors.colorWhite
                  : ConstantsColors.colorWhite60,
            ),
          ),
          title: Text(
            listMainModelItem.title!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              listMainModelItem.subtitle!,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildViewCallRecords(BuildContext context) {
    final mainProvider = providerMainScope(context);
    return ViewBackupPage(
      title: '$mainTitle Backup',
      body: ListView.builder(
        itemCount: mainProvider.callLogs.length,
        itemBuilder: (context, i) {
          final call = mainProvider.callLogs[i];
          return call.isHide
              ? Container()
              : Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: Text('${call.name} (${call.mobileNumber})'),
                        subtitle: Text('${call.duration} Minutes'),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('${call.datetime?.toLocal()}'),
                    ),
                    const SizedBox(height: 15),
                  ],
                );
        },
      ),
    );
    ;
  }

  Widget buildViewMessages(BuildContext context) {
    final mainProvider = providerMainScope(context);
    return ViewBackupPage(
      title: '$mainTitle Backup',
      body: ListView.builder(
        itemCount: mainProvider.smsLogs.length,
        itemBuilder: (context, i) {
          final sms = mainProvider.smsLogs[i];
          return Column(
            children: [
              Card(
                child: ListTile(
                  title: Text('${sms.phoneNumber}'),
                  subtitle: Text('${sms.message}'),
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: Text('${sms.datetime?.toLocal()}'),
              ),
              const SizedBox(height: 15),
            ],
          );
        },
      ),
    );
  }
}
