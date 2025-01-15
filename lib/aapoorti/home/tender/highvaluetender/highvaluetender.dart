import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter_app/aapoorti/home/tender/highvaluetender/high_value_tender_details.dart';

class DropDownhvt extends StatefulWidget {
  DropDownhvt() : super();
  final String title = "DropDown Demo";
  @override
  DropDownState createState() => DropDownState();
}

class DropDownState extends State<DropDownhvt> {
  int _user = 0;

  String? txt1, txt2;
  String date = "-1";
  bool pressed = false;
  ProgressDialog? pr;
  DateTime? selected;
  bool _autoValidate = false;
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);
  var users = <String>[
    'Goods & Services',
    'Works',
    'Earning& Leasing',
  ];

  bool visibilityTag = false;
  bool visibilityObs = false;
  bool visibilityclose = false;
  bool visibilityupload = false;
  String Dt1In = "12/Aug/2019",
      Dt2In = "10/Sep/2019",
      searchOption = "2",
      // ignore: non_constant_identifier_names
      OrgCode = "01",
      ClDate = "0";
  static DateTime _valueto = new DateTime.now();
  DateTime _valuefrom = _valueto.add(new Duration(days: 1));
  DateTime _valuecond = _valueto.add(new Duration(days: 30));

  String? item1, item2, item3, item4, item5, item6, item7;
  String? _mySelection1,
      _mySelection2,
      _mySelection3,
      _mySelection4 = "-1",
      _mySelection5 = "PT";
  List<dynamic>? jsonResult1;
  List<dynamic>? jsonResult2;
  List<dynamic>? jsonResult3;
  List<dynamic>? jsonResult4;
  String? url;

  int counter = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Text? txtfirst, txtsecond;
  GlobalKey<ScaffoldState> _snackKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      pr = ProgressDialog(context);
      fetchPost();

    });
  }

  void reset() {
    pressed = false;
    _mySelection1 = null;
    _mySelection2 = null;
    _mySelection3 = null;
    _mySelection4 = null;
    _user = 0;
    _valueto = new DateTime.now();
    _valuefrom = _valueto.add(new Duration(days: 1));
    _valuecond = _valueto.add(new Duration(days: 30));

    setState(() {
      pressed = false;
      _mySelection1 = null;
      _mySelection2 = null;
      _mySelection3 = null;
      _mySelection4 = null;
      _user = 0;
      _valueto = new DateTime.now();
      _valuefrom = _valueto.add(new Duration(days: 1));
      _valuecond = _valueto.add(new Duration(days: 30));
    });
  }

  Future _selectDateTo() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );
    if (picked != null)
      setState(() {
        _valueto = picked;
        // _valuefrom = _valueto.add(new Duration(days: 1));
        _valuecond = _valueto.add(new Duration(days: 30));
      });
  }

  Future _selectDateFrom() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _valueto,
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

  //  void getProgressDialog()  {
  //   pr.style(message: 'Please Wait...',
  //       borderRadius: 10.0,
  //       backgroundColor: Colors.white,
  //       elevation: 20.0,
  //       insetAnimCurve: Curves.easeInOut,
  //       messageTextStyle: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w600));
  //   pr.show();
  // }

  // void stopProgress()
  // {
  //  pr.hide()
  //   .then((isHidden) {
  //     print('dialoghidden: $isHidden');
  //   });
  // }

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
  List dataZone = [];
  List dataDepartment = [];
  List dataUnit = [];

  Future<void> fetchPost() async {
    try {
      debugPrint('Fetching from service first spinner');

      var u = AapoortiConstants.webServiceUrl +
          '/getData?input=SPINNERS,ORGANIZATION';
      AapoortiUtilities.getProgressDialog(pr!);
      final response =
          await http.post(Uri.parse(u)).timeout(Duration(seconds: 4));
      jsonResult1 = json.decode(response.body);
      if (response == null || response.statusCode != 200) throw Exception('HTTP request failed, statusCode: ${response?.statusCode}');
      debugPrint(jsonResult1.toString());
      AapoortiUtilities.stopProgress(pr!);
      if (this.mounted)
        setState(() {
          if (jsonResult1 != null) dataOrganisation = jsonResult1!;
        });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> fetchPostZone() async {
    if (_mySelection1 != "-1") {
      AapoortiUtilities.getProgressDialog(pr!);

      var v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,${_mySelection1}';
      debugPrint("url2-----" + v);
      //var vl="https://ireps.gov.in/Aapoorti/ServiceCall/getData?input=SPINNERS,ZONE,-2,,,null";
      final response = await http.post(Uri.parse(v)).timeout(Duration(seconds: 4));
      jsonResult2 = json.decode(response.body);

      debugPrint("jsonResult2------");
      debugPrint(jsonResult2.toString());
      AapoortiUtilities.stopProgress(pr!);
      setState(() {
        dataZone = jsonResult2!;
      });
    }
    return "Success";
  }

  Future<void> fetchPostDepartment() async {
    debugPrint('Fetching from service first spinner');
    if (_mySelection2 != "-2") {
      AapoortiUtilities.getProgressDialog(pr!);
      var u = AapoortiConstants.webServiceUrl +
          '/getData?input=SPINNERS,DEPARTMENT,${_mySelection1},${_mySelection2}';
      debugPrint("ur13-----" + u);

      final response1 = await http.post(Uri.parse(u)).timeout(Duration(seconds: 30));
      jsonResult3 = json.decode(response1.body);
      debugPrint("jsonResult3===");
      debugPrint(jsonResult3.toString());

      AapoortiUtilities.stopProgress(pr!);
      setState(() {
        dataDepartment = jsonResult3!;
      });
    }
  }

  Future<void> fetchPostUnit(String url) async {
    debugPrint('Fetching from service first spinner');
    if (_mySelection3 != "-2") {
      AapoortiUtilities.getProgressDialog(pr!);
      var u = url;
      debugPrint("ur1-----" + u);

      final response1 = await http.post(Uri.parse(u)).timeout(Duration(seconds: 30));
      jsonResult4 = json.decode(response1.body);
      debugPrint("jsonResult4===");
      debugPrint(jsonResult4.toString());
      AapoortiUtilities.stopProgress(pr!);

      setState(() {
        dataUnit = jsonResult4!;
      });
    }
  }

  Widget _myListView(BuildContext context) {
    return Container(
        child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    hint: Text(_mySelection1 != null
                        ? _mySelection1!
                        : "Select Organization"),
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        icon: Icon(Icons.train, color: Colors.black)),
                    items: dataOrganisation.map((item) {
                      return DropdownMenuItem(
                          child: Text(
                            item['NAME'],
                          ),
                          value: item['ID'].toString());
                    }).toList(),
                    onChanged: (newVal1) {
                      setState(() {
                        _mySelection2 = null;
                        _mySelection3 = null;
                        _mySelection4 = null;

                        dataZone.clear();
                        dataDepartment.clear();
                        dataUnit.clear();

                        _mySelection1 = newVal1;

                      });
                      fetchPostZone();
                    },
                    value: _mySelection1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
                  child: DropdownButtonFormField(
                    hint: Text('Select Zone '),
                    decoration: InputDecoration(
                        icon: Icon(Icons.camera, color: Colors.black)),
                    items: dataZone.map((item) {
                      return DropdownMenuItem(
                          child: Text(item['NAME']),
                          value: item['ID'].toString());
                    }).toList(),
                    onChanged: (newVal1) {
                      setState(() {
                        _mySelection3 = null;
                        _mySelection4 = null;

                        dataDepartment.clear();
                        dataUnit.clear();

                        _mySelection2 = newVal1;
                      });
                      this.fetchPostDepartment();
                    },
                    value: _mySelection2,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
                  child: DropdownButtonFormField(
                    hint: Text('Select Department '),
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_balance, color: Colors.black)),
                    items: dataDepartment.map((item) {
                      return DropdownMenuItem(
                          child: Text(item['NAME']),
                          value: item['ID'].toString());
                    }).toList(),
                    onChanged: (newVal1) {
                      setState(() {
                        _mySelection4 = null;

                        dataUnit.clear();

                        _mySelection3 = newVal1;
                      });
                      if (_mySelection3 == "-1") {
                        url = AapoortiConstants.webServiceUrl +
                            '/getData?input=SPINNERS,UNIT,-2,-2,-2,-1';
                      }
                      if (_mySelection3 != "-1") {
                        url = AapoortiConstants.webServiceUrl +
                            '/getData?input=SPINNERS,UNIT,${this._mySelection1},${this._mySelection2},${this._mySelection3}';
                      }
                      this.fetchPostUnit(url!);
                    },
                    value: _mySelection3,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
                  child: DropdownButtonFormField(
                    hint: Text('Select Unit'),
                    decoration: InputDecoration(
                        icon: Icon(Icons.pages, color: Colors.black)),
                    items: dataUnit.map((item) {
                      return DropdownMenuItem(
                          child: Text(item['NAME']),
                          value: item['ID'].toString());
                    }).toList(),
                    onChanged: (newVal1) {
                      setState(() {
                        _mySelection4 = newVal1;
                      });
                    },
                    value: _mySelection4,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
                  child: DropdownButtonFormField(
                    hint: Text('Goods and Services '),
                    decoration: InputDecoration(
                        icon: Icon(Icons.line_weight, color: Colors.black)),
                    value: _user == null ? null : users[_user],
                    items: users.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _user = users.indexOf(value as String);
                        if (_user == 0) {
                          _mySelection5 = "PT";
                        } else if (_user == 1) {
                          _mySelection5 = "WT";
                        } else {
                          _mySelection5 = "LT";
                        }
                      });
                    },
                  ),
                ),
                Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'Publish Date Range',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(top: 20.0, left: 20)),
                Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10),
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          MaterialButton(
                            onPressed: _selectDateTo,
                            child: Icon(
                              Icons.date_range,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: .100),
                          ),
                          txtfirst = Text(
                            DateFormat('dd/MM/yyyy').format(_valueto),
                            style: TextStyle(
                                color: Colors.cyan.shade400,
                                fontWeight: FontWeight.bold),
                          ),
                          MaterialButton(
                            onPressed: _selectDateFrom,
                            child: Icon(
                              Icons.date_range,
                            ),
                          ),
                          txtsecond = Text(
                            DateFormat('dd/MM/yyyy').format(_valuefrom),
                            style: TextStyle(
                                color: Colors.cyan.shade400,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
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
                  child: Text(
                    'Show Result',
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  onPressed: () {
                    if (_mySelection1 != null &&
                        _mySelection2 != null &&
                        _mySelection3 != null &&
                        _mySelection4 != null) {

                      txt1 = txtfirst!.data;
                      txt2 = txtsecond!.data;

                      if (_valuefrom.difference(_valueto).inDays < 1) {
                        ScaffoldMessenger.of(context).showSnackBar(snackbar1);
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HighValueStatus(
                                      item1: _mySelection1,
                                      item2: _mySelection2,
                                      item3: _mySelection3,
                                      item4: _mySelection4,
                                      item5: _mySelection5,
                                      item6: txt1,
                                      item7: txt2,
                                    )));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                    checkvalue();
                  },
                  color: Colors.cyan.shade400,
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                MaterialButton(
                    minWidth: 330,
                    height: 40,
                    padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                    child: Text('Reset',
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    onPressed: () {
                      reset();
                    },
                    color: Colors.cyan.shade400),
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
            key: _snackKey,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Colors.cyan[400],
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Text('High Value Tender',
                            style: TextStyle(color: Colors.white))),
                    IconButton(
                      icon: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                  ],
                )),
            backgroundColor: Colors.white,
            body: Builder(
              builder: (context) => Material(
                  child: ListView(
                children: <Widget>[_myListView(context)],
              )),
            )

            ));
  }

  void checkvalue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
      debugPrint("If all data are not valid then start auto validation.");
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
  final snackbar1 = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Please select a valid date',
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 15, color: Colors.white),
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
