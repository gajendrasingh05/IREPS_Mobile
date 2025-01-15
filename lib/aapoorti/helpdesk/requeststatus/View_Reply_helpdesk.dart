import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/helpdesk/requeststatus/view_helpdesk_details.dart';
import 'package:flutter_app/aapoorti/home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class View_Reply_helpdesk extends StatefulWidget {
  View_Reply_helpdesk() : super();

  final String title = "DropDown Demo";

  @override
  View_Reply_helpdeskState createState() => View_Reply_helpdeskState();
}

class View_Reply_helpdeskState extends State<View_Reply_helpdesk> {
  String? content;
  String? id;
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  List<dynamic>? jsonResult;
  List<dynamic>? jsonResult1;
  List<dynamic>? jsonFinalResult;
  String? _mySelection, myselection1;
  TextEditingController myController2 = TextEditingController();
  TextEditingController myController1 = TextEditingController();

  var index = 0;

  void _onClear() {
    print('calling');

    myController1.text = "";
    myController2.text = "";
    content = null;
    id = null;

    setState(() {
      myController1.text = "";
      myController2.text = "";
      content = null;
      id = null;

      //   _mySelection= 1.toString();
    });
  }

  bool visibilityTag = false;
  bool visibilityObs = false;
  int counter = 0;
  bool visibilityyes = false;
  bool visibilityno = false;
  String? _name;
  String? _email;

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "tag") {
        visibilityTag = visibility;
        visibilityObs = false;
      }
    });
  }

  String? validateName(String? value) {
    if (value!.length < 3)
      return ' Enter Query ID';
    else
      return null;
  }

  String? validateEmail(String? value) {
    // Define a regex pattern for email validation
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );

    // Check if the email matches the regex pattern
    if (value!.isEmpty) {
      return 'Email cannot be empty';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    } else {
      return null; // No error
    }
  }


  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController1.dispose();
    myController2.dispose();
    super.dispose();
  }

  List data = [];
  List data1 = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TopSection = Container(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 20.0)),
                Icon(Icons.assignment),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                Expanded(
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Enter Query ID'),
                    keyboardType: TextInputType.text,
                    validator: validateName,
                    controller: myController1,
                    onEditingComplete: () {
                      content = myController1.text;
                    },
                    onSaved: (String? val) {
                      content = val;
                    },
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 5.0)),
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 20.0)),
                Icon(Icons.email),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                Expanded(
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Enter Email ID'),
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                    controller: myController2,
                    onEditingComplete: () {
                      id = myController2.text;
                    },
                    onSaved: (String? val) {
                      id = val;
                    },
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 5.0)),
          ],
        ),
      ),
      margin: EdgeInsets.only(top: 20, bottom: 30, right: 10),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.cyan[400],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Query Search', style: TextStyle(color: Colors.white)),
            // Padding(padding: EdgeInsets.only(left: 10)),
          ],
        ),
      ),

      backgroundColor: Colors.black,

      body: Builder(
          builder: (context) => Material(

                child: Container(
                  child: ListView(
                    children: <Widget>[
                      TopSection,
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
                          'Search',
                          textAlign: TextAlign.center,
                          style: style.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () {
                          if (content != null && id != null) {
                            print("button not pressed");

                            //  content.trim();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Details(queryid: content, mailid: id)));
                            //fetchPost();
                            //print(jsonResult[index]['REQUEST_STATUS']);
                            _changed(true, "tag");
                            _myListView(context);
                          } else {
                            print("aa");
                            // Scaffold.of(context).showSnackBar(snackbar);
                          }
                          checkvalue();
                        },
                        color: Colors.cyan.shade400,
                      ),
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
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () {
                          _onClear();
                        },
                        color: Colors.cyan.shade400,
                      ),
                    ],
                  ),
                ),
              )),
    );
  }

  Widget _myListView(BuildContext context) {
    //Dismiss spinner
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return ListView.builder(
      itemCount: jsonResult != null ? jsonResult!.length : 0,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 65.0,
                        child: Column(
                          children: <Widget>[
                            Row(children: <Widget>[
                              Expanded(
                                child: Visibility(
                                  child: Text(
                                    "Your request id " + content! + " has been",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: visibilityTag,
                                ),
                              )
                            ]),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Row(children: <Widget>[
                              Expanded(
                                child: Visibility(
                                  child: Text(
                                    jsonResult![index]['REQUEST_STATUS'] != null
                                        ? " " +
                                            jsonResult![index]['REQUEST_STATUS']
                                        : "",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: visibilityTag,
                                ),
                              )
                            ]),
                          ],
                        ),
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.all(2),
                      ),
                      Container(
                        height: 65.0,
                        child: Column(
                          children: <Widget>[
                            Row(children: <Widget>[
                              Expanded(
                                child: Visibility(
                                  child: Text(
                                    "Remarks",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: visibilityTag,
                                ),
                              )
                            ]),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: Visibility(
                                      child: Text(
                                        jsonResult![index]['REMARKS'] != null
                                            ? " " + jsonResult![index]['REMARKS']
                                            : "",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      visible: visibilityTag,
                                    ),
                                    /*Text(
                                            jsonResult[index]['REMARKS'] != null
                                                ? " " +
                                                jsonResult[index]['REMARKS']
                                                : "",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          )*/
                                  )
                                ]),
                          ],
                        ),
                        color: Colors.white,
                      ),
                    ]),
              ),
            ]),
          ),
        );
      },
    );
  }

  final snackbar = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Please Enter ID',
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white),
      ),
    ),
  );

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
}
