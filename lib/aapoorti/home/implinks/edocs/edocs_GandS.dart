import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/home/implinks/edocs/EdocsWorksDATA.dart';
import 'package:http/http.dart' as http;
//import'package:flutter_app/aapoorti/home/tender/tenderstatus/tender_status_view.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'EdocsGSdata.dart';
//import 'package:flutter_app/aapoorti/home/tender/highvaluetender/high_value_tender_details.dart';

class edocs_GandS extends StatefulWidget {
  edocs_GandS() : super();

  final String title = "DropDown Demo";

  @override
  edocs_GandSState createState() => edocs_GandSState();
}

class edocs_GandSState extends State<edocs_GandS> {
  int? _user;
  ProgressDialog? pr;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool _autoValidate = false;

  String? txt1, txt2;
  var users = <String>[
    'Goods & Services',
    'Works',
    'Earning& Leasing',
  ];

  navigate() async {
    if (_mySelection1 != null &&
        _mySelection2 != null &&
        _mySelection3 != null) {
      try {
        // await Future.delayed(const Duration(milliseconds: 100));
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EdocsGSdata(
                item1: _mySelection1!,
                item2: _mySelection2!,
                item3: _mySelection3!,
              ),
            ));
      } catch (exception) {
        print('SharedProfile ' + exception.toString());
        print("222222" + _mySelection2!);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  _onClear() {
    setState(() {
      _formKey.currentState!.reset();
      _formKey.currentState!.save();
      _autoValidate = false;

      _mySelection1 = null;
      _mySelection2 = null;
      _mySelection3 = null;
    });
  }

  _progressShow() {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: true, showLogs: true);
    pr!.show();
  }

  _progressHide() {
    Future.delayed(Duration(milliseconds: 100), () {
      pr!.hide().then((isHidden) {
        print(isHidden);
      });
    });
  }

  String? _mySelection1, _mySelection2, _mySelection3;
  List<dynamic>? jsonResult1;
  List<dynamic>? jsonResult2;
  List<dynamic>? jsonResult3;
  List<dynamic>? jsonResult4;

  int counter = 0;

  Text? txtfirst, txtsecond;

  @override
  void initState() {
    super.initState();
    fetchPostOrganisation();
    // this.fetchPostZone();
    // this.fetchPostDepartment();

    //this.fetchPostUnit();
  }

  List dataOrganisation = [];
  List dataZone = [];
  List dataDepartment = [];
  List data = [];

  Future<void> fetchPostOrganisation() async {
    var u = AapoortiConstants.webServiceUrl +
        '/getData?input=SPINNERS,ORGANIZATION';
    _progressShow();
    final response1 = await http.post(Uri.parse(u));
    //  final response1 =   await http.post(u);
    jsonResult1 = json.decode(response1.body);
    // jsonResult1 = json.decode(response1.body);

    _progressHide();
    setState(() {
      dataOrganisation = jsonResult1!;
    });
  }

  Future<String> fetchPostZone() async {
    var v = AapoortiConstants.webServiceUrl +
        '/getData?input=SPINNERS,ZONE,${this._mySelection1}';
    _progressShow();
    //var vl="https://ireps.gov.in/Aapoorti/ServiceCall/getData?input=SPINNERS,ZONE,-2,,,null";
    final response = await http.post(Uri.parse(v));
    jsonResult2 = json.decode(response.body);

    _progressHide();
    setState(() {
      dataZone = jsonResult2!;
    });
    return "Success";
  }

  Future<void> fetchPostDepartment() async {
    var u = AapoortiConstants.webServiceUrl +
        '/getData?input=SPINNERS,DEPARTMENT,${this._mySelection1},${this._mySelection2}';
    //  var u=AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,${myselection1}';
    _progressShow();
    final response1 = await http.post(Uri.parse(u));
    //  final response1 =   await http.post(u);
    jsonResult3 = json.decode(response1.body);
    _progressHide();

    setState(() {
      dataDepartment = jsonResult3!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context, rootNavigator: true).pop();
          return false;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                iconTheme: new IconThemeData(color: Colors.white),
                backgroundColor: Colors.cyan[400],
                title: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Text('Public Documents',
                            style: TextStyle(color: Colors.white))),
                    new IconButton(
                      icon: new Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/common_screen", (route) => false);
                      },
                    ),
                  ],
                )),
            /* MaterialApp(
        debugShowCheckedModeBanner: false,

        title: "About Us",*/

            body: Builder(
              builder: (context) => Material(
                child: new Container(
                  //color: Colors.black,
                  child: new Column(
                    children: <Widget>[
                      Container(
                        width: 370.0,
                        height: 25.0,
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          "   Goods and Services",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                        color: Colors.cyan[700],
                      ),
                      new Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //autovalidate: _autoValidate,
                        child: FormUI(),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  void _validateInputs() async {
    if (_formKey.currentState!.validate()) {
      print("If all data are correct then save data to out variables");
      _formKey.currentState!.save();
    } else {
//    If all data are not valid then start auto validation.
      print("If all data are not valid then start auto validation.");
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Widget FormUI() {
    return /*new ListView(
      children: <Widget>[*/
        new Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10.0, left: 15, right: 15),
          child: DropdownButtonFormField(
            // isExpanded: true,

//
            hint: Text(
                _mySelection1 != null ? _mySelection1! : "Select Organization"),
            decoration: InputDecoration(
                errorStyle: TextStyle(color: Colors.red),
                icon: Icon(Icons.train, color: Colors.black)),
            items: dataOrganisation.map((item) {
              return new DropdownMenuItem(
                  child: new Text(item['NAME']), value: item['ID'].toString());
            }).toList(),

            onChanged: (newVal1) {
              setState(() {
                _mySelection2 = null;
                _mySelection3 = null;
                dataZone.clear();
                dataDepartment.clear();

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
            decoration:
                InputDecoration(icon: Icon(Icons.camera, color: Colors.black)),
            items: dataZone.map((item) {
              return new DropdownMenuItem(
                  child: new Text(item['NAME']), value: item['ID'].toString());
            }).toList(),
            onChanged: (newVal1) {
              setState(() {
                _mySelection3 = null;

                dataDepartment.clear();
                _mySelection2 = newVal1 as String?;
                print("my selection second" + _mySelection2!);
              });
              // checkvalue();
              fetchPostDepartment();
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
              return DropdownMenuItem(
                  child: Text(item['NAME']), value: item['ID'].toString());
            }).toList(),
            onChanged: (newVal1) {
              setState(() {
                _mySelection3 = newVal1 as String?;
                print("my selection third" + _mySelection3!);
              });
              //checkvalue();
            },
            value: _mySelection3,
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              ButtonTheme(
                minWidth: double.infinity,
                child: MaterialButton(
                  onPressed: () {
                    _validateInputs();
                    navigate();
                  },
                  textColor: Colors.white,
                  color: Colors.cyan,
                  child: Text(
                    "Show Results",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              )
            ],
          ),
        ),
        new Container(
          padding: new EdgeInsets.only(left: 20, right: 20),
          margin: const EdgeInsets.only(top: 5.0),
          child: new Column(
            children: <Widget>[
              ButtonTheme(
                //elevation: 4,
                //color: Colors.green,
                minWidth: double.infinity,
                child: MaterialButton(
                  onPressed: () => _onClear(),
                  textColor: Colors.white,
                  color: Colors.cyan,
                  child: Text(
                    "Reset",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              )
            ],
          ),
        ),
        /*],
        ),*/
      ],
    );
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
