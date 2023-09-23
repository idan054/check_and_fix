import 'package:call_log/call_log.dart';
import 'package:files_sync/repository/call_log_repository.dart';
import 'package:files_sync/repository/models/call_log_group.dart';
import 'package:flutter/material.dart';

class MyCallLog extends StatefulWidget {
  const MyCallLog({Key? key}) : super(key: key);

  @override
  State<MyCallLog> createState() => _MyCallLogState();
}

class _MyCallLogState extends State<MyCallLog> {

  Iterable<CallLogEntry> importedCallLogs = [];
  List<CallLogGroup> myLogs = [];

  @override
  void initState() {
    getAllCallLogs();
    // TODO: implement initState
    super.initState();
  }

  getAllCallLogs() async {
  importedCallLogs = await CallLog.get();
  for (var element in importedCallLogs) {

    CallLogGroup callLogGroup = CallLogGroup(
      name: element.name ?? '',
      number: element.number ?? '',
      formattedNumber: element.formattedNumber ?? '',
      callType: element.callType.toString(),
      duration: element.duration ?? 0,
      timestamp: element.timestamp ?? 0,
      cachedNumberType: element.cachedNumberType ?? 0,
      cachedNumberLabel: element.cachedNumberLabel ?? '',
      cachedMatchedNumber: element.cachedMatchedNumber ?? '',
      simDisplayName:  element.simDisplayName ?? '',
      phoneAccountId: element.phoneAccountId ?? '',
    );
    myLogs.add(callLogGroup);
  }
  setState(() {

  });

}
  CallLogRepository callLogRepository = CallLogRepository();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                onPressed: () async {
                  List<CallLogGroup> tempLogs = await callLogRepository.getAllCallLogs();
                  myLogs.forEach((element) async {
                    try{
                      int index = tempLogs.indexWhere((value) => (value.timestamp == element.timestamp));
                      if(index == -1){
                        callLogRepository.insertAccount(element);
                      }else{

                      }
                    }catch(e){
                      debugPrint('This is error: $e');
                    }
                  });
                },
                child: const Text(
                    'Backup'
                )
            ),
            ElevatedButton(
                onPressed: () async {
                  await callLogRepository.getAllCallLogs().then((value) {
                    if(value.isEmpty){
                      var snackBar = const SnackBar(content: Text('No back logs was found'));
                      if(mounted){
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }else{
                      myLogs.clear();
                      myLogs = value;
                      setState(() {

                      });
                    }
                  });
                },
                child: const Text('Restore')),
            ElevatedButton(
                onPressed: () async {
                  callLogRepository.deleteAllContacts();
                  var snackBar = const SnackBar(content: Text('Back Up has been deleted'));
                  if(mounted){
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Text('Delete Backup')),

          ],
        ),
        Expanded(
            child: ListView.builder(
              itemCount: myLogs.length,
              itemBuilder: (context, index){
                return Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: ListTile(
                      title: Text(
                        myLogs[index].name ?? 'No Name',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text(
                        myLogs[index].number!.isNotEmpty ? myLogs[index].number!.replaceAll(',', '') : 'No number',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                );
              },
            )
        )
      ],
    );
  }
}