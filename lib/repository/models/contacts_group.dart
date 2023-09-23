class ContactGroup {
  int? id;
  String? displayName;
  String? givenName;
  String? middleName;
  String? familyName;
  String? prefix;
  String? phones;
  String? birthday;
  ContactGroup({this.id, this.displayName, this.prefix, this.phones, this.birthday, this.givenName, this.middleName, this.familyName});

  Map<String, dynamic> toMap() {
    var contactGroup = {
      'id': id,
      'displayName': displayName,
      'givenName': givenName,
      'middleName': middleName,
      'familyName': familyName,
      'prefix': prefix,
      'phones': phones,
      'birthday': birthday,
    };

    if (id == null) {
      contactGroup.remove('id');
    }

    return contactGroup;
  }

  factory ContactGroup.fromMap(Map<String, dynamic> map) {
    return ContactGroup(
      id: map['id'],
      displayName: map['displayName'],
      givenName: map['givenName'],
      middleName: map['middleName'],
      familyName: map['familyName'],
      prefix: map['prefix'],
      phones: map['phones'],
      birthday: map['birthday'],
    );
  }
}
