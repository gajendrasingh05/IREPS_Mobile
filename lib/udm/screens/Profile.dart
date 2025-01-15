import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/widgets/bottom_Nav/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profile> {
  bool isLoginSaved = false;

  String? username = "",
      emailid = '',
      phoneno = '',
      usertype = '',
      workarea = '',
      firmname = '',
      lastlogintime = '';
  List<Map<String, dynamic>>? dbResult;

  void initState() {
    UserData();
    super.initState();
  }

  Future<void> UserData() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbResult = await dbHelper.fetchSaveLoginUser();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(dbResult!.isNotEmpty) {
        setState(() {
          //username = dbResult![0][DatabaseHelper.Tb3_col8_userName];
          username = prefs.getString('name');
          emailid = dbResult![0][DatabaseHelper.Tb3_col5_emailid];
          phoneno = dbResult![0][DatabaseHelper.Tb3_col7_mobile];
          firmname = dbResult![0][DatabaseHelper.Tb3_col12_OuName];
          usertype = dbResult![0][DatabaseHelper.Tb3_col9_UserVlue];
          workarea = dbResult![0][DatabaseHelper.Tb3_col11_WKArea];
          lastlogintime = dbResult![0][DatabaseHelper.Tb3_col10_LastLogin];
        });
      }
    } catch (err) {}
  }

/*  _callPhone(phn1) async {

    if (await canLaunch(phn1)) {
      await launch(phn1);
    } else {
      throw 'Could not Call Phone';
    }
  }
  _launchURL(String toMailId) async {
    var url = 'mailto:$toMailId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }*/

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
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          Navigator.of(context).pop();
        },
        backgroundColor: Colors.white,
        elevation: 0,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 1),
      body: Container(
        height: mediaQuery.size.height,
        width: mediaQuery.size.width,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: mediaQuery.size.height * 0.50,
                    width: mediaQuery.size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage('assets/welcome.jpg'),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: mediaQuery.size.height * 0.15,
                    child: FittedBox(
                      child: Column(
                        children: [
                          Container(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  nameToInitials,
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 30,
                            // width: mediaQuery.size.width * 0.6,
                            width: 250,
                            child: FittedBox(
                              child: (username!.isEmpty || username == null)
                                  ? SizedBox(height: 1, width: 1)
                                  : Text(
                                username!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: mediaQuery.size.height * 0.55,
                width: mediaQuery.size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: mediaQuery.size.height * 0.55,
                width: mediaQuery.size.width,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: mediaQuery.size.height * 0.55,
                width: mediaQuery.size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.phone, size: 25),
                          SizedBox(width: 25),
                          Expanded(
                            child: Text(
                              phoneno!,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.email, size: 25),
                          SizedBox(width: 25),
                          FittedBox(
                            alignment: Alignment.topLeft,
                            fit: BoxFit.scaleDown,
                            child: (emailid == null || emailid!.isEmpty)
                                ? SizedBox(width: 1, height: 1)
                                : Text(
                              emailid!,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Image.asset(
                            'assets/name_profile.png',
                            width: 24,
                            height: 32,
                          ),
                          SizedBox(width: 25),
                          Expanded(
                            child: Text(
                              usertype!,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Image.asset(
                            'assets/work_area.png',
                            width: 24,
                            height: 32,
                          ),
                          SizedBox(width: 25),
                          Expanded(
                            child: Text(
                              workarea!,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          // Expanded(
                          //   child: Divider(),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Organization Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      Row(
                        children: [
                          Image.asset(
                            'assets/firm_icon.png',
                            width: 24,
                            height: 32,
                          ),
                          SizedBox(width: 25),
                          Expanded(
                            child: Text(
                              firmname!,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          // Expanded(
                          //   child: Divider(),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Last Login Time',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Image.asset(
                            'assets/login_time.png',
                            width: 24,
                            height: 32,
                          ),
                          SizedBox(width: 25),
                          Expanded(
                            child: Text(
                              lastlogintime!,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       //resizeToAvoidBottomPadding: true,

//       backgroundColor: Colors.grey[200],

//       appBar: AppBar(
//         iconTheme: new IconThemeData(color: Colors.white),
//         backgroundColor: Colors.red[300],
//         title: Text('Profile'),
//       ),

//       body: new ListView(
//         children: <Widget>[
//           new Card(
//             child: Container(
//               decoration: new BoxDecoration(
//                 image: new DecorationImage(
//                   image: new ExactAssetImage('assets/welcome.jpg'),
//                   fit: BoxFit.cover,
//                   colorFilter: new ColorFilter.mode(
//                       Colors.white.withOpacity(0.2), BlendMode.dstATop),
//                 ),
//               ),
//               height: 200,
//               child: new Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   new Center(
//                     child: new SizedBox(
//                       height: 100,
//                       width: 100,
//                       child: new Icon(
//                         Icons.account_circle,
//                         size: 100,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   Padding(padding: new EdgeInsets.only(bottom: 10.0)),
//                 ],
//               ),
//             ),
//           ),
//           new Padding(padding: new EdgeInsets.only(top: 10)),
//           new Card(
//             child: new Column(
//               children: <Widget>[
//                 // new  Image.asset('assets/main.jpg'),

//                 new Padding(padding: new EdgeInsets.only(top: 10)),

//                 new Text(
//                   'User Details',
//                   style: new TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold),
//                 ),
//                 //new Padding(padding: new EdgeInsets.all(15.0)),
//                 Container(
//                   height: 0.5,
//                   padding: EdgeInsets.all(10),
//                   color: Colors.grey,
//                 ),
//                 new Column(
//                   children: <Widget>[
//                     Row(
//                       children: <Widget>[
//                         Padding(
//                             padding: EdgeInsets.only(top: 10.0, left: 20.0)),
//                         Image.asset(
//                           'assets/name.png',
//                           width: 30,
//                           height: 40,
//                         ),
//                         Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
//                         InkWell(
//                           child: Text(username!,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                               )),
//                           onTap: () {},
//                         ),
// //                        Text("+91-11-23761525",
// //                            style: TextStyle(color: Colors.indigo,fontSize: 15,
// //                              decoration: TextDecoration.underline,)),
//                       ],
//                     ),
//                     Padding(padding: EdgeInsets.only(top: 10.0)),
//                     Row(
//                       children: <Widget>[
//                         Padding(
//                             padding: EdgeInsets.only(top: 10.0, left: 20.0)),
//                         Image.asset(
//                           'assets/email_profile.png',
//                           width: 30,
//                           height: 40,
//                         ),
//                         Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
//                         InkWell(
//                           child: Text(emailid!,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                               )),
//                           onTap: () {},
//                         ),
// //                        Text("+91-11-23761525",
// //                            style: TextStyle(color: Colors.indigo,fontSize: 15,
// //                              decoration: TextDecoration.underline,)),
//                       ],
//                     ),
//                     Padding(padding: EdgeInsets.only(top: 10.0)),
//                     Row(
//                       children: <Widget>[
//                         Padding(
//                             padding: EdgeInsets.only(top: 10.0, left: 20.0)),
//                         Image.asset(
//                           'assets/phone_icon.png',
//                           width: 30,
//                           height: 40,
//                         ),
//                         Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
//                         InkWell(
//                           child: Text(phoneno!,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                               )),
//                           onTap: () {},
//                         ),
// //                        Text("+91-11-23761525",
// //                            style: TextStyle(color: Colors.indigo,fontSize: 15,
// //                              decoration: TextDecoration.underline,)),
//                       ],
//                     ),
//                     Padding(padding: EdgeInsets.only(top: 10.0)),
//                     Row(
//                       children: <Widget>[
//                         Padding(
//                             padding: EdgeInsets.only(top: 10.0, left: 20.0)),
//                         Image.asset(
//                           'assets/name_profile.png',
//                           width: 30,
//                           height: 40,
//                         ),
//                         Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
//                         InkWell(
//                           child: Text(usertype!,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                               )),
//                           onTap: () {},
//                         ),
// //                        Text("+91-11-23761525",
// //                            style: TextStyle(color: Colors.indigo,fontSize: 15,
// //                              decoration: TextDecoration.underline,)),
//                       ],
//                     ),
//                     Padding(padding: EdgeInsets.only(top: 10.0)),
//                     Row(
//                       children: <Widget>[
//                         Padding(
//                             padding: EdgeInsets.only(top: 10.0, left: 20.0)),
//                         Image.asset(
//                           'assets/work_area.png',
//                           width: 30,
//                           height: 40,
//                         ),
//                         Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
//                         InkWell(
//                           child: Text(workarea!,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                               )),
//                           onTap: () {},
//                         ),
// //                        Text("+91-11-23761525",
// //                            style: TextStyle(color: Colors.indigo,fontSize: 15,
// //                              decoration: TextDecoration.underline,)),
//                       ],
//                     ),
//                     Padding(padding: EdgeInsets.only(top: 10.0)),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           new Padding(padding: new EdgeInsets.only(top: 10)),
//           new Card(
//             child: new Column(
//               children: <Widget>[
//                 // new  Image.asset('assets/main.jpg'),

//                 new Padding(padding: new EdgeInsets.only(top: 10)),

//                 new Text(
//                   'Organization Details',
//                   style: new TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15.0),
//                 ),
//                 //new Padding(padding: new EdgeInsets.all(15.0)),

//                 new Container(
//                   child: Row(
//                     children: <Widget>[
//                       Padding(padding: EdgeInsets.only(top: 10.0, left: 20.0)),
//                       Image.asset(
//                         'assets/firm_icon.png',
//                         width: 30,
//                         height: 40,
//                       ),
//                       Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
//                       InkWell(
//                         child: Text(firmname!,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 15,
//                             )),
//                         onTap: () {},
//                       ),
// //                        Text("+91-11-23761525",
// //                            style: TextStyle(color: Colors.indigo,fontSize: 15,
// //                              decoration: TextDecoration.underline,)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           new Padding(padding: new EdgeInsets.only(top: 10)),
//           new Card(
//             child: new Column(
//               children: <Widget>[
//                 // new  Image.asset('assets/main.jpg'),

//                 new Padding(padding: new EdgeInsets.only(top: 10)),

//                 new Text(
//                   'Last Login Time',
//                   style: new TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15.0),
//                 ),
//                 //new Padding(padding: new EdgeInsets.all(15.0)),

//                 new Container(
//                   child: Row(
//                     children: <Widget>[
//                       Padding(padding: EdgeInsets.only(top: 10.0, left: 20.0)),
//                       Image.asset(
//                         'assets/login_time.png',
//                         width: 30,
//                         height: 40,
//                       ),
//                       Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
//                       InkWell(
//                         child: Text(lastlogintime!,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 15,
//                             )),
//                         onTap: () {},
//                       ),
// //                        Text("+91-11-23761525",
// //                            style: TextStyle(color: Colors.indigo,fontSize: 15,
// //                              decoration: TextDecoration.underline,)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
  }

/*Profile()
  {
    username=AapoortiUtilities.user.USER_NAME;

    usertype=AapoortiUtilities.user.U_VALUE;
    emailid=AapoortiUtilities.user.EMAIL_ID;
    phoneno=AapoortiUtilities.user.MOBILE;
    if(AapoortiUtilities.user.USER_TYPE=="0")
      {
        workarea="HelpDesk";

      }
   else if(AapoortiUtilities.user.USER_TYPE=="8"||AapoortiUtilities.user.USER_TYPE=="9")
      workarea="Auction User";
      else
    if(AapoortiUtilities.user.CUSTOM_WK_AREA=="PT")
      {
        workarea="Goods and Services";
      }
   else if(AapoortiUtilities.user.CUSTOM_WK_AREA=="WT")
    {
      workarea="Works";
    }
    else if(AapoortiUtilities.user.CUSTOM_WK_AREA=="LT")
    {
      workarea="Earning/Leasing";
    }
  firmname=AapoortiUtilities.user.FIRM_NAME;
    lastlogintime=AapoortiUtilities.user.LAST_LOG_TIME;
  }*/
}
