import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';

import 'package:flutter_app/aapoorti/home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Vendor_Registration_helpdesk1 extends StatefulWidget {
  Vendor_Registration_helpdesk1() : super();

  final String title = "DropDown Demo";

  @override
  Vendor_Registration_helpdeskState createState() =>
      Vendor_Registration_helpdeskState();
}

class Vendor_Registration_helpdeskState
    extends State<Vendor_Registration_helpdesk1> {
  late String content;
  late String id;
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);

  List<dynamic>? jsonResult;
  List<dynamic>? jsonResult1;
  late List<dynamic> jsonFinalResult;
  late String _mySelection, myselection1;
  TextEditingController myController = TextEditingController();

  var index = 0;

  void _onClear() {
    print('calling');

    myController.text = "";

    content = "";

    setState(() {
      myController.text = "";
      content = "";

      //   _mySelection= 1.toString();
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  bool visibilityTag = false;
  int counter = 0;
  bool visibilityyes = false;
  bool visibilityno = false;

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "tag") {
        visibilityTag = visibility;
      }
    });
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  List data = [];
  List data1 = [];
  String req_status = "";
  String remark = "";
  String status_value = "";
  String remark_value = "";

  Future<void> fetchPost() async {
    debugPrint('Fetching from service first spinner');
    var u = AapoortiConstants.webServiceUrl +
        'HD/vendorRegnStatus?REQ_ID=${this.content}';
    debugPrint("url----" + u);

    final response1 = await http.post(Uri.parse(u));

    jsonResult1 = json.decode(response1.body);

    if (jsonResult1![0]['ErrorCode'] == 3) {
      jsonResult1 = null;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog<String>(
          context: context,
          builder: (context) {
            String contentText = "Content of Dialog";
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  content: Container(
                    child: Text(
                      'Invalid Request ID',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            );
          },
        );
      });
      // status_value=remark_value="Invalid Request ID";

    } else if (jsonResult1![0]['ErrorCode'] == 4) {
      jsonResult1 = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoData()));
    } else {
      debugPrint("jsonresult1===");
      debugPrint(jsonResult1.toString());
      req_status = "Your request number " +
          content +
          " has been " +
          jsonResult1![0]['REQUEST_STATUS'].toString();
      remark = "Remark: " + jsonResult1![0]['REMARKS'].toString();

      status_value = req_status;
      remark_value = remark;

      setState(() {
        data = jsonResult1!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  String? validateName(String? value) {
    if (value!.length < 3)
      return 'Enter Request ID';
    else
      return null;
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
                  Icon(Icons.assignment),
                  Padding(padding: EdgeInsets.only(left: 10.0)),
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Enter Request ID'),
                      keyboardType: TextInputType.text,
                      validator: validateName,
                      controller: myController,
                      onEditingComplete: () {
                        content = myController.text;
                      },
                      onSaved: (String? val) {
                        content = val!;
                        print(val);
                      },
                    ),
                  ),
                ],
              ),
            ],
          )),
      margin: EdgeInsets.all(20.0),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "my APP",
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          // //resizeToAvoidBottomPadding: true,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.cyan[400],
            title: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 1.0)),
                IconButton(
                  alignment: Alignment.centerLeft,
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(padding: EdgeInsets.only(left: 15.0)),
                Text('Vendor registration Status',
                    style: TextStyle(color: Colors.white)),
                Padding(padding: EdgeInsets.only(left: 10)),
              ],
            ),
          ),

          //backgroundColor: Colors.black,

          body: Builder(
              builder: (context) => Material(
                    //  color: Colors.blue[50],
                    child: Container(
                      //color: Colors.blue[50],
                      child: Column(
                        children: <Widget>[
                          TopSection,
                          Padding(padding: EdgeInsets.only(top: 10.0)),
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
                              'Get Status',
                              textAlign: TextAlign.center,
                              style: style.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            onPressed: () {
                              if (content != null) {
                                print("button not pressed");

                                print("printing......");
                                print("Content==>" + content);
                                //  content.trim();

                                fetchPost();
                                _changed(true, "tag");
                              } else {
                                print("aa");
                                //Scaffold.of(context).showSnackBar(snackbar);
                              }
                              checkvalue();
                            },
                            color: Colors.cyan.shade400,
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  new Text(
                                    status_value,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                  child: new Text(
                                remark_value,
                                style: TextStyle(color: Colors.black),
                              ))
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
        ));
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
}
