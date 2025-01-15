import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/widgets/bottom_Nav/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

class UdmChangePin extends StatefulWidget {
  static const routeName = "/changePin-screen";
  @override
  _UdmChangePinState createState() => _UdmChangePinState();
}

class _UdmChangePinState extends State<UdmChangePin> {
  dynamic jsonResult = null;
  var errorcode = 0;
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);
  var email, opin, npin, rnpin;
  var _snackfoldtxt;
  TextEditingController? _controller;
  void initState() {
    super.initState();
    getSharedPrefs();
    //email=LoginProvider().user.emailid;
    _snackfoldtxt = "abc";
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email");
    setState(() {
      _controller = new TextEditingController(text: email);
    });
  }

// ----------------------------------------- Done by Gurmeet for Login Starts
  static const platform = const MethodChannel('MyNativeChannel');
  late String ohashPassOutput, nhashPassOutput;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userType = "";

  // ----------------------------------------- Done by Gurmeet for Login Start

  Future<dynamic> _callLoginWebService(String email, String opin, String npin) async {
    debugPrint('Function called ' + email.toString() + "-------" + opin.toString());
    try {
      var oinput = email + "#" + opin;
      var bytes = utf8.encode(oinput);
      ohashPassOutput = sha256.convert(bytes).toString();
      debugPrint("hashPass = " + ohashPassOutput.toString());
    } on PlatformException catch (e) {
      debugPrint("Failed to get data from native : '${e.message}'.");
    }
    try {
      var ninput = email + "#" + npin;
      var bytes = utf8.encode(ninput);
      nhashPassOutput = sha256.convert(bytes).toString();

      debugPrint("hashPass = " + nhashPassOutput.toString());
    } on PlatformException catch (e) {
      debugPrint("Failed to get data from native : '${e.message}'.");
    }
    var random = Random.secure();
    String ctoken = random.nextInt(100).toString();

    for (var i = 1; i < 10; i++) {
      ctoken = ctoken + random.nextInt(100).toString();
    }
    ctoken = ctoken + random.nextInt(10).toString();
    Map<String, dynamic> urlinput = {
      "input_type": "UdmChangePin",
      "input": email + '~' + nhashPassOutput + '~' + ohashPassOutput + '~' + ctoken,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var userinput1={"userId":"vdev@gmail.com","pass":"nLatDbjLGZkywYhA6cxdDqkDHDycKHvKwXBMrI0FPec=","oldpass":"xTDopCCaUsy6xt4cOtMRTOWaRV1O8u8Arvt281elo3o=","cId":"62860158858222445764"};
    debugPrint("input  " + urlinput.toString());
    String urlInputString = json.encode(urlinput);
    try {
      var response = await Network.postDataWithAPIM('UDM/UdmAppLogin/V1.0.0/UdmAppLogin','UdmChangePin', email + '~' + nhashPassOutput + '~' + ohashPassOutput + '~' + ctoken ,prefs.getString('token'));
      jsonResult = json.decode(response.body);
      debugPrint("json result = " + jsonResult.toString());
      debugPrint("response code = " + response.statusCode.toString());
      if(response.statusCode == 200) {
        IRUDMConstants.removeProgressIndicator(context);
        IRUDMConstants.ans = "false";
        if(jsonResult['status'] == 'OK') {
          _showVersionDDialog(context);
          // IRUDMConstants().showSnack('data', context);
          return true;
        } else
          return false;
      } else {
        IRUDMConstants.removeProgressIndicator(context);
        return false;
      }
    } on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
  }

  GlobalKey _snackKey = GlobalKey<ScaffoldState>();

  Future<dynamic> validateAndLogin() async {
    var res;
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      email = prefs.get('email');
      IRUDMConstants.showProgressIndicator(context);
      res = await _callLoginWebService(email, opin, rnpin);
      if(res == true) {
        debugPrint("response succesful");
        return true;
      } else {
        debugPrint("response not succesful");
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      key: _snackKey,
      appBar: AppBar(
        title: Text(language.text('changePin'),
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.red[300],
      ),
      //bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.0, color: Colors.red.shade300),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 5.0),
                          TextFormField(
                            enabled: false,
                            controller: _controller,
                            onSaved: (value) {},
                            style: style,
                            decoration: InputDecoration(
                              hintText: "Enter Registered Email ID",
                              icon: Icon(
                                Icons.account_circle_sharp,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.0, color: Colors.red.shade300),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 5.0),
                          TextFormField(
                            initialValue: null,
                            keyboardType: TextInputType.number,
                            validator: (pin) {
                              if (pin!.isEmpty) {
                                return language.text('pinLengthError');
                              } else if (pin.length < 6 || pin.length > 12) {
                                return language.text('pinLengthError');
                              }
                              return null;
                            },
                            onSaved: (value) {
                              opin = value;
                            },
                            obscureText: true,
                            style: style,
                            decoration: InputDecoration(
                              hintText: language.text('enterOldPin'),
                              labelText: language.text('enterOldPin'),
                              contentPadding: EdgeInsetsDirectional.all(10),
                              border: const OutlineInputBorder(),
                              icon: Icon(
                                Icons.lock_outline_sharp,
                                color: Colors.yellow[500],
                              ),
                            ),
                          ),
                          SizedBox(height: 25.0),
                          TextFormField(
                            initialValue: null,
                            keyboardType: TextInputType.number,
                            validator: (pin) {
                              if (pin == null || pin.isEmpty) {
                                return language.text('pinLengthError');
                              } else if (pin.length < 6 || pin.length > 12) {
                                return language.text('pinLengthError');
                              }
                            },
                            onSaved: (value) {
                              npin = value;
                            },
                            obscureText: true,
                            style: style,
                            decoration: InputDecoration(
                              hintText: language.text('enterNewPin'),
                              labelText: language.text('enterNewPin'),
                              contentPadding: EdgeInsetsDirectional.all(10),
                              border: const OutlineInputBorder(),
                              icon: Icon(
                                Icons.lock,
                                color: Colors.green[400],
                              ),
                            ),
                          ),
                          SizedBox(height: 25.0),
                          TextFormField(
                            initialValue: null,
                            keyboardType: TextInputType.number,
                            validator: (pin) {
                              if (pin == null || pin.isEmpty) {
                                return language.text('pinLengthError');
                              } else if (pin.length < 6 || pin.length > 12) {
                                return language.text('pinLengthError');
                              }
                            },
                            onSaved: (value) {
                              rnpin = value;
                            },
                            obscureText: true,
                            style: style,
                            decoration: InputDecoration(
                              hintText: language.text('confirmPin'),
                              labelText: language.text('confirmPin'),
                              contentPadding: EdgeInsetsDirectional.all(10),
                              border: const OutlineInputBorder(),
                              icon: Icon(
                                Icons.lock,
                                color: Colors.green[800],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                      width: size.width,
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton (
                              height: 45,
                              minWidth: size.width * 0.40,
                              child: Text(language.text('nsdsubmit')),
                              shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                              onPressed: () async{
                                FocusScope.of(context).unfocus();
                                _formKey.currentState!.save();
                                if (npin != rnpin) {
                                  ScaffoldMessenger.of(context).showSnackBar(snackbar1);
                                } else {
                                  bool check = await validateAndLogin();
                                  if (check == true) {
                                    _showVersionDDialog(context);
                                  }
                                }
                              }, color: Colors.blue, textColor: Colors.white),
                          MaterialButton (
                              height: 45,
                              minWidth: size.width * 0.40,
                              child: Text(language.text('reset')),
                              shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                              onPressed: () {
                                _formKey.currentState!.reset();
                                setState(() {
                                  _formKey.currentState!.reset();
                                });
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandDataSummaryScreen(fromdate, todate, rlycode, unittypecode, unitnamecode, departmentcode, consigneecode, indentorcode)));
                              }, color: Colors.red, textColor: Colors.white),
                        ],
                      )
                  )

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SizedBox(
                  //       height: 40,
                  //       child: Container(
                  //         height: 40.0,
                  //         width: 150.0,
                  //         decoration: BoxDecoration(
                  //           color: Colors.red.shade500
                  //         ),
                  //         child: OutlinedButton(
                  //           style: ButtonStyle(
                  //               backgroundColor:
                  //                   MaterialStateProperty.resolveWith(
                  //                       (color) => Colors.white),
                  //               shape: MaterialStateProperty.all(
                  //                   RoundedRectangleBorder(
                  //                       borderRadius:
                  //                           BorderRadius.circular(200.0))),
                  //               elevation: MaterialStateProperty.all(7.0),
                  //               side: MaterialStateProperty.all(BorderSide(
                  //                   color: Colors.red[300]!, width: 2.0))),
                  //           onPressed: () {
                  //             _formKey.currentState!.reset();
                  //             setState(() {
                  //               _formKey.currentState!.reset();
                  //             });
                  //           },
                  //
                  //           child: Text(
                  //             language.text('reset'),
                  //             textAlign: TextAlign.center,
                  //             style: style.copyWith(
                  //                 color: Colors.red[300],
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 18),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     // SizedBox(width: 20.0),
                  //     SizedBox(
                  //       height: 40,
                  //       child: Container(
                  //         height: 40.0,
                  //         width: 150.0,
                  //         child: OutlinedButton(
                  //           style: ButtonStyle(
                  //               backgroundColor:
                  //                   MaterialStateProperty.resolveWith(
                  //                       (color) => Colors.white),
                  //               shape: MaterialStateProperty.all(
                  //                   RoundedRectangleBorder(
                  //                       borderRadius:
                  //                           BorderRadius.circular(200.0))),
                  //               //overlayColor: MaterialStateProperty.resolveWith((color) => Colors.red[300])
                  //               elevation: MaterialStateProperty.all(7.0),
                  //               side: MaterialStateProperty.all(BorderSide(
                  //                   color: Colors.red[300]!, width: 2.0))),
                  //           onPressed: () async {
                  //             FocusScope.of(context).unfocus();
                  //             _formKey.currentState!.save();
                  //
                  //             if (npin != rnpin) {
                  //               ScaffoldMessenger.of(context).showSnackBar(snackbar1);
                  //             } else {
                  //               bool check = await validateAndLogin();
                  //               if (check == true) {
                  //                 _showVersionDDialog(context);
                  //               }
                  //             }
                  //             // ProgressIndicator  pr=new CircularProgressIndicator();
                  //           },
                  //           child: Text(
                  //             language.text('submit'),
                  //             textAlign: TextAlign.center,
                  //             style: style.copyWith(
                  //                 color: Colors.red[300],
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 18),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showVersionDDialog(context) async {
    final dbHelper = DatabaseHelper.instance;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String message = "PIN Changed Successfully.";
        String btnLabel = "Okay";
        return Platform.isIOS
            ? CupertinoAlertDialog(
                content: Text(message),
                actions: <Widget>[
                  MaterialButton(
                      child: Text(btnLabel),
                      onPressed: () {
                        dbHelper.deleteSaveLoginUser();

                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              ModalRoute.withName("/Login"));
                        });
                      }),
                ],
              )
            : AlertDialog(
                content: Text(message),
                actions: <Widget>[
                  MaterialButton(
                      child: Text(btnLabel),
                      onPressed: () {
                        dbHelper.deleteSaveLoginUser();
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              ModalRoute.withName("/Login"));
                        });
                      }),
                ],
              );
      },
    );
  }

  final snackbar = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Pin Changed Successfully',
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white),
      ),
    ),
  );
  final snackbar1 = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Invalid Credentials',
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 15, color: Colors.white),
      ),
    ),
  );
  var bodyProgress = Container(
    child: new Stack(
      children: <Widget>[
        Container(
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
            color: Colors.white70,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(10.0)),
            width: 300.0,
            height: 200.0,
            alignment: AlignmentDirectional.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: CircularProgressIndicator(
                      value: null,
                      strokeWidth: 7.0,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      "loading.. wait...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
