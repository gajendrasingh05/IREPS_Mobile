import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/home/home_screen.dart';
import 'package:flutter_app/aapoorti/home/policy_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(new AboutUs());

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => new _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  initState() {
    super.initState();
    versionControl();
  }

  String appVersion = '';
  void versionControl() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.buildNumber;
    debugPrint("aboutappVersion = " + appVersion);
  }

  String? url;

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context, rootNavigator: true).pop();
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.cyan[400],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: Text('About Us',
                          style: TextStyle(color: Colors.white))),
                  // new Padding(padding: new EdgeInsets.only(right: 80.0)),
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              ),
            ),
            body: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                child: Material(
                  child: Card(
                    color: Colors.teal[50],
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image.asset(
                                  'assets/indian_railway2.png',
                                  width: 50.0,
                                  height: 50.0,
                                  color: Colors.indigo[900],
                                ),
                                Expanded(
                                  child: Card(
                                    color: Colors.indigo[900],
                                    child: Text(
                                      "\n    IREPS\n    Indian Railways E-Procurement System                 \n",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(width: 1, color: Colors.grey[300]!),
                          ),
                          // color: Colors.grey[100],
                
                          child: Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.fromLTRB(5, 0, 5, 0)),
                              Flexible(
                                child: Text(
                                  "\nThis is the official mobile app of IREPS application (www.ireps.gov.in ). IREPS  mobile  app  provides information available on IREPS. IREPS application provide services related to procurement of Goods,Works and Services, Sale of Materials through the process  of  E-Tendering , E-Auction  or  Reverse Auction.\n",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15.0,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(width: 1, color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(
                                " \n   App Name\n",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.0,
                                    color: Colors.black),
                              ),
                              Text(
                                " \n       IREPS\n",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    color: Colors.indigo[900]),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(width: 1, color: Colors.grey[300]!),
                          ),
                          //color: Colors.grey[100],
                          child: Row(
                            children: <Widget>[
                              Text(
                                " \n   Version\n",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.0,
                                    color: Colors.black),
                              ),
                              Text(
                                " \n             " +
                                    HomeScreen.projectVersion +
                                    "\n",
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(width: 1, color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(
                                " \n   Website\n",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.0,
                                    color: Colors.black),
                              ),
                              InkWell(
                                child: Text(
                                  " \n           www.ireps.gov.in\n",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.indigo[400],
                                  ),
                                ),
                                onTap: () {
                                  url = "http://www.ireps.gov.in";
                                  _launchURL(url!);
                                },
                              ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(width: 1, color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(
                                " \n   Rate Us      \n",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.0,
                                    color: Colors.black),
                              ),
                              MaterialButton(
                                  onPressed: () {
                                    openStore();
                                    // LaunchReview.launch(
                                    //   androidAppId: "in.gov.ireps",
                                    //   iOSAppId: "1462024189",
                                    // );
                                  },
                                  child: Image.asset('assets/rating.png',
                                    width: 120.0,
                                    height: 30.0,
                                  )),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context) => PolicyScreen()));
                          },
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(width: 1, color: Colors.grey[300]!),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Privacy Policy",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15.0,
                                      color: Colors.indigo[400]),
                                  ),
                                  Icon(Icons.arrow_forward_ios_outlined, color: Colors.indigo[400], size: 16)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                " \n Developed and Published by",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13.0,
                                    color: Colors.indigo[900]),
                              ),
                              Text(
                                " Centre for Railway Information Systems",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.indigo[900]),
                              ),
                              Text(
                                "  (An Organization of the Ministry of Railways, Govt. of India)\n",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10.0,
                                    color: Colors.indigo[900]),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }

  Future<void> _launchPolicyURL() async {
    const url = 'https://www.ireps.gov.in/html/misc/Privacy_Policy_IREPS_App_NEW.html';
    if(await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> openStore() async{
     String storeUrl = '';
     if(Platform.isIOS){
       storeUrl = 'https://apps.apple.com/in/app/ireps/id1462024189';
     }
     else{
       storeUrl = "https://play.google.com/store/apps/details?id=in.gov.ireps";
     }
     if(await canLaunchUrl(Uri.parse(storeUrl))){
       await launch(storeUrl);
     }
     else{
       AapoortiUtilities.showInSnackBar(context, 'Could not launch $storeUrl');
     }
  }
}
