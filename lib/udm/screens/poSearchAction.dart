import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';
//import 'package:share/share.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/shared_data.dart';

class PoSearch extends StatefulWidget {
  String? railway_code, pokey;
  PoSearch(this.railway_code, this.pokey);
  @override
  _CustomItemDtailsState createState() => _CustomItemDtailsState();
}

class _CustomItemDtailsState extends State<PoSearch>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  static const List<IconData> icons = const [
    Icons.person_add,
    Icons.mail,
    Icons.phone,
    Icons.share,
  ];
  Future<void> _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Function> get floatingActions => [() async {
      if (await FlutterContacts.requestPermission()) {
        var newContact = Contact()
          ..name.first = contactPerson!.split(' ')[0]
          ..name.last = contactPerson!.split(' ').last
          ..phones = [Phone(phon!)]
          ..addresses = [Address(address!)]
          ..emails = [Email(emailId!)]
          ..organizations = [
            Organization(
              company: vName!,
            ),
          ]
          ..notes = [Note('Consignee Code: $ccode')];
        var contactsList =
        await FlutterContacts.getContacts(withProperties: true);

        bool exists = false;
        for (var contact in contactsList) {
          for (Email email in contact.emails) {
            if (email.address == emailId) {
              //print(email.address);
              exists = true;
            }
          }
          if (exists == true) {
            break;
          }
          for (Phone phone in contact.phones) {
            if (phone.number == phon) {
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
        if (!exists) {
          newContact = await newContact.insert();
        }
        await FlutterContacts.openExternalEdit(newContact.id);
      } else {
      }
    },
        () async {
      await _openUrl('mailto:$emailId');
    },
        () async {
      await _openUrl('tel:$phon');
    },
        () {
      _onShareData(
          "View Contact Details \n"
              "Vendor's Name (M/s): " +
              vName! +
              "\nVendor Code : " +
              vCode! +
              "\nAddress : " +
              address! +
              "\nEmail Id : " +
              emailId! +
              "\nPhone No. : " +
              phon! +
              "\nFax : " +
              fax! +
              "\nContact Person : " +
              contactPerson!
          // "\Mobile No. : "+companyUrl
          ,
          context);
    }
  ];
  String? vName = '';
  String? vCode = '';
  String? address = '';
  String? emailId = '', ccode = '';
  String? phon = '', fax = '', contactPerson = '', companyUrl = '';
  String location = '';
  bool _autoValidate = false;
  var _isAtEnd = false;
  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
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
        title: Text(language.text('viewContactDetails'), style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: vName == null || vName == '' ? SizedBox() : Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(icons.length, (int index) {
          Widget child = Container(
            height: 70.0,
            width: 56.0,
            alignment: Alignment.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _controller,
                curve: Interval(0.0, 1.0 - index / icons.length,
                    curve: Curves.easeOut),
              ),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return FloatingActionButton(
                    heroTag: null,
                    backgroundColor: Colors.white,
                    mini: true,
                    child: Transform(
                      transform: Matrix4.rotationZ((_controller.value) / 2 * pi + 3 * pi / 2),
                      alignment: FractionalOffset.center,
                      child: FadeTransition(
                        opacity: _controller.view,
                        child: Icon(
                          icons[index],
                          color: Colors.red[300],
                        ),
                      ),
                    ),
                    onPressed: () {
                      floatingActions[index]();
                    },
                  );
                },
              ),
            ),
          );
          return child;
        }).toList()..add(
            FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.red[300],
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return Transform(
                    transform: Matrix4.rotationZ(_controller.value * 0.5 * pi),
                    alignment: FractionalOffset.center,
                    child: Icon(_controller.isDismissed ? Icons.menu : Icons.close, color: Colors.white),
                  );
                },
              ),
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
            ),
          ),
      ),
      body: SingleChildScrollView(
        child: vName == null || vName == '' ? Container(height: mq.height, width: mq.width, child: Center(child: CircularProgressIndicator())) : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                child: Icon(
                  Icons.domain,
                  color: Colors.white,
                  size: 40,
                ),
                backgroundColor: Colors.black,
                radius: 35,
              ),
              SizedBox(height: 10),
              Text(
                vName!,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          language.text('vendorCode'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[400],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          vCode.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextColumn(
                          description: "Address",
                          value: address,
                          icon: Icons.location_on,
                        ),
                        TextColumn(
                          description: "Email Id",
                          value: emailId,
                          icon: Icons.mail,
                        ),
                        TextColumn(
                          description: "Phone No.",
                          value: phon,
                          icon: Icons.call,
                        ),
                        TextColumn(
                          description: "Fax",
                          value: fax,
                          icon: Icons.print,
                        ),
                        TextColumn(
                          description: "Contact Person",
                          value: contactPerson,
                          icon: Icons.person,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
    _future = fetchActionData();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  Future<void>? _future;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    //  'Authorization' : 'Bearer $token'
  };
  Future<void> fetchActionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {

      var result_UDMItemData=await Network.postDataWithAPIM('UDM/SearchPO/GetPOResultContactDetails/V1.0.0/GetPOResultContactDetails','GetPOResultContactDetails', widget.railway_code! + "~" + widget.pokey!,prefs.getString('token'));
      var itemData = json.decode(result_UDMItemData.body);
      var UDMITEMData_body = itemData['data'];
      setState(() {
        vName = UDMITEMData_body[0]['vendorname'];

        vCode = UDMITEMData_body[0]['vendorcode'];
        address = UDMITEMData_body[0]['address'];
        emailId = UDMITEMData_body[0]['emailid'];
        phon = UDMITEMData_body[0]['phoneno'];
        fax = UDMITEMData_body[0]['faxno'];
        contactPerson = UDMITEMData_body[0]['contactperson'];
        // designation = UDMITEMData_body[0]['DESIGNATION'];
        //mobile = UDMITEMData_body[0]['MOBILENO'];
      });
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

class TextColumn extends StatelessWidget {
  const TextColumn({
    Key? key,
    required this.icon,
    required this.description,
    required this.value,
  }) : super(key: key);

  final IconData icon;
  final String description;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 30,
          ),
          SizedBox(width: 10),
          Flexible(
            child: Column(
              children: [
                SizedBox(height: 5),
                Text(
                  value!.trim().isEmpty ? 'NA' : value!,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
