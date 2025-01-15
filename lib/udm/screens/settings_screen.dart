import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/localization/languageHelper.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/loginProvider.dart';
import 'package:flutter_app/udm/screens/UdmChangePin.dart';
import 'package:flutter_app/udm/screens/Profile.dart';
import 'package:flutter_app/udm/screens/login_screen.dart';
import 'package:flutter_app/udm/utils/extensions/Extensions.dart';
import 'package:flutter_app/udm/widgets/bottom_Nav/bottom_nav.dart';
import 'package:flutter_app/udm/widgets/delete_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLoginSaved = false;

  String? username = "", emailid = '', phoneno = '', usertype = '';
  List<Map<String, dynamic>>? dbResult;

  void initState() {
    userData();
    super.initState();
  }

  Future<void> userData() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbResult = await dbHelper.fetchSaveLoginUser();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (dbResult!.isNotEmpty) {
        setState(() {
          //username = dbResult![0][DatabaseHelper.Tb3_col8_userName];
          username = prefs.getString('name');
          emailid = dbResult![0][DatabaseHelper.Tb3_col5_emailid];
          phoneno = dbResult![0][DatabaseHelper.Tb3_col7_mobile];
        });
      }
    } catch (err) {}
  }

  String get nameToInitials {
    String initials = '';
    List<String> splitName = username!.split(' ');
    if (splitName[0].isNotEmpty) {
      initials += splitName[0][0].toUpperCase();
    }
    if (splitName.length > 1) {
      if (splitName[splitName.length - 1].isNotEmpty) {
        initials += splitName[splitName.length - 1][0].toUpperCase();
      }
    }
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade300,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(language.text('settingritle'),
            style: TextStyle(color: Colors.white)),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color:Colors.red.shade300, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  surfaceTintColor: Colors.white,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.red.shade300,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.grey.shade600)),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                nameToInitials,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(username!.capitalizeFirstLetter(), style: TextStyle(fontSize: 16)),
                          Text(emailid!, style: TextStyle(fontSize: 16))
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                color: Colors.white,
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color:Colors.red.shade300, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  surfaceTintColor: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 50,
                          child: Row(
                            children: [
                              Icon(Icons.account_circle),
                              SizedBox(width: 10),
                              Expanded(
                                  child: Text(language.text('profile'),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16))),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Profile()));
                                  },
                                  icon: Icon(Icons.arrow_forward_ios_outlined,
                                      size: 20))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                            color: Colors.grey.shade700,
                            height: 0.5,
                            thickness: 0.5),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 50,
                          child: Row(
                            children: [
                              Icon(Typicons.pin_outline),
                              SizedBox(width: 10),
                              Expanded(
                                  child: Text(language.text('changepin'),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16))),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UdmChangePin()));
                                  },
                                  icon: Icon(Icons.arrow_forward_ios_outlined,
                                      size: 20))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                            color: Colors.grey.shade700,
                            height: 0.5,
                            thickness: 0.5),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 50,
                          child: Row(
                            children: [
                              Icon(Icons.language),
                              SizedBox(width: 10),
                              Expanded(
                                  child: Text(language.text('changelan'),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16))),
                              IconButton(
                                  onPressed: () {
                                    changeLanguage(language);
                                  },
                                  icon: Icon(Icons.arrow_forward_ios_outlined,
                                      size: 20))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                            color: Colors.grey.shade700,
                            height: 0.5,
                            thickness: 0.5),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 50,
                          child: Row(
                            children: [
                              Icon(Typicons.lock),
                              SizedBox(width: 10),
                              Expanded(
                                  child: Text(language.text('changelogin'),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16))),
                              IconButton(
                                  onPressed: () {
                                    WarningAlertDialog().changeLoginAlertDialog(context, () {callWebServiceLogout();}, language);
                                  },
                                  icon: Icon(Icons.arrow_forward_ios_outlined,
                                      size: 20))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void callWebServiceLogout() async {
    IRUDMConstants.showProgressIndicator(context);
    var loginprovider = Provider.of<LoginProvider>(context, listen: false);
    List<dynamic>? jsonResult;
    try {
      jsonResult = await fetchPostPostLogin(loginprovider.user!.ctoken!,
          loginprovider.user!.stoken!, loginprovider.user!.map_id!);
      IRUDMConstants.removeProgressIndicator(context);
      if (jsonResult![0]['logoutstatus'] == "You have been successfully logged out.") {
        DatabaseHelper.instance.deleteSaveLoginUser();
        loginprovider.setState(LoginState.FinishedWithError);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (context) => LoginScreen()));
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              ModalRoute.withName("/login-screen"));
        });
      }
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {}
  }

  Future<List<dynamic>?> fetchPostPostLogin(String cTocken, String sTocken, String mapId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await Network.postDataWithAPIM(
        'UDM/UdmAppLogin/V1.0.0/UdmAppLogin',
        'UdmLogout',
        cTocken + '~' + sTocken + '~' + mapId,
        prefs.getString('token'));
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      return jsonResult['data'];
    } else {
      return IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    }
  }

  void changeLanguage(LanguageProvider language) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(horizontal: 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                        child: Text(language.text('selela'), style: TextStyle(fontSize: 16, decoration: TextDecoration.underline)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: InkWell(
                          onTap: () {
                            Provider.of<LanguageProvider>(context,
                                    listen: false)
                                .updateLanguage(Language.English);
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 45,
                            child: Row(
                              children: [
                                Image.asset('assets/translation.png',
                                    height: 27, width: 27),
                                SizedBox(width: 15),
                                Expanded(
                                    child: Text('English',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16))),
                                Provider.of<LanguageProvider>(context)
                                            .language ==
                                        Language.English
                                    ? Icon(Icons.check_box, color: Colors.blue)
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Divider(
                            color: Colors.grey.shade700,
                            height: 0.5,
                            thickness: 0.5),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: InkWell(
                          onTap: () {
                            Provider.of<LanguageProvider>(context,
                                    listen: false)
                                .updateLanguage(Language.Hindi);
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 45,
                            child: Row(
                              children: [
                                Image.asset('assets/translation.png',
                                    height: 27, width: 27),
                                SizedBox(width: 15),
                                Expanded(
                                    child: Text('हिंदी',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16))),
                                Provider.of<LanguageProvider>(context).language ==
                                        Language.English
                                    ? SizedBox()
                                    : Icon(Icons.check_box, color: Colors.blue),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
