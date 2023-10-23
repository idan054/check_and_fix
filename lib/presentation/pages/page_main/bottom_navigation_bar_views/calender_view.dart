import 'package:phone_backup/presentation/providers/uni_provider.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

class CalenderView extends StatefulWidget {
  const CalenderView({Key? key}) : super(key: key);

  @override
  State<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  @override
  void initState() {
    DeviceCalendarPlugin().requestPermissions().then((value) async {
      final c = await DeviceCalendarPlugin().retrieveCalendars();
      context.uniProvider.calendersUpdate(c.data?.toList() ?? []);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final calenders = context.uniProvider.calendars;
    return Container();
  }
}
