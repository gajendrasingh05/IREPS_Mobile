//DEEPAS PC CODE
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'PendingTenderReportDetails.dart';

class PendingTenderReport extends StatefulWidget {
  get path => null;

  @override
  _PendingTenderReportState createState() => _PendingTenderReportState();
}

class _PendingTenderReportState extends State<PendingTenderReport> {

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  int _user = 0;
  List<dynamic>? jsonResult1;
  List<dynamic>? jsonResult2;
  List<dynamic>? jsonResult3;
  List<dynamic>? jsonResult4;
  List<dynamic>? jsonResult5;
  List<dynamic>? jsonResult;
  String? url;
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);
  ProgressDialog? pr;
  DateTime? selected;
  List dataOrganisation = [];
  List dataZone = [];
  List dataDepartment = [];
  List dataUnit = [];
  List dataUnitType = [];
  String? _mySelection1,
      _mySelection2,
      _mySelection3,
      _mySelection4,
      _mySelection5;
  String? item1, item2, item3, item4, item5;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Text? txtfirst, txtsecond;
  bool pressed = false;
  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(context);
    this.fetchPostOrganisation();
    this.fetchPostZone();
    this.fetchPostDepartment();
    //this.fetchPostUnit();
  }

  void reset() {

    pressed = false;
    _mySelection1 = null;
    _mySelection2 = null;
    _mySelection3 = null;
    _mySelection4 = null;
    _mySelection5 = null;

    setState(() {
      pressed = false;
      _mySelection1 = null;
      _mySelection2 = null;
      _mySelection3 = null;
      _mySelection4 = null;
    });
  }

  Future<void> fetchPostOrganisation() async {
    var u =
        'https://ireps.gov.in/Aapoorti/ServiceCall/getData?input=SPINNERS,ORGANIZATION';

    final response1 = await http.post(Uri.parse(u));
    //  final response1 =   await http.post(u);
    jsonResult1 = json.decode(response1.body);

    setState(() {
      dataOrganisation = jsonResult1!;
//data1=jsonResult1;
    });
  }

  Future<String> fetchPostZone() async {
    var v =
        'https://ireps.gov.in/Aapoorti/ServiceCall/getData?input=SPINNERS,ZONE,${_mySelection1}';
    print("url2-----" + v);
    //var vl="https://ireps.gov.in/Aapoorti/ServiceCall/getData?input=SPINNERS,ZONE,-2,,,null";
    final response = await http.post(Uri.parse(v));
    jsonResult2 = json.decode(response.body);

    setState(() {
      dataZone = jsonResult2!;
    });
    //print(resBody);
    return "Success";
  }

  Future<void> fetchPostDepartment() async {
    print('Fetching from service first spinner');
    var u =
        'https://ireps.gov.in/Aapoorti/ServiceCall/getData?input=SPINNERS,DEPARTMENT,${_mySelection1},${_mySelection2}';
    print("ur13-----" + u);
    //  var u='https://ireps.gov.in/Aapoorti/ServiceCall/getData?input=SPINNERS,ZONE,${myselection1}';

    final response1 = await http.post(Uri.parse(u));
    //  final response1 =   await http.post(u);
    jsonResult3 = json.decode(response1.body);

    setState(() {
      dataDepartment = jsonResult3!;
//data1=jsonResult1;
    });
  }

  Future<String> fetchPostUnitType() async {
    var v =
        'https://ireps.gov.in/Aapoorti/ServiceCall/getData?input=SPINNERS,ORG_UNIT_TYPE,${_mySelection1}';
    //var vl="https://ireps.gov.in/Aapoorti/ServiceCall/getData?input=SPINNERS,ZONE,-2,,,null";
    final response = await http.post(Uri.parse(v));
    jsonResult4 = json.decode(response.body);


    setState(() {
      dataUnitType = jsonResult4!;
    });
    //print(resBody);
    return "Success";
  }

  Future<void> fetchPostUnit() async {
    print('Fetching from service first spinner');
    var u =
        'https://ireps.gov.in/Aapoorti/ServiceCall/getData?input=SPINNERS,UNIT,${this._mySelection1},${this._mySelection2},${this._mySelection3}';
    //  var u='https://ireps.gov.in/Aapoorti/ServiceCall/getData?input=SPINNERS,ZONE,${myselection1}';

    final response1 = await http.post(Uri.parse(u));
    //  final response1 =   await http.post(u);
    jsonResult5 = json.decode(response1.body);

    setState(() {
      dataUnit = jsonResult5!;
//data1=jsonResult1;
    });
  }

  Widget _myListView(BuildContext context) {
    return Container(
        child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10.0, left: 15, right: 15),
                  child: DropdownButtonFormField(
                    hint: Text(_mySelection1 != null
                        ? _mySelection1!
                        : "Select Organization"),
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        icon: Icon(Icons.train, color: Colors.black)),
                    items: dataOrganisation.map((item) {
                      return new DropdownMenuItem(
                          child: new Text(item['NAME']),
                          value: item['ID'].toString());
                    }).toList(),
                    onChanged: (newVal1) {
                      setState(() {
                        _mySelection1 = newVal1 as String?;
                        print("my selection first" + _mySelection1!);
                      });
//checkvalue();
                      this.fetchPostZone();
                    },
                    value: _mySelection1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, left: 15, right: 15),
                  child: DropdownButtonFormField(
                    hint: Text('Select Zone '),
                    decoration: InputDecoration(
                        icon: Icon(Icons.camera, color: Colors.black)),
                    items: dataZone.map((item) {
                      return new DropdownMenuItem(
                          child: new Text(item['NAME']),
                          value: item['ID'].toString());
                    }).toList(),
                    onChanged: (newVal1) {
                      setState(() {
                        _mySelection2 = newVal1 as String?;
                        print("my selection second" + _mySelection2!);
                      });
                      this.fetchPostDepartment();
                    },
                    value: _mySelection2,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, left: 15, right: 15),
                  child: DropdownButtonFormField(
                    hint: Text('Select Department '),
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_balance, color: Colors.black)),
                    items: dataDepartment.map((item) {
                      return new DropdownMenuItem(
                          child: new Text(item['NAME']),
                          value: item['ID'].toString());
                    }).toList(),
                    onChanged: (newVal1) {
                      setState(() {
                        _mySelection3 = newVal1 as String?;
                        print("my selection third" + _mySelection3!);
                      });
                      this.fetchPostUnitType();
                    },
                    value: _mySelection3,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, left: 15, right: 15),
                  child: DropdownButtonFormField(
                    hint: Text('Select Unit type'),
                    decoration: InputDecoration(
                        icon: Icon(Icons.pages, color: Colors.black)),
                    items: dataUnitType.map((item) {
                      return DropdownMenuItem(
                          child: Text(item['NAME']),
                          value: item['ID'].toString());
                    }).toList(),
                    onChanged: (newVal1) {
                      setState(() {
                        _mySelection4 = newVal1 as String?;
                        print("my selection fourth" + _mySelection4!);
                      });
// checkvalue();
                      this.fetchPostUnit();
                    },
                    value: _mySelection4,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, left: 15, right: 15),
                  child: DropdownButtonFormField(
                    hint: Text('Select Unit'),
                    decoration: InputDecoration(
                        icon: Icon(Icons.pages, color: Colors.black)),
                    items: dataUnit.map((item) {
                      return new DropdownMenuItem(
                          child: new Text(item['NAME']),
                          value: item['ID'].toString());
                    }).toList(),
                    onChanged: (newVal1) {
                      setState(() {
                        _mySelection5 = newVal1 as String?;
                        print("my selection fifth" + _mySelection5!);
                      });
// checkvalue();
                      //this.fetchPostUnit();
                    },
                    value: _mySelection5,
                  ),
                ),
                MaterialButton(
                  minWidth: 330,
                  height: 40,
                  padding: EdgeInsets.fromLTRB(
                    25.0,
                    5.0,
                    25.0,
                    5.0,
                  ),
// padding: const EdgeInsets.only(left:110.0,right:110.0),
                  child: Text(
                    'Show Result',
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
//
//                    if(text==null)||myselection1!=minus&&myselection1!=minus1&&myselection1!=minus2&&myselection1!=minus3&&myselection1!=minus4&&myselection1!=minus5&&myselection1!=minus6&&myselection1!=minus7||_mySelection==null)
                    if (_mySelection1 != null &&
                        _mySelection2 != null &&
                        _mySelection3 != null &&
                        _mySelection4 != null &&
                        _mySelection5 != null) {
                      print("next");

                      String inputParam1 = AapoortiUtilities.user!.C_TOKEN +
                          "," +
                          AapoortiUtilities.user!.S_TOKEN +
                          ",Flutter,0,0," +
                          AapoortiUtilities.user!.MAP_ID;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PendingTenderReportDetails(
                                  item1: _mySelection1!,
                                  item2: _mySelection2!,
                                  item3: _mySelection3!,
                                  item4: _mySelection4!,
                                  item5: _mySelection5!,
                                  item6: inputParam1)));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                    checkvalue();
// Navigator.push(context,MaterialPageRoute(builder: (context) => Status(content: text,id:_mySelection)));
                  },
                  color: Colors.teal,
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                MaterialButton(
                    minWidth: 330,
                    height: 40,
                    padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
// padding: const EdgeInsets.only(left:110.0,right:110.0),
                    child: Text('Reset',
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {
                      reset();
                    },
                    color: Colors.teal),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context, rootNavigator: true).pop();
          return false;
        },
        child: Scaffold(
            key: _scaffoldkey,
            appBar: AppBar(
                backgroundColor: Colors.teal,
                iconTheme: IconThemeData(color: Colors.white),
                title: Row(
                  children: [
                    Container(
                        child: Text('Pending Tender Report',
                            style: TextStyle(color: Colors.white))),
                  ],
                )),
            backgroundColor: Colors.white,
            drawer: AapoortiUtilities.navigationdrawer(_scaffoldkey,context),
            body: Builder(
              builder: (context) => Material(
                  child: ListView(
                children: <Widget>[_myListView(context)],
              )),
            )
//            Container(child: _myListView(context))

            ));
  }

  void checkvalue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Navigator.push(context,MaterialPageRoute(builder: (context) => Status(content: text,id:_mySelection)));
    } else {
//    If all data are not valid then start auto validation.
      print("If all data are not valid then start auto validation.");
      setState(() {
        _autoValidate = true;
      });
    }
  }

  final snackbar = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Please select values',
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 18, color: Colors.teal),
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
