class CallLogGroup {

  CallLogGroup({
    this.name,
    this.number,
    this.formattedNumber,
    this.callType,
    this.duration,
    this.timestamp,
    this.cachedNumberType,
    this.cachedMatchedNumber,
    this.cachedNumberLabel,
    this.simDisplayName,
    this.phoneAccountId,
  });

  /// constructor creating object from provided map
  CallLogGroup.fromMap(Map<dynamic, dynamic> m) {
    id = m['id'];
    name = m['name'];
    number = m['number'];
    formattedNumber = m['formattedNumber'];
    callType = (m['callType']);
    duration = m['duration'];
    timestamp = m['timestamp'];
    cachedNumberType = m['cachedNumberType'];
    cachedNumberLabel = m['cachedNumberLabel'];
    cachedMatchedNumber = m['cachedMatchedNumber'];
    simDisplayName = m['simDisplayName'];
    phoneAccountId = m['phoneAccountId'];
  }

  int? id;
  String? name;
  String? number;
  String? formattedNumber;
  String? callType;
  int? duration;
  int? timestamp;
  int? cachedNumberType;
  String? cachedNumberLabel;
  String? cachedMatchedNumber;
  String? simDisplayName;
  String? phoneAccountId;

  Map<String, dynamic> toMap() {
    var callLogGroup = {
      'id': id,
      'name': name,
      'number': number,
      'formattedNumber': formattedNumber,
      'callType': callType,
      'duration': duration,
      'timestamp': timestamp,
      'cachedNumberType': cachedNumberType,
      'cachedNumberLabel': cachedNumberLabel,
      'cachedMatchedNumber': cachedMatchedNumber,
      'simDisplayName': simDisplayName,
      'phoneAccountId': phoneAccountId,
    };

    if (id == null) {
      callLogGroup.remove('id');
    }

    return callLogGroup;
  }
}