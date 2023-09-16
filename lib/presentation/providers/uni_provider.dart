import 'package:device_calendar/device_calendar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UniProvider with ChangeNotifier {
  List<PlatformFile> files = [];
  List<Calendar> calendars = [];

  void calendersUpdate(List<Calendar> data, {bool notify = true}) {
    calendars = data;
    if (notify) notifyListeners();
  }

  void filesUpdate(List<PlatformFile> data, {bool notify = true}) {
    files = data;
    if (notify) notifyListeners();
  }
}

extension ContextX on BuildContext {
  UniProvider get uniProvider => Provider.of<UniProvider>(this, listen: false);
  UniProvider get listenUniProvider => Provider.of<UniProvider>(this);

//? A ~ GET VALUE
// context.uniProvider.postUploaded; // current value.
// context.listenUniProvider.postUploaded; // current value & rebuild when B3 used

//? B ~ SET VALUE
// context.uniProvider.postUploaded = 'Biton';             // NOT notify listener
// context.uniProvider.updateName('Biton', notify: false); // NOT notify listener
// context.uniProvider.updateName('Biton');                // notify listener
}
