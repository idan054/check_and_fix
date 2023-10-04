// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:check_and_fix/core/constants/constants_colors.dart';
import 'package:check_and_fix/data/models/card_model.dart';
import 'package:check_and_fix/presentation/pages/page_main/bottom_navigation_bar_views/files_view.dart';
import 'package:check_and_fix/presentation/providers/provider_main.dart';
import 'package:check_and_fix/presentation/providers/uni_provider.dart';
import 'package:check_and_fix/services/api_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:share_plus/share_plus.dart';

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
    Widget page = const Offstage();
    if (bnbType == BNBType.files && !kIsWeb && Platform.isAndroid) {
      page = const FilesView();
    } else if ((bnbType == BNBType.calender || bnbType == BNBType.files) &&
        !kIsWeb &&
        Platform.isIOS) {
      page = bodyBg(
          body: const Center(
        child:
            Text('This feature will be available soon! ', style: CommonStyles.mainTitle),
      ));
    } else {
      const privacyUrl =
          'https://docs.google.com/document/d/1aqZtQoF07VW1PtumKUw5sObgpE6d25hmM5HoPB1BojI/edit';
      page = bodyBg(
        body: Column(
          children: [
            Text(bnbType.name.toCapitalized(), style: CommonStyles.titleStyle),
            const SizedBox(height: 40),
            const _ActionCardList(),
            TextButton(
              onPressed: () =>
                  launchUrl(Uri.parse(privacyUrl), mode: LaunchMode.externalApplication),
              child: const Text('Privacy Policy', style: CommonStyles.clickable),
            ),
          ],
        ),
      );
    }
    return page;
  }

  Widget bodyBg({Widget? body}) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: const BoxDecoration(
            color: Color(0xfff6f6f6),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: body);
  }
}

class _ActionCardList extends ConsumerWidget {
  const _ActionCardList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerMainRead = ref.read(providerMain.notifier);
    final providerMainWatch = ref.watch(providerMain);

    String title = providerMainRead.bnbList[providerMainWatch.currentTabIndex].name;
    List<CardModel> cardModelList =
        providerMainRead.getCardModelList(title, isContacts: title == 'contacts');

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
    final tabType = widget.mainTitle;
    var title = listMainModelItem.title;
    bool isEnable = true;
    final mainScope = providerMainScope(context);

    if (tabType == 'contacts' && !kIsWeb && Platform.isIOS) {
      if (title == 'Backup') title = 'Sync';
      if (title == 'Restore') title = 'Share';
      if (title == 'View') title = 'Copy';
    }

    // final providerMainWatch = ref.watch(providerMain);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          onTap: isEnable
              ? () async {
                  // 1st. Android - Backup
                  // 1st. IOS - Sync
                  if (title == 'Backup' || title == 'Sync') {
                    await CardActions.onBackupOrSync(context, tabType);
                    setState(() {});
                  }

                  // 2nd. Android - Restore
                  // 2nd. IOS - Transfer
                  if (title == 'Restore') {
                    CardActions.onRestore(context, tabType);
                  }
                  if (title == 'Share') {
                    CardActions.bottomLocationTag(context,
                        postAction: () async => await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  _buildViewContacts(context, shareMode: true),
                            )));
                  }

                  // 3rd. Android - View
                  // 3rd. IOS - Copy
                  if (title == 'View' || title == 'Copy') {
                    await CardActions.bottomLocationTag(context, postAction: () async {
                      // This dialog show TextField that request "Sync Code" to View data
                      await showWebDialogIfNeeded(tabType);

                      // Default
                      Widget page = ViewBackupPage(
                          title: '${tabType.toCapitalized()} '
                              '${!kIsWeb && Platform.isIOS ? 'Copy' : 'Backup'}',
                          body: const Column(children: [Row()]));

                      if (tabType == 'Messages') {
                        page = _buildViewMessages(context);
                      } else if (tabType == 'call records') {
                        page = _buildViewCallRecords(context);
                      } else if (tabType == 'contacts') {
                        page = _buildViewContacts(context);
                      } else if (tabType == 'files') {
                        page = _buildViewFiles(context);
                      } else if (tabType == 'calender') {
                        page = _buildViewCalenders(context);
                      }

                      await Navigator.push(
                          context, MaterialPageRoute(builder: (context) => page));
                    });
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
          title: Builder(builder: (context) {
            var txt = '$title';
            if (title == 'View' &&
                tabType == 'Files' &&
                context.listenUniProvider.files.isNotEmpty) {
              txt = 'View ${context.uniProvider.files.length} Files';
              //
            } else if (title == 'View' &&
                tabType == 'calender' &&
                context.listenUniProvider.calendars.isNotEmpty) {
              txt = 'View ${context.uniProvider.calendars.length} Calenders';
            }

            return Text(txt, style: const TextStyle(fontWeight: FontWeight.bold));
          }),
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

  Future showWebDialogIfNeeded(String tabType) async {
    final codeController = TextEditingController(text: kDebugMode ? '#0675a' : null);
    if (kIsWeb) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enter your sync code'),
            content: TextField(
              controller: codeController,
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                  hintText: 'Example: #00fc8',
                  hintStyle: TextStyle(fontWeight: FontWeight.normal)),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  String collection = '';
                  if (tabType == 'contacts') collection = 'Contacts';
                  if (tabType == 'calender') collection = 'Calenders';

                  final resp = await FirebaseFirestore.instance
                      .collection(collection)
                      .doc(codeController.text)
                      .get();
                  final data = resp.data()?['items'];

                  print('data ${data}');

                  if (tabType == 'contacts') {
                    List<Contact> _contacts = [];
                    for (var c in data) {
                      _contacts.add(Contact(
                        givenName: '${c['name']}',
                        phones: [
                          Item(value: '${c['mobileNumber']}'),
                        ],
                      ));
                    }

                    providerMainScope(context).contacts = _contacts;
                  }
                  if (tabType == 'calender') {
                    List<Calendar> _calender = [];
                    for (var c in data) {
                      _calender.add(Calendar(
                        name: '${c['name']}',
                        accountName: '${c['accountName']}',
                      ));
                    }
                    context.uniProvider.calendersUpdate(_calender);
                  }

                  Navigator.of(context).pop();
                },
                child: Text('Enter'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildViewContacts(BuildContext context, {bool shareMode = false}) {
    final listMainModelItem = widget.listMainModelItem;
    final mainTitle = widget.mainTitle.toCapitalized();
    var appBarTitle = '';
    final mainProvider = providerMainScope(context);

    var contacts = providerMainScope(context).contacts;
    final contactsLength = contacts.length;
    bool checkAll = false;
    List<bool> checkedItems = List.generate(contactsLength, (i) => false);
    List<String> sContacts = [];

    if (!kIsWeb && Platform.isAndroid) appBarTitle = '$mainTitle Backup';
    if (!kIsWeb && Platform.isIOS) appBarTitle = 'Sync $mainTitle';
    if (shareMode) appBarTitle = 'Share $mainTitle';

    return StatefulBuilder(builder: (context, stfState) {
      return ViewBackupPage(
        title: appBarTitle,
        appBarButton: !kIsWeb && Platform.isIOS
            ? Row(
                children: [
                  Checkbox(
                    side: const BorderSide(color: Colors.white, width: 2),
                    value: checkAll,
                    onChanged: (bool? value) {
                      checkAll = !checkAll;
                      if (checkAll) {
                        checkedItems = List.generate(contactsLength, (i) => true);
                        contacts.forEach((c) => (c.phones ?? []).isEmpty
                            ? null
                            : sContacts
                                .add('${c.givenName} : ${c.phones?.first.value}\n'));
                      } else {
                        checkedItems = List.generate(contactsLength, (i) => false);
                        sContacts = [];
                      }
                      stfState(() {});
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      if (shareMode) {
                        final data = '$sContacts'
                            .replaceAll('[', '')
                            .replaceAll(']', '')
                            .replaceAll(',', '');

                        // Share.share(data);

                        // final Email email = Email(
                        //   // recipients: ['placeholder@gmail.com'],
                        //   body: data,
                        //   subject: '${sContacts.length} contacts info is ready',
                        //   isHTML: false,
                        // );
                        // await FlutterEmailSender.send(email);

                        await EasyLoading.showSuccess(
                            // '${sContacts.length} Contacts sent at mail',
                            '${sContacts.length} Contacts shared',
                            dismissOnTap: false,
                            duration: const Duration(milliseconds: 2000),
                            maskType: EasyLoadingMaskType.custom);

                        Navigator.pop(context);
                      } else {
                        Clipboard.setData(ClipboardData(
                            text: '$sContacts'
                                .replaceAll('[', '')
                                .replaceAll(']', '')
                                .replaceAll(',', '')));
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$passkey Code copied to clipboard')),);
                        await EasyLoading.showSuccess(
                            '${sContacts.length} Contacts copied to clipboard',
                            dismissOnTap: false,
                            duration: const Duration(milliseconds: 2000),
                            maskType: EasyLoadingMaskType.custom);

                        Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Icon(
                        size: 25,
                        Icons.check_circle,
                        color: Colors.green[200],
                      ),
                    ),
                  ),
                ],
              )
            : null,
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
                    trailing: !kIsWeb && Platform.isIOS
                        ? Checkbox(
                            value: checkedItems[i],
                            onChanged: (bool? value) {
                              print('value ${value}');
                              if (value == false) checkAll = false;
                              checkedItems[i] = value ?? false;
                              sContacts.add(
                                  '${contact.givenName} : ${contact.phones?.first.value}\n');
                              stfState(() {});
                            },
                          )
                        : null,
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
    });
  }

  Widget _buildViewCalenders(BuildContext context) {
    final listMainModelItem = widget.listMainModelItem;
    final mainTitle = widget.mainTitle.toCapitalized();
    final mainProvider = providerMainScope(context);
    var calenders = context.uniProvider.calendars;

    return ViewBackupPage(
      title: '$mainTitle Backup',
      body: ListView.builder(
        itemCount: calenders.length,
        itemBuilder: (context, i) {
          final calender = calenders[i];

          return Column(
            children: [
              Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.today)),
                  title: Text('${calender.name}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child:
                        Text('${calender.accountName}', style: TextStyle(fontSize: 13)),
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

  Widget _buildViewFiles(BuildContext context) {
    final listMainModelItem = widget.listMainModelItem;
    final mainTitle = widget.mainTitle.toCapitalized();
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
