import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'PurchaseOrders.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PurchaseOrder_filter extends StatefulWidget {
  @override
  _PurchaseOrder_filterState createState() => _PurchaseOrder_filterState();
}

class _PurchaseOrder_filterState extends State<PurchaseOrder_filter>
    implements Exception {
  _PurchaseOrder_filterState() {}
  TextEditingController myController1 = TextEditingController();
  int _user = 0;
  ProgressDialog? pr;
  String desc = "";
  List dataZone = [];
  List<dynamic>? jsonResult;
  String myselection = "-2;-2",
      myselection1 = "-1",
      myselection2 = "-2",
      myselection3 = "-2";
  double _containerHeight = 35,
      _imageHeight = 20,
      _iconTop = 11,
      _iconLeft = 5,
      _marginLeft = 110,
      _top = 200;

  void initState() {
    super.initState();
    AapoortiUtilities.setPortraitOrientation();
    setState(() {
      callWebService();
    });
  }

  _progressShow() {
    pr = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: true, showLogs: false);
    pr!.show();
  }

  _progressHide() {
    Future.delayed(Duration(milliseconds: 100), () {
      pr!.hide().then((isHidden) {
        print(isHidden);
      });
    });
  }

  void callWebService() async {
    try {
      var v =
          AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,01';
      final response = await http.post(Uri.parse(v));
      jsonResult = json.decode(response.body);
      dataZone = jsonResult!;
    } catch (e) {
      print(e);
    }
  }

  void _applyFilter() {
    debugPrint(myselection1 == "-1" ? "PO" : myselection1);
    debugPrint(myselection == "-2;-2"
        ? "-1"
        : myselection.substring(0, myselection.indexOf(';')));
    debugPrint(myController1.text.isEmpty ? "-1" : myController1.text);
    debugPrint(DateFormat('dd/MMM/yyyy').format(_valueto).toString());
    debugPrint(DateFormat('dd/MMM/yyyy').format(_valuefrom).toString());
    Navigator.of(context).pop();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PurchaseOrders(
              area: myselection1 == "-1" ? "PO" : myselection1,
              RailZoneIn: myselection == "-2;-2"
                  ? "-1"
                  : myselection.substring(0, myselection.indexOf(';')),
              SearchForstring:
                  myController1.text.isEmpty ? "-1" : myController1.text,
              Dt1In: DateFormat('dd/MMM/yyyy').format(_valueto).toString(),
              Dt2In: DateFormat('dd/MMM/yyyy').format(_valuefrom).toString(),
              searchOption: "#"),
        ));
  }

  static DateTime _valueto = new DateTime.now();
  DateTime _valuefrom = _valueto.add(new Duration(days: 180));

  Future _selectDateTo() async {
    final ThemeData theme = Theme.of(context);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1990),
      lastDate: new DateTime(2023),
    );

    if (picked != null)
      setState(() {
        _valueto = picked;
        _valuefrom = _valueto.add(new Duration(days: 180));
      });
  }

  Future _selectDateFrom() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _valueto,
      firstDate: _valueto,
      lastDate: _valueto.add(new Duration(days: 180)),
    );
    if (picked != null) setState(() => _valuefrom = picked);
  }

  var users = <String>['PO', 'RNote', 'RChallan'];

  @override
  Widget build(BuildContext context) {
    _top = MediaQuery.of(context).size.height / 5;
    return Scaffold(
        body: Material(
            child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color.fromARGB(100, 0, 0, 0),
                      offset: Offset(0.0, 1.0),
                      blurRadius: 3.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 35,
                        right: 25,
                        height: _containerHeight,
                        top: _top,
                        child: Container(color: Colors.teal),
                      ),
                      Positioned(
                        right: 25,
                        top: _iconTop + (_top) - 20,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          color: Colors.white,
                          icon: new Icon(
                            Icons.cancel,
                          ),
                        ),
                      ),
                      Positioned(
                        left: _marginLeft,
                        top: _iconTop + (_top) - 4,
                        child: Text("View Contract Filter",
                            style: TextStyle(
                                color: Colors.white,
                                /* fontWeight: FontWeight.w500,*/
                                fontSize: 15)),
                      ),
                      Positioned(
                          top: _containerHeight + (_imageHeight / 4) + (_top),
                          right: 25,
                          left: 35,
                          child: Row(mainAxisSize: MainAxisSize.max, children: <
                              Widget>[
                            // Padding(padding: EdgeInsets.only(left: 35,right:35)),
                            Expanded(
                              child: Container(
                                // width: 400,
                                color: Colors.teal[50],
                                child: new Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(0),
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          new Container(
                                            padding: const EdgeInsets.only(
                                                right: 25),
                                            child: new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                /* Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: <Widget>[*/
                                                FormField(
                                                  builder:
                                                      (FormFieldState state) {
                                                    return InputDecorator(
                                                      decoration:
                                                          InputDecoration(
                                                        icon: const Icon(
                                                            Icons.equalizer,
                                                            color:
                                                                Colors.black),
                                                        errorText: state
                                                                .hasError
                                                            ? state.errorText
                                                            : null,
                                                      ),
                                                      isEmpty: _user == -1,
                                                      child:
                                                          new DropdownButtonHideUnderline(
                                                        child:
                                                            new DropdownButton<
                                                                String>(
                                                          isDense: true,
                                                          isExpanded: true,

                                                          value: _user == -1
                                                              ? null
                                                              : users[_user],
                                                          //value: myselection5 == "-2" ? null : myselection5,
                                                          hint: Text('All'),
                                                          items: users.map(
                                                              (String value) {
                                                            return new DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: new Text(
                                                                  value),
                                                            );
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              print(
                                                                  "-------value--------" +
                                                                      value!);

                                                              _user =
                                                                  users.indexOf(
                                                                      value);

                                                              print("index of ----" +
                                                                  _user
                                                                      .toString());
                                                              if (_user == 0) {
                                                                myselection1 =
                                                                    value == ""
                                                                        ? "-2"
                                                                        : "PO";
                                                              } else if (_user ==
                                                                  1) {
                                                                myselection1 =
                                                                    value == ""
                                                                        ? "-2"
                                                                        : "RNote";
                                                              } else if (_user ==
                                                                  2) {
                                                                myselection1 =
                                                                    value == ""
                                                                        ? "-2"
                                                                        : "RChallan";
                                                              }
                                                              print("myselection1 index of ----" +
                                                                  myselection1);
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                /*],
                                ),*/
                                                /*Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: <Widget>[

                                  ],
                                ),*/

                                                new FormField(
                                                  builder:
                                                      (FormFieldState state) {
                                                    return InputDecorator(
                                                      decoration:
                                                          InputDecoration(
                                                        icon: const Icon(
                                                            Icons.train,
                                                            color:
                                                                Colors.black),
                                                        errorText: state
                                                                .hasError
                                                            ? state.errorText
                                                            : null,
                                                      ),
                                                      isEmpty: myselection ==
                                                          '-2;-2',
                                                      child:
                                                          new DropdownButtonHideUnderline(
                                                        child:
                                                            new DropdownButton<
                                                                String>(
                                                          isDense: true,
                                                          // isExpanded: true,
                                                          value: myselection ==
                                                                      '-2;-2' ||
                                                                  myselection ==
                                                                      ""
                                                              ? null
                                                              : myselection,

                                                          hint: Text('All'),
                                                          items: dataZone
                                                              .map((item) {
                                                            return new DropdownMenuItem(
                                                                child: new Text(
                                                                    item[
                                                                        'NAME']),
                                                                value: item['ACCID']
                                                                        .toString() +
                                                                    ";" +
                                                                    item['ID']
                                                                        .toString());
                                                          }).toList(),
                                                          onChanged: (String?
                                                              newValue) {
                                                            try {
                                                              setState(() {
                                                                if (newValue !=
                                                                    null) {
                                                                  print("my selection second newVal1" +
                                                                      newValue);
                                                                  myselection =
                                                                      newValue;
                                                                  print("my selection second" +
                                                                      myselection);
                                                                }
                                                              });
                                                            } catch (e) {
                                                              print(
                                                                  "execption" +
                                                                      e.toString());
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                new FormField(
                                                  builder:
                                                      (FormFieldState state) {
                                                    return TextFormField(
                                                      onSaved: (value) {
                                                        desc = value!;
                                                      },
                                                      controller: myController1,
                                                      decoration:
                                                          InputDecoration(
                                                              icon: Icon(
                                                                Icons
                                                                    .assignment,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              labelText:
                                                                  'Enter PO No',
                                                              labelStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              helperStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                              )),
                                                      onEditingComplete: () {
                                                        desc =
                                                            myController1.text;
                                                      }, /*)*/
                                                    );
                                                  },
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                    ),
                                                    new Text(
                                                        "Date Range difference 180 days"),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[],
                                                ),
                                              ],
                                            ),
                                          ),
                                          new Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(10),
                                              ),
                                              new MaterialButton(
                                                  padding:
                                                      const EdgeInsets.all(0.2),
                                                  onPressed: _selectDateTo,
                                                  child: new Row(
                                                    children: <Widget>[
                                                      new Icon(
                                                        Icons.date_range,
                                                        color: Colors.teal,
                                                      ),
                                                      Padding(
                                                          padding:
                                                              new EdgeInsets
                                                                      .only(
                                                                  left: 15)),
                                                      Text(
                                                          DateFormat(
                                                                  'dd-MM-yyyy')
                                                              .format(_valueto),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          textAlign:
                                                              TextAlign.left),
                                                    ],
                                                  )),
                                              Padding(
                                                padding: EdgeInsets.all(10),
                                              ),
                                              new MaterialButton(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  onPressed: _selectDateFrom,
                                                  child: new Row(
                                                    children: <Widget>[
                                                      new Icon(
                                                        Icons.date_range,
                                                        color: Colors.teal,
                                                      ),
                                                      Padding(
                                                          padding:
                                                              new EdgeInsets
                                                                      .only(
                                                                  left: 15)),
                                                      Text(
                                                          DateFormat(
                                                                  'dd-MM-yyyy')
                                                              .format(
                                                                  _valuefrom),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          textAlign:
                                                              TextAlign.left),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                          new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3)),
                                              MaterialButton(
                                                onPressed: () {
                                                  _applyFilter();
                                                },
                                                textColor: Colors.white,
                                                color: Colors.teal,
                                                child: Text(
                                                  "Apply",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                shape:
                                                    new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          30.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ]))
                    ]))));
  }
}
