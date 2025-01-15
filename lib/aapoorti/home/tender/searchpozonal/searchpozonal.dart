import 'dart:core';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'SearchPoList.dart';

class SearchPoZonal extends StatefulWidget {
  TextEditingController _textFieldController = TextEditingController();
  SearchPoZonal() : super();

  @override
  _SearchZonalState createState() => _SearchZonalState();
}

class _SearchZonalState extends State<SearchPoZonal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<dynamic>? jsonResult;
  String pv1 = "", pv2 = "";
  String supName = "";
  bool pressed = false;
  double val = 0;
  String plNo = "";
  bool _autoValidate = false;
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);
  bool slider_color = true;
  String? railUnit;
  DateTime? selected;
  double valueRange = 0;
  static DateTime _valuefrom = DateTime.now();
  DateTime _valueto = _valuefrom.add(Duration(days: 1));
  DateTime _valuecond = _valuefrom.add(Duration(days: 30));
  TextEditingController myController = TextEditingController();
  TextEditingController myController1 = TextEditingController();
  var myselection1;
  List data = [];
  GlobalKey<ScaffoldState> _snackKey = GlobalKey<ScaffoldState>();
  Future _selectDateTo() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _valuefrom,
      firstDate: DateTime(1990),
      lastDate: DateTime(2050),
    );
    if (picked != null) setState(() => _valueto = picked);
  }

  Future _selectDateFrom() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2050),
    );
    if (picked != null)
      setState(() {
        _valuefrom = picked;
        //_valueto = _valuefrom.add(new Duration(days: 1));
        _valuecond = _valuefrom.add(Duration(days: 30));
      });
  }

  Future<String> getSWData() async {
    var v = AapoortiConstants.webServiceUrl +
        '/getData?input=SPINNERS,ZONE,01,,,-1';
    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);
    setState(() {
      data = jsonResult!;
      data.removeAt(0);
    });
    return "Success";
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }

  void reset() {
    pressed = false;
    myController.clear();
    myselection1 = null;
    myController1.clear();
    myselection1 = false;
    _valuefrom = DateTime.now();
    _valueto = _valuefrom.add(Duration(days: 1));
    _valueto = _valuefrom.add(Duration(days: 30));
    valueRange = 0.0;
    getSWData();
    setState(() {
      valueRange = 0.0;
      pressed = false;
      //data = [];
      myselection1 = null;
      myController.clear();
      myController1.clear();
      _valueto = DateTime.now();
      _valueto = _valuefrom.add(Duration(days: 1));
      _valuecond = _valuefrom.add(Duration(days: 30));
    });
  }

  Widget _myListView(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.only(top: 20.0, left: 10, right: 10),
              child: TextFormField(
                  onSaved: (value) {
                    supName = value!;
                  },
                  controller: myController,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.assignment, color: Colors.black,
                        // textDirection: TextDirection.rtl,
                      ),
                      labelText: 'Supplier Name (min 3 char,Optional field)',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      helperStyle: TextStyle(
                        color: Colors.grey,
                      ))),
            ),
            Card(
              margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
              child: TextFormField(
                  onSaved: (value) {
                    plNo = value!;
                  },
                  controller: myController1,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.assignment, color: Colors.black,
                        // textDirection: TextDirection.rtl,
                      ),
                      labelText: 'PL No (min 3 char, Optional field)',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      helperStyle: TextStyle(
                        color: Colors.grey,
                      ))),
            ),
            Card(
              margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
              child: DropdownButtonFormField(
                validator: (newVal1) {
                  if (newVal1 == null) {
                    return "Select Railway";
                  } else {
                    return null;
                  }
                },

                hint: Text(
                    myselection1 != null ? myselection1 : "Select Railway"),
                decoration: InputDecoration(
                    icon: Icon(Icons.train, color: Colors.black)),
                items: data.map((item) {
                  return DropdownMenuItem(
                      child: Text(item['NAME']),
                      value: item['ACCID'].toString());
                }).toList(),
                onChanged: (newVal1) {
                  setState(() {
                    myselection1 = newVal1;
                  });
                  //checkvalue();
                  this.getSWData();
                },

                // color: visibilitywk ? Colors.grey : Colors.red, fontSize: 11.0),
                value: myselection1,
              ),
            ),
            Card(
              margin: EdgeInsets.only(top: 15.0, left: 15, right: 15),
              child: Column(
                children: <Widget>[
                  Text(
                    "Select PO Value Range (in Lakhs)",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: slider_color ? Colors.grey : Colors.red,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[200],
                    height: 40,
                    child: CupertinoSlider(
                      value: valueRange,
                      onChanged: (value) {
                        setState(() {
                          valueRange = value;
                          setRange(valueRange);
                        });
                      },
                      max: 5,
                      min: val,
                      divisions: 5,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: (MediaQuery.of(context).size.width - 20) / 5.7,
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "0",
                                style:
                                    TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          )),
                      Padding(padding: EdgeInsets.all(2.0)),
                      Container(
                          width: (MediaQuery.of(context).size.width - 20) / 6.4,
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "0-1",
                                style:
                                    TextStyle(fontSize: 9, color: Colors.grey),
                              ),
                            ],
                          )),
                      Padding(padding: EdgeInsets.all(2.0)),
                      Container(
                          width: (MediaQuery.of(context).size.width - 20) / 6.9,
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "1-2",
                                style:
                                    TextStyle(fontSize: 9, color: Colors.grey),
                              ),
                            ],
                          )),
                      Padding(padding: EdgeInsets.all(2.0)),
                      Container(
                          width: (MediaQuery.of(context).size.width - 20) / 7,
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "2-5",
                                style:
                                    TextStyle(fontSize: 9, color: Colors.grey),
                              ),
                            ],
                          )),
                      Padding(padding: EdgeInsets.all(2.0)),
                      Container(
                          width: (MediaQuery.of(context).size.width - 20) / 7,
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "5-50",
                                style:
                                    TextStyle(fontSize: 9, color: Colors.grey),
                              ),
                            ],
                          )),
                         Container(
                          width:
                              (MediaQuery.of(context).size.width - 20) / 11.45,
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "50-99999",
                                style:
                                    TextStyle(fontSize: 8, color: Colors.grey),
                              ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Card(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text('   Date Range difference must be 30 days',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.fromLTRB(10, 30, 0, 10)),
                          Padding(padding:EdgeInsets.symmetric()),
                          MaterialButton(
                              padding: const EdgeInsets.all(0.0),
                              onPressed: _selectDateFrom,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 15)),
                                  Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(_valuefrom),
                                      style: TextStyle(color: Colors.black),
                                      textAlign: TextAlign.left),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.fromLTRB(50, 30, 0, 10)),
                          MaterialButton(
                              padding: const EdgeInsets.all(0.0),
                              onPressed: _selectDateTo,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 15)),
                                  Text(
                                      DateFormat('dd-MM-yyyy').format(_valueto),
                                      style: TextStyle(color: Colors.black),
                                      textAlign: TextAlign.left),
                                ],
                              )),
                        ]),
                  ],
                ),
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
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
                  borderRadius: BorderRadius.circular(30.0)),
              onPressed: () {
                if(myselection1 == null) {
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
                if(valueRange == 0) {
                  slider_color = false;
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                } else if (_valueto.difference(_valuefrom).inDays < 1) {
                  ScaffoldMessenger.of(context).showSnackBar(snackbar1);
                } else if (_valueto.difference(_valuefrom).inDays > 30) {
                  ScaffoldMessenger.of(context).showSnackBar(snackbar2);
                } else {
                  slider_color = true;
                  pressed = true;
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                    pressed ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchPoList(
                                supName: supName,
                                plNo: plNo,
                                railUnit: myselection1,
                                pv1: pv1,
                                pv2: pv2,
                                valuefrom: DateFormat('dd-MM-yyyy').format(_valuefrom),
                                valueto: DateFormat('dd-MM-yyyy').format(_valueto)))) : null;
                  }
                }

                //checkvalue();
              },
              color: Colors.cyan.shade400,
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
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
                    borderRadius: BorderRadius.circular(30.0)),
                onPressed: () {
                  reset();
                  slider_color = true;
                  myselection1 = null;
                },
                color: Colors.cyan.shade400),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    key: _snackKey,
    // appBar: AppBar(
    //     backgroundColor: Colors.cyan[400],
    //     iconTheme: IconThemeData(color: Colors.white),
    //     title: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Container(child: Text('Purchase Order Search', style: TextStyle(color: Colors.white, fontSize: 16))),
    //         IconButton(
    //           icon: Icon(
    //             Icons.home,
    //             color: Colors.white,
    //           ),
    //           onPressed: () {
    //             Navigator.of(context, rootNavigator: true).pop();
    //           },
    //         ),
    //       ],
    //     )),
    body: Builder(
      builder: (context) => Material(
          color: Colors.cyan.shade50,
          child: ListView(
            children: <Widget>[_myListView(context)],
          )),
    ));
    // return WillPopScope(
    //     onWillPop: () async {
    //       Navigator.of(context, rootNavigator: true).pop();
    //       return false;
    //     },
    //     child: Scaffold(
    //         key: _snackKey,
    //         appBar: AppBar(
    //             backgroundColor: Colors.cyan[400],
    //             iconTheme: IconThemeData(color: Colors.white),
    //             title: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Container(child: Text('Purchase Order Search', style: TextStyle(color: Colors.white, fontSize: 16))),
    //                 IconButton(
    //                   icon: Icon(
    //                     Icons.home,
    //                     color: Colors.white,
    //                   ),
    //                   onPressed: () {
    //                     Navigator.of(context, rootNavigator: true).pop();
    //                   },
    //                 ),
    //               ],
    //             )),
    //         body: Builder(
    //           builder: (context) => Material(
    //               color: Colors.cyan.shade50,
    //               child: ListView(
    //                 children: <Widget>[_myListView(context)],
    //               )),
    //         )));
  }

  void setRange(double value) {
    debugPrint("value" + value.toString());
    if (value == 0.0) {
      pv1 = "0";
      pv2 == "0";
    } else if (value == 1.0) {
      pv1 = "0";
      pv2 = "1";
    } else if (value == 2.0) {
      pv1 = "1";
      pv2 = "2";
    } else if (value == 3.0) {
      pv1 = "2";
      pv2 = "5";
    } else if (value == 4.0) {
      pv1 = "5";
      pv2 = "50";
    } else if (value == 5.0) {
      pv1 = "50";
      pv2 = "99999";
    }
  }

  void checkvalue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Navigator.push(context,MaterialPageRoute(builder: (context) => Status(content: text,id:_mySelection)));
    } else {
//    If all data are not valid then start auto validation.
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

  final snackbar2 = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Maximum date difference must be 30 days',
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

//  Widget build(BuildContext context) {
//    var dateFormat_1 = new Column(
//      children: <Widget>[
//        new SizedBox(
//          height: 30.0,
//        ),
//        selected != null
//            ? new Text(
//          new DateFormat('yyyy-MM-dd').format(selected),
//          style: new TextStyle(
//            color: Colors.black,
//            fontSize: 20.0,
//          ),
//        )
//            : new SizedBox(
//          width: 0.0,
//          height: 0.0,
//        ),
//      ],
//    );
//
//    var dateFormat_2 = new Column(
//      children: <Widget>[
//        new SizedBox(
//          height: 30.0,
//        ),
//        selected != null
//            ? new Text(
//          new DateFormat('yyyy-MM-dd').format(selected),
//          style: new TextStyle(
//            color: Colors.deepPurple,
//            fontSize: 20.0,
//          ),
//        )
//            : new SizedBox(
//          width: 0.0,
//          height: 0.0,
//        ),
//      ],
//    );
//
//    var dateStringParsing = new Column(
//      children: <Widget>[
//        new SizedBox(
//          height: 30.0,
//        ),
//        selected != null
//            ? new Text(
//          new DateFormat('yyyy-MM-dd')
//              .format(DateTime.parse("2018-09-15")),
//          style: new TextStyle(
//            color: Colors.green,
//            fontSize: 20.0,
//          ),
//        )
//            : new SizedBox(
//          width: 0.0,
//          height: 0.0,
//        ),
//      ],
//    );
//
//
//
//    _onClear(){
//      setState(()
//      {
//        _textFieldController1.text = "";
//        _textFieldController2.text = "";
//      });
//    }
//
//    void dispose()
//    {
//      _textFieldController1.dispose();
//      _textFieldController2.dispose();
//      super.dispose();
//    }
//    final SupplierNameCard = new Card(
//      // padding: new EdgeInsets.only(left: 10,right: 150,top: 10),
//
//      child: Padding(
//        //Add padding around textfield
//        padding: EdgeInsets.symmetric(horizontal: 10.0),
//        child: TextField(
//          controller: _textFieldController1,
//          onEditingComplete: (){
//            supName = _textFieldController1.text;
//            print(supName);
//          },
//          decoration: InputDecoration(
//            hintText: "Supplier Name(min 3 char, Optional field)",
//            //add icon outside input field
//            icon: Icon(Icons.speaker_notes,color: Colors.black,),
//          ),
//        ),
//      ),
//      margin: EdgeInsets.only(left: 20,right: 20,top: 40) ,
//    );
//
//    final PLNumberCard = new Card(
//      // padding: new EdgeInsets.only(left: 10,right: 150),
//      child: Padding(
//        //Add padding around textfield
//        padding: EdgeInsets.symmetric(horizontal: 10.0),
//        child: TextField(
//          controller: _textFieldController2,
//          onEditingComplete: (){
//            plNo = _textFieldController2.text;
//            print(plNo);
//          },
//          decoration: InputDecoration(
//            hintText: "PL No(min 3 characters, option field)",fillColor: Colors.black,
//            //add icon outside input field
//            icon: Icon(Icons.speaker_notes,color: Colors.black,),
//          ),
//        ),
//      ),
//      margin: EdgeInsets.only(left: 20,right: 20,top: 40) ,
//    );
//    final DropDownCard = new Card(
//
//      child: Container
//        (
//        width: MediaQuery.of(context).size.width,
//        child: new  Row(
//          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//
//            new Icon(Icons.train,color: Colors.black,),
//            DropdownButton(
//              hint: Text('   Select Railway/PU',),
//
//              items: data.map((item){
//                return new DropdownMenuItem(child: new Text(item['NAME']),value: item['ACCID'].toString(),
//                );
//              }).toList(),
//              onChanged: (newVal){
//
//                setState(() {
//                  railUnit = newVal;
//                  print("railUnit"+railUnit);
//                });
//              },
//              value: railUnit,
//            ),
////
//          ],
//        ),
//      )
//      ,margin: EdgeInsets.only(left: 20,right: 20,top: 20) ,
//    );
//
//    final SliderCard = new Card(
//
//      child: Padding(
//        /*padding: EdgeInsets.symmetric(vertical: 2),*/
//          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//          child: Column(
//            children: <Widget>[
//              new Text("Select PO Value Range (in Lakhs)",
//                textAlign: TextAlign.left,
//                style: TextStyle(
//                    color: Colors.grey
//                ),
//              ),
//              new Container(
//                width:MediaQuery.of(context).size.width,
//                color: Colors.grey[200],
//                height: 50,
//                child: CupertinoSlider(
//                  value: valueRange,
//                  onChanged : (value){
//                    setState(() {
//                      valueRange = value;
//                      setRange(valueRange);
//                      print(valueRange);
//                    });
//                  },
//                  max: 5,
//                  min: 0,
//                  divisions :5,
//                ),
//              ),
//
//              Row(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  new Container(
//                      width: (MediaQuery.of(context).size.width-20)/5.7,
//                      alignment: Alignment.topLeft,
//                      child:
//                      Column(
//                        children: <Widget>[
//                          Text("0",
//                            style: TextStyle(
//                                fontSize:7.6,
//                                color:Colors.grey
//                            ),),
//                        ],
//                      )
//                  ),
//
//                  Padding(padding: new EdgeInsets.all(2.0)),
//                  new Container(
//                      width: (MediaQuery.of(context).size.width-20)/6.4,
//                      alignment: Alignment.topLeft,
//                      child:
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Text("0-1",
//                            style: TextStyle(
//                                fontSize:7.6,
//                                color:Colors.grey
//                            ),
//                          ),
//                        ],
//                      )
//                  ),
//                  Padding(padding: new EdgeInsets.all(2.0)),
//                  new Container(
//                      width: (MediaQuery.of(context).size.width-20)/6.9,
//                      alignment: Alignment.topLeft,
//                      child:
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Text("1-2",
//                            style: TextStyle(
//                                fontSize:7.6,
//                                color:Colors.grey
//                            ),
//                          ),
//                        ],
//                      )
//                  ),
//                  Padding(padding: new EdgeInsets.all(2.0)),
//                  new Container(
//                      width: (MediaQuery.of(context).size.width -20)/7,
//                      alignment: Alignment.topLeft,
//                      child:
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Text("2-5",
//                            style: TextStyle(
//                                fontSize:7.6,
//                                color:Colors.grey
//                            ),
//                          ),
//                        ],
//                      )
//                  ),
//                  Padding(padding: new EdgeInsets.all(2.0)),
//                  new Container(
//                      width: (MediaQuery.of(context).size.width -20)/7,
//                      alignment: Alignment.topLeft,
//                      child:
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Text("5-50",
//                            style: TextStyle(
//                                fontSize:7.6,
//                                color:Colors.grey
//                            ),),
//                        ],
//                      )
//                  ),
//                  new Container(
//                      width: (MediaQuery.of(context).size.width-20)/11.45,
//                      alignment: Alignment.topLeft,
//                      child:
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Text("50-99999",
//                            style: TextStyle(
//                                fontSize:7.6,
//                                color:Colors.grey
//                            ),
//                          ),
//                        ],
//                      )
//                  ),
//                ],
//              ),
//            ],
//          )
//      ),
//      margin: EdgeInsets.only(left: 20,right: 20,top: 20) ,
//    );
//
//
//    final DateRangeText = new Card(
//      color: Colors.white,
//      child: Padding(
//        padding: EdgeInsets.symmetric(horizontal: 10.0),
//      ),
//      margin: EdgeInsets.only(left: 20,right: 20,top: 20) ,
//    );
//    final DateSelectCard = new Card(
//      child: Padding(
//        padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 0.0),
//        child: new Column(
//
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          mainAxisSize: MainAxisSize.max,
//          children: <Widget>[
//            new Row(
//
//
//              mainAxisSize: MainAxisSize.max,
//              children: <Widget>[
//                new Text('   Date Range Difference must be in 30 days',style: TextStyle(color: Colors.grey)),
//
//
//              ],
//            ),
//            new Row(
//              children: <Widget>[
//                new MaterialButton(
//                  onPressed: ()=>{ _selectDateFrom(),
//                  },
//                  child: new Icon(
//                    Icons.date_range,
//                  ),
//                ),
//                new Text(
//                  new DateFormat('dd-MM-yyyy').format(_valuefrom),
//                  style: TextStyle(color: Colors.black),
//                ),
//                new MaterialButton(
//                  onPressed: ()=>{_selectDateTo(),
//                  /*print("valueto"+_valueto.toString()),*/
//                  },
//                  child: new Icon(
//                    Icons.date_range,
//                  ),
//                ),
//                new Text(
//                  new DateFormat('dd-MM-yyyy').format(_valueto),
//                  style: TextStyle(color: Colors.black),
//                ),
//              ],
//            ),
//          ],
//        ),)
//      ,margin: EdgeInsets.only(left: 20,right: 20) ,
//
//    );
//
//    final ResultButton = new Container(
//        padding: new EdgeInsets.only(left: 20,right: 20,top:30.0),
//        child: new Column(
//          children: <Widget>[
//            SizedBox(
//              height: 10,
//            ),
//            ButtonTheme(
//              minWidth: double.infinity,
//              child: MaterialButton(
//                onPressed: () => {
//                print("submit button"),
//                print("supName"+supName.toString()),
//                print("plNo"+plNo.toString()),
//                print("pv1 "+pv1.toString()),
//                print("pv2 "+pv2.toString()),
//                print("valuefrom"+DateFormat('dd-MM-yyyy').format(_valuefrom)),
//                print("valueto"+DateFormat('dd-MM-yyyy').format(_valueto)),
//
//                Navigator.push(context, MaterialPageRoute(
//                    builder: (context) =>
//                        SearchPoList(supName: supName,
//                            plNo: plNo,
//                            pv1: pv1,
//                            pv2:pv2,
//                            valuefrom: DateFormat('dd-MM-yyyy').format(_valuefrom),
//                            valueto: DateFormat('dd-MM-yyyy').format(_valueto))))
//                },
//                textColor: Colors.white,
//                color: Colors.cyan[600],
//                height: 40,
//                child: Text("Show Results",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
//                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
//              ),
//            )
//          ],
//        )
//
//
//    );
//
//    final ResetButton = new Container(
//
//        padding: new EdgeInsets.only(left: 20,right: 20),
//        child: new Column(
//
//          children: <Widget>[
//
//            SizedBox(
//              height: 10,
//            ),
//            ButtonTheme(
//              //elevation: 4,
//              //color: Colors.green,
//              minWidth: double.infinity,
//              child: MaterialButton(
//                onPressed: () => {},
//                textColor: Colors.white
//                ,
//
//                color: Colors.cyan[600],
//                height: 40,
//                child: Text("Reset",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
//                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
//              ),
//            )
//          ],
//        )
//
//
//    );
//    return MaterialApp(
//        debugShowCheckedModeBanner: false,
//
//        title: "my APP",
//        home: Scaffold(
//          appBar: AppBar(title: Text("Purchase Order"),
//            backgroundColor: Colors.cyan,),
//          body: Material(
//            child: new Container(
//                color: Colors.cyan[50],
//                child: ListView(
//                  children: <Widget>[
//                    new Column(
//                      children: <Widget>[
//
//                      ],
//                    ),
//                  ],
//                )
//            ),
//          ),
//        )
//    );
//  }
//
//  void setRange(double value)
//  {
//
//    if(value == 0.0)
//    {
//      pv1 = "0";
//      pv2 == "0";
//    }
//    else if(value == 1.0)
//    {
//      pv1 = "0";
//      pv2 = "1";
//    }
//    else if(value == 2.0)
//    {
//      pv1 = "1";
//      pv2 = "2";
//    }
//    else if(value == 3.0)
//    {
//      pv1 = "2";
//      pv2 = "5";
//    }
//    else if(value == 4.0)
//    {
//      pv1= "5";
//      pv2 = "50";
//    }
//    else if(value == 5.0)
//    {
//      pv1 = "50";
//      pv2 = "99999";
//    }
//
//    print("pv1"+pv1.toString());
//    print("pv2"+pv2.toString());
//  }



//import 'dart:core';
//import 'dart:core';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_app/common/AapoortiConstants.dart';
//import 'package:intl/intl.dart';
//import 'dart:convert';
//import 'package:http/http.dart' as http;
//
//import 'SearchPoList.dart';
//class SearchPoZonal extends StatefulWidget {
//
//  TextEditingController _textFieldController = TextEditingController();
//  SearchPoZonal() : super();
//
//  @override
//  _SearchZonalState createState() => _SearchZonalState();
//}
//
//class _SearchZonalState extends State<SearchPoZonal> {
//  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//  List<dynamic> jsonResult;
//  String pv1 = "",pv2="";
//  String supName = "";
//  bool pressed= false;
//  String plNo = "";
//  bool _autoValidate = false;
//  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
//  bool slider_color=true;
//  String railUnit;
//  DateTime selected;
//  double valueRange = 0;
//
//  DateTime _valuefrom = new DateTime.now();
//  DateTime _valueto = new DateTime.now().add(new Duration(days: 1));
//
//
//
//
//  String text1;
//
//  TextEditingController myController = TextEditingController();
//  TextEditingController myController1 = TextEditingController();
//  String text2;
//
//  var myselection1;
//  Future _selectDateTo() async {
//    DateTime picked = await showDatePicker(
//      context: context,
//      initialDate: new DateTime.now(),
//      firstDate: new DateTime(1960),
//      lastDate: new DateTime(2050),
//    );
//    if (picked != null) setState(() => _valueto = picked);
//  }
//
//  Future _selectDateFrom() async {
//    DateTime picked = await showDatePicker(
//      context: context,
//      initialDate: new DateTime.now(),
//      firstDate: new DateTime(1990),
//      lastDate: new DateTime(2050),
//    );
//    if (picked != null) setState(() => _valuefrom = picked);
//  }
//
//
//
//  List data=List();
//  Future<String> getSWData() async {
//    print('Fetching from service');
//    var v =AapoortiConstants.webServiceUrl +'/getData?input=SPINNERS,ZONE,01,,,-1';
//
//    final response =   await http.post(v);
//    jsonResult = json.decode(response.body);
//
//    print(jsonResult);
//
//    setState(() {
//      data=jsonResult;
//    });
//    return "Success";
//  }
//  @override
//  void initState() {
//
//    super.initState();
//    this.getSWData();
//  }
//  void reset()
//  {
//    print('calling');
//
//    pressed=false;
//
//    myController.clear();
//    myController1.clear();
//    _valueto = new DateTime.now();
//    _valuefrom = _valueto.add(new Duration(days: 1));
//    _valueto = _valueto.add(new Duration(days: 30));
//
//    setState(() {
//      pressed=false;
//      myselection1=null;
//      myselection1=null;
//      myController.clear();
//      myController1.clear();
//
//      _valueto = new DateTime.now();
//      _valuefrom = _valueto.add(new Duration(days: 1));
//      _valueto = _valueto.add(new Duration(days: 30));
//
//    });
//
//  }
//  Widget _myListView(BuildContext context) {
//    return Container(
//      child:Form(
//        key: _formKey,
//        autovalidate: _autoValidate,
//        child: Column(
//          children: <Widget>[
//
//            Card(
//              margin: EdgeInsets.only(top: 20.0, left: 15, right: 15),
//              child: TextFormField(
//                  onSaved: (value) {
//                    text1 = value;
//                  },
//                  controller: myController,
//
//                  decoration: InputDecoration(
//
//
//                      icon: Icon(Icons.assignment, color: Colors.black,
//                        // textDirection: TextDirection.rtl,
//                      ),
//                      labelText: 'Supplier Name (min 3 char,Optional field)',
//                      labelStyle: TextStyle(
//                        color: Colors.grey,
//                      ),
//                      helperStyle: TextStyle(
//                        color: Colors.grey,
//                      )
//
//                  )
//              ),
//            ),
//            Card(
//              margin: EdgeInsets.only(top: 10.0, left: 15, right: 15),
//              child: TextFormField(
//                  onSaved: (value) {
//                    text2 = value;
//                  },
//                  controller: myController1,
//
//                  decoration: InputDecoration(
//
//
//                      icon: Icon(Icons.assignment, color: Colors.black,
//                        // textDirection: TextDirection.rtl,
//                      ),
//                      labelText: 'PL No (min 3 char, Optional field)',
//                      labelStyle: TextStyle(
//                        color: Colors.grey,
//                      ),
//                      helperStyle: TextStyle(
//                        color: Colors.grey,
//                      )
//
//                  )
//              ),
//            ),
//            Card(
//              margin: EdgeInsets.only(top: 10.0, left: 15, right: 15),
//              child: DropdownButtonFormField(
//
//                validator: (newVal1) {
//                  if (newVal1 == null) {
//                    return "Select Railway";
//                  }
//                  else {
//                    return null;
//                  }
//                },
//                onSaved: (newVal1) {
//                  setState(() {
//                    myselection1 = newVal1;
//                    print("my selection first" + myselection1);
//                  });
//                },
//
//                hint: Text('Select Railway'),
//                decoration: InputDecoration(
//                    icon: Icon(Icons.train, color: Colors.black)),
//                items: data.map(
//                        (item) {
//                      return new DropdownMenuItem(child:
//                      new Text(
//                          item['NAME']
//                      ), value: item['ACCID'].toString()
//                      );
//                    }).toList(),
//                onChanged: (newVal1) {
//                  setState(() {
//                    //enable=true;
//                    myselection1 = newVal1;
//                    print("my selection first" + myselection1);
//                  });
//                  //checkvalue();
//                  this.getSWData();
//                },
//
//                // color: visibilitywk ? Colors.grey : Colors.red, fontSize: 11.0),
//                value: myselection1,
//              ),
//            ),
//            Card(
//              margin: EdgeInsets.only(top: 15.0, left: 15, right: 15),
//              child: Column(
//                children: <Widget>[
//                  new Text("Select PO Value Range (in Lakhs)",
//                    textAlign: TextAlign.left,
//                    style: TextStyle(
//                      color: slider_color?Colors.grey:Colors.red,
//                    ),
//                  ),
//                  Container(
//                    width:MediaQuery.of(context).size.width,
//                    color: Colors.grey[200],
//                    height: 40,
//                    child: CupertinoSlider(
//                      value: valueRange,
//                      onChanged : (value){
//                        setState(() {
//                          valueRange = value;
//                          setRange(valueRange);
//                          print(valueRange);
//                        });
//                      },
//                      max: 5,
//                      min: 0,
//                      divisions :5,
//                    ),
//                  ),
//                  Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      new Container(
//                          width: (MediaQuery.of(context).size.width-20)/5.7,
//                          alignment: Alignment.topLeft,
//                          child:
//                          Column(
//                            children: <Widget>[
//                              Text("0",
//                                style: TextStyle(
//                                    fontSize:10,
//                                    color:Colors.grey
//                                ),),
//                            ],
//                          )
//                      ),
//
//                      Padding(padding: new EdgeInsets.all(2.0)),
//                      new Container(
//                          width: (MediaQuery.of(context).size.width-20)/6.4,
//                          alignment: Alignment.topLeft,
//                          child:
//                          Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("0-1",
//                                style: TextStyle(
//                                    fontSize:9,
//                                    color:Colors.grey
//                                ),
//                              ),
//                            ],
//                          )
//                      ),
//                      Padding(padding: new EdgeInsets.all(2.0)),
//                      new Container(
//                          width: (MediaQuery.of(context).size.width-20)/6.9,
//                          alignment: Alignment.topLeft,
//                          child:
//                          Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("1-2",
//                                style: TextStyle(
//                                    fontSize:9,
//                                    color:Colors.grey
//                                ),
//                              ),
//                            ],
//                          )
//                      ),
//                      Padding(padding: new EdgeInsets.all(2.0)),
//                      new Container(
//                          width: (MediaQuery.of(context).size.width -20)/7,
//                          alignment: Alignment.topLeft,
//                          child:
//                          Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("2-5",
//                                style: TextStyle(
//                                    fontSize:9,
//                                    color:Colors.grey
//                                ),
//                              ),
//                            ],
//                          )
//                      ),
//                      Padding(padding: new EdgeInsets.all(2.0)),
//                      new Container(
//                          width: (MediaQuery.of(context).size.width -20)/7,
//                          alignment: Alignment.topLeft,
//                          child:
//                          Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("5-50",
//                                style: TextStyle(
//                                    fontSize:9,
//                                    color:Colors.grey
//                                ),),
//                            ],
//                          )
//                      ),
//                      new Container(
//                          width: (MediaQuery.of(context).size.width-20)/11.45,
//                          alignment: Alignment.topLeft,
//                          child:
//                          Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("50-99999",
//                                style: TextStyle(
//                                    fontSize:8,
//                                    color:Colors.grey
//                                ),
//                              ),
//                            ],
//                          )
//                      ),
//                    ],
//                  ),
//                ],
//              ),
//            ),
//            Padding(padding: EdgeInsets.only(top: 20)),
//            Card(
//              child: Padding(
//                padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 0.0),
//                child: new Column(
//
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  mainAxisSize: MainAxisSize.max,
//                  children: <Widget>[
//                    new Row(
//                      mainAxisSize: MainAxisSize.max,
//                      children: <Widget>[
//                        new Text('   Date Range difference must be 30 days',style: TextStyle(color: Colors.grey)),
//
//
//                      ],
//                    ),
//                    new Row(
//                      children: <Widget>[
//                        new MaterialButton(
//                          onPressed: ()=>{ _selectDateFrom(),
//                          },
//                          child: new Icon(
//                            Icons.date_range,
//                          ),
//                        ),
//                        new Text(
//                          new DateFormat('dd-MM-yyyy').format(_valuefrom),
//                          style: TextStyle(color: Colors.black),
//                        ),
//                        new MaterialButton(
//                          onPressed: ()=>{_selectDateTo(),
//                            /*print("valueto"+_valueto.toString()),*/
//                          },
//                          child: new Icon(
//                            Icons.date_range,
//                          ),
//                        ),
//                        new Text(
//                          new DateFormat('dd-MM-yyyy').format(_valueto),
//                          style: TextStyle(color: Colors.black),
//                        ),
//                      ],
//                    ),
//                  ],
//                ),)
//              ,margin: EdgeInsets.only(left: 20,right: 20) ,
//            ),
//            Padding(padding: EdgeInsets.only(top: 20)),
//            MaterialButton(
//              minWidth: 330,
//              height: 40,
//
//              padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0,),
//              // padding: const EdgeInsets.only(left:110.0,right:110.0),
//              child: Text('Show Result', textAlign: TextAlign.center,
//                style: style.copyWith(
//                    color: Colors.white,
//                    fontWeight: FontWeight.bold,
//                    fontSize: 18),),
//              shape: RoundedRectangleBorder(
//                  borderRadius: new BorderRadius.circular(30.0)),
//              onPressed: () {
//                // slider_color=false;
//                if(    myselection1 ==null)
//                {
//                  if(valueRange==0){
//                    slider_color=false;
//                    print("button not pressed");
//                    Scaffold.of(context).showSnackBar(snackbar);
//
//                  }
//
//                  print("button not pressed");
//                  Scaffold.of(context).showSnackBar(snackbar);
//
//
//                }
//
//                else
//                {
//                  pressed = true;
//                  print("submit button");
////                print("supName"+supName.toString()),
////                print("plNo"+plNo.toString()),
////                print("pv1 "+pv1.toString()),
////                print("pv2 "+pv2.toString()),
////                print("valuefrom"+DateFormat('dd-MM-yyyy').format(_valuefrom)),
////                print("valueto"+DateFormat('dd-MM-yyyy').format(_valueto)),
////
////                Navigator.push(context, MaterialPageRoute(
////                    builder: (context) =>
////                        SearchPoList(supName: supName,
////                            plNo: plNo,
////                            pv1: pv1,
////                            pv2:pv2,
////                            valuefrom: DateFormat('dd-MM-yyyy').format(_valuefrom),
////                            valueto: DateFormat('dd-MM-yyyy').format(_valueto))))
//                  pressed? Navigator.push(context, MaterialPageRoute(
//                      builder: (context) =>
//                          SearchPoList(
//
//                              supName: supName,
//                              plNo: plNo,
//                              railUnit:myselection1,
//                              pv1:pv1,
//                              pv2:pv2,
//                              valuefrom: DateFormat('dd-MM-yyyy').format(_valuefrom),
//                              valueto: DateFormat('dd-MM-yyyy').format(_valueto)))):null;
//                }
//
//                checkvalue();
//
////
////                    if(text==null)||myselection1!=minus&&myselection1!=minus1&&myselection1!=minus2&&myselection1!=minus3&&myselection1!=minus4&&myselection1!=minus5&&myselection1!=minus6&&myselection1!=minus7||_mySelection==null)
////                if (text == null || myselection1 == null ||
////                    _mySelection == null) {
////
////                  print("button not pressed");
////
////                  //  AapoortiUtilities.showInSnackBar(context,"please select atleast one option!!")
////
////                }
////                else {
////                  text1.trim();
////                  pressed = true;
////                  pressed
////                      ? Navigator.push(context, MaterialPageRoute(
////                      builder: (context) => Status(
////                          Date: date, content: text, id: _mySelection)))
////                      : null;
////                }
////                checkvalue();
//
//                // Navigator.push(context,MaterialPageRoute(builder: (context) => Status(content: text,id:_mySelection)));
//
//              },
//              color: Colors.cyan.shade400,
//            ),
//            Padding(padding: EdgeInsets.only(top: 20)),
//            MaterialButton(
//                minWidth: 330,
//                height: 40,
//                padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
//                // padding: const EdgeInsets.only(left:110.0,right:110.0),
//                child: Text('Reset', textAlign: TextAlign.center,
//                    style: style.copyWith(
//                        color: Colors.white,
//                        fontWeight: FontWeight.bold,
//                        fontSize: 18)),
//
//                shape: RoundedRectangleBorder(
//                    borderRadius: new BorderRadius.circular(30.0)),
//
//                onPressed: () {
////                  _onClear();
//                },
//                color: Colors.cyan.shade400),
//
//
//          ],
//        ),
//      ),
//
//    );
//  }
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//        onWillPop: () async {
//          Navigator.of(context, rootNavigator: true).pop();
//          return false;
//        },
//        child:Scaffold(
//            appBar:AppBar(
//                backgroundColor: Colors.cyan[400],
//                title: new Row(
//                  children: [
//                    Container(
//                        child: Text('Purchase Order Search', style:TextStyle(
//                            color: Colors.white
//                        ))),
//                    new Padding(padding: new EdgeInsets.only(right: 65.0)),
//                    new IconButton(
//                      icon: new Icon(
//                        Icons.home,color: Colors.white,
//                      ),
//                      onPressed: () {
//                        Navigator.of(context, rootNavigator: true).pop();
//                      },
//                    ),
//                  ],
//                )),
//            body:
//            Builder(
//              builder: (context) =>Material(
//
//                  color: Colors.cyan.shade50,
//                  child:
//                  ListView(
//                    children: <Widget>[
//                      _myListView(context)
//                    ],
//                  )
//
//              ),
//
//            )
//
////            Container(child: _myListView(context))
//
//
//        )
//    );
//  }
//
//  void setRange(double value)
//  {
//    print("value"+value.toString());
//    if(value == 0.0)
//    {
//      pv1 = "0";
//      pv2 == "0";
//    }
//    else if(value == 1.0)
//    {
//      pv1 = "0";
//      pv2 = "1";
//    }
//    else if(value == 2.0)
//    {
//      pv1 = "1";
//      pv2 = "2";
//    }
//    else if(value == 3.0)
//    {
//      pv1 = "2";
//      pv2 = "5";
//    }
//    else if(value == 4.0)
//    {
//      pv1= "5";
//      pv2 = "50";
//    }
//    else if(value == 5.0)
//    {
//      pv1 = "50";
//      pv2 = "99999";
//    }
//
//    print("pv1"+pv1.toString());
//    print("pv2"+pv2.toString());
//  }
//  void checkvalue() {
//
//    if (_formKey.currentState.validate()) {
//      _formKey.currentState.save();
//
//      // Navigator.push(context,MaterialPageRoute(builder: (context) => Status(content: text,id:_mySelection)));
//    }
//    else {
////    If all data are not valid then start auto validation.
//      print("If all data are not valid then start auto validation.");
//      setState(() {
//        _autoValidate = true;
//      });
//    }
//
//
//  }
//  final snackbar=  SnackBar(
//
//    backgroundColor: Colors.redAccent[100],
//    content: Container(
//
//      child: Text('Please select values',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18,color: Colors.teal),),
//    ),
//    action: SnackBarAction(
//      label: 'Undo',
//      onPressed: () {
//        // Some code to undo the change.
//      },
//    ),
//  );
//}
//
////  Widget build(BuildContext context) {
////    var dateFormat_1 = new Column(
////      children: <Widget>[
////        new SizedBox(
////          height: 30.0,
////        ),
////        selected != null
////            ? new Text(
////          new DateFormat('yyyy-MM-dd').format(selected),
////          style: new TextStyle(
////            color: Colors.black,
////            fontSize: 20.0,
////          ),
////        )
////            : new SizedBox(
////          width: 0.0,
////          height: 0.0,
////        ),
////      ],
////    );
////
////    var dateFormat_2 = new Column(
////      children: <Widget>[
////        new SizedBox(
////          height: 30.0,
////        ),
////        selected != null
////            ? new Text(
////          new DateFormat('yyyy-MM-dd').format(selected),
////          style: new TextStyle(
////            color: Colors.deepPurple,
////            fontSize: 20.0,
////          ),
////        )
////            : new SizedBox(
////          width: 0.0,
////          height: 0.0,
////        ),
////      ],
////    );
////
////    var dateStringParsing = new Column(
////      children: <Widget>[
////        new SizedBox(
////          height: 30.0,
////        ),
////        selected != null
////            ? new Text(
////          new DateFormat('yyyy-MM-dd')
////              .format(DateTime.parse("2018-09-15")),
////          style: new TextStyle(
////            color: Colors.green,
////            fontSize: 20.0,
////          ),
////        )
////            : new SizedBox(
////          width: 0.0,
////          height: 0.0,
////        ),
////      ],
////    );
////
////
////
////    _onClear(){
////      setState(()
////      {
////        _textFieldController1.text = "";
////        _textFieldController2.text = "";
////      });
////    }
////
////    void dispose()
////    {
////      _textFieldController1.dispose();
////      _textFieldController2.dispose();
////      super.dispose();
////    }
////    final SupplierNameCard = new Card(
////      // padding: new EdgeInsets.only(left: 10,right: 150,top: 10),
////
////      child: Padding(
////        //Add padding around textfield
////        padding: EdgeInsets.symmetric(horizontal: 10.0),
////        child: TextField(
////          controller: _textFieldController1,
////          onEditingComplete: (){
////            supName = _textFieldController1.text;
////            print(supName);
////          },
////          decoration: InputDecoration(
////            hintText: "Supplier Name(min 3 char, Optional field)",
////            //add icon outside input field
////            icon: Icon(Icons.speaker_notes,color: Colors.black,),
////          ),
////        ),
////      ),
////      margin: EdgeInsets.only(left: 20,right: 20,top: 40) ,
////    );
////
////    final PLNumberCard = new Card(
////      // padding: new EdgeInsets.only(left: 10,right: 150),
////      child: Padding(
////        //Add padding around textfield
////        padding: EdgeInsets.symmetric(horizontal: 10.0),
////        child: TextField(
////          controller: _textFieldController2,
////          onEditingComplete: (){
////            plNo = _textFieldController2.text;
////            print(plNo);
////          },
////          decoration: InputDecoration(
////            hintText: "PL No(min 3 characters, option field)",fillColor: Colors.black,
////            //add icon outside input field
////            icon: Icon(Icons.speaker_notes,color: Colors.black,),
////          ),
////        ),
////      ),
////      margin: EdgeInsets.only(left: 20,right: 20,top: 40) ,
////    );
////    final DropDownCard = new Card(
////
////      child: Container
////        (
////        width: MediaQuery.of(context).size.width,
////        child: new  Row(
////          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
////          children: <Widget>[
////
////            new Icon(Icons.train,color: Colors.black,),
////            DropdownButton(
////              hint: Text('   Select Railway/PU',),
////
////              items: data.map((item){
////                return new DropdownMenuItem(child: new Text(item['NAME']),value: item['ACCID'].toString(),
////                );
////              }).toList(),
////              onChanged: (newVal){
////
////                setState(() {
////                  railUnit = newVal;
////                  print("railUnit"+railUnit);
////                });
////              },
////              value: railUnit,
////            ),
//////
////          ],
////        ),
////      )
////      ,margin: EdgeInsets.only(left: 20,right: 20,top: 20) ,
////    );
////
////    final SliderCard = new Card(
////
////      child: Padding(
////        /*padding: EdgeInsets.symmetric(vertical: 2),*/
////          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
////          child: Column(
////            children: <Widget>[
////              new Text("Select PO Value Range (in Lakhs)",
////                textAlign: TextAlign.left,
////                style: TextStyle(
////                    color: Colors.grey
////                ),
////              ),
////              new Container(
////                width:MediaQuery.of(context).size.width,
////                color: Colors.grey[200],
////                height: 50,
////                child: CupertinoSlider(
////                  value: valueRange,
////                  onChanged : (value){
////                    setState(() {
////                      valueRange = value;
////                      setRange(valueRange);
////                      print(valueRange);
////                    });
////                  },
////                  max: 5,
////                  min: 0,
////                  divisions :5,
////                ),
////              ),
////
////              Row(
////                crossAxisAlignment: CrossAxisAlignment.center,
////                mainAxisAlignment: MainAxisAlignment.center,
////                children: <Widget>[
////                  new Container(
////                      width: (MediaQuery.of(context).size.width-20)/5.7,
////                      alignment: Alignment.topLeft,
////                      child:
////                      Column(
////                        children: <Widget>[
////                          Text("0",
////                            style: TextStyle(
////                                fontSize:7.6,
////                                color:Colors.grey
////                            ),),
////                        ],
////                      )
////                  ),
////
////                  Padding(padding: new EdgeInsets.all(2.0)),
////                  new Container(
////                      width: (MediaQuery.of(context).size.width-20)/6.4,
////                      alignment: Alignment.topLeft,
////                      child:
////                      Column(
////                        crossAxisAlignment: CrossAxisAlignment.center,
////                        children: <Widget>[
////                          Text("0-1",
////                            style: TextStyle(
////                                fontSize:7.6,
////                                color:Colors.grey
////                            ),
////                          ),
////                        ],
////                      )
////                  ),
////                  Padding(padding: new EdgeInsets.all(2.0)),
////                  new Container(
////                      width: (MediaQuery.of(context).size.width-20)/6.9,
////                      alignment: Alignment.topLeft,
////                      child:
////                      Column(
////                        crossAxisAlignment: CrossAxisAlignment.center,
////                        children: <Widget>[
////                          Text("1-2",
////                            style: TextStyle(
////                                fontSize:7.6,
////                                color:Colors.grey
////                            ),
////                          ),
////                        ],
////                      )
////                  ),
////                  Padding(padding: new EdgeInsets.all(2.0)),
////                  new Container(
////                      width: (MediaQuery.of(context).size.width -20)/7,
////                      alignment: Alignment.topLeft,
////                      child:
////                      Column(
////                        crossAxisAlignment: CrossAxisAlignment.center,
////                        children: <Widget>[
////                          Text("2-5",
////                            style: TextStyle(
////                                fontSize:7.6,
////                                color:Colors.grey
////                            ),
////                          ),
////                        ],
////                      )
////                  ),
////                  Padding(padding: new EdgeInsets.all(2.0)),
////                  new Container(
////                      width: (MediaQuery.of(context).size.width -20)/7,
////                      alignment: Alignment.topLeft,
////                      child:
////                      Column(
////                        crossAxisAlignment: CrossAxisAlignment.center,
////                        children: <Widget>[
////                          Text("5-50",
////                            style: TextStyle(
////                                fontSize:7.6,
////                                color:Colors.grey
////                            ),),
////                        ],
////                      )
////                  ),
////                  new Container(
////                      width: (MediaQuery.of(context).size.width-20)/11.45,
////                      alignment: Alignment.topLeft,
////                      child:
////                      Column(
////                        crossAxisAlignment: CrossAxisAlignment.center,
////                        children: <Widget>[
////                          Text("50-99999",
////                            style: TextStyle(
////                                fontSize:7.6,
////                                color:Colors.grey
////                            ),
////                          ),
////                        ],
////                      )
////                  ),
////                ],
////              ),
////            ],
////          )
////      ),
////      margin: EdgeInsets.only(left: 20,right: 20,top: 20) ,
////    );
////
////
////    final DateRangeText = new Card(
////      color: Colors.white,
////      child: Padding(
////        padding: EdgeInsets.symmetric(horizontal: 10.0),
////      ),
////      margin: EdgeInsets.only(left: 20,right: 20,top: 20) ,
////    );
////    final DateSelectCard = new Card(
////      child: Padding(
////        padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 0.0),
////        child: new Column(
////
////          mainAxisAlignment: MainAxisAlignment.spaceBetween,
////          mainAxisSize: MainAxisSize.max,
////          children: <Widget>[
////            new Row(
////
////
////              mainAxisSize: MainAxisSize.max,
////              children: <Widget>[
////                new Text('   Date Range Difference must be in 30 days',style: TextStyle(color: Colors.grey)),
////
////
////              ],
////            ),
////            new Row(
////              children: <Widget>[
////                new MaterialButton(
////                  onPressed: ()=>{ _selectDateFrom(),
////                  },
////                  child: new Icon(
////                    Icons.date_range,
////                  ),
////                ),
////                new Text(
////                  new DateFormat('dd-MM-yyyy').format(_valuefrom),
////                  style: TextStyle(color: Colors.black),
////                ),
////                new MaterialButton(
////                  onPressed: ()=>{_selectDateTo(),
////                  /*print("valueto"+_valueto.toString()),*/
////                  },
////                  child: new Icon(
////                    Icons.date_range,
////                  ),
////                ),
////                new Text(
////                  new DateFormat('dd-MM-yyyy').format(_valueto),
////                  style: TextStyle(color: Colors.black),
////                ),
////              ],
////            ),
////          ],
////        ),)
////      ,margin: EdgeInsets.only(left: 20,right: 20) ,
////
////    );
////
////    final ResultButton = new Container(
////        padding: new EdgeInsets.only(left: 20,right: 20,top:30.0),
////        child: new Column(
////          children: <Widget>[
////            SizedBox(
////              height: 10,
////            ),
////            ButtonTheme(
////              minWidth: double.infinity,
////              child: MaterialButton(
////                onPressed: () => {
////                print("submit button"),
////                print("supName"+supName.toString()),
////                print("plNo"+plNo.toString()),
////                print("pv1 "+pv1.toString()),
////                print("pv2 "+pv2.toString()),
////                print("valuefrom"+DateFormat('dd-MM-yyyy').format(_valuefrom)),
////                print("valueto"+DateFormat('dd-MM-yyyy').format(_valueto)),
////
////                Navigator.push(context, MaterialPageRoute(
////                    builder: (context) =>
////                        SearchPoList(supName: supName,
////                            plNo: plNo,
////                            pv1: pv1,
////                            pv2:pv2,
////                            valuefrom: DateFormat('dd-MM-yyyy').format(_valuefrom),
////                            valueto: DateFormat('dd-MM-yyyy').format(_valueto))))
////                },
////                textColor: Colors.white,
////                color: Colors.cyan[600],
////                height: 40,
////                child: Text("Show Results",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
////                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
////              ),
////            )
////          ],
////        )
////
////
////    );
////
////    final ResetButton = new Container(
////
////        padding: new EdgeInsets.only(left: 20,right: 20),
////        child: new Column(
////
////          children: <Widget>[
////
////            SizedBox(
////              height: 10,
////            ),
////            ButtonTheme(
////              //elevation: 4,
////              //color: Colors.green,
////              minWidth: double.infinity,
////              child: MaterialButton(
////                onPressed: () => {},
////                textColor: Colors.white
////                ,
////
////                color: Colors.cyan[600],
////                height: 40,
////                child: Text("Reset",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
////                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
////              ),
////            )
////          ],
////        )
////
////
////    );
////    return MaterialApp(
////        debugShowCheckedModeBanner: false,
////
////        title: "my APP",
////        home: Scaffold(
////          appBar: AppBar(title: Text("Purchase Order"),
////            backgroundColor: Colors.cyan,),
////          body: Material(
////            child: new Container(
////                color: Colors.cyan[50],
////                child: ListView(
////                  children: <Widget>[
////                    new Column(
////                      children: <Widget>[
////
////                      ],
////                    ),
////                  ],
////                )
////            ),
////          ),
////        )
////    );
////  }
////
////  void setRange(double value)
////  {
////
////    if(value == 0.0)
////    {
////      pv1 = "0";
////      pv2 == "0";
////    }
////    else if(value == 1.0)
////    {
////      pv1 = "0";
////      pv2 = "1";
////    }
////    else if(value == 2.0)
////    {
////      pv1 = "1";
////      pv2 = "2";
////    }
////    else if(value == 3.0)
////    {
////      pv1 = "2";
////      pv2 = "5";
////    }
////    else if(value == 4.0)
////    {
////      pv1= "5";
////      pv2 = "50";
////    }
////    else if(value == 5.0)
////    {
////      pv1 = "50";
////      pv2 = "99999";
////    }
////
////    print("pv1"+pv1.toString());
////    print("pv2"+pv2.toString());
////  }
//
//
