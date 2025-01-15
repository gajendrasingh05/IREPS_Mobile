import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/ComingSoonLogin.dart';
import 'package:flutter_app/aapoorti/common/NoConnection.dart';
import 'package:flutter_app/aapoorti/helpdesk/problemreport/ReportOpt.dart';
import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
import 'package:flutter_app/aapoorti/views/imp_link_screen.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/dashboard/dashboard.dart';
import 'package:flutter_app/aapoorti/helpdesk/contactdetails/helpdesk.dart';
import 'package:flutter_app/aapoorti/home/home_screen.dart';
import 'package:flutter_app/aapoorti/login/Login.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


class CommonScreen extends StatefulWidget {
  @override
  _CommonScreenState createState() => _CommonScreenState();
}

class _CommonScreenState extends State<CommonScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget>? _screens;
  int bottomIndex = 0;
  var param;
  String? logOutSucc;
  //This variable is used to stop set param from ModalRoute.of(context).settings.arguments
  var afterLogout = 0;
  String? localCurrVer;
  String? globalCurrVer, globalLastAppVer;

  void initState() {
    super.initState();
    //fetchVersion();
    //AapoortiUtilities().versionControl();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(afterLogout == 0) {
      param = ModalRoute.of(context)!.settings.arguments ?? [bottomIndex, ''];

      bottomIndex = param[0];
      logOutSucc = param[1].toString();
    }

    _screens = [
      HomeScreen(_scaffoldKey),
      LoginActivity(_scaffoldKey, logOutSucc ?? ''),
      Help(),
      ImplinkScreen()
      //Dashboard(),
    ];
  }

  void checkBeforeLogin() async {
    ProgressDialog pr;
    if(Platform.isAndroid) {
      if(AapoortiConstants.ans == "true") {
        AapoortiUtilities.Progress(context);
        if (AapoortiConstants.check == "true" && DateTime.now().toString().compareTo(AapoortiConstants.date) < 0) {
          var jsonResult = null;
          var random = Random.secure();
          String ctoken = random.nextInt(100).toString();

          for (var i = 1; i < 10; i++) {
            ctoken = ctoken + random.nextInt(100).toString();
          }
          Map<String, dynamic> urlinput = {
            "userId": AapoortiConstants.loginUserEmailID,
            "pass": AapoortiConstants.hash,
            "cToken": "$ctoken",
            "sToken": "",
            "os": "Flutter",
            "token4": "",
            "token5": ""
          };

          debugPrint(AapoortiConstants.hash + " <-hash");
          String urlInputString = json.encode(urlinput);
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

          if (response.statusCode == 200) {
            debugPrint(jsonResult[0]['ErrorCode'].toString());
            if (jsonResult[0]['ErrorCode'] == null) {
              AapoortiUtilities.setUserDetails(jsonResult); //To save user details in shared object
              AapoortiUtilities.user1 = jsonResult[0]['USER_TYPE'].toString();
            }
          }
          AapoortiUtilities.ProgressStop(context);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHome(AapoortiUtilities.user1!, AapoortiConstants.loginUserEmailID)));
        } else {
          bottomIndex = 1;

          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) =>
          //     LoginActivity('')));
        }
      }
      else {
        bottomIndex = 1;

        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) =>
        //     LoginActivity('')));
      }
    }
    else {
      if(AapoortiConstants.ans == "true") {
        AapoortiUtilities.Progress(context);
        if (AapoortiConstants.check == "true" && DateTime.now().toString().compareTo(AapoortiConstants.date) < 0) {
          var jsonResult = null;
          var random = Random.secure();
          String ctoken = random.nextInt(100).toString();

          for (var i = 1; i < 10; i++) {
            ctoken = ctoken + random.nextInt(100).toString();
          }
          Map<String, dynamic> urlinput = {
            "userId": AapoortiConstants.loginUserEmailID,
            "pass": AapoortiConstants.hash,
            "cToken": "$ctoken",
            "sToken": "",
            "os": "Flutter~ios",
            "token4": "",
            "token5": ""
          };

          debugPrint(AapoortiConstants.hash + " <-hash");
          String urlInputString = json.encode(urlinput);
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

          if (response.statusCode == 200) {
            debugPrint(jsonResult[0]['ErrorCode'].toString());
            if (jsonResult[0]['ErrorCode'] == null) {
              AapoortiUtilities.setUserDetails(jsonResult); //To save user details in shared object
              AapoortiUtilities.user1 = jsonResult[0]['USER_TYPE'].toString();
            }
          }
          AapoortiUtilities.ProgressStop(context);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHome(AapoortiUtilities.user1!, AapoortiConstants.loginUserEmailID)));
        } else {
          bottomIndex = 1;
        }
      }
      else {
        bottomIndex = 1;

      }
    }
  }

  Future<bool> AapoortiCheckConnection() async {
    bool check = await AapoortiUtilities.checkConnection();
    return check;
  }

  void navigateFunction(int indx) {
    AapoortiUtilities.logoutBanner = false;
    switch (indx) {
      case 0:
        setState(() {
          bottomIndex = indx;
          afterLogout = 1;
        });
        break;
      case 1:
        checkBeforeLogin();
        setState(() {
          bottomIndex = indx;
        });
        break;
      case 2:
        ReportaproblemOpt.rec = "0";
        setState(() {
          bottomIndex = indx;
          afterLogout = 1;
        });
        break;
      case 3:
        AapoortiUtilities.checkConnection().then((check) {
          if(check == true) {
            setState(() {
              bottomIndex = indx;
              afterLogout = 1;
            });
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
          }
        });
        break;

      default:
    }
  }

  Widget _buildBottomNavigationMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Text(
                "Do you want to exit?",
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "No",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              color: Colors.cyan[400],
              minWidth: 150,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            SizedBox(width: 20),
            MaterialButton(
              onPressed: () => SystemNavigator.pop(),
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              color: Colors.cyan[400],
              minWidth: 150,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            )
          ],
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     SizedBox(height: 40),
        //     MaterialButton(
        //       child: Text("Rate Us",
        //           style: TextStyle(
        //               color: Colors.indigo,
        //               fontWeight: FontWeight.bold,
        //               fontSize: 15)),
        //       onPressed: () {
        //         LaunchReview.launch(
        //           //StoreRedirect.redirect(
        //           androidAppId: "in.gov.ireps",
        //           iOSAppId: "1462024189",
        //         );
        //       },
        //     ),
        //     SizedBox(width: 70),
        //     MaterialButton(
        //       onPressed: () {
        //         ReportaproblemOpt.rec = "0";
        //         Navigator.pushNamed(context, "/report");
        //       },
        //       child: Text("Report Problem",
        //           style: TextStyle(
        //               color: Colors.indigo,
        //               fontWeight: FontWeight.bold,
        //               fontSize: 15)),
        //     )
        //   ],
        // )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(bottomIndex != 0) {
          Future.delayed(Duration.zero, () => setState(() {bottomIndex = 0;}));
          return false;
        } else {
           AapoortiUtilities.alertDialog(context, "IREPS");
          //_onBackPressed();
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.cyan[400],
          title: Text(
            // 'आपूर्ति (IREPS)',
            'IREPS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.grey[200],
        drawer: AapoortiUtilities.navigationdrawerbeforLOgin(_scaffoldKey, context),
        body: _screens![bottomIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: bottomIndex,
          onTap: navigateFunction,
          selectedItemColor: Colors.cyan[400], // Active item color
          unselectedItemColor: Colors.grey, // Inactive item color
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: SizedBox(
                width: 35,
                height: 33,
                child: Icon(Icons.home),
              ),
            ),
            BottomNavigationBarItem(
              //icon: new Icon(Icons.person),
              icon: SizedBox(
                width: 35,
                height: 33,
                child: Icon(Icons.person_pin),
              ),
              label: 'Login',
            ),
            BottomNavigationBarItem(
                icon: SizedBox(
                    width: 35,
                    height: 33,
                    child: Icon(Icons.live_help)),
                label: 'Helpdesk'),
            BottomNavigationBarItem(
                icon: SizedBox(
                    width: 35,
                    height: 33,
                    child: Icon(Icons.link)),
                label: 'Links'),
          ],
        ),
      ),
    );
  }

}
