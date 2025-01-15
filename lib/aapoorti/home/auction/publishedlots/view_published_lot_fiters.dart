import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:http/http.dart' as http;
//import'package:flutter_app/aapoorti/home/tender/tenderstatus/tender_status_view.dart';
import 'package:intl/intl.dart';

//import 'package:flutter_app/aapoorti/home/tender/highvaluetender/high_value_tender_details.dart';

class published_filters extends StatefulWidget {
  published_filters() : super();

  final String title = "DropDown Demo";

  @override
  published_filters_state createState() => published_filters_state();
}

class published_filters_state extends State<published_filters> {
  int? _user;
  String? txt1, txt2;
  var users = <String>[
    'Goods & Services',
    'Works',
    'Earning& Leasing',
  ];

  String? _mySelection1 = "-1", _mySelection2, _mySelection3;
  List<dynamic>? jsonResult1;
  List<dynamic>? jsonResult2;
  List<dynamic>? jsonResult3;
  List<dynamic>? jsonResult4;

  int counter = 0;

  @override
  void initState() {
    super.initState();
    fetchPostOrganisation();

    //this.fetchPostUnit();
  }

  List dataOrganisation = [];
  List dataZone = [];
  List dataDepartment = [];
  List data = [];

  Future<void> fetchPostOrganisation() async {
    if (AapoortiUtilities.dataOrganisation == null) {
      AapoortiUtilities.fetchPostOrganisation();
      jsonResult1 = AapoortiUtilities.dataOrganisation;
    } else
      jsonResult1 = AapoortiUtilities.dataOrganisation;
    dataOrganisation = jsonResult1!;
    setState(() {
      jsonResult1 = AapoortiUtilities.dataOrganisation;
      dataOrganisation = jsonResult1!;
    });
  }

  Future<String> fetchPostZone() async {
    var v = AapoortiConstants.webServiceUrl +
        '/getData?input=AUCTION_PRELOGIN,DP_START_DATE,${this._mySelection1}';
    //var vl="https://ireps.gov.in/Aapoorti/ServiceCall/getData?input=SPINNERS,ZONE,-2,,,null";
    final response = await http.post(Uri.parse(v));
    jsonResult2 = json.decode(response.body);

    setState(() {
      dataZone = jsonResult2!;
    });
    return "Success";
  }

  Future<void> fetchPostDepartment() async {
    var u = AapoortiConstants.webServiceUrl +
        '/getData?input=SPINNERS,DEPARTMENT,${this._mySelection1},${this._mySelection2}';
    final response1 = await http.post(Uri.parse(u));
    jsonResult3 = json.decode(response1.body);

    setState(() {
      dataDepartment = jsonResult3!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TopSection = Container(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.train,
            color: Colors.black,
          ),
          DropdownButton(
            hint: Text('     Select Organization       '),
            items: dataOrganisation.map((item) {
              return DropdownMenuItem(
                  child: Text(item['NAME']), value: item['ID'].toString());
            }).toList(),
            onChanged: (newVal1) {
              setState(() {
                _mySelection1 = newVal1;
              });
              fetchPostZone();
            },
            value: _mySelection1,
          ),
        ],
      ),
      margin: EdgeInsets.all(10.0),
    );
    final TopSection1 = Container(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.camera,
            color: Colors.black,
          ),
          DropdownButton(
            hint: Text('     Select        '),
            items: dataZone.map((item) {
              return DropdownMenuItem(
                  child: Text(item['NAME']), value: item['ID'].toString());
            }).toList(),
            onChanged: (newVal1) {
              setState(() {
                _mySelection2 = newVal1;
              });
              fetchPostDepartment();
            },
            value: _mySelection2,
          ),
        ],
      ),
      margin: EdgeInsets.all(10.0),
    );
    final TopSection2 = Container(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.account_balance,
            color: Colors.black,
          ),
          DropdownButton(
            hint: Text('     Select Department       '),
            items: dataDepartment.map((item) {
              return DropdownMenuItem(
                  child: Text(item['NAME']), value: item['ID'].toString());
            }).toList(),
            onChanged: (newVal1) {
              setState(() {
                _mySelection3 = newVal1;
              });
              // fetchPostUnit();
            },
            value: _mySelection3,
          ),
        ],
      ),
      margin: EdgeInsets.all(10.0),
    );
    final BottomSection = Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            ButtonTheme(
              minWidth: double.infinity,
              child: MaterialButton(
                onPressed: () => {
                },
                textColor: Colors.white,
                color: Colors.cyan[600],
                height: 35,
                child: Text(
                  "Apply",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            )
          ],
        ));

    final BottomSection1 = Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            ButtonTheme(
              //elevation: 4,
              //color: Colors.green,
              minWidth: double.infinity,
              child: MaterialButton(
                onPressed: () => {},
                textColor: Colors.white,
                color: Colors.cyan[600],
                height: 35,
                child: Text(
                  "Reset",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            )
          ],
        ));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "my APP",
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Published Lots(Sale)"),
                Padding(padding: EdgeInsets.only(left: 140)),
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/common_screen", (route) => false);
                  },
                )
              ],
            ),
            backgroundColor: Colors.cyan[400],
          ),
          backgroundColor: Colors.black,
          body: Material(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 370.0,
                    height: 25.0,
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                      "   Published Lot Search ",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                      textAlign: TextAlign.start,
                    ),
                    color: Colors.cyan[700],
                  ),
                  TopSection,
                  TopSection1,
                  TopSection2,
                  BottomSection,
                  BottomSection1,
                ],
              ),
            ),
          ),
        ));
  }
}
