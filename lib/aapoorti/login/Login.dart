import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/NoConnection.dart';

import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'home/UserHome.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_app/udm/screens/login_screen.dart';
import 'package:crypto/crypto.dart';

class LoginActivity extends StatefulWidget {
  String logoutsucc;
  final GlobalKey<ScaffoldState> _scaffoldkey;
  LoginActivity(this._scaffoldkey, this.logoutsucc);

  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  var jsonResult = null;
  var errorcode = 0;
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);
  var email, pin;
  var connectivityresult;
  ProgressDialog? pr;
  bool? _check;
  bool value1 = true;
  bool _check1 = false;
  String? checkbox;
  BuildContext? context1;
  String? logoutsucc;

  bool visibilty = false;

  String? selectedValue = 'IREPS';

  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        logoutsucc = widget.logoutsucc;

        pr = ProgressDialog(context);
        debugPrint('logoutsucc' + widget.logoutsucc);
        debugPrint("init ==" + AapoortiConstants.loginUserEmailID);

        //if (AapoortiUtilities.loginflag == false) showDialogBox(context);
      });
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void showDialogBox(BuildContext context1) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        barrierDismissible: false,
        context: context1,
        builder: (BuildContext context) => AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height * 0.32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                    "For better experience to users, login on APP is allowed using Email ID & PIN.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Text(
                  "Please visit www.ireps.gov.in to create/reset your PIN and then try to login using Email ID and PIN.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Text(
                  "If successfully logged in using Email ID & PIN, please ignore this.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Colors.blue,
              child: Text(
                "OKAY",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    });
  }


  static const platform = const MethodChannel('MyNativeChannel');
  String? hashPassOutput;
  String? hash2;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final GlobalKey<ScaffoldState> _scaffoldkey=new GlobalKey<ScaffoldState>();
  String userType = "";

  Future<bool> _callLoginWebService(String email, String pin) async {
    debugPrint('Function called ' + email.toString() + "-------" + pin.toString());
    try {
      var input = email + "#" + pin;
      debugPrint(input);
      var hashPassInput = <String, String>{"input": input};
      //hashPassOutput = await platform.invokeMethod('getData', hashPassInput);
      // AapoortiConstants.hash=hashPassOutput.toString();
      //print("hashPass = " + hashPassOutput.toString());
      var bytes = utf8.encode(input);
      hash2 = sha256.convert(bytes).toString();
      debugPrint(hash2);
      AapoortiConstants.hash = '' + "~" + hash2!;
    } on PlatformException catch (e) {
      debugPrint("Failed to get data from native : '${e.message}'.");
    }
    var random = Random.secure();
    String ctoken = random.nextInt(100).toString();

    for (var i = 1; i < 10; i++) {
      ctoken = ctoken + random.nextInt(100).toString();
    }

    //JSON VALUES FOR POST PARAM
    Map<String, dynamic> urlinput = {
      "userId": "$email",
      "pass": "" + "~$hash2",
      "cToken": "$ctoken",
      "sToken": "",
      "os": "Flutter~ios",
      "token4": "",
      "token5": ""
    };
    // Map<String, dynamic>  urlinput = {"userId":"$email","pass":"$hashPassOutput","cToken":"$ctoken","sToken":"","os":"Flutter","token4":"","token5":""};

    String urlInputString = json.encode(urlinput);
    debugPrint(urlinput.toString());

    //NAME FOR POST PARAM
    String paramName = 'UserLogin';

    //Form Body For URL
    String formBody = paramName + '=' + Uri.encodeQueryComponent(urlInputString);

    var url = AapoortiConstants.webServiceUrl + 'Login/UserLogin';

    debugPrint("url = " + url);

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

    AapoortiUtilities.stopProgress(pr!);
    if(response.statusCode == 200) {
      debugPrint("Error code "+jsonResult[0]['ErrorCode'].toString());
      if (jsonResult[0]['ErrorCode'] == null) {
        AapoortiUtilities.setUserDetails(jsonResult); //To save user details in shared object
        userType = jsonResult[0]['USER_TYPE'].toString();
        return true;
      } else
        return false;
    } else
      return false;
  }

  void validateAndLogin() async {
    var res;
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AapoortiUtilities.getProgressDialog(pr!);
      _check = await _callLoginWebService(email, pin);
      res = _check;
      debugPrint("res return ${res.toString()}");
      if(res == true) {
        debugPrint("res return1 ${res.toString()}");
        _check = true;
        AapoortiUtilities.loggedin = false;
        Navigator.pop(context);


        AapoortiConstants.ans = "true";
        if(_check1 == true) checkbox = "true";
        else checkbox = "false";
        AapoortiConstants.check = checkbox!;
        AapoortiConstants.date = DateTime.now().add(Duration(days: 5)).toString();
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserHome(userType, email)));
        // if(Navigator.canPop(context))
        //   debugPrint("res return2 ${res.toString()}");
        //   Navigator.of(context).pop();
        //   Navigator.push(context, MaterialPageRoute(builder: (context) => UserHome(userType, email)));
      } else {
        debugPrint("res return3 ${res.toString()}");
        AapoortiUtilities.stopProgress(pr!);
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(color: Colors.grey.shade100),
      child: Center(child: SingleChildScrollView(child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 15.0),
                              if(AapoortiUtilities.logoutBanner)AapoortiUtilities.customTextView(logoutsucc != null ? logoutsucc! : '', Colors.red),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Text("Indian Railways e-procurement System(IREPS)", textAlign: TextAlign.center, style: TextStyle(color: Colors.cyan[400], fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(height: 20.0),
                              Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Center the radio buttons
                              children: [
                                RadioOption(
                                  value: 'IREPS',
                                  groupValue: selectedValue,
                                  onChanged: (String? newValue) {
                                    //Navigator.push(context,MaterialPageRoute(builder: (context) => LoginActivity()));
                                    // setState(() {
                                    //   selectedValue = newValue;
                                    // });
                                  },
                                  label: 'IREPS',
                                ),
                                SizedBox(width: 25.0),
                                RadioOption(
                                  value: 'UDM',
                                  groupValue: selectedValue,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedValue = newValue;
                                    });
                                    Navigator.pushNamed(context, LoginScreen.routeName);
                                  },
                                  label: 'UDM',
                                ),
                                // Radio button for "Cris MMIS"
                                // RadioOption(
                                //   value: 'Cris MMIS',
                                //   groupValue: selectedValue,
                                //   onChanged: (String? newValue) {
                                //     setState(() {
                                //       selectedValue = newValue;
                                //     });
                                //   },
                                //   label: 'Cris MMIS',
                                // ),
                                ]),
                              SizedBox(height: 10),
                              //SizedBox(height: 30.0),
                              TextFormField(
                                initialValue: AapoortiConstants.loginUserEmailID != "" ? AapoortiConstants.loginUserEmailID : null,
                                validator: (value) {
                                  // bool emailValid = RegExp("^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                                  bool emailValid = RegExp(
                                      "^[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\.[A-Za-z0-9]+)*(\.[A-Za-z]{2,})\$")
                                      .hasMatch(value!.trim());
                                  if (value.isEmpty) {
                                    return ('Please enter valid Email-ID');
                                  } else if (!emailValid) {
                                    return ('Please enter valid Email-ID');
                                  }
                                },
                                onSaved: (value) {
                                  email = value!.trim();
                                },
                                style: style,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                  prefixIcon: Icon(Icons.mail),
                                  focusColor: Colors.red.shade800,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey.shade800, width: 1.0),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey.shade800, width: 1.0),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey.shade800, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  labelText: 'User ID' + '/' + 'Email ID',
                                  labelStyle: TextStyle(fontSize: 15.0),
                                  hintText: "Enter Registered Email ID",
                                  // icon: Icon(
                                  //   Icons.mail,
                                  //   color: Colors.black,
                                  // ),
                                ),
                              ),
                              SizedBox(height: 35.0),
                              TextFormField(
                                initialValue: null,
                                keyboardType: TextInputType.number,
                                validator: (pin) {
                                  if (pin!.isEmpty) {
                                    return ('Please enter 6-12 digit PIN');
                                  } else if (pin.length < 6 || pin.length > 12) {
                                    return ('Please enter 6-12 digit PIN');
                                  }
                                },
                                onSaved: (value) {
                                  pin = value;
                                },
                                obscureText: visibilty,
                                style: style,
                                decoration: InputDecoration(
                                 contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                  hintText: "Enter PIN",
                                  labelText: 'Enter PIN',
                                  prefixIcon: Icon(Icons.vpn_key),
                                  suffixIcon: InkWell(
                                    onTap: (){
                                      if(visibilty == true){
                                        setState(() {
                                           visibilty = false;
                                        });
                                      }
                                      else{
                                        setState(() {
                                           visibilty = true;
                                        });
                                      }
                                    },
                                    child: visibilty == true ? Icon(Icons.visibility_rounded) : Icon(Icons.visibility_off),
                                  ),
                                  labelStyle: TextStyle(fontSize: 15),
                                  focusColor: Colors.red.shade800,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey.shade800, width: 1.0),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey.shade800, width: 1.0),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey.shade800, width: 1.0),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Padding(padding: EdgeInsets.only(left: 3)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Checkbox(
                                              value: _check1,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  _check1 = value!;
                                                });
                                              })
                                        ],
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 3)),
                                      InkWell(
                                        child:
                                        Text("Save Login Credentials for 5 days "),
                                        onTap: () {
                                          onChanged(value1);
                                          value1 = !value1;
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 60,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
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
                                    minWidth: 350,
                                    height: 60,
                                    padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      try {
                                        connectivityresult = await InternetAddress.lookup('google.com');
                                        if (connectivityresult != null) {
                                          validateAndLogin();
                                        }
                                      } on SocketException catch (_) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NoConnection()));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "You are not connected to the internet!"),
                                          duration: const Duration(seconds: 1),
                                          backgroundColor: Colors.red[800],
                                        ));
                                      }
                                    },
                                    child: Text("Login",
                                        textAlign: TextAlign.center,
                                        style: style.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              InkWell(
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'How to ',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.teal[900],
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'enable login ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.underline,
                                              color: Colors.teal[900],
                                            )),
                                        TextSpan(text: 'access for IREPS App?'),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    _enableloginBottomSheet(context);
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                                  }),
                              SizedBox(
                                height: 20.0,
                              ),
                              InkWell(
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'How to ',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.teal[900],
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'reset PIN? ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.underline,
                                              color: Colors.teal[900],
                                            )),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    _resetpinBottomSheet(context);
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPIN()));
                                  }),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
      ))),
      // ),
    );
  }

  onChanged(value1) {
    debugPrint(value1);
    setState(() {
      _check1 = value1;
      debugPrint(value1);
    });
  }

  final snackbar = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Invalid Credentials!',
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white),
      ),
    ),
    duration: Duration(seconds: 2),
  );

  final snackbar1 = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text('Internet not available', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white)),
    ),
    duration: Duration(seconds: 2),
  );

  Future<Widget> _enableloginBottomSheet(BuildContext context) async {
    return await showModalBottomSheet(
        context: context,
        constraints:
        BoxConstraints.loose(Size(MediaQuery.of(context).size.width, 400)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        clipBehavior: Clip.hardEdge,
        builder: (_) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12.0)),
                        alignment: Alignment.center,
                        child: Icon(Icons.clear, size: 15, color: Colors.white),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            " Note: ",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.red),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 5.0)),
                          Expanded(
                              child: Text(
                                  "1. Login feature is available to users already \n    registered in IREPS.",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  ))),
                          Padding(padding: EdgeInsets.only(left: 20.0)),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 5.0)),
                          Text(
                              "2. Login feature is available on Mobile App for:\n",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                              padding:
                              EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 10.0)),
                          //Padding(padding: new EdgeInsets.only(top:1.0)),
                          RichText(
                            text: TextSpan(
                              text: 'Vendor',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.blueGrey,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                    '                              Launched',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[500],
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                              padding:
                              EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 10.0)),
                          RichText(
                            text: TextSpan(
                              text: 'Railway User(Tender)',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.blueGrey,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '     Launched',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[500],
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Row(
                      //   children: <Widget>[
                      //     Padding(padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 10.0)),
                      //     RichText(
                      //       text: TextSpan(
                      //         text: 'Bidder',
                      //         style: TextStyle(fontSize:15.0,color: Colors.blueGrey,),
                      //         children: <TextSpan>[
                      //           TextSpan(
                      //               text: '                               Coming Soon',
                      //               style: TextStyle(color: Colors.redAccent,)
                      //           ),
                      //         ],
                      //       ),
                      //     ),/*//Padding(padding: new EdgeInsets.only(top:1.0)),
                      //       Text("Bidder",style: TextStyle(fontSize:15.0,color: Colors.blueGrey,)),*/
                      //   ],
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(8.0)),
                      Row(
                        children: <Widget>[
                          Text(
                            "   To enable Login access for IREPS: ",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      //new Padding(padding: new EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 30.0)),
                          Text("1. Login to www.ireps.gov.in",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.blueGrey,
                              )),
                          Padding(padding: EdgeInsets.only(left: 35.0)),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 30.0)),
                          Text(
                              "2. Go to link on the right navigation (Enable\n    MobileApp Access for IREPS)",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.blueGrey,
                              )),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 30.0)),
                          Text("3. Complete the process.",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.blueGrey,
                              )),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<Widget> _resetpinBottomSheet(BuildContext context) async {
    return await showModalBottomSheet(
        context: context,
        constraints:
        BoxConstraints.loose(Size(MediaQuery.of(context).size.width, 200)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        clipBehavior: Clip.hardEdge,
        builder: (_) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("To reset PIN for IREPS: ",
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.normal)),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12.0)),
                            alignment: Alignment.center,
                            child: Icon(Icons.clear,
                                size: 15, color: Colors.white),
                          ))
                    ],
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                  Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      Text("1. Login to www.ireps.gov.in",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.blueGrey,
                          )),
                      Padding(padding: EdgeInsets.only(left: 35.0)),
                    ],
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                  Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      Text(
                          "2. Go to link on the right navigation (Enable\n    MobileApp Access for IREPS)",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.blueGrey,
                          )),
                    ],
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                  Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      Expanded(
                          child: Text(
                              "3. Select RESET PIN and complete the process.",
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.blueGrey))),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

}

class RadioOption extends StatelessWidget {
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;
  final String label;

  const RadioOption({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          activeColor: label == 'IREPS' ? Colors.cyan[400] : Colors.red.shade300,
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }
}
