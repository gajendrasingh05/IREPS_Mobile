import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/NoConnection.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/aapoorti/home/tender/tenderstatus/tender_status_view.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/aapoorti/home/tender/highvaluetender/high_value_tender_details.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'CatalogueDetails.dart';

class CatalogueSum extends StatefulWidget {
  CatalogueSum() : super();

  final String title = "DropDown Demo";

  @override
  CatalogueSumState createState() => CatalogueSumState();
}

class CatalogueSumState extends State<CatalogueSum> {

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  int? _user;
  String? txt1, txt2;
  ProgressDialog? pr;
  var users = <String>[
    'Goods & Services',
    'Works',
    'Earning& Leasing',
  ];
  bool _enable = true;
  bool visibilityTag = false;
  bool visibilityObs = false;
  bool visibilityclose = false;
  bool visibilityupload = false;
  String Dt1In = "12/Aug/2019",
      Dt2In = "10/Sep/2019",
      searchOption = "2",
      OrgCode = "01",
      ClDate = "0";
  String? item1, item2, item3, item4, item5, item6, item7;

  String? _mySelection1,
      _mySelection2,
      _mySelection3,
      _mySelection4,
      _mySelection5,
      _finalsel1;
  List<dynamic>? jsonResult1;
  List<dynamic>? jsonResult2;
  List<dynamic>? jsonResult3;
  List<dynamic>? jsonResult4;
  dynamic jsoninstant;
  int counter = 0;
  Text? txtfirst, txtsecond;

  @override
  void initState() {
    super.initState();
    print("coming in setstate");
    dataOrganisation.add('Select Railway Unit');
    dataOrganisation.add('CENTRAL RLY');
    dataOrganisation.add('CLW');
    dataOrganisation.add('CORE');
    dataOrganisation.add('DLW');
    dataOrganisation.add('DMRC');
    dataOrganisation.add('DMW');
    dataOrganisation.add('EAST CENTRAL RLY');
    dataOrganisation.add('EASTERN RLY');
    dataOrganisation.add('ECOR');
    dataOrganisation.add('ICF');
    dataOrganisation.add('IREPS-TESTING');
    dataOrganisation.add('KRCL');
    dataOrganisation.add('MCF- RAE BARELI');
    dataOrganisation.add('METRO RAILWAY');
    dataOrganisation.add('N F RLY');
    dataOrganisation.add('NORTH CENTRAL RLY');
    dataOrganisation.add('NORTH EASTERN RL');
    dataOrganisation.add('NORTH WESTERN RLY');
    dataOrganisation.add('NORTHERN RLY');
    dataOrganisation.add('RCF');
    dataOrganisation.add('RWF');
    dataOrganisation.add('RWP\/BELA');
    dataOrganisation.add('SOUTH CENTRAL RLY');
    dataOrganisation.add('SOUTH EAST CENTRAL RLY');
    dataOrganisation.add('SOUTH EASTERN RLY');
    dataOrganisation.add('SOUTH WESTERN RLY');
    dataOrganisation.add('SOUTHERN RLY');
    dataOrganisation.add('WEST CENTRAL RLY');
    dataOrganisation.add('WESTERN RLY');

    dataOrgID.add('-15');
    dataOrgID.add('561');
    dataOrgID.add('6721');
    dataOrgID.add('31381');
    dataOrgID.add('1222');
    dataOrgID.add('55541');
    dataOrgID.add('831');
    dataOrgID.add('6806');
    dataOrgID.add('8937');
    dataOrgID.add('3482');

    dataOrgID.add('641');
    dataOrgID.add('301');
    dataOrgID.add('58281');
    dataOrgID.add('20281');
    dataOrgID.add('31528');
    dataOrgID.add('4527');
    dataOrgID.add('541');
    dataOrgID.add('4702');
    dataOrgID.add('4494');
    dataOrgID.add('401');

    dataOrgID.add('501');
    dataOrgID.add('1233');
    dataOrgID.add('43901');
    dataOrgID.add('562');
    dataOrgID.add('581');
    dataOrgID.add('5261');
    dataOrgID.add('4495');
    dataOrgID.add('582');
    dataOrgID.add('601');
    dataOrgID.add('483');

    // this.fetchPostOrganisation();
    pr = ProgressDialog(context);
    this.fetchPostZone();
    //  this.fetchPostDepartment();
    //this.fetchPostUnit();
  }

  DateTime _valueto = DateTime.now();
  DateTime _valuefrom = DateTime.now().add(Duration(days: 1));

  Future _selectDateTo() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );
    if (picked != null) setState(() => _valueto = picked);
  }

  Future _selectDateFrom() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );
    if (picked != null) setState(() => _valuefrom = picked);
  }

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "tag") {
        visibilityTag = visibility;
        visibilityObs = false;
      }
    });
  }

  void _changedtick(bool visibility, String field) {
    setState(() {
      if (field == "yestick") {
        visibilityclose = visibility;
        visibilityupload = false;
      } else {
        visibilityclose = false;
        visibilityupload = visibility;
      }
    });
  }

  List dataOrganisation = [];
  List dataOrgID = [];
  List dataZone = [];
  List dataDepartment = [];
  List dataUnit = [];
//  Future<String> fetchPostOrganisation() async {
//    print('Fetching from service first spinner');
//    var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ORGANIZATION,null,null,null,null';
//    print("ur1-----"+u);
//    //  var u=AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,${myselection1}';
//
//    final response1 = await http.post(u);
//    //  final response1 =   await http.post(u);
//    jsonResult1 = json.decode(response1.body);
//    // jsonResult1 = json.decode(response1.body);
//    print("jsonresult1===");
//    print(jsonResult1);
////    print("jsonresult1===");
////    print(jsonResult1);
//
//
//    setState(() {
//
//
////data1=jsonResult1;
//    });
//  }
  Future<String> fetchPostZone() async {
    AapoortiUtilities.getProgressDialog(pr!);
    print('Fetching from service');
    int pos = dataOrganisation.indexOf(_mySelection1);
    _finalsel1 = dataOrgID[pos];
    _mySelection2 = null.toString();
    _mySelection3 = null.toString();
    //  dataZone.clear();
    var v = AapoortiConstants.webServiceUrl +
        'Auction/DepotList?ACCID=${_finalsel1}';
    print("url2-----" + v);
    //var vl="https://ireps.gov.in/Aapoorti/ServiceCall/getData?input=SPINNERS,ZONE,-2,,,null";
    final response = await http.post(Uri.parse(v));
    jsonResult2 = json.decode(response.body);
    //  jsonResult2.insert(0, {-1,'Sect Depot'});
    AapoortiUtilities.stopProgress(pr!);
    print("jsonResult2------");
    print(jsonResult2);
//    dynamic jsoninstant1=jsonResult2[0];
//    jsonResult2.insert(0, jsoninstant1);
//    print(jsoninstant1);
//    jsoninstant=jsoninstant1;
//    jsoninstant['DEPTID']=-1;
//    jsoninstant['DEPTNM']="Select Depot";
    // print(jsoninstant1);

    setState(() {
      dataZone = jsonResult2!;

      print("datazone......" + dataZone.toString());
//  print("datazone id"+jsonResult2['ID'].toString());
    });
    //print(resBody);
    return "Success";
  }

  Future<String> callWebService() async {
    _mySelection3 = null.toString();
//    jsonResult3=null;
    //  dataDepartment.clear();
    AapoortiUtilities.getProgressDialog(pr!);
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN +
        "," +
        AapoortiUtilities.user!.S_TOKEN +
        ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + _mySelection2!;

    jsonResult3 = await AapoortiUtilities.fetchPostPostLogin(
        'AFLAuction/ACNO', 'ACNO', inputParam1, inputParam2);
    print(jsonResult3);
    AapoortiUtilities.stopProgress(pr!);
    setState(() {
      dataDepartment = jsonResult3!;
//data1=jsonResult1;
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    final TopSection = Container(
      // padding: new EdgeInsets.only(left: 10,right: 150,top: 10),

      child: Row(
        children: <Widget>[
          Icon(
            Icons.train,
            color: Colors.black,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 0),
              height: 30,
              width: 350,
              child: DropdownButton(
                isExpanded: true,
                isDense: true,
                hint: Text(_mySelection1 != null
                    ? _mySelection1!
                    : "Select Railway Unit"),
                items: dataOrganisation.map((item) {
                  return DropdownMenuItem(
                      child: Text(item != null ? item : "abc"),
                      value: item);
                }).toList(),
                onChanged: (newVal1) {
                  setState(() {
                    _enable = true;
                    _mySelection1 = newVal1.toString();
                    print("my selection first" + _mySelection1!);
                  });
                  fetchPostZone();
                },
                value: _mySelection1,
              ),
            ),
          ),
        ],
//
      ),
      margin: EdgeInsets.only(top: 30.0, left: 10, right: 10, bottom: 10),
    );
    final TopSection1 = Container(
      // padding: new EdgeInsets.only(left: 10,right: 150),

      child: Row(
        children: <Widget>[
          Icon(
            Icons.account_balance,
            color: Colors.black,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              width: 350,
              child: DropdownButton(
                isDense: true,
                isExpanded: true,
                hint: Text('Select Depot'),
                items: dataZone.map((item) {
                  return DropdownMenuItem(
                      child: Text(item['DEPTNM'] != null
                          ? item['DEPTNM']
                          : "not found"),
                      value: item['DEPTID'].toString());
                }).toList(),
                onChanged: (newVal1) {
                  setState(() {
                    _mySelection2 = newVal1.toString();
                    print("my selection second" + _mySelection2!);
                  });
                  callWebService();
                },
                value: _mySelection2,
              ),
            ),
          )
        ],
      ),
      margin: EdgeInsets.only(top: 30.0, left: 10, right: 10, bottom: 10),
    );
    final TopSection2 = Container(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.looks_one,
            color: Colors.black,
          ),
          Expanded(
            child: Container(
              width: 350,
              padding: EdgeInsets.only(left: 10, right: 10),
              child: DropdownButton(
                isDense: true,
                isExpanded: true,
                hint: Text('Select One'),
                items: dataDepartment.map((item) {
                  return DropdownMenuItem(
                      child: Text(item['CATALOG_NO'] != null
                          ? item['CATALOG_NO']
                          : "ABC"),
                      value: item['CATALOG_ID'].toString());
                }).toList(),
                onChanged: (newVal1) {
                  setState(() {
                    _mySelection3 = newVal1.toString();
                  });
                  //fetchPostUnit();
                },
                value: _mySelection3,
              ),
            ),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 40.0, left: 10, right: 10, bottom: 10),
    );

    final BottomSection = Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.1,
                      0.3,
                      0.5,
                      0.7,
                      0.9
                    ],
                    colors: [
                      Colors.teal[400]!,
                      Colors.teal[400]!,
                      Colors.teal[800]!,
                      Colors.teal[400]!,
                      Colors.teal[400]!,
                    ]),
              ),
              child: Builder(
                builder: (context) => MaterialButton(
                  minWidth: 350,
                  height: 20,
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  onPressed: () async {
                    if (_mySelection1 != null &&
                        _mySelection2 != null &&
                        _mySelection3 != null) {
                      bool check = await AapoortiUtilities.checkConnection();
                      if (check == true)
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CatalogueDetails(_mySelection3!)));
                      else
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoConnection()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                  },
                  child: Text('Submit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            )
          ],
        ));

    final BottomSection1 = Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [
                            0.1,
                            0.3,
                            0.5,
                            0.7,
                            0.9
                          ],
                          colors: [
                            Colors.teal[400]!,
                            Colors.teal[400]!,
                            Colors.teal[800]!,
                            Colors.teal[400]!,
                            Colors.teal[400]!,
                          ]),
                    ),
                    child: MaterialButton(
                      minWidth: 350,
                      height: 20,
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                      onPressed: () {
                        reset();
                      },
                      child: Text('Reset',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  )
                ],
              ))
        ]));

    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: _scaffoldkey,

            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              title: Text("Catalogue Summary"),
              backgroundColor: Colors.teal,
            ),
            backgroundColor: Colors.black,
            drawer: AapoortiUtilities.navigationdrawer(_scaffoldkey,context),
            body: Builder(
              builder: (context) => Material(
                child: Container(
                  //color: Colors.black,
                  child: Column(
                    children: <Widget>[
                      TopSection,
                      TopSection1,
                      TopSection2,
                      BottomSection,
                      BottomSection1,
                    ],
                  ),
                ),
              ),
            )));
  }

  void reset() {
    _mySelection3 = null.toString();
    _mySelection2 = null.toString();
    _mySelection1 = null.toString();
    _finalsel1 = null.toString();
    setState(() {
      _mySelection3 = null.toString();
      _mySelection2 = null.toString();
      _mySelection1 = null.toString();
      _finalsel1 = null.toString();
    });
  }

  final snackbar = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Please select values',
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white),
      ),
    ),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
}
