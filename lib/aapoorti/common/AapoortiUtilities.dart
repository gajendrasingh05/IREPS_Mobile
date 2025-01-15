import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/CommonScreen.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:flutter_app/udm/widgets/delete_dialog.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_app/aapoorti/common/downloadFile.dart';

import 'package:open_filex/open_filex.dart';
import 'package:flutter_app/aapoorti/helpdesk/requeststatus/view_helpdesk_details.dart';
import 'package:flutter_app/aapoorti/home/home_screen.dart';
import 'package:flutter_app/aapoorti/login/auctionReports/catalogRpt/CatalogueSum.dart';
import 'package:flutter_app/aapoorti/login/bills/closed/ClosedBills.dart';
import 'package:flutter_app/aapoorti/login/contracts/PurchaseOrders.dart';
import 'package:flutter_app/aapoorti/login/home/ChangePin.dart';
import 'package:flutter_app/aapoorti/login/auctionReports/consolidatedRpt/Consolidated.dart';
import 'package:flutter_app/aapoorti/login/auctionReports/invoice/Invoice.dart';
import 'package:flutter_app/aapoorti/login/IrepsProgress/IrepsProgress.dart';
import 'package:flutter_app/aapoorti/login/helpdesk/MobileAppQuery/MobileAppQuery.dart';
import 'package:flutter_app/aapoorti/login/tenderpayments/closed/ClosedTender.dart';
import 'package:flutter_app/aapoorti/login/tenderpayments/live/LiveTender.dart';
import 'package:flutter_app/aapoorti/login/tenderpayments/payments/Payments.dart';
import 'package:flutter_app/aapoorti/login/bills/pending/PendingBills.dart';
import 'package:flutter_app/aapoorti/login/helpdesk/pendingQuery/PendingQuery.dart';
import 'package:flutter_app/aapoorti/login/home/Profile.dart';
import 'package:flutter_app/aapoorti/login/tenderpayments/reverse/ReverseAuction.dart';
import 'package:flutter_app/aapoorti/login/auctionReports/SoldLots/SoldLots.dart';
import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
import 'package:flutter_app/aapoorti/login/loginReports/StockPosition/stock_posiion.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AapoortiConstants.dart';
import 'package:flutter/services.dart';
import 'NoConnection.dart';
import 'WebViewInFlutter.dart';

import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class AapoortiUtilities {
  static bool loggedin = false;
  static const platform = const MethodChannel('DownloadChannel');
  static bool loginflag = false;
  static int bbottom = 0;
  static UserDetails? user;
  static List<dynamic>? dataOrganisation;
  static List<dynamic>? dataZone;
  static String version = "";
  static String? user1;
  static bool logoutBanner = false;

  // LoginActivity lg=new LoginActivity(" ");

  AapoortiUtilities() {
    versionControl();
  }

  static void showInSnackBar(BuildContext context, String value) {
    SnackBar snackbar = SnackBar(
      content: Text(value),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.redAccent[100],
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static void showFlushBar(BuildContext context, String msg, {bool error = true}){
    Flushbar(
      message: msg,
      backgroundColor: error ? Colors.red : Colors.blueGrey,
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(15.0),
      borderRadius: BorderRadius.circular(8.0),
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  void versionControl() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = "${packageInfo.version}:${packageInfo.buildNumber}";
  }

  static Future<void> fetchPostOrganisation() async {
    var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ORGANIZATION';
    final response1 = await http.post(Uri.parse(u));
    dataOrganisation = json.decode(response1.body);
    setStateL(() {
      dataOrganisation = dataOrganisation;
    });
  }

  static Future<void> getZone(ProgressDialog pr) async {
    try {
      getProgressDialog(pr);
      var v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,01';
      final response = await http.post(Uri.parse(v));
      dataZone = json.decode(response.body);
      if(response == null || response.statusCode != 200)
        throw Exception('HTTP request failed, statusCode: ${response?.statusCode}');
      stopProgress(pr);
      setStateL(() {
        dataZone = dataZone;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static getProgressDialog(ProgressDialog pr) {
    pr.style(
        message: 'Please Wait...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        elevation: 20.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w600));
    pr.show();
  }

  static stopProgress(ProgressDialog pr) {
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      pr.hide().whenComplete(() {});
    });
  }

  static setPortraitOrientation() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  static setLandscapeOrientation() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  static Widget attachDocsListView(BuildContext context, String attachDocsString) {
    var attachDocsArray = attachDocsString.split('~~');

    return ListView.separated(
        itemCount: attachDocsString != null ? attachDocsArray.length : 0,
        itemBuilder: (context, index) {
          String fileUrl = AapoortiConstants.contextPath + attachDocsArray[index].split(',')[1].toString();
          String fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));

          return Container(
              padding: EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        (index + 1).toString() + ". ",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )
                    ],
                  ),
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            Dialog(
                              backgroundColor: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                  ),
                                  Text(
                                    "Loading",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                ],
                              ),
                            );
                            openPdf(context, fileUrl, fileName);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  AapoortiUtilities.ackAlert(
                                      context, fileUrl, fileName);
                                },
                                child: Text(
                                  attachDocsArray[index]
                                      .split(',')[1]
                                      .toString()
                                      .substring(attachDocsArray[index]
                                              .split(',')[1]
                                              .toString()
                                              .lastIndexOf('/') +
                                          1),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  AapoortiUtilities.ackAlert(
                                      context, fileUrl, fileName);
                                },
                                child: Text(
                                  attachDocsArray[index]
                                      .split(',')[0]
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                              ),
                            ],
                          )))
                ],
              ));
        },
        separatorBuilder: (context, index) {
          return Divider();
        });
  }

  static Widget ButtonAfterLogin(String text, BuildContext context) {
    return Container(
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
        minWidth: 250,
        height: 20,
        padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
        onPressed: () {
          // validateAndLogin,
        },
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }

  static Widget corrigendumListView(BuildContext context, String attachCorriString) {
    var corriArray = attachCorriString.split(',');
    return ListView.separated(
        itemCount: attachCorriString != null ? corriArray.length : 0,
        itemBuilder: (context, index) {
          var corriURL = corriArray[index].split('#')[2].toString();
          return Container(
              margin: EdgeInsets.only(bottom: 50),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text((index + 1).toString() + ".    ", style: TextStyle(color: Colors.white, fontSize: 17))
                    ],
                  ),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewInFlutter(url1: corriURL)));
                        },
                        child: Text('Corrigendum ' + (index + 1).toString(), style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewInFlutter(url1: corriURL)));
                        },
                        child: Text(
                          corriArray[index].split('#')[1].toString(),
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                    ],
                  ))
                ],
              ));
        },
        separatorBuilder: (context, index) {
          return Divider();
        });
  }

  static ProgressStop(context) {
    ProgressDialog pr = ProgressDialog(context);
    if(AapoortiConstants.check == "true") {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
    }
  }

  static Progress(context) {
    ProgressDialog pr;
    if(AapoortiConstants.check == "true") {
      pr = ProgressDialog(context,
        type: ProgressDialogType.normal,
        isDismissible: true,
        showLogs: true,
      );
      pr.show();
    }
  }

  static Widget dummyBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      onTap: (value) {
        Navigator.of(context).pushReplacementNamed(
            "/common_screen", arguments: [value, '']);
      },
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
              child: Icon(Icons.live_help),
            ),
            label: 'Helpdesk'),
      ],
    );
  }

  static Widget navigationdrawerbeforLOgin(GlobalKey<ScaffoldState> _scaffoldKey, BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints.expand(height: 180.0),
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/welcome.jpg'),
                          fit: BoxFit.cover),
                    ),
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, "/about");
                    },
                    leading: Icon(Icons.info_outline),
                    title: Text('About Us'),
                  ),
                  ListTile(
                      leading: Icon(Icons.star_border),
                      title: Text('Rate Us'),
                      onTap: () {
                        AapoortiUtilities.openStore(context);
                        // LaunchReview.launch(
                        //   //StoreRedirect.redirect(
                        //   androidAppId: "in.gov.ireps",
                        //   iOSAppId: "1462024189",
                        // );
                      }),

                ],
              ),
            ),
          ),
          Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      height: 80.0,
                      width: 80.0,
                      decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.grey), borderRadius: BorderRadius.circular(40)),
                      child: Image.asset('assets/images/crisnew.png', fit: BoxFit.cover, width: 80, height: 80),
                    ),
                ),
              ),
              SizedBox(height: 2.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      "Version: $version",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(
                      "Developed by CRIS",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  if(_scaffoldKey.currentState!.isDrawerOpen) {
                    _scaffoldKey.currentState!.closeDrawer();
                    alertDialog(context, "IREPS");
                    //_showConfirmationDialog(context);
                    //WarningAlertDialog().changeLoginAlertDialog(context, () {callWebServiceLogout();}, language);
                    //callWebServiceLogout();
                  }
                },
                child: Container(
                  height: 45,
                  color: Colors.cyan.shade400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.white),
                      SizedBox(width: 10),
                      Text("Exit", style: TextStyle(fontSize: 16, color: Colors.white))
                    ],
                  ),
                ),
              )
            ],
          ),
          //SizedBox(height: 15),
        ],
      ),
    );
  }

  static Future<bool> check() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    debugPrint("Connectivity result :: ${connectivityResult.toString()}");
    if(connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi)){
      return true;
    }
    else{
      return false;
    }
    //return connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile;
  }

  static void showDownloadProgress(received, total) {
    if (total != -1) {
      debugPrint((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  static Future<File> changeFileNameOnly(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.rename(newPath);
  }

  static Future<void>? openPdfSheet(BuildContext context, String fileUrl, String fileName, String name){
    if(Platform.isAndroid){
      return showModalBottomSheet(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
          backgroundColor: Colors.white,
          context: context,
          isScrollControlled: true,
          builder: (context) => Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 5.0, bottom: 5.0), child: Text(name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                            onPressed: (){
                              AapoortiUtilities.openPdf(context, fileUrl, fileName);
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.grey)))),
                            icon: const Icon(Icons.open_in_new, color: Colors.black),
                            label: const Text("Open", style: TextStyle(color: Colors.black))),
                        const SizedBox(width: 40),
                        ElevatedButton.icon(
                            onPressed: (){
                              AapoortiUtilities.download(fileUrl, fileName, context);
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.grey)))),
                            icon: const Icon(Icons.file_download, color: Colors.black),
                            label: const Text("Download", style: TextStyle(color: Colors.black))),
                      ],
                    )
                  ])
          )
      );
    }
    else{
      AapoortiUtilities.openPdf(context, fileUrl, fileName);
    }
  }

  static Future<void> openPdf(BuildContext context, String fileUrl, String fileName) async {
    ProgressDialog? pr = ProgressDialog(context);
    debugPrint("file Url  $fileUrl");
    debugPrint("file fileName  $fileUrl");
    bool check = await checkConnection();
    AapoortiUtilities.getProgressDialog(pr);
    if(check == false) {
      AapoortiUtilities.stopProgress(pr);
      Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
    } else {
      try {
        File file = await DefaultCacheManager().getSingleFile(fileUrl);
        String fileName = fileUrl.split('/').last;
        debugPrint("file fileName 1 ${file.absolute.path}");
        OpenFilex.open(file.absolute.path);
        AapoortiUtilities.stopProgress(pr);
      } on HttpExceptionWithStatus catch (_) {
        AapoortiUtilities.stopProgress(pr);
        Navigator.pop(context);
        showInSnackBar(context, "File Not Found");
      } catch (e) {
        AapoortiUtilities.stopProgress(pr);
        Navigator.pop(context);
        showInSnackBar(context, "Something unexpected occurred.");
      }
    }
  }

  static Future<void> ackAlertLogin(BuildContext context, String fileUrl, String fileName, String name) async {
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(name, style: TextStyle(color : Colors.white, fontWeight : FontWeight.bold)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 50,
                      onPressed: () {
                        AapoortiUtilities.openPdf(context, fileUrl, fileName);
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.open_in_new,
                            color: Colors.white,
                            size: 25,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Open",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      width: 1,
                      color: Colors.black,
                    ),
                    MaterialButton(
                      minWidth: 50,
                      onPressed: () async {
                        AapoortiUtilities.download(fileUrl, fileName, context);
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.file_download,
                            color: Colors.white,
                            size: 25,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Download",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      AapoortiUtilities.openPdf(context, fileUrl, fileName);
    }
  }

  static Future<void> ackAlert(BuildContext context, String fileUrl, String fileName) async {
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  minWidth: 50,
                  onPressed: () {
                    AapoortiUtilities.openPdf(context, fileUrl, fileName);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.open_in_new,
                        color: Colors.white,
                        size: 25,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Open",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  width: 1,
                  color: Colors.black,
                ),
                MaterialButton(
                  minWidth: 50,
                  onPressed: () async {
                    AapoortiUtilities.download(fileUrl, fileName, context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.file_download,
                        color: Colors.white,
                        size: 25,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Download",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    else {
      AapoortiUtilities.openPdf(context, fileUrl, fileName);
    }
  }

  static alertDialog(BuildContext context, String? appName) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40, bottom: 15, left: 15, right: 15),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Text(
                        "Confirmation!!",
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Do you want to exit from application?',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                side: BorderSide(color: Colors.white, width: 1),
                                textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontStyle: FontStyle.normal),
                              ),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text("Cancel",style: TextStyle(fontSize: 14, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                side: BorderSide(color: Colors.white, width: 1),
                                textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontStyle: FontStyle.normal),
                              ),
                              onPressed: (){
                                appName == "UDM"  || appName == "MMIS" ? Navigator.push(context, MaterialPageRoute(builder: (context) => CommonScreen())) : exit(0);
                              },
                              child: Text("Yes", style: TextStyle(fontSize: 14, color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: -30,
                  left: MediaQuery.of(context).padding.left,
                  right: MediaQuery.of(context).padding.right,
                  child: Image.asset(
                    "assets/web.png",
                    height: 60,
                    width: 60,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  static void download(String fileurl, String filename, BuildContext context) async {
    downloadFile(fileurl).then((filepath) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          barrierColor: Colors.black54,
          opaque: false,
          pageBuilder: (context, _, __) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Text('File Saved'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('File saved at:'),
                      Text(filepath),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      OpenFilex.open(filepath);
                    },
                  ),
                ],
        )));
    });
  }

  static void callWebServiceLogout1(BuildContext context) async {
    IRUDMConstants.showProgressIndicator(context);
    List<dynamic> jsonResult;
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," + AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + ",,";
    bool check = await checkConnection();
    if(check == true) {
      jsonResult = await AapoortiUtilities.fetchPostPostLogin('Log/Logout', 'Logout', inputParam1, inputParam2);
      debugPrint("logOut result ${jsonResult.toString()}");
      if (jsonResult[0]['LOGOUTSTATUS'] == "You have been successfully logged out.") {
        debugPrint("successfully logout");
        AapoortiUtilities.user = null;
      }
      debugPrint("length of jsonResult ${jsonResult.length}");
      debugPrint(jsonResult.toString());
      IRUDMConstants.removeProgressIndicator(context);
      String logoutsucc = jsonResult[0]['LOGOUTSTATUS'];
      logoutBanner = true;
      Navigator.pop(context, logoutsucc);
      Navigator.of(context).pushReplacementNamed("/common_screen", arguments: [1, logoutsucc]);
    } else {
      IRUDMConstants.removeProgressIndicator(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
    }
  }

  static Widget customTextViewWithoutE(
      String displayString, Color displayColor) {
    return Text(
      displayString != null ? displayString : "",
      style: TextStyle(
        color: displayColor,
        fontSize: 15,
      ),
    );
  }

  static Widget customTextView(String displayString, Color displayColor) {
    return Text(displayString != null ? displayString : "",
        style: TextStyle(
          color: displayColor,
          fontSize: 15,
        ),
        overflow: TextOverflow.ellipsis);
  }

  static Widget customTextViewBold(String displayString, Color displayColor) {
    return Text(displayString != null ? displayString : "",
        maxLines: 2,
        style: TextStyle(
          color: displayColor,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        overflow: TextOverflow.ellipsis);
  }

  static Widget navigationdrawer(GlobalKey<ScaffoldState> _scaffoldKey,BuildContext context) {
    String username = '', emailid = '', usertype = '', moduleaccess = '';
    if (user != null) {
      username = AapoortiUtilities.user!.USER_NAME;
      emailid = AapoortiUtilities.user!.EMAIL_ID;
      usertype = AapoortiUtilities.user!.USER_TYPE;
      moduleaccess = AapoortiUtilities.user!.MODULE_ACCESS.toString();
    }
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              child: Container(
                  constraints: BoxConstraints.expand(height: 180.0),
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/welcome.jpg'),
                        fit: BoxFit.cover),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Welcome',
                            style: TextStyle(
                                color: Colors.white, fontSize: 15.0),
                          ),
                          Text(
                            username,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          Text(
                            emailid,
                            style: TextStyle(
                                color: Colors.white, fontSize: 15.0),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ],
                      )
                    ],
                  ))),
          ListTile(
              onTap: () async {
                //Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserHome('', '')));
              },
              leading: Icon(
                Icons.home,
                textDirection: TextDirection.rtl,
              ),
              title: Text(
                'UserHome',
                style: TextStyle(fontSize: 15),
              )),
          if (((usertype == "1" || usertype == 6) && moduleaccess == "NA") ||
              moduleaccess.contains("1"))
            SizedBox(
              height: 1,
              child: const DecoratedBox(
                decoration: const BoxDecoration(color: Colors.teal),
              ),
            ),
          if (((usertype == "1" || usertype == "6") && moduleaccess == "NA") ||
              moduleaccess.contains("1"))
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                  child: const DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.white),
                  ),
                ),
                Text(
                  'Reports',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  textAlign: TextAlign.start,
                ),
                ListTile(
                    onTap: () async {
                      try {
                        //var connectivityresult = await InternetAddress.lookup('google.com');
                        var connectivityresult = await AapoortiUtilities.check();
                        if (connectivityresult) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StockPosition()));
                        }
                        else{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NoConnection()));
                        }
                      } on SocketException catch (_) {
                        debugPrint('internet not available');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoConnection()));
                      }
                    },
                    leading: Icon(Icons.score),
                    title: Text('Stock Position Report')),

                ListTile(
                    onTap: () async {
                      try {
                        var connectivityresult = await AapoortiUtilities.check();
                        if (connectivityresult) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IrepsProgress()));
                        }
                      } on SocketException catch (_) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoConnection()));
                      }
                    },
                    leading:Icon(Icons.timeline),
                    title:Text('IREPS Progress')),
              ],
            ),
          if ((usertype == "8" || usertype == "9" && moduleaccess == "NA") ||
              moduleaccess.contains("8") ||
              moduleaccess.contains("9"))
            SizedBox(
              height: 1,
              child: const DecoratedBox(
                decoration: const BoxDecoration(color: Colors.teal),
              ),
            ),
          if((usertype == "8" || usertype == "9" && moduleaccess == "NA") || moduleaccess.contains("8") || moduleaccess.contains("9"))
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                  child: const DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.white),
                  ),
                ),
                Text(
                  'Reports',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  textAlign: TextAlign.start,
                ),
                ListTile(
                    onTap: () async {
                      try {
                        var connectivityresult = await AapoortiUtilities.check();
                        if (connectivityresult) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Invoice()));
                        }
                      } on SocketException catch (_) {
                        debugPrint('internet not available');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoConnection()));
                      }
                    },
                    leading: Icon(Icons.payment),
                    title: Text('Invoice')),
                    ListTile(
                     onTap: () async {
                      try {
                        var connectivityresult = await AapoortiUtilities.check();
                        if (connectivityresult) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SoldLots()));
                        }
                      } on SocketException catch (_) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoConnection()));
                      }
                    },
                    leading: Icon(Icons.report_off),
                    title: Text('Sold Lots')),
                ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CatalogueSum()));
                    },
                    leading: Icon(Icons.dashboard),
                    title: Text('Catalogue Summary')),
                ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConsolidatedSum()));
                    },
                    leading: Icon(Icons.add_to_photos),
                    title: Text('Consolidated Summary')),
              ],
              //padding: new EdgeInsets.only(left:0) ,
            ),
          if ((usertype == "4" && moduleaccess == "NA") || moduleaccess.contains("4"))
            SizedBox(
              height: 1,
              child: const DecoratedBox(
                decoration: const BoxDecoration(color: Colors.teal),
              ),
            ),
          if ((usertype == "4" && moduleaccess == "NA") || moduleaccess.contains("4"))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                  child: const DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.white),
                  ),
                ),
                Text(
                  'Payment and Tenders',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  textAlign: TextAlign.start,
                ),
                ListTile(
                    onTap: () async {
                      try {
                        var connectivityresult = await AapoortiUtilities.check();
                        if (connectivityresult) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Payments()));
                        }
                      } on SocketException catch (_) {
                        print('internet not available');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoConnection()));
                      }
                    },
                    leading: Icon(Icons.payment),
                    title: Text('My Payments')),
                ListTile(
                    onTap: () async {
                      try {
                        var connectivityresult = await AapoortiUtilities.check();
                        if (connectivityresult) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LiveTender()));
                        }
                      } on SocketException catch (_) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoConnection()));
                      }
                    },
                    leading: Icon(Icons.live_tv),
                    title: Text('My Live Tender')),
                ListTile(
                    onTap: () async {
                      try {
                        var connectivityresult = await AapoortiUtilities.check();
                        if (connectivityresult) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ClosedTender()));
                        }
                      } on SocketException catch (_) {
                        debugPrint('internet not available');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoConnection()));
                      }
                    },
                    leading: Icon(Icons.closed_caption),
                    title: Text('My Closed Tenders')),
                ListTile(
                    onTap: () async {
                      try {
                        var connectivityresult = await AapoortiUtilities.check();
                        if (connectivityresult) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReverseAuction()));
                        }
                      } on SocketException catch (_) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoConnection()));
                      }
                    },
                    leading: Icon(Icons.settings_backup_restore),
                    title: Text('My Reverse Auction')),
              ],
              //padding: new EdgeInsets.only(left:0) ,
            ),
          if ((usertype == "4" && moduleaccess == "NA") || moduleaccess.contains("4"))
            SizedBox(
              height: 1,
              child: const DecoratedBox(
                decoration: const BoxDecoration(color: Colors.teal),
              ),
            ),
          if((usertype == "4" && moduleaccess == "NA") || moduleaccess.contains("4"))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                  child: const DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.white),
                  ),
                ),
                Text('Bill Tracking', style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  textAlign: TextAlign.start,
                ),
                ListTile(
                    onTap: () async {
                      try {
                        var connectivityresult = await AapoortiUtilities.check();
                        if (connectivityresult) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PendingBill()));
                        }
                      } on SocketException catch (_) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
                      }
                    },
                    leading: Icon(Icons.assignment),
                    title: Text('My Pending Bills')),
                ListTile(
                    onTap: () async {
                      try {
                        var connectivityresult = await AapoortiUtilities.check();
                        if (connectivityresult) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ClosedBill()));
                        }
                      } on SocketException catch (_) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoConnection()));
                      }
                    },
                    leading: Icon(Icons.assignment),
                    title: Text('My Closed Bills')),
              ],
            ),
          if ((usertype == "0" && moduleaccess == "NA") || moduleaccess.contains("0"))
            SizedBox(
              height: 1,
              child: const DecoratedBox(
                decoration: const BoxDecoration(color: Colors.teal),
              ),
            ),
          if((usertype == "0" && moduleaccess == "NA") || moduleaccess.contains("0"))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                  child: const DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.white),
                  ),
                ),
                Text(
                  'Reply and Comments',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  textAlign: TextAlign.start,
                ),
                ListTile(
                    onTap: () async {
                      try {
                        var connectivityresult = await AapoortiUtilities.check();
                        if (connectivityresult) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MobileAppQuery()));
                        }
                      } on SocketException catch (_) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoConnection()));
                      }
                    },
                    leading: Icon(Icons.comment),
                    title: Text('Mobile App Query')),
                ListTile(
                    onTap: () async {
                      try {
                        var connectivityresult = await AapoortiUtilities.check();
                        if (connectivityresult) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PendingQuery()));
                        }
                      } on SocketException catch (_) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new NoConnection()));
                      }
                    },
                    leading: Icon(Icons.reply),
                    title: Text('My Helpdesk Queries')),
              ],
            ),
          if((usertype == "4" && moduleaccess == "NA") || moduleaccess.contains("4"))
            SizedBox(
              height: 1,
              child: const DecoratedBox(decoration: const BoxDecoration(color: Colors.teal)),
            ),
          if((usertype == "4" && moduleaccess == "NA") || moduleaccess.contains("4"))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                  child: const DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.white),
                  ),
                ),
                Text(
                  'View Contracts',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  textAlign: TextAlign.start,
                ),
                ListTile(
                    onTap: () async {
                      try {
                        var connectivityresult = await AapoortiUtilities.check();
                        if (connectivityresult) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PurchaseOrders()));
                        }
                      } on SocketException catch (_) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoConnection()));
                      }
                    },
                    leading: Icon(Icons.border_color),
                    title: Text('My PO/RNote/RChallan')),
              ],
            ),
          SizedBox(
            height: 1,
            child: const DecoratedBox(
              decoration: const BoxDecoration(color: Colors.teal),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
                child: const DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              Text(
                'My Account',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
                textAlign: TextAlign.start,
              ),
              ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChangePin()));
                  },
                  leading: Icon(Icons.pin_drop),
                  title: Text('Change PIN')),
                  ListTile(
                    onTap: (){
                      if(_scaffoldKey.currentState!.isDrawerOpen) {
                        _scaffoldKey.currentState!.closeDrawer();
                        WarningAlertDialog().logOut(context, () {AapoortiUtilities.callWebServiceLogout1(context);});
                      }
                    },
                    leading: Icon(Icons.power_settings_new),
                    title:Text('Logout')

                )
            ],
            //padding: new EdgeInsets.only(left:0) ,
          ),
        ],
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
      ),
    );
  }

  static Future<List<dynamic>> fetchPostPostLogin(String webServiceModuleUrl, String inputParamName, String inputParam1, String inputParam2) async {
    //Json Values For Post Param
    Map<String, dynamic> urlinput = {
      "param1": "$inputParam1",
      "param2": "$inputParam2"
    };
    debugPrint(urlinput.toString());
    String urlInputString = json.encode(urlinput);
    //Form Body For URL
    String formBody = inputParamName + '=' + Uri.encodeQueryComponent(urlInputString);
    var url = AapoortiConstants.webServiceUrl + webServiceModuleUrl;
    debugPrint("url = " + url);

    final response = await http.post(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
    },
    body: formBody, encoding: Encoding.getByName("utf-8"));
    debugPrint("resp##### ${response.body}");
    if(!response.body.contains('[{"ErrorCode')) {
      debugPrint(response.body);
      List<dynamic> jsonResult = json.decode(response.body);
      debugPrint("Form body = " + json.encode(formBody).toString());
      debugPrint("Json result = " + jsonResult.toString());
      debugPrint("Response code = " + response.statusCode.toString());
      return jsonResult;
    } else {
      jsonResult = [];
      return jsonResult!;
    }
  }

  static Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      debugPrint('Internet not available');
      return false;
    }
    return false;
  }

  static Future<void> openStore(BuildContext context) async{
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

  static void setUserDetails(var jsonResult) {
    user = UserDetails(
        jsonResult[0]['C_TOKEN'].toString(),
        jsonResult[0]['S_TOKEN'].toString(),
        jsonResult[0]['MAP_ID'].toString(),
        jsonResult[0]['EMAIL_ID'].toString(),
        jsonResult[0]['MOBILE'].toString(),
        jsonResult[0]['USER_NAME'].toString(),
        jsonResult[0]['USER_TYPE'].toString(),
        jsonResult[0]['U_VALUE'].toString(),
        jsonResult[0]['LAST_LOG_TIME'].toString(),
        jsonResult[0]['FIRM_NAME'].toString(),
        jsonResult[0]['MODULE_ACCESS'].toString(),
        jsonResult[0]['WK_AREA'].toString(),
        jsonResult[0]['WK_AREA'].toString() == 'NA' ? 'PT' : jsonResult[0]['WK_AREA'].toString(),
        jsonResult[0]['ORG_ZONE'].toString());
  }
}

class UserDetails {
  String C_TOKEN,
      S_TOKEN,
      MAP_ID,
      EMAIL_ID,
      MOBILE,
      USER_NAME,
      USER_TYPE,
      U_VALUE,
      LAST_LOG_TIME,
      FIRM_NAME,
      MODULE_ACCESS,
      DEFAULT_WK_AREA,
      //Work area to display in userhome only
      CUSTOM_WK_AREA,
      ORG_ZONE; //Work area to pass in web services

  UserDetails(
      this.C_TOKEN,
      this.S_TOKEN,
      this.MAP_ID,
      this.EMAIL_ID,
      this.MOBILE,
      this.USER_NAME,
      this.USER_TYPE,
      this.U_VALUE,
      this.LAST_LOG_TIME,
      this.FIRM_NAME,
      this.MODULE_ACCESS,
      this.DEFAULT_WK_AREA,
      this.CUSTOM_WK_AREA,
      this.ORG_ZONE);
}
