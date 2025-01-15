import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/CommonScreen.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/providers/change_visibility_provider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/widgets/switch_language_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/error.dart';
import '../helpers/shared_data.dart';
import '../providers/loginProvider.dart';
import '../providers/versionProvider.dart';
import '../widgets/checkbox.dart';
import '../widgets/dailog.dart';
import '../widgets/sigin_button.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login-screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoginSaved = false;

  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);
  var email= '11', pin;
  var connectivityresult;

  String? selectedValue = 'UDM';

  bool value1 = true;
  Map<String, String> versionResult = {};

  String? checkbox;
  BuildContext? context1;
  String? logoutsucc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailFieldController = TextEditingController();
  final TextEditingController _passwdFieldController = TextEditingController();

  Error? _error;

  var appStoreUrl = 'https://apps.apple.com/in/app/ireps/id1462024189';

  var playStoreUrl = 'https://play.google.com/store/apps/details?id=in.gov.ireps';

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      Provider.of<LoginProvider>(context, listen: false).setState(LoginState.Idle);
      checkVersion();
    });
  }

  void checkVersion() async {
    try {
      Uri default_url = Uri.parse(IRUDMConstants.downTimeUrl);
      var response = await http.get(default_url);
      await fetchToken(context);
      await Provider.of<VersionProvider>(context, listen: false).fetchVersion(context);
      _error = Provider.of<VersionProvider>(context, listen: false).error;
      if(_error!.title == "Exception") {
        Timer.run(() => showDialog(
            context: context,
            builder: (_) => CommonDailog(
              title: _error!.title,
              contentText: _error!.description,
              type: 'Exception',
              action: action,
            )));
      }
      else if(_error!.title.contains("Error")) {
        Timer.run(() => showDialog(
            context: context,
            builder: (_) => CommonDailog(
              title: _error!.title,
              contentText: _error!.description,
              type: 'Error',
              action: action,
            )));
      }
      // else if(_error!.title.contains("Update")) {
      //   Timer.run(() => showDialog(
      //       context: context,
      //       builder: (_) => CommonDailog(
      //         title: _error!.title,
      //         contentText: _error!.description,
      //         type: 'Error',
      //         action: action,
      //       )));
      // }
      else if(_error!.title.contains('title2')) {
        Provider.of<LoginProvider>(context, listen: false).autologin(context);
      }
      // if(response.statusCode == 200) {
      //   Navigator.pop(context);
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => PdfView(IRUDMConstants.downTimeUrl)));
      // } else {
      //    await Provider.of<VersionProvider>(context, listen: false).fetchVersion(context);
      //   _error = Provider.of<VersionProvider>(context, listen: false).error;
      //   if(_error!.title == "Exception") {
      //     Timer.run(() => showDialog(
      //         context: context,
      //         builder: (_) => CommonDailog(
      //               title: _error!.title,
      //               contentText: _error!.description,
      //               type: 'Exception',
      //               action: action,
      //             )));
      //   }
      //   else if(_error!.title.contains("Error")) {
      //     Timer.run(() => showDialog(
      //         context: context,
      //         builder: (_) => CommonDailog(
      //               title: _error!.title,
      //               contentText: _error!.description,
      //               type: 'Error',
      //               action: action,
      //             )));
      //   }
      //   else if(_error!.title.contains("Update")) {
      //     Timer.run(() => showDialog(
      //         context: context,
      //         builder: (_) => CommonDailog(
      //               title: _error!.title,
      //               contentText: _error!.description,
      //               type: 'Error',
      //               action: action,
      //             )));
      //   }
      //   else if(_error!.title.contains('title2')) {
      //     Provider.of<LoginProvider>(context, listen: false).autologin(context);
      //   }
      // }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void action() {
    if(_error!.title.contains('Error')) {}
    else if (_error!.title.contains('Update')) {
      AapoortiUtilities.openStore(context);
    }
  }

  void validateAndLogin() {
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        Provider.of<LoginProvider>(context, listen: false).authenticateUser(email, pin, isLoginSaved, false, context);
      }
      catch (err) {
        SchedulerBinding.instance.addPostFrameCallback((_){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 3),
            content: Text('Something Unexpected happened!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ));
        });
      }
    }
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return WillPopScope(
       onWillPop: () async{
        AapoortiUtilities.alertDialog(context, "UDM");
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CommonScreen()));
              //Navigator.of(context).pop();
            },
          ),
          actions: [
            SwitchLanguageButton(color: Colors.black)
          ],
          centerTitle: true,
          title: Text(language.text('login'), style: TextStyle(color: Colors.white)), // You can customize the title
          backgroundColor: Colors.red.shade300,
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: Provider.of<LanguageProvider>(context, listen: false).fetchLanguage(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting ? const Center(child: CircularProgressIndicator()) : Consumer<LanguageProvider>(
                    builder: (context, language, child) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300
                          // image: DecorationImage(
                          //   image: AssetImage("assets/images/login_bg.jpg"),
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        child: Column(
                          children: [_trialCheck(context),
                            Expanded(
                              child: SafeArea (
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Form(
                                          key: _formKey,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          child: Card(
                                            surfaceTintColor: Colors.white,
                                            elevation: 8.0,
                                            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                            color: Colors.white.withOpacity(0.8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 50),
                                                  Row(mainAxisAlignment: MainAxisAlignment.start, // Center the radio buttons
                                                children: [
                                                  RadioOption(
                                                    value: 'IREPS',
                                                    groupValue: selectedValue,
                                                    onChanged: (String? newValue) {
                                                      setState(() {
                                                        selectedValue = newValue;
                                                      });
                                                      Navigator.of(context).pushReplacementNamed('/common_screen', arguments: [1,'']);
                                                    },
                                                    label: language.text('irepslabel'),
                                                  ),
                                                  SizedBox(width: 25),
                                                  RadioOption(
                                                    value: 'UDM',
                                                    groupValue: selectedValue,
                                                    onChanged: (String? newValue) {
                                                      setState(() {
                                                        selectedValue = newValue;
                                                      });
                                                    },
                                                    label: language.text('udmlabel'),
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
                                                  TextFormField(
                                                    keyboardType: TextInputType.emailAddress,
                                                    controller: _emailFieldController,
                                                    cursorColor: Colors.black,
                                                    decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 1.0),
                                                      prefixIcon: Icon(Icons.mail),
                                                      focusColor: Colors.red.shade800,
                                                      focusedErrorBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Color(0xFF00008B), width: 1.0),
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                      errorBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                      labelText: language.text('userId') + '/' + language.text('emailId'),
                                                      labelStyle: TextStyle(fontSize: 15),
                                                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                    ),
                                                    validator: (value) {
                                                      bool emailValid = RegExp("^[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9\.]+(\.[A-Za-z0-9]+)*(\.[A-Za-z]{2,})\$").hasMatch(value!.trim());
                                                      //bool emailValid = RegExp("^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})\$").hasMatch(value!.trim());
                                                      if(value.isEmpty) {
                                                        return language.text('validEmail');
                                                      }
                                                      else if(!emailValid) {
                                                        return language.text('validEmail');
                                                      }
                                                    },
                                                    onChanged: (value){

                                                    },
                                                    onSaved: (val) {
                                                      email = val!.trim();
                                                    },
                                                  ),
                                                  SizedBox(height: 25),
                                                  Consumer<ChangeVisibilityProvider>(builder: (context, value, child){
                                                    return TextFormField(
                                                      obscureText: value.getVisibility,
                                                      keyboardType: TextInputType.text,
                                                      controller: _passwdFieldController,
                                                      cursorColor: Colors.black,
                                                      decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                        labelText: language.text('enterPin'),
                                                        prefixIcon: Icon(Icons.vpn_key),
                                                        suffixIcon: InkWell(
                                                          onTap: (){
                                                            if(value.getVisibility == true){
                                                              value.setVisibility(false);
                                                            }
                                                            else{
                                                              value.setVisibility(true);
                                                            }
                                                          },
                                                          child: value.getVisibility == true ? Icon(Icons.visibility_rounded) : Icon(Icons.visibility_off),
                                                        ),
                                                        labelStyle: TextStyle(fontSize: 15),
                                                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: const BorderSide(color: Color(0xFF00008B), width: 1.0),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        border: OutlineInputBorder(
                                                          borderSide: const BorderSide(
                                                            color: Colors.grey,
                                                          ),
                                                          borderRadius: BorderRadius.circular(14),
                                                        ),
                                                        disabledBorder: OutlineInputBorder(
                                                          borderSide: const BorderSide(
                                                            color: Colors.grey,
                                                          ),
                                                          borderRadius: BorderRadius.circular(14),
                                                        ),
                                                        errorBorder: OutlineInputBorder(
                                                          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        focusColor: Colors.red.shade800,
                                                        focusedErrorBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                      ),
                                                      validator: (pin) {
                                                        String text = language.text('pinLengthError');
                                                        if(pin == null || pin.isEmpty) {
                                                          return text;
                                                        } else if(pin.length < 6 || pin.length > 12) {
                                                          return text;
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (val) {
                                                        pin = val;
                                                      },
                                                    );
                                                  }),
                                                  SizedBox(height: 10),
                                                  LoginSavedCheckBox(
                                                    value: isLoginSaved,
                                                    setValue: (bool val) {
                                                      isLoginSaved = val;
                                                    },
                                                  ),
                                                  Consumer<LoginProvider>(builder: (_, loginProvider, __) {
                                                    if((_emailFieldController.value.text.isEmpty) && (loginProvider.user != null)) {
                                                      Future.delayed(Duration.zero, () async {
                                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                                        _emailFieldController.text = prefs.get('email') as String;
                                                        _passwdFieldController.text = '';
                                                      });
                                                    }
                                                    if(loginProvider.state == LoginState.Idle || loginProvider.state == LoginState.Complete) {
                                                      Future.delayed(Duration.zero, () async {
                                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                                        if(_emailFieldController.text == '') {
                                                          _emailFieldController.text = "${prefs.get('email') ?? ""}";
                                                          _passwdFieldController.text = '';
                                                        }
                                                      });
                                                    }
                                                    else if(loginProvider.state == LoginState.Finished) {
                                                      SchedulerBinding.instance.addPostFrameCallback((_) {
                                                        loginProvider.setState(LoginState.FinishedWithError);
                                                      });
                                                    }
                                                    return SignInButton(
                                                      text: language.text('login'),
                                                      action: validateAndLogin,
                                                      loginstate: loginProvider.state,
                                                    );
                                                  }),
                                                  SizedBox(height: 20),
                                                  InkWell(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          text: language.text('enableAccessLabel1'),
                                                          style: TextStyle(
                                                            decoration: TextDecoration.underline,
                                                            color: Colors.teal[900],
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: language.text('enableAccessLabel2'),
                                                                style: TextStyle(fontWeight: FontWeight.bold,
                                                                    decoration: TextDecoration.underline,
                                                                    color: Colors.teal[900])),
                                                            TextSpan(text: language.text('enableAccessLabel3')),
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        _enableAndResetModalSheet(context, 'enable', language);
                                                      }),
                                                  SizedBox(height: 15.0),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            text: language.text('resetPinInstructionsLabel1'),
                                                            style: TextStyle(
                                                              decoration: TextDecoration.underline,
                                                              color: Colors.teal[900],
                                                            ),
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                  text: language.text('resetPinInstructionsLabel2'),
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    decoration: TextDecoration.underline,
                                                                    color: Colors.teal[900],
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          _enableAndResetModalSheet(
                                                            context,
                                                            'reset',
                                                            language,
                                                          );
                                                        },
                                                      ),
                                                      //Text(" ||", style: TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold)),
                                                      // TextButton(onPressed: (){
                                                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => HelpDeskScreen(data: 0)));
                                                      // }, child: Text(language.text('helpdesktitle'), style: TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold, decoration: TextDecoration.underline)))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        child!,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Positioned(
                      top: 15,
                      child: Column(
                        children: [
                          // CircleAvatar(
                          //   backgroundColor: Colors.white,
                          //   backgroundImage: AssetImage('assets/indian_railway2.png'),
                          //   radius: 40,
                          // ),
                          // SizedBox(height: 5),
                          // Text('यूजर डिपो मॉड्यूल',
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //       color: Color(0xFF00008B),
                          //       fontWeight: FontWeight.bold,
                          //       fontSize: 20),
                          // ),
                          SizedBox(height: 15),
                          Text(language.text('udmtitle'), textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF00008B), fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget _trialCheck(BuildContext context) {
    if(IRUDMConstants.webServiceUrl.contains('trial')) {
      return Text("TRIAL", style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold));
    } else {
      return Text("");
    }
  }

  Future<void> _enableAndResetModalSheet(BuildContext context, String type, LanguageProvider language) async {
    return await showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        clipBehavior: Clip.hardEdge,
        builder: (_) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
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
                Row(
                  children: <Widget>[
                    Text(
                      type == 'reset' ? language.text('resetPinInstructionsTitle') : language.text('enableAccessInstructionsTitle'),
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 32.0)),
                    Text("1.", style: TextStyle(fontSize: 16.0)),
                    SizedBox(width: 5),
                    Text(language.text('loginScreenInstructions1'), style: TextStyle(fontSize: 16.0)),
                    Padding(padding: EdgeInsets.only(left: 35.0)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 32.0)),
                    Text("2.", style: TextStyle(fontSize: 16.0)),
                    SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        language.text('loginScreenInstructions2'),
                        style: TextStyle(fontSize: 16.0),
                        softWrap: true,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 32.0)),
                    Text("3.", style: TextStyle(fontSize: 16.0)),
                    SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        type == 'reset' ? language.text('resetPinInstructionsText') : language.text('enableAccessInstructionsText'),
                        style: TextStyle(fontSize: 16.0,
                          // color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 3);
    path.lineTo(0.0, 0.0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => true;
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
          activeColor: label == 'IREPS' || label == 'आईआरईपीएस' ? Colors.cyan[400] : Colors.red.shade300,
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }
}
