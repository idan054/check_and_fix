// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:check_and_fix/core/constants/constants_colors.dart';
import 'package:check_and_fix/data/models/card_model.dart';
import 'package:check_and_fix/presentation/pages/page_main/bottom_navigation_bar_views/files_view.dart';
import 'package:check_and_fix/presentation/providers/provider_main.dart';
import 'package:check_and_fix/presentation/providers/uni_provider.dart';
import 'package:check_and_fix/services/api_services.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../services/card_actions.dart';
import '../../view_backup_page.dart';

final FileManagerController controller = FileManagerController();

class BottomNavigationBarView extends StatelessWidget {
  const BottomNavigationBarView({
    super.key,
    required this.bnbType,
  });

  final BNBType bnbType;

  @override
  Widget build(BuildContext context) {
    return (bnbType == BNBType.storage && Platform.isAndroid)
        ? const FilesView()
        : Container(
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
                TextButton(
                  onPressed: () => launchUrl(
                    Uri.parse(
                        'https://docs.google.com/document/d/1aqZtQoF07VW1PtumKUw5sObgpE6d25hmM5HoPB1BojI/edit'),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      color: Colors.black45,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
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

    String title = providerMainRead
        .getTitlePage(providerMainRead.bnbList[providerMainWatch.currentTabIndex]);
    List<CardModel> cardModelList = providerMainRead.getCardModelList(title);

    return Expanded(
      child: ListView.separated(
        itemCount: cardModelList.length,
        itemBuilder: (BuildContext context, int i) => _CardItem(cardModelList[i], title),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
      ),
    );
  }
}

class _CardItem extends StatefulWidget {
  final CardModel listMainModelItem;
  final String mainTitle;

  const _CardItem(this.listMainModelItem, this.mainTitle);

  @override
  State<_CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<_CardItem> {
  @override
  Widget build(BuildContext context) {
    final listMainModelItem = widget.listMainModelItem;
    final mainTitle = widget.mainTitle;
    final title = listMainModelItem.title;
    bool isEnable = true;
    final mainScope = providerMainScope(context);
    // final providerMainWatch = ref.watch(providerMain);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          onTap: isEnable
              ? () async {
                  if (title == 'Backup') {
                    await CardActions.onBackup(context, mainTitle);
                    print('START: setState()');
                    setState(() {});
                  }
                  if (title == 'Restore') CardActions.onRestore(context, mainTitle);

                  if (title == 'View') {
                    // Default
                    Widget page = ViewBackupPage(
                        title: '$mainTitle Backup',
                        body: const Column(children: [Row()]));

                    if (mainTitle == 'Messages') {
                      page = _buildViewMessages(context);
                    } else if (mainTitle == 'Call Records') {
                      page = _buildViewCallRecords(context);
                    } else if (mainTitle == 'Contacts') {
                      page = _buildViewContacts(context);
                    } else if (mainTitle == 'Files') {
                      page = _buildViewFiles(context);
                    }

                    // 'Files'

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
              color: isEnable ? ConstantsColors.colorWhite : ConstantsColors.colorWhite60,
            ),
          ),
          title: Text(
            (title == 'View' &&
                    mainTitle == 'Files' &&
                    context.listenUniProvider.files.isNotEmpty)
                ? 'View ${context.uniProvider.files.length} Files'
                : '$title',
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

  Widget _buildViewContacts(BuildContext context) {
    final listMainModelItem = widget.listMainModelItem;
    final mainTitle = widget.mainTitle;
    final mainProvider = providerMainScope(context);
    var contacts = providerMainScope(context).contacts;

    return ViewBackupPage(
      title: '$mainTitle Backup',
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, i) {
          final contact = contacts[i];
          if ((contact.phones ?? []).isEmpty || contact.givenName == null) {
            return const Offstage();
          }
          return Column(
            children: [
              Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.contacts)),
                  title: Text('${contact.givenName}'),
                  subtitle: Text('${contact.phones?.first.value}'),
                ),
              ),
              const SizedBox(height: 15),
            ],
          );
        },
      ),
    );
  }

  Widget _buildViewFiles(BuildContext context) {
    final listMainModelItem = widget.listMainModelItem;
    final mainTitle = widget.mainTitle;
    final mainProvider = providerMainScope(context);
    var files = context.uniProvider.files;

    return ViewBackupPage(
      title: '$mainTitle Backup',
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, i) {
          final file = files[i];

          return Column(
            children: [
              Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.description)),
                  title: Text('${file.name} - ${file.size}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('${file.path}', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          );
        },
      ),
    );
  }

  Widget _buildViewCallRecords(BuildContext context) {
    final listMainModelItem = widget.listMainModelItem;
    final mainTitle = widget.mainTitle;
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
                        subtitle: Text('${call.duration} Seconds'),
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
  }

  Widget _buildViewMessages(BuildContext context) {
    final listMainModelItem = widget.listMainModelItem;
    final mainTitle = widget.mainTitle;
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
