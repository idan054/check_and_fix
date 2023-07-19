import 'dart:convert';
import 'color_printer.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_number/mobile_number.dart';
import 'package:uuid/uuid.dart';

class Api {
  /// On 1st start only (Should be)"
  static Future<String?> initRegister(String agent) async {
    const url = 'https://directupdate.link/a_agent_register';
    final headers = {'Content-Type': 'application/json', 'User-Agent': agent};
    printYellow('headers ${headers}');
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('initRegister - Response: \n$responseData\n--');

      try {
        // {extra_data: {"agent_uuid": "901916f1-803b-4a56-b302-0209d4515b8d"}, status: 1}
        final uuid = jsonDecode(responseData['extra_data'])['agent_uuid'];
        return uuid;
      } catch (e, s) {
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
      printYellow('PASS agentUpdate() command_id: ${data?['command_id']} No SERVER UUID');
      return;
    }

    const url = 'https://directupdate.link/a_agent_upload';
    final headers = {'Content-Type': 'application/json', 'User-Agent': agent};
    // final String mobileNumber = await MobileNumber.mobileNumber ?? '';

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
      print('Request failed with status: ${response.statusCode}');
    }
  }
}
