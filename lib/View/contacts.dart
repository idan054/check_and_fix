import 'package:files_sync/repository/contact_repository.dart';
import 'package:files_sync/repository/models/contacts_group.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MyContactList extends StatefulWidget {
  const MyContactList({Key? key}) : super(key: key);

  @override
  State<MyContactList> createState() => _MyContactListState();
}

class _MyContactListState extends State<MyContactList> {

  List<Contact> importedContacts = [];
  List<ContactGroup> myContact = [];

  @override
  void initState() {
    askPermissions();
    // TODO: implement initState
    super.initState();
  }
  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      var snackBar = const SnackBar(content: Text('Access to contact data granted'));
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      importedContacts.clear();
      importedContacts = await ContactsService.getContacts();

      for (var element in importedContacts) {
        String _ph = '';
        if(element.phones != null && element.phones!.isNotEmpty){
          for (var number in element.phones!) {
            _ph = '$_ph${number.value},';
          }
        }
        ContactGroup contactG = ContactGroup(
          displayName: element.displayName ?? '',
          givenName: element.givenName ?? '',
          middleName: element.middleName ?? '',
          familyName: element.familyName ?? '',
          prefix: element.prefix ?? '',
          phones: _ph ?? '',
          birthday: element.birthday != null ? element.birthday.toString() : '',
        );
        myContact.add(contactG);
      }
      setState(() {

      });
    } else {
      handleInvalidPermissions(permissionStatus);
    }
  }
  Future<PermissionStatus> getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      var snackBar = const SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      var snackBar = const SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  ContactRepository contactRepository = ContactRepository();
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
                  List<ContactGroup> tempContacts = await contactRepository.getAllContacts();
                  myContact.forEach((element) async {
                    try{
                      int index = tempContacts.indexWhere((value) => (value.givenName == element.givenName ||
                          value.displayName == element.displayName
                      ));
                      if(index == -1){
                        contactRepository.insertAccount(element);
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
                  List<Contact> tempContacts = await ContactsService.getContacts();
                  await contactRepository.getAllContacts().then((value) {
                    if(value.isEmpty){
                      var snackBar = const SnackBar(content: Text('No back contacts was found'));
                      if(mounted){
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }else{
                      if(value.length == tempContacts.length){
                        var snackBar = const SnackBar(content: Text('All contacts are synced'));
                        if(mounted){
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }else{
                        value.forEach((element) async {
                          try{
                            int index = tempContacts.indexWhere((value) => (value.givenName == element.givenName ||
                                value.displayName == element.displayName
                            ));
                            if(index == -1){
                              List<Item> phoneList = [];
                              phoneList.add(Item(label: 'Mobile' , value: element.phones));
                              Contact newContact = Contact(
                                displayName: element.displayName,
                                givenName: element.givenName,
                                middleName: element.middleName,
                                familyName: element.familyName,
                                prefix: element.prefix,
                                phones: phoneList,
                                birthday: (element.birthday!.isNotEmpty) ? DateTime.parse(element.birthday!) : null,
                              );
                              await ContactsService.addContact(newContact);
                            }else{
                            }
                          }catch(e){
                            debugPrint('This is error: $e');
                          }
                        });
                      }
                    }
                  });
                },
                child: const Text('Restore')),
            ElevatedButton(
                onPressed: () async {
                  contactRepository.deleteAllContacts();
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
              itemCount: myContact.length,
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
                        myContact[index].displayName ?? 'No Name',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text(
                        myContact[index].phones!.isNotEmpty ? myContact[index].phones!.replaceAll(',', '') : 'No number',
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