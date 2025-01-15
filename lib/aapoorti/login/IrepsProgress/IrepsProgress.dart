import 'dart:convert';
import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'IrepsProgressDetails.dart';

class IrepsProgress extends StatefulWidget {
  @override
  _IrepsProgressState createState() => _IrepsProgressState();
}

class _IrepsProgressState extends State<IrepsProgress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autoValidate = false;
  int _user = 0;
  ProgressDialog? pr;
  var users = <String>[
    'All',
    'Goods & Services',
    'Works',
    'Earning & Leasing',
    'Sales Auction'
  ];

  int counter = 2;
  DateTime? selected;

  List<dynamic>? jsonResult;
  List<dynamic>? jsonResult1;

  List dataRly = [];
  List dataZone = [];
  List dataUnit = [];
  List dataUnitType = [];
  List dataDept = [];

  String? myselection = "-2;-2",
      myselection1 = "-1",
      myselection2 = "-2",
      myselection3 = "-2",
      myselection4 = "-2",
      myselection5 = "NA",
      dt1,
      dt2;

  static DateTime _valueto = DateTime.now();
  DateTime _valuefrom = _valueto.add(Duration(days: 1));

  _IrepsProgressState() {
    AapoortiUtilities.setPortraitOrientation();
  }

  navigate() async {
    try {
      _validateInputs();
      if ((myselection1 != "-1") &&
          (myselection != "-2;-2") &&
          (myselection2 != "-2") &&
          (myselection3 != "-2") &&
          (myselection4 != "-2")) {
        print(myselection);
        dt1 = DateFormat('dd/MMM/yyyy').format(_valueto).toString();
        dt2 = DateFormat('dd/MMM/yyyy').format(_valuefrom).toString();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IrepsProgressDetails(
                    OrgCode: myselection1!,
                    RailZoneIn:
                        '${myselection!.substring(myselection!.indexOf(';') + 1, myselection!.length)}',
                    dept: myselection2!,
                    unit: myselection3!,
                    uutype: myselection4!,
                    workarea: myselection5!,
                    Dt1In: dt1!,
                    Dt2In: dt2!)));
      }
    } catch (exception) {
      debugPrint('SharedProfile ' + exception.toString());
    }
  }

  void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  _onClear() {
    setState(() {
      counter = 2;

      myselection = "-2;-2";
      myselection1 = "-1";
      myselection2 = "-2";
      myselection3 = "-2";
      myselection4 = "-2";
      myselection5 = "NA";
      _user = 0;
      _valueto = DateTime.now();
      _valuefrom = _valueto.add(Duration(days: 1));
    });
  }

  Future _selectDateTo() async {
    final ThemeData theme = Theme.of(context);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2023),
    );

    if (picked != null)
      setState(() {
        _valueto = picked;
        _valuefrom = _valueto.add(Duration(days: 1));
      });
  }

  _progressShow() {
    pr = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: true, showLogs: true);
    pr!.show();
  }

  _progressHide() {
    Future.delayed(Duration(milliseconds: 100), () {
      pr!.hide().then((isHidden) {
        debugPrint(isHidden.toString());
      });
    });
  }

  Future _selectDateFrom() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _valueto,
      firstDate: _valueto,
      lastDate: DateTime(2023),
    );
    if (picked != null) setState(() => _valuefrom = picked);
  }

  Future<void> fetchPost() async {
    var u = AapoortiConstants.webServiceUrl +
        '/getData?input=SPINNERS,ORGANIZATION';
    final response = await http.post(Uri.parse(u));
    jsonResult1 = json.decode(response.body);
    if (response == null || response.statusCode != 200)
      throw new Exception(
          'HTTP request failed, statusCode: ${response.statusCode}');
    print(jsonResult1);
    setState(() {
      dataRly = jsonResult1!;
    });
  }

  Future<void> getZone() async {
    try {
      _progressShow();
      var v = AapoortiConstants.webServiceUrl +
          '/getData?input=SPINNERS,ZONE,${myselection1}';
      final response = await http.post(Uri.parse(v));
      jsonResult = json.decode(response.body);
      if (response == null || response.statusCode != 200)
        throw new Exception(
            'HTTP request failed, statusCode: ${response?.statusCode}');

      _progressHide();
      setState(() {
        dataZone = jsonResult!;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> fetchDept() async {
    try {
      _progressShow();

      var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,DEPARTMENT,${myselection1},${myselection!.substring(myselection!.indexOf(';') + 1)},,-1';
      final response = await http.post(Uri.parse(u));
      jsonResult = json.decode(response.body);
      if (response.statusCode != 200)
        throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
      _progressHide();
      setState(() {
        dataDept = jsonResult!;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> fetchUnitType() async {
    try {
      _progressShow();
      var v = AapoortiConstants.webServiceUrl +
          '/getData?input=SPINNERS,ORG_UNIT_TYPE,${myselection1},${myselection!.substring(myselection!.indexOf(';') + 1)},${myselection2},null';
      final response = await http.post(Uri.parse(v));
      if (response.body.isEmpty || response.statusCode != 200)
        throw new Exception('HTTP request failed, statusCode: ${response?.statusCode}');
      jsonResult = json.decode(response.body);
      _progressHide();
      setState(() {
        dataUnitType = jsonResult!;
      });
    } catch (e) {
    }
  }

  Future<void> fetchUnit() async {
    try {
      _progressShow();
      var v = AapoortiConstants.webServiceUrl +
          '/getData?input=SPINNERS,UNIT,${myselection1},${myselection!.substring(myselection!.indexOf(';') + 1)},${myselection2},';
      final response = await http.post(Uri.parse(v));
      if (response.statusCode != 200)
        throw new Exception(
            'HTTP request failed, statusCode: ${response.statusCode}');
      jsonResult = json.decode(response.body);
      _progressHide();
      setState(() {
        dataUnit = jsonResult!;
      });
    }
    catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        drawer: AapoortiUtilities.navigationdrawer(_scaffoldKey,context),
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.teal,
            title: Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 15.0)),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '   IREPS  Progress    ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
        )),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: FormUI(),
            ),
          ),
        ),
      ),
    );
  }

  Widget FormUI() {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 1.0)),
        FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                icon: const Icon(Icons.train, color: Colors.black),
                errorText: state.hasError ? state.errorText : null,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isDense: true,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  value: myselection1,
                  disabledHint: Text(
                    'Select Organization',
                  ),
                  hint: Text('Select Organization'),
                  items: dataRly.map((item) {
                    return DropdownMenuItem(
                        child: Text(item['NAME']),
                        value: item['ID'].toString());
                  }).toList(),
                  onChanged: (String? newValue) {
                    try {
                      setState(() {
                        if (newValue != null) {
                          myselection = "-2;-2";
                          myselection1 = (newValue == "-2" || newValue == ""
                              ? null
                              : newValue)!;
                          state.didChange(newValue);
                        }
                      });
                    } catch (e) {
                    }
                    getZone();
                  },
                ),
              ),
            );
          },
          onSaved: (String? val) {
            myselection1 = val!;
          },
          validator: (val) {
            if (val != null) {
              return null;
            } else {
              return ' Please select Organization ';
            }
          },
        ),
        FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                icon: const Icon(Icons.camera, color: Colors.black),
                errorText: state.hasError ? state.errorText : null,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isDense: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  value: myselection == '-2;-2' || myselection == ""
                      ? null
                      : myselection,
                  disabledHint: Text('Select Railway'),
                  hint: Text('Select Railway'),
                  items: dataZone.map((item) {
                    return DropdownMenuItem(child: Text(item['NAME']), value: item['ACCID'].toString() + ";" + item['ID'].toString());
                  }).toList(),
                  onChanged: (String? newValue) {
                    try {
                      setState(() {
                        if (newValue != null) {
                          myselection = (newValue == "-2;-2" || newValue == ""
                              ? null
                              : newValue)!;

                          state.didChange(newValue);
                        }
                      });
                    } catch (e) {
                      debugPrint("execption" + e.toString());
                    }
                    fetchDept();
                  },
                ),
              ),
            );
          },
          onSaved: (String? val) {
            myselection = val;
          },
          validator: (val) {
            if (val != null) {
              return null;
            } else {
              return 'Please select  Railway ';
            }
          },
        ),
        FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                icon: const Icon(Icons.account_balance, color: Colors.black),
                errorText: state.hasError ? state.errorText : null,
              ),
              isEmpty: myselection2 == '-2',
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isDense: true,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  value: myselection2 == "-2" ? null : myselection2,
                  disabledHint: Text('Select   Department'),
                  hint: Text('Select   Department'),
                  items: dataDept.map((item) {
                    return DropdownMenuItem(
                        child: Text(item['NAME']),
                        value: item['ID'].toString());
                  }).toList(),
                  onChanged: (String? newValue) {
                    state.didChange(newValue);
                    setState(() {
                      myselection2 = (newValue == "-2" ? null : newValue)!;
                    });

                    fetchUnitType();
                  },
                ),
              ),
            );
          },
          onSaved: (String? val) {
            myselection2 = val;
          },
          validator: (val) {
            if (val != null) {
              return null;
            } else {
              return 'Please select Department ';
            }
          },
        ),
        FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                icon: const Icon(Icons.device_hub, color: Colors.black),
                errorText: state.hasError ? state.errorText : null,
              ),
              isEmpty: myselection3 == '-2',
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isDense: true,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  value: myselection3 == "-2" ? null : myselection3,
                  hint: Text('Select Unit Type'),
                  disabledHint: Text('Select Unit Type'),
                  items: dataUnitType.map((item) {
                    return DropdownMenuItem(
                        child: Text(item['NAME']),
                        value: item['ID'].toString());
                  }).toList(),
                  onChanged: (String? newValue) {
                    state.didChange(newValue);
                    setState(() {
                      myselection3 = (newValue == "-2" ? null : newValue)!;
                    });

                    fetchUnit();
                  },
                ),
              ),
            );
          },
          onSaved: (String? val) {
            myselection3 = val!;
          },
          validator: (val) {
            return val != null ? null : 'Please select Unit Type';
          },
        ),
        FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                icon: const Icon(Icons.business, color: Colors.black),
                errorText: state.hasError ? state.errorText : null,
              ),
              isEmpty: myselection4 == '-2',
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isDense: true,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  value: myselection4 == "-2" ? null : myselection4,
                  hint: Text('Select Unit'),
                  disabledHint: Text('Select Unit'),
                  items: dataUnit.map((item) {
                    return DropdownMenuItem(
                        child: Text(item['NAME']),
                        value: item['ID'].toString());
                  }).toList(),
                  onChanged: (String? newValue) {
                    state.didChange(newValue);
                    setState(() {
                      print("my selection4 second newVal1" + newValue!);
                      myselection4 = newValue == "" ? "-2" : newValue;
                      print("my selection4 second" + myselection4!);
                    });
                    _validateInputs();
                  },
                ),
              ),
            );
          },
          onSaved: (String? val) {
            myselection4 = val!;
          },
          validator: (val) {
            return val != null ? null : 'Please select unit';
          },
        ),
        FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                icon: const Icon(Icons.equalizer, color: Colors.black),
                errorText: state.hasError ? state.errorText : null,
              ),
              isEmpty: _user == -1,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isDense: true,
                  isExpanded: true,

                  value: _user == -1 ? null : users[_user],
                  hint: Text('All'),
                  items: users.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      debugPrint("-------value--------" + value!);

                      _user = users.indexOf(value!);

                      if (_user == 0) {
                        myselection5 = value == "" ? "-2" : "NA";
                      } else if (_user == 1) {
                        myselection5 = value == "" ? "-2" : "PT";
                      } else if (_user == 2) {
                        myselection5 = value == "" ? "-2" : "WT";
                      } else if (_user == 3) {
                        myselection5 = value == "" ? "-2" : "LT";
                      } else if (_user == 4) {
                        myselection5 = value == "" ? "-2" : "SA";
                      }
                    });
                  },
                ),
              ),
            );
          },
          validator: (val) {
            return val != -1 ? null : 'Please select unit';
          },
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Text(
          "Report Period                                                         ",
          style: TextStyle(color: Colors.grey, fontSize: 12.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: _selectDateTo,
              child: Icon(
                Icons.date_range,
              ),
            ),
            Text(DateFormat('dd-MM-yyyy').format(_valueto),
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
            ),
            MaterialButton(
              onPressed: _selectDateFrom,
              child:Icon(
                Icons.date_range,
              ),
            ),
            Text(
              DateFormat('dd-MM-yyyy').format(_valuefrom),
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
            ),
          ],
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
                    navigate();
                  },
                  textColor: Colors.white,
                  color: Colors.teal,
                  child: Text(
                    "Show Results",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          margin: const EdgeInsets.only(top: 5.0),
          child: Column(
            children: <Widget>[
              ButtonTheme(
                minWidth: double.infinity,
                child: MaterialButton(
                  onPressed: () => _onClear(),
                  textColor: Colors.white,
                  color: Colors.teal,
                  child: Text(
                    "Reset",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
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
}
