import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/shared_data.dart';
//import 'package:share/share.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import 'package:flutter_contacts/flutter_contacts.dart';

class ItemDetails extends StatefulWidget {
  String? railway_code, cons_code, sccode;
  ItemDetails(this.railway_code, this.cons_code, this.sccode);
  @override
  _CustomItemDtailsState createState() => _CustomItemDtailsState();
}



class _CustomItemDtailsState extends State<ItemDetails> {
  List<DataRow> _rowList = [];
  String? railway = '';
  String consgnCode = '';
  String? cname = '';
  String? postdesig = '', ccode = '';
  String? name = '', email = '', cellNumber = '', address = '';
  String? overallname = '',
      overallemail = '',
      overallcellNumber = '',
      overalladdress = '',
      overallpostdesig = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  late final LanguageProvider language;


  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          splashRadius: 30,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          language.text('userDepotDetails'),
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              elevation: 7,
              child: Icon(
                Icons.share,
                color: Colors.white,
              ),
              backgroundColor: Colors.red[300],
              onPressed: () {
                _onShareData(
                    "Details of User Depot \n"
                        "Railway : " +
                        railway! +
                        "\nConsignee Code : " +
                        ccode! +
                        "\nC_Name : " +
                        cname! +
                        "\nName : " +
                        name! +
                        "\nDesignation : " +
                        postdesig! +
                        "\nEmail : " +
                        email! +
                        "\nMobile : " +
                        cellNumber! +
                        "\nAddress : " +
                        address! +
                        "\n\nDetails of Overall in-charge"
                            "\nName : " +
                        overallname! +
                        "\nDesignation : " +
                        overallpostdesig! +
                        "\nEmail : " +
                        overallemail! +
                        "\nMobile : " +
                        overallcellNumber!,
                    context);
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: <Widget>[
                  const SizedBox(height: 5),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 63,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      railway!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      cname!,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 37,
                                child: Column(
                                  children: [
                                    Text(
                                      language.text('consigneeCode'),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.pink[200],
                                      child: Text(
                                        ccode!,
                                        style: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      minRadius: 35,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  color: Colors.grey[700]!, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          name!,
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          postdesig!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            FittedBox(
                                              child: Text(
                                                email!.isEmpty ? ' ' : email!,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              cellNumber!,
                                              softWrap: true,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.blue,
                                            child: (name!.isEmpty ||
                                                name == null)
                                                ? Icon(Icons.person)
                                                : Text(name![0] +
                                                name!.split(' ').last[0]),
                                            minRadius: 25,
                                          ),
                                          Column(
                                            children: [
                                              TextButton(
                                                child: Text(language
                                                    .text('saveContact')),
                                                onPressed: () async {
                                                  if (await FlutterContacts
                                                      .requestPermission()) {
                                                    var newContact = Contact()
                                                      ..name.first =
                                                      name!.split(' ')[0]
                                                      ..name.last =
                                                          name!.split(' ').last
                                                      ..phones = [
                                                        Phone(cellNumber!)
                                                      ]
                                                      ..addresses = [
                                                        Address(address!)
                                                      ]
                                                      ..emails = [Email(email!)]
                                                      ..organizations = [
                                                        Organization(
                                                            company: railway!,
                                                            title: postdesig!),
                                                      ]
                                                      ..notes = [Note('Consignee Code: $ccode')
                                                      ];
                                                    var contactsList =
                                                    await FlutterContacts.getContacts(withProperties: true);
                                                    bool exists = false;
                                                    for(var contact in contactsList) {
                                                      for (Email emailNew
                                                      in contact.emails) {
                                                        if(emailNew.address == email) {
                                                          exists = true;
                                                        }
                                                      }
                                                      if(exists == true) {
                                                        break;
                                                      }
                                                      for(Phone phone in contact.phones) {
                                                        if(phone.number == cellNumber) {
                                                          exists = true;
                                                        }
                                                      }
                                                      if(exists == true) {
                                                        break;
                                                      }
                                                    }
                                                    if (exists) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                              title: Text(
                                                                  'Duplicate!'),
                                                              content: Text(
                                                                  'Contact with same email id or phone number already exists!'),
                                                              actions: [
                                                                TextButton(
                                                                  child: Text('OK'),
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                          context)
                                                                          .pop(),
                                                                )
                                                              ],
                                                            ),
                                                      );
                                                      return;
                                                    }
                                                    newContact =
                                                    await newContact
                                                        .insert();
                                                    await FlutterContacts
                                                        .openExternalEdit(
                                                        newContact.id);
                                                  }
                                                },
                                              ),
                                              TextButton(
                                                child: Text(language.text('whatsAppMsg')),
                                                onPressed: () async {
                                                  if(cellNumber != null && cellNumber!.isNotEmpty) {
                                                    var link = WhatsAppUnilink(
                                                      phoneNumber: cellNumber,
                                                      text: 'UDM App- ',
                                                    );
                                                    if(await canLaunch(link.toString())) {
                                                      await launch(link.toString());
                                                    }
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    address!,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        language.text('overallDetailsHeading'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red[500],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 64,
                                  child: Text(
                                    overallname!,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 36,
                                  child: Text(
                                    overallpostdesig!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      FittedBox(child: Text(overallemail!.isEmpty ? ' ' : overallemail!, style: TextStyle(fontSize: 18))),
                                      SizedBox(height: 10),
                                      Text(overallcellNumber!, softWrap: true, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      SizedBox(height: 10),
                                      Text(overalladdress!, style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      child: (overallname == null ||
                                          overallname!.isEmpty)
                                          ? Icon(Icons.person)
                                          : Text(overallname![0] +
                                          overallname!.split(' ').last[0]),
                                      minRadius: 25,
                                    ),
                                    TextButton(
                                      child: Text(language.text('saveContact')),
                                      onPressed: () async {
                                        if(await FlutterContacts.requestPermission()) {
                                          var newContact = Contact()
                                            ..name.first =
                                            overallname!.split(' ')[0]
                                            ..name.last =
                                                overallname!.split(' ').last
                                            ..phones = [
                                              Phone(overallcellNumber!)
                                            ]
                                            ..addresses = [
                                              Address(overalladdress!)
                                            ]
                                            ..emails = [Email(overallemail!)]
                                            ..organizations = [
                                              Organization(
                                                  company: railway!,
                                                  title: overallpostdesig!),
                                            ];
                                          var contactsList =
                                          await FlutterContacts.getContacts(withProperties: true);

                                          bool exists = false;
                                          for(var contact in contactsList) {
                                            for(Email email in contact.emails) {
                                              if(email.address == overallemail) {
                                                exists = true;
                                              }
                                            }
                                            if(exists == true) {
                                              break;
                                            }
                                            for(Phone phone in contact.phones) {
                                              if (phone.number == overallcellNumber) {
                                                exists = true;
                                              }
                                            }
                                            if (exists == true) {
                                              break;
                                            }
                                          }
                                          if (exists) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text('Duplicate!'),
                                                content: Text('Contact with same email id or phone number already exists!'),
                                                actions: [
                                                  TextButton(
                                                    child: Text('OK'),
                                                    onPressed: () => Navigator.of(context).pop(),
                                                  )
                                                ],
                                              ),
                                            );
                                            return;
                                          }
                                          newContact = await newContact.insert();
                                          await FlutterContacts.openExternalEdit(newContact.id);
                                        }
                                      },
                                    ),
                                    TextButton(
                                      child: Text(language.text('whatsAppMsg')),
                                      onPressed: () async {
                                        if (overallcellNumber != null &&
                                            overallcellNumber!.isNotEmpty) {
                                          var link = WhatsAppUnilink(
                                            phoneNumber: overallcellNumber,
                                            text: 'UDM app- ',
                                          );
                                          if (await canLaunch(
                                              link.toString())) {
                                            print(overallcellNumber);
                                            await launch(link.toString());
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  _onShareData(String data, BuildContext context) async {
    await Share.share(data + "");
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      IRUDMConstants.showProgressIndicator(context);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    language = Provider.of<LanguageProvider>(context);
    fetchActionData().then((_) {
      IRUDMConstants.removeProgressIndicator(context);

      super.didChangeDependencies();
    });
  }

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    //  'Authorization' : 'Bearer $token'
  };

  Future<void> fetchActionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var result_UDMItemData = await Network.postDataWithAPIM('Items/UDMItemsSearchAction/V1.0.0/UDMItemsSearchAction','UDMItemsSearchAction', widget.railway_code! + "~" + widget.cons_code! + "~" + widget.sccode!, prefs.getString('token'));

      var itemData = json.decode(result_UDMItemData.body);
      if (itemData['status'] != 'OK') {
        IRUDMConstants().showSnack("No Data Found", context);
      } else {
        var UDMITEMData_body = itemData['data'];
        var rest = UDMITEMData_body['DtlsUserDepot'];
        var incharge_data = UDMITEMData_body['DtlsIncharge'];
        var item_userDetails = rest["DATA"] as List?;
        var incharge_details = incharge_data["DATA"] as List?;
        setState(() {
          railway = item_userDetails == null ? "NA" : item_userDetails![0]['railway'];
          cname = item_userDetails == null ? "NA" : item_userDetails[0]['cname'];
          postdesig = item_userDetails == null ? "NA" : item_userDetails[0]['postdesig'];
          name = item_userDetails == null ? "NA"  : item_userDetails[0]['name'];
          email = item_userDetails == null ? "NA"  : item_userDetails[0]['email'];
          cellNumber = item_userDetails == null ? "NA" : item_userDetails[0]['cellnumber'];
          address = item_userDetails == null ? "NA" : item_userDetails[0]['address'];
          ccode = item_userDetails == null  ? "NA" : item_userDetails[0]['consigneecode'];
          overallname = incharge_details == null ? "NA" : incharge_details![0]['overallname'];
          overallemail = incharge_details == null? "NA" : incharge_details[0]['overallemail'];
          overallcellNumber = incharge_details == null ? "NA" : incharge_details[0]['overallcellnumber'];
          overalladdress = incharge_details == null ? "NA" : incharge_details[0]['overalladdress'];
          overallpostdesig = incharge_details == null ? "NA" :  incharge_details[0]['overallpostdesig'];
          //_progressHide();
        });
      }
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    }
  }
}
