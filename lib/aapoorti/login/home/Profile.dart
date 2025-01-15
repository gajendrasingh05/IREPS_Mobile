import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatelessWidget {
  String? username,
      emailid,
      phoneno,
      usertype,
      workarea,
      firmname,
      lastlogintime;
  String phone_IREPS = 'tel:+91-11-23761525',
      phone_SBIePAY = 'tel:+91-22-27523816',
      phone_SBInetBanking1 = 'tel:+91-11-23761525',
      phone_SBInetBanking2 = 'tel:+91-22-27566067',
      phone_SBInetBanking3 = 'tel:+91-22-27560137',
      phone_SBInetBanking4 = 'tel:+91-22-27566501',
      email_SBIePAY = 'sbipay@sbi.co.in',
      email_SBInetbanking = "inb.cinb@sbi.co.in";
  String phnl = "", url = "";
  _callPhone(phn1) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        title: Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage('assets/welcome.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.2), BlendMode.dstATop),
                ),
              ),
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 10.0)),
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Card(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 10)),
                Text('User Details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                //new Padding(padding: new EdgeInsets.all(15.0)),
                Container(
                  height: 0.5,
                  padding: EdgeInsets.all(10),
                  color: Colors.grey,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 10.0, left: 20.0)),
                        Image.asset(
                          'assets/name.png',
                          width: 30,
                          height: 40,
                        ),
                        Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
                        InkWell(
                          child: Text(username!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )),
                          onTap: () {},
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 10.0, left: 20.0)),
                        Image.asset(
                          'assets/email_profile.png',
                          width: 30,
                          height: 40,
                        ),
                        Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
                        InkWell(
                          child: Text(emailid!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )),
                          onTap: () {},
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 10.0, left: 20.0)),
                        Image.asset(
                          'assets/phone_icon.png',
                          width: 30,
                          height: 40,
                        ),
                        Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
                        InkWell(
                          child: Text(phoneno!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )),
                          onTap: () {},
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 10.0, left: 20.0)),
                        Image.asset(
                          'assets/name_profile.png',
                          width: 30,
                          height: 40,
                        ),
                        Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
                        InkWell(
                          child: Text(usertype!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )),
                          onTap: () {},
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 10.0, left: 20.0)),
                        Image.asset(
                          'assets/work_area.png',
                          width: 30,
                          height: 40,
                        ),
                        Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
                        InkWell(
                          child: Text(workarea!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )),
                          onTap: () {},
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                  ],
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Card(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 10)),
                Text('Firm Details', style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 10.0, left: 20.0)),
                      Image.asset(
                        'assets/firm_icon.png',
                        width: 30,
                        height: 40,
                      ),
                      Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
                      InkWell(
                        child: Text(firmname!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            )),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Card(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 10)),
                Text('Last Login Time', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15.0)),
                Container(
                  child: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 10.0, left: 20.0)),
                      Image.asset(
                        'assets/login_time.png',
                        width: 30,
                        height: 40,
                      ),
                      Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
                      InkWell(
                        child: Text(lastlogintime!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            )),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Profile() {
    username = AapoortiUtilities.user!.USER_NAME;

    usertype = AapoortiUtilities.user!.U_VALUE;
    emailid = AapoortiUtilities.user!.EMAIL_ID;
    phoneno = AapoortiUtilities.user!.MOBILE;
    if (AapoortiUtilities.user!.USER_TYPE == "0") {
      workarea = "HelpDesk";
    } else if (AapoortiUtilities.user!.USER_TYPE == "8" ||
        AapoortiUtilities.user!.USER_TYPE == "9")
      workarea = "Auction User";
    else if (AapoortiUtilities.user!.CUSTOM_WK_AREA == "PT") {
      workarea = "Goods and Services";
    } else if (AapoortiUtilities.user!.CUSTOM_WK_AREA == "WT") {
      workarea = "Works";
    } else if (AapoortiUtilities.user!.CUSTOM_WK_AREA == "LT") {
      workarea = "Earning/Leasing";
    }
    firmname = AapoortiUtilities.user!.FIRM_NAME;
    lastlogintime = AapoortiUtilities.user!.LAST_LOG_TIME;
  }
}
