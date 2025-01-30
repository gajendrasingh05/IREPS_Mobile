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
          backgroundColor: Colors.blue,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child:
                      Text('About Us', style: TextStyle(color: Colors.white))),
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
            child: Column(children: <Widget>[
              SizedBox(height: 15),
              Center(
                child: Image.asset(
                  'assets/indian_railway2.png',
                  width: 70.0,
                  height: 70.0,
                  color: Colors.indigo[900],
                ),
              ),
              SizedBox(height: 5),

              Center(
                child: Text(
                  "IREPS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0, // Larger font for emphasis
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                  height:
                      5), // Space between the first line and the second line of text
              Center(
                child: Text(
                  "Indian Railways E-Procurement System",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5.0), // Adjust the value as needed
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(width: 1, color: Colors.grey[300]!),
                  ),
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
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.0, // Adjust the value as needed
                ),
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(width: 1, color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Version",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          "8.01.04(1809)",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.0, // Adjust the value as needed
                ),
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(width: 1, color: Colors.grey[300]!),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                      vertical: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Website",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            "www.ireps.gov.in",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              color: Colors.indigo[400],
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onTap: () {
                            String url = "http://www.ireps.gov.in";
                            _launchURL(url);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.0, // Adjust the value as needed
                ),
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(width: 1, color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Rate Us",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          openStore();
                        },
                        child: Image.asset(
                          'assets/rating.png',
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.0, // Adjust the value as needed
                ),
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(width: 1, color: Colors.grey[300]!),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                      vertical: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Privacy Policy",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.indigo[400],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.indigo[400],
                          size: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Column(children: <Widget>[
                  Center(
                    child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // Minimizes extra vertical space
                        children: [
                          Image.asset(
                            'assets/images/crisnew.png',
                            width: 50.0,
                            height: 50.0,
                          ),
                          SizedBox(
                              height:
                                  5.0), // Controls the space between the image and text
                          Text(
                            "Developed and Published by",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 13.0,
                              color: Colors.indigo[900],
                            ),
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
                        ]),
                  ),
                ]),
              ),
            ]),
          ),
          // Footer
        ),
      ),
    );
  }

  Future<void> _launchPolicyURL() async {
    const url =
        'https://www.ireps.gov.in/html/misc/Privacy_Policy_IREPS_App_NEW.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> openStore() async {
    String storeUrl = '';
    if (Platform.isIOS) {
      storeUrl = 'https://apps.apple.com/in/app/ireps/id1462024189';
    } else {
      storeUrl = "https://play.google.com/store/apps/details?id=in.gov.ireps";
    }
    if (await canLaunchUrl(Uri.parse(storeUrl))) {
      await launch(storeUrl);
    } else {
      AapoortiUtilities.showInSnackBar(context, 'Could not launch $storeUrl');
    }
  }
}
