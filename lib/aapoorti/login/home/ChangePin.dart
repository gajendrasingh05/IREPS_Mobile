import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'UserHome.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class ChangePin extends StatefulWidget {
  @override
  _ChangePinState createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {
  var jsonResult = null;
  var errorcode = 0;
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);
  var email, opin, npin, rnpin;
  var _snackfoldtxt;
  void initState() {
    super.initState();
    _snackfoldtxt = "abc";
    email = AapoortiUtilities.user!.EMAIL_ID;
    debugPrint("init ==" + AapoortiConstants.loginUserEmailID);
  }


  static const platform = const MethodChannel('MyNativeChannel');
  String? ohashPassOutput, nhashPassOutput;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userType = "";

  Future<bool> _callLoginWebService(String email, String opin, String npin) async {
    try {
      var oinput = email + "#" + opin;
      //Commented for dart based encryption
      // var ohashPassInput = <String, String>{"input": oinput};
      // ohashPassOutput =
      // await platform.invokeMethod('getData', ohashPassInput);

      var bytes = utf8.encode(oinput);
      ohashPassOutput = sha256.convert(bytes).toString();
      debugPrint("hashPass = " + ohashPassOutput.toString());
    } on PlatformException catch (e) {
      debugPrint("Failed to get data from native : '${e.message}'.");
    }
    try {
      var ninput = email + "#" + npin;
      //Commented for dart based encryption
      // var nhashPassInput = <String, String>{"input": ninput};
      // nhashPassOutput =
      // await platform.invokeMethod('getData', nhashPassInput);

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
    //ctoken=AapoortiUtilities.user.C_TOKEN;

    //JSON VALUES FOR POST PARAM
    Map<String, dynamic> urlinput = {
      "userId": "$email",
      "pass": "$nhashPassOutput",
      "oldpass": "$ohashPassOutput",
      "cId": "$ctoken"
    };
    // var userinput1={"userId":"vdev@gmail.com","pass":"nLatDbjLGZkywYhA6cxdDqkDHDycKHvKwXBMrI0FPec=","oldpass":"xTDopCCaUsy6xt4cOtMRTOWaRV1O8u8Arvt281elo3o=","cId":"62860158858222445764"};
    debugPrint("input  " + urlinput.toString());
    String urlInputString = json.encode(urlinput);

    //NAME FOR POST PARAM
    String paramName = 'changePr';

    //Form Body For URL
    String formBody =
        paramName + '=' + Uri.encodeQueryComponent(urlInputString);

    var url = AapoortiConstants.webServiceUrl + 'Login/changePr';
    debugPrint("url = " + url);
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: formBody,
          encoding: Encoding.getByName("utf-8"));
      jsonResult = json.decode(response.body);
      debugPrint("form body = " + json.encode(formBody).toString());
      debugPrint("json result = " + jsonResult.toString());
      debugPrint("response code = " + response.statusCode.toString());

      if (response.statusCode == 200) {
        debugPrint(jsonResult[0]['ErrorCode'].toString());
        final dbHelper = DatabaseHelper.instance;
        AapoortiConstants.ans = "false";
        dbHelper.deleteLoginUser(1);
        dbHelper.deleteSaveLoginUser(1);
        if (jsonResult[0]['ErrorCode'] == null) {
          AapoortiUtilities.user!.C_TOKEN = ctoken;

          return true;
        } else
          return false;
      } else
        return false;
    } on Exception catch (e) {
      debugPrint("Failed to get data from native : '${e}'.");
      return false;
    }
  }

  GlobalKey _snackKey = GlobalKey<ScaffoldState>();

  Future<bool> validateAndLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        bool res = await _callLoginWebService(email, opin, rnpin);
        if(res) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    } else {
      // Form is not valid
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            resizeToAvoidBottomInset: false,
            key: _snackKey,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.white, //change your color here
              ),
              title: Text('Login', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.teal,
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: Colors.grey.shade100),
              child: Center(
                child: SingleChildScrollView(
                  child: Builder(
                    builder: (context) => Center(
                        child: Form(
                            key: _formKey,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(26.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Card(
                                      elevation: 5.0,
                                      color: Colors.white,
                                      surfaceTintColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 0.0, color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            SizedBox(height: 40.0),
                                            TextFormField(
                                              enabled: false,
                                              initialValue:
                                                  email != "" ? email : null,
                                              validator: (value) {
                                                bool emailValid = RegExp(
                                                        r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                    .hasMatch(value!);
                                                if (value.isEmpty) {
                                                  return ('Please enter valid Email-ID');
                                                } else if (!emailValid) {
                                                  return ('Please enter valid Email-ID');
                                                }
                                                return "";
                                              },
                                              onSaved: (value) {},
                                              style: style,
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Enter Registered Email ID",
                                                icon: Icon(
                                                  Icons.account_box,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 40.0),
                                            TextFormField(
                                              initialValue: null,
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (pin) {
                                                if (pin!.isEmpty) {
                                                  return ('Please enter 6-12 digit PIN');
                                                } else if (pin.length < 6 ||
                                                    pin.length > 12) {
                                                  return ('Please enter 6-12 digit PIN');
                                                }
                                                return "";
                                              },
                                              onSaved: (value) {
                                                opin = value;
                                              },
                                              obscureText: true,
                                              style: style,
                                              decoration: InputDecoration(
//                                        contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                                                hintText: "Enter Old Pin",
                                                icon: Icon(
                                                  Icons.lock,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: 40.0),
                                            TextFormField(
                                              initialValue: null,
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (pin) {
                                                if (pin!.isEmpty) {
                                                  return ('Please enter 6-12 digit PIN');
                                                } else if (pin.length < 6 ||
                                                    pin.length > 12) {
                                                  return ('Please enter 6-12 digit PIN');
                                                }
                                                return "";
                                              },
                                              onSaved: (value) {
                                                npin = value;
                                              },
                                              obscureText: true,
                                              style: style,
                                              decoration: InputDecoration(
                                                hintText: "Enter New Pin",
                                                icon: Icon(
                                                  Icons.lock,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 40.0),
                                            TextFormField(
                                              initialValue: null,
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (pin) {
                                                if (pin!.isEmpty) {
                                                  return ('Please enter 6-12 digit PIN');
                                                } else if (pin.length < 6 ||
                                                    pin.length > 12) {
                                                  return ('Please enter 6-12 digit PIN');
                                                }
                                                return "";
                                              },
                                              onSaved: (value) {
                                                rnpin = value;
                                              },
                                              obscureText: true,
                                              style: style,
                                              decoration: InputDecoration(
                                                hintText: "Confirm New Pin",
                                                icon: Icon(
                                                  Icons.lock,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 40.0,
                                            ),

                                            SizedBox(
                                              height: 40,
                                              child: Container(
                                                decoration: new BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
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
                                                  minWidth: 250,
                                                  height: 20,
                                                  padding: EdgeInsets.fromLTRB(
                                                      25.0, 5.0, 25.0, 5.0),
                                                  onPressed: () async {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    _formKey.currentState!.save();
                                                    if (npin != rnpin) {
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(
                                                              snackbar1);
                                                    } else {
                                                      ProgressDialog pr =
                                                          new ProgressDialog(
                                                              context);
                                                      AapoortiUtilities
                                                          .getProgressDialog(
                                                              pr);

                                                      bool check =
                                                          await validateAndLogin();
                                                      AapoortiUtilities
                                                          .stopProgress(pr);
                                                      if (check == true) {
                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(
                                                                snackbar);
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 2),
                                                            () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      } else
                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(
                                                                snackbar1);
                                                    }
                                                    // ProgressIndicator  pr=new CircularProgressIndicator();
                                                  },
                                                  child: Text("Submit",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: style.copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18)),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),

                                            SizedBox(
                                              height: 40,
                                              child: Container(
                                                decoration: new BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
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
                                                  minWidth: 250,
                                                  height: 20,
                                                  padding: EdgeInsets.fromLTRB(
                                                      25.0, 5.0, 25.0, 5.0),
                                                  onPressed: () {
                                                    _formKey.currentState!.reset();
                                                    setState(() {
                                                      _formKey.currentState!.reset();
                                                    });
                                                  },
                                                  child: Text("Reset",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: style.copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18)),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 50.0,
                                            // ),
                                          ],
                                        ),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            ))),
                  ),
                ),
              ),
            )

            // ),
            );
  }

  final snackbar = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Pin Changed Successfully',
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
  final snackbar1 = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Invalid Credentials',
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 15, color: Colors.teal),
      ),
    ),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  var bodyProgress = Container(
    child: Stack(
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
                  child: new Center(
                    child: new Text(
                      "Please wait...",
                      style: new TextStyle(color: Colors.white),
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
