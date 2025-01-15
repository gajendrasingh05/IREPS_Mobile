import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/CommonParamData.dart';
import 'package:flutter_app/aapoorti/common/NoConnection.dart';
import 'package:flutter_app/aapoorti/helpdesk/problemreport/ReportOpt.dart';
import 'package:flutter_app/aapoorti/home/auction/lease_payment_status/lease_payment_status_screen.dart';
import 'package:flutter_app/aapoorti/home/generate_otp.dart';
import 'package:flutter_app/aapoorti/home/tender/closedra/ClosedRA.dart';
import 'package:flutter_app/aapoorti/models/CountryCode.dart';
import 'package:flutter_app/aapoorti/views/search_po_oz_screen.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/screens/login_screen.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/mmis/helpers/di_services.dart' as di_service;

class HomeScreen extends StatefulWidget {
  static var projectVersion;
  static var isLoading = true;
  final GlobalKey<ScaffoldState> scaffoldKey;
  HomeScreen(this.scaffoldKey);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic>? jsonResult;
  int? rowCount;
  bool visibilityClosing = true;
  bool visibilityClosed = true;
  bool visibilityLive = true;
  bool visibilityUp = true;
  bool visibilitySched = true;
//---------------COMMON-PARAM-DATA---------------------------------------------//

  String? localCurrVer;
  String? globalCurrVer, globalLastAppVer;

  Future<void> fetchPost() async {
    try {
      var v = AapoortiConstants.webServiceUrl + 'Common/CommonParam';
      List<dynamic> jsonResult;
      final response = await http.post(Uri.parse(v));
      jsonResult = json.decode(response.body);

      String paramValue = jsonResult.toString();
      List paramList = paramValue.split("#");

      String ForceUpFlagStr = paramList[0];
      List ForceUpFlagVal = ForceUpFlagStr.split("=");
      CommonParamData.ForceUpFlagVal = ForceUpFlagVal[1].trim();
      //print(ForceUpFlagVal);

      String LiveAucCountStr = paramList[1];
      List LiveAucCountVal = LiveAucCountStr.split("=");
      CommonParamData.LiveAucCountVal = LiveAucCountVal[1].trim();
      //print(LiveAucCountVal);

      String UpAucCountStr = paramList[3];
      List UpAucCountVal = UpAucCountStr.split("=");
      CommonParamData.UpAucCountVal = UpAucCountVal[1].trim();
      //print(UpAucCountVal);

      String AucSchedCountStr = paramList[5];
      List AucSchedCountVal = AucSchedCountStr.split("=");
      CommonParamData.AucSchedCountVal = AucSchedCountVal[1].trim();
      //print(AucSchedCountVal);

      String ClosingtodayCountStr = paramList[7];
      List ClosingTodayCountVal = ClosingtodayCountStr.split("=");
      CommonParamData.ClosingTodayCountVal = ClosingTodayCountVal[1].trim();
      //print(ClosingTodayCountVal);

      String dashboardUpdateStr = paramList[9];
      List dashboardUpdateFlag = dashboardUpdateStr.split("=");
      CommonParamData.dashboardUpdateFlag = dashboardUpdateFlag[1].trim();
      //print(dashboardUpdateFlag);

      String bannedfirmsCountStr = paramList[10];
      List bannedFirmsCount = bannedfirmsCountStr.split("=");
      CommonParamData.bannedFirmsCount = bannedFirmsCount[1].trim();
      //print(bannedFirmsCount);

      String closedRACountStr = paramList[11];
      List closedRACount = closedRACountStr.split("=");
      CommonParamData.closedRACount = closedRACount[1].trim();
      //print(closedRACount);

      //For pagination starts
      String LiveAucPagesStr = paramList[2];
      List LiveAucPageVal = LiveAucPagesStr.split("=");
      CommonParamData.LiveAucPageVal = LiveAucPageVal[1].trim();
      //print(LiveAucPageVal);

      String UpAucPagesStr = paramList[4];
      List UpAucPageVal = UpAucPagesStr.split("=");
      CommonParamData.UpAucPageVal = UpAucPageVal[1].trim();
      //print(UpAucPageVal);

      String AucSchedPagesStr = paramList[6];
      List AucSchedPageVal = AucSchedPagesStr.split("=");
      CommonParamData.AucSchedPageVal = AucSchedPageVal[1].trim();
      //print(AucSchedPageVal);

      String closingTodayPagesStr = paramList[8];
      List ClosingTodayPageVal = closingTodayPagesStr.split("=");
      CommonParamData.ClosingTodayPageVal = ClosingTodayPageVal[1].trim();
      //print(ClosingTodayPageVal);
      //For pagination ends
      if(this.mounted)
        setState(() {
          HomeScreen.isLoading = HomeScreen.isLoading & false;
        });
    } on Exception catch (_) {
      fetchPost();
    }
  }

  //**********DASHBOARD*****************

  final dbHelper = DatabaseHelper.instance;
  void fetchPostDS() async {
    try {
      if(await AapoortiUtilities.check() == false) {
        rowCount = await dbHelper.rowCountd();
        if (rowCount! > 0) {
          debugPrint('Fetching from local DB');
          jsonResult = await dbHelper.fetchd();
          AapoortiConstants.jsonResult1 = jsonResult!;
        }
      } else {
        var v = AapoortiConstants.webServiceUrl + 'Common/DashboardData';
        debugPrint(v);
        final response = await http.post(Uri.parse(v));
        jsonResult = json.decode(response.body);
        AapoortiConstants.jsonResult1 = jsonResult!;
        debugPrint("my data 1 ${jsonResult.toString()}");

        for (int index = 0; index < jsonResult!.length; index++) {
          Map<String, dynamic> row = {
            DatabaseHelper.Tbld_Col1_MODULE: jsonResult![index]['MODULE'],
            DatabaseHelper.Tbld_Col2_UNIQUEGRAPHID: jsonResult![index]['UNIQUEGRAPHID'],
            DatabaseHelper.Tbld_Col3_HEADING: jsonResult![index]['HEADING'],
            DatabaseHelper.Tbld_Col4_XAXIS: jsonResult![index]['XAXIS'],
            DatabaseHelper.Tbld_Col5_YAXIS: jsonResult![index]['YAXIS'],
            DatabaseHelper.Tbld_Col6_LEGEND: jsonResult![index]['LEGEND'],
            DatabaseHelper.Tbld_Col7_LASTUPDATEDON: jsonResult![index]['LASTUPDATEDON'],
            DatabaseHelper.Tbld_Col9_UPDATEDFLAG: jsonResult![index]['UPDATEDFLAG'],
            DatabaseHelper.Tbld_Col8_CREATION_TIME: jsonResult![index]['CREATION_TIME'],
          };
          final id = dbHelper.insertd(row);
        }
      }
      if (this.mounted)
        setState(() {
          HomeScreen.isLoading = HomeScreen.isLoading & false;
        });
    } on Exception catch (_) {}
  }

  //----------------------------COMMON-PARAM-DATA------------------------------------//
  //Version Control
  var appVersion, sqfliteVersion, webServiceVersion;

  Future<void> fetchVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String version = packageInfo.version;
      localCurrVer = packageInfo.buildNumber;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var v = await Network.postDataWithAPIM(
          'UDMAPPVersion/V1.0.0/UDMAPPVersion',
          'UDMAPPVersion',
          '',
          prefs.getString('token'));
      //var v = AapoortiConstants.webServiceUrl + 'Common/GetVersionDtls?input=GetVersionDtls,' + version;
      debugPrint(v);
      List<dynamic> jsonResult;
      final response = await http.post(Uri.parse(v));
      jsonResult = json.decode(response.body);

      debugPrint("json result data ${jsonResult.toString()}");
      // if(jsonResult.isEmpty) {
      //   Timer(Duration(seconds: 2), () => Navigator.of(context).pushReplacementNamed("/common_screen"));
      // }
      // else {
      //   int index = 0;
      //   for (index = 0; index < jsonResult.length; index++) {
      //     print(jsonResult[index]["PARAM_NAME"]);
      //     print(jsonResult[index]["PARAM_VALUE"]);
      //
      //     if (jsonResult[index]["PARAM_NAME"].toString() == "Appdaysleft") {
      //       finalDate = jsonResult[index]["PARAM_VALUE"];
      //     }
      //     if(jsonResult[index]["PARAM_NAME"].toString() == "CurrentVersionCode")
      //     {
      //       globalCurrVer = jsonResult[index]["PARAM_VALUE"];
      //       if(globalCurrVer?.compareTo(localCurrVer!) == 0) {
      //         Timer(Duration(seconds: 3), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CommonScreen())));
      //       }
      //     }
      //     if (jsonResult[index]["PARAM_NAME"].toString() == "LastVersionCode") {
      //       globalLastAppVer = jsonResult[index]["PARAM_VALUE"];
      //       if (globalLastAppVer?.compareTo(localCurrVer!) == 0) {
      //         var now = DateTime.now();
      //         DateTime finalDatecomp = DateTime.parse(finalDate);
      //         print(now.toIso8601String());
      //         print(finalDatecomp.toIso8601String());
      //         if(now.toIso8601String().compareTo(finalDatecomp.toIso8601String()) > 0) {
      //           Navigator.of(context).pop();
      //           _showVersionDDialog(context);
      //         } else {
      //           _showVersionDialog(context);
      //           count = 1;
      //         }
      //       }
      //       print("daman");
      //       print(globalLastAppVer);
      //       print(localCurrVer);
      //
      //       print(int.parse(globalLastAppVer!) > int.parse(localCurrVer!));
      //
      //       if (int.parse(globalLastAppVer!) > int.parse(localCurrVer!)) {
      //         _showVersionDDialog(context);
      //       }
      //     }
      //   }
      //   if((index == jsonResult.length) && !(int.parse(globalLastAppVer!) > int.parse(localCurrVer!))) if (count == 1) {}
      //   else {
      //     count = 0;
      //     Timer(Duration(seconds: 3), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CommonScreen())));
      //   }
      // }
    } catch (e) {
      Timer(Duration(seconds: 2), () => Navigator.of(context).pushReplacementNamed("/common_screen"));
      debugPrint("splash screen exception ${e.toString()}");
    }
  }

  void versionControl() async {
    //final dbhelper = DatabaseHelper.instance;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.buildNumber;
    debugPrint("appVersion = " + appVersion);
    HomeScreen.projectVersion =
        "${packageInfo.version}(${packageInfo.buildNumber})";
    AapoortiUtilities.version = HomeScreen.projectVersion;
    debugPrint("Version = " + HomeScreen.projectVersion);
  }

  //AnimationController? _controller;
  //Animation<double>? _animation;

  //----------------
  late AnimationController _animationController;
  late Animation<Offset> _leftButtonAnimation;
  late Animation<Offset> _rightButtonAnimation;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final mobileController = TextEditingController();

  void _countvisible(bool visibility, String field) {
    setState(() {
      if (field == "fetched") {
        visibilityClosing = visibility;
        visibilityClosed = visibility;
        visibilityLive = visibility;
        visibilityUp = visibility;
        visibilitySched = visibility;
      } else {
        visibilityClosing = false;
        visibilityClosed = false;
        visibilityLive = false;
        visibilityUp = false;
        visibilitySched = false;
      }
    });
  }

  void requestWritePermission() async {
    PermissionStatus permissionStatus = await Permission.storage.request();
    if(permissionStatus != true) {
      debugPrint("status  not true");
      bool isshown = await Permission.storage.shouldShowRequestRationale;
      debugPrint(isshown.toString());

      Map<Permission, PermissionStatus> permissions = await [Permission.storage].request();
      if (this.mounted) setState(() {});
    } else {
      if(this.mounted)
        setState(() {});
    }
  }

//----------------------------EXIT-APP-SHEET------------------------------------//
  void _onBackPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 150,
            child: Container(
              child: _buildBottomNavigationMenu(),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  Column _buildBottomNavigationMenu() {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 20)),
        Text(
          "Do you want to exit from application?",
          style: TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 40.0, top: 30.0)),
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
            Padding(padding: EdgeInsets.only(right: 20.0, top: 40.0)),
            MaterialButton(
              onPressed: () => SystemNavigator.pop(),
              //exit(0)/*Navigator.of(context).pop(true)*/,
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
        Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 65.0, top: 40.0)),
            MaterialButton(
              child: Text("Rate Us",
                  style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              onPressed: () {
                AapoortiUtilities.openStore(context);
                // LaunchReview.launch(
                //   //StoreRedirect.redirect(
                //   androidAppId: "in.gov.ireps",
                //   iOSAppId: "1462024189",
                // );
              },
            ),
            Padding(padding: EdgeInsets.only(left: 70.0, top: 40.0)),
            MaterialButton(
              onPressed: () {
                ReportaproblemOpt.rec = "0";
                Navigator.pushNamed(context, "/report");
              },
              child: Text("Report Problem",
                  style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            )
          ],
        )
      ],
    );
  }
//----------------------------EXIT-APP-SHEET------------------------------------//

  //----------------------------IMAGE-SLIDESHOW------------------------------------//
  //CarouselSlider? carouselSlider;
  //final CarouselController carouselController = CarouselController();
  int _current = 0;
  List imgList = [
    'assets/vandebharat.jpg',
    'assets/image22.png',
    'assets/image29.jpg',
    'assets/image32.jpg',
    'assets/image36.png',
    'assets/image40.png',
  ];

  final List<Map<String, String>> etenderitems = [
    {"image": "assets/search.png", "text": "Custom\nSearch"},
    {"image": "assets/closingtoday.png", "text": "Closing\nToday"},
    {"image": "assets/pohome.jpeg", "text": "Tender\nStatus"},
    {"image": "assets/highvaluetender.png", "text": "High Value\nTender"},
    {"image": "assets/live.png", "text": "Live &\nUpcoming-RA"},
    {"image": "assets/closed_tender_login.png", "text": "Closed-RA"},
    {"image": "assets/search_po_z.png", "text": "Search PO"},
    {"image": "assets/images/phoneotp.png", "text": "Generate\nOTP"},
  ];

  final List<Map<String, String>> eauctionitems = [
    {"image": "assets/bill.png", "text": "Parcel Payment"},
    {"image": "assets/radio.png", "text": "Live"},
    {"image": "assets/live.png", "text": "Upcoming"},
    {"image": "assets/vpl.png", "text": "Published Lot"},
    {"image": "assets/closingtoday.png", "text": "Schedules"},
    {"image": "assets/search.png", "text": "Lot Search(Sale)"},
    {"image": "assets/pdf.png", "text": "e-Sale Condition"},
    {"image": "assets/pdf.png", "text": "Auctioning Units"},
  ];

  ProgressDialog? pr;

  @override
  void initState() {
    super.initState();
    this.fetchPost();
    this.fetchPostDS();
    //fetchVersion();
    requestWritePermission();
    //version-control
    versionControl();
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 500),
    // );
    // _animation = CurvedAnimation(parent: _controller!, curve: Curves.bounceIn);
    // _controller!.forward();

    // Initialize the AnimationController
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1400), // Animation duration
      vsync: this,
    );

    // Define the animations for the buttons
    _leftButtonAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Start off-screen to the left
      end: const Offset(0.0, 0.0),    // End at the center
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut, // Smooth easing for the animation
    ));

    _rightButtonAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Start off-screen to the right
      end: const Offset(0.0, 0.0),   // End at the center
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut, // Smooth easing for the animation
    ));

    // Start the animation when the screen is loaded
    _animationController.forward();

    pr = ProgressDialog(context);

    //_showOverlay(context);
  }

  @override
  void dispose() {
    //_controller!.dispose();
    _animationController.dispose(); // Dispose the animation controller
    mobileController.dispose();
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                //SizedBox(height: 5.0),
                // Stack (
                //     children: [
                //       CarouselSlider(
                //         items: imgList.map((imgUrl) {
                //           return Container(
                //             width: MediaQuery.of(context).size.width,
                //             margin: EdgeInsets.symmetric(horizontal: 6.0),
                //             decoration: BoxDecoration(
                //                 color: Colors.white,
                //                 image: DecorationImage(
                //                     image: AssetImage(imgUrl),
                //                     fit: BoxFit.cover),
                //                 borderRadius: BorderRadius.circular(5)),
                //           );
                //         }).toList(),
                //         carouselController: carouselController,
                //         options: CarouselOptions(
                //           initialPage: 0,
                //           //aspectRatio: 16/9,
                //           //viewportFraction: 0.8,
                //           //autoPlay: true,
                //           reverse: false,
                //           enlargeCenterPage: true,
                //           enableInfiniteScroll: true,
                //           autoPlayInterval: Duration(seconds: 2),
                //           autoPlayAnimationDuration: Duration(milliseconds: 1000),
                //           pauseAutoPlayOnTouch: true,
                //           scrollDirection: Axis.horizontal,
                //           scrollPhysics: const BouncingScrollPhysics(),
                //           autoPlay: true,
                //           aspectRatio: 2,
                //           viewportFraction: 1,
                //           onPageChanged: (index, reason) {
                //             setState(() {
                //               _current = index;
                //             });
                //           },
                //         ),
                //       ),
                //       Positioned(
                //         bottom: 10,
                //         left: 0,
                //         right: 0,
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: imgList.asMap().entries.map((entry) {
                //             return GestureDetector(
                //               onTap: () => carouselController.animateToPage(entry.key),
                //               child: Container(
                //                 width: _current == entry.key ? 17 : 7,
                //                 height: 7.0,
                //                 margin: const EdgeInsets.symmetric(
                //                   horizontal: 3.0,
                //                 ),
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(10),
                //                     color: _current == entry.key
                //                         ? Colors.cyan[400]
                //                         : Colors.teal.shade100),
                //               ),
                //             );
                //           }).toList(),
                //         ),
                //       ),
                //     ]),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: map<Widget>(imgList, (index, url) {
                //     return Container(
                //       width: 10.0,
                //       height: 1.0,
                //       margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                //     );
                //   }),
                // ),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(width: 1, color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 5.0),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0)),
                          color: Colors.cyan[700],
                        ),
                        child: Text(
                          'E-Tender',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 230,
                        width: size.width,
                        child: GridView.builder(
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.85,
                              crossAxisCount: 4, // Number of items per row
                              crossAxisSpacing: 0.0, // Horizontal space between items
                              mainAxisSpacing: 16.0, // Vertical space between items
                            ),
                            itemCount: etenderitems.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Column(
                                  children: <Widget>[
                                    Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      surfaceTintColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3),
                                        side: BorderSide(
                                          width: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 5.0),
                                          Image.asset(
                                              etenderitems[index]['image']!,
                                              width: 30,
                                              height: 30),
                                          SizedBox(height: 5.0),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(child: Text(
                                                  etenderitems[index]['text']! == "Closing\nToday" ? 'Closing\nToday(${CommonParamData.ClosingTodayCountVal.trim()})' :
                                                  etenderitems[index]['text']! == "Closed-RA" ? 'Closed-RA\n(${CommonParamData.closedRACount.replaceAll("}]", "")})' : etenderitems[index]['text']!,
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: TextStyle(color: Colors.black, fontSize: 12)))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  bool check = await AapoortiUtilities.checkConnection();
                                  if (check == true) {
                                    if (etenderitems[index]['text'] == "Custom\nSearch") {
                                      Navigator.pushNamed(context, "/custom");
                                    }
                                    else if(etenderitems[index]['text'] == "Closing\nToday") {
                                      if(CommonParamData.ClosingTodayCountVal.trim() == "") {
                                        this.fetchPost();
                                        if(CommonParamData.ClosingTodayCountVal.trim() != "") {
                                          this.fetchPost();
                                          _countvisible(true, "fetched");
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Please try again!"),
                                          duration: const Duration(seconds: 1),
                                          backgroundColor:
                                              Colors.redAccent[100],
                                        ));
                                      } else {
                                        if (CommonParamData.ClosingTodayCountVal == "0") {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text("Presently there is no tender closing today!"),
                                            duration: const Duration(seconds: 1),
                                            backgroundColor: Colors.redAccent[100],
                                          ));
                                        } else
                                          Navigator.pushNamed(context, "/closing_today");
                                      }
                                    }
                                    else if(etenderitems[index]['text'] == "Tender\nStatus"){
                                      Navigator.pushNamed(context, "/tender_status");
                                    }
                                    else if(etenderitems[index]['text'] == "High Value\nTender"){
                                      Navigator.pushNamed(context, "/high_tender");
                                    }
                                    else if(etenderitems[index]['text'] ==  "Live &\nUpcoming-RA"){
                                      Navigator.pushNamed(context, "/live_upcoming_ra");
                                    }
                                    else if(etenderitems[index]['text'] == "Closed-RA"){
                                      if(CommonParamData.closedRACount.trim() == "") {
                                         if(CommonParamData.closedRACount.trim() != "") {
                                           _countvisible(true, "fetched");
                                         }
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please try again!"), duration: const Duration(seconds: 1), backgroundColor: Colors.redAccent[100],));
                                         }
                                         else {
                                           if(CommonParamData.closedRACount == "0") {
                                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                            content: Text("Presently there is no closed RA!"),
                                                            duration: const Duration(seconds: 1),
                                                            backgroundColor: Colors.redAccent[100],
                                                ));
                                             }
                                             else
                                               Navigator.push(context, MaterialPageRoute(builder: (context) => CloseRA()));
                                        }
                                    }
                                    else if(etenderitems[index]['text'] == "Search PO"){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPoOtherZonalScreen()));
                                    }
                                    else if(etenderitems[index]['text'] == "Generate\nOTP"){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateOtpScreen()));
                                    }
                                  }
                                  else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NoConnection()));
                                  }
                                },
                              );
                            }),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //Left Button with animation
                      SlideTransition(
                        position: _leftButtonAnimation,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red.shade300, // Text color
                            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Rounded corners
                            ),
                            side: const BorderSide(color: Colors.black, width: 1), // Border
                            elevation: 10, // Elevation for shadow effect
                          ),
                          child: const Text('UDM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ),

                      // Right Button with animation
                      SlideTransition(
                        position: _rightButtonAnimation,
                        child: ElevatedButton(
                          onPressed: (){
                             //Get.toNamed(Routes.performanceDB);
                             //await di_service.init();
                             Get.toNamed(Routes.loginScreen);
                            //Get.toNamed(Routes.homeScreen);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo.shade600,
                            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Rounded corners
                            ),
                            side: const BorderSide(color: Colors.black, width: 1), // Border
                            elevation: 10, // Elevation for shadow effect
                          ),
                          child: const Text('CRIS MMIS',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(width: 1, color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 5.0),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0)),
                          color: Colors.cyan[700],
                        ),
                        child: Text(
                          'E-Auction (Leasing & Sale)',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 230,
                        width: size.width,
                        child: GridView.builder(
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.85,
                              crossAxisCount: 4, // Number of items per row
                              crossAxisSpacing: 0.0, // Horizontal space between items
                              mainAxisSpacing: 16.0, // Vertical space between items
                            ),
                            itemCount: eauctionitems.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Column(
                                  children: <Widget>[
                                    Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      surfaceTintColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3),
                                        side: BorderSide(
                                          width: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 5.0),
                                          Image.asset(
                                              eauctionitems[index]['image']!,
                                              width: 30,
                                              height: 30),
                                          SizedBox(height: 5.0),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(child: Text(
                                                  eauctionitems[index]['text']! == "Live" ? 'Live\n(${CommonParamData.LiveAucCountVal.trim()})' :
                                                  eauctionitems[index]['text']! == "Upcoming" ? 'Upcoming\n(${CommonParamData.UpAucCountVal.trim()})' :
                                                  eauctionitems[index]['text']! == "Schedules" ? 'Schedules\n(${CommonParamData.AucSchedCountVal.trim()})' : eauctionitems[index]['text']!,
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12)))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  bool check = await AapoortiUtilities.checkConnection();
                                  if (check == true) {
                                    if (eauctionitems[index]['text'] == "Parcel Payment") {
                                      Navigator.pushNamed(context, LeasePaymentStatus.routeName);
                                      //Navigator.pushNamed(context, "/custom");
                                    }
                                    else if(eauctionitems[index]['text'] == "Live") {
                                      if (CommonParamData.LiveAucCountVal
                                          .trim() ==
                                          "") {
                                        this.fetchPost();
                                        if (CommonParamData.LiveAucCountVal
                                            .trim() !=
                                            "") {
                                          this.fetchPost();
                                          _countvisible(true, "fetched");
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Please try again!"),
                                          duration: const Duration(seconds: 1),
                                          backgroundColor: Colors.redAccent[100],
                                        ));
                                      } else {
                                        if (CommonParamData.LiveAucCountVal ==
                                            "0") {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Presently there is no Live Auction!"),
                                            duration: const Duration(seconds: 1),
                                            backgroundColor:
                                            Colors.redAccent[100],
                                          ));
                                        } else
                                          Navigator.pushNamed(
                                              context, "/live_auction");
                                      }
                                    }
                                    else if(eauctionitems[index]['text'] == "Upcoming") {
                                      if (CommonParamData.UpAucCountVal.trim() == "") {
                                        this.fetchPost();
                                        if(CommonParamData.UpAucCountVal.trim() != "") {
                                          this.fetchPost();
                                          _countvisible(true, "fetched");
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Please try again!"),
                                          duration: const Duration(seconds: 1),
                                          backgroundColor: Colors.redAccent[100],
                                        ));
                                      } else {
                                        if (CommonParamData.UpAucCountVal ==
                                            "0") {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Presently there is no Upcoming Auction!"),
                                            duration: const Duration(seconds: 1),
                                            backgroundColor:
                                            Colors.redAccent[100],
                                          ));
                                        } else
                                          Navigator.pushNamed(context, "/upcoming");
                                      }
                                    }
                                    else if(eauctionitems[index]['text'] == "Published Lot"){
                                      Navigator.pushNamed(context, "/published_lot");
                                    }
                                    else if(eauctionitems[index]['text'] ==  "Schedules"){
                                      if (CommonParamData.AucSchedCountVal
                                          .trim() ==
                                          "") {
                                        this.fetchPost();
                                        if (CommonParamData.AucSchedCountVal
                                            .trim() !=
                                            "") {
                                          this.fetchPost();
                                          _countvisible(true, "fetched");
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Please try again!"),
                                          duration: const Duration(seconds: 1),
                                          backgroundColor: Colors.redAccent[100],
                                        ));
                                      } else {
                                        if (CommonParamData.AucSchedCountVal ==
                                            "0") {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Presently there is no auction scheduled!"),
                                            duration: const Duration(seconds: 1),
                                            backgroundColor:
                                            Colors.redAccent[100],
                                          ));
                                        } else
                                          Navigator.pushNamed(
                                              context, "/schedule");
                                    }}
                                    else if(eauctionitems[index]['text'] == "Lot Search(Sale)"){
                                      Navigator.pushNamed(context, "/lot_search");
                                    }
                                    else if(eauctionitems[index]['text'] == "e-Sale Condition"){
                                      var fileUrl = "https://www.ireps.gov.in//ireps/upload/resources/Uniform_E_Sale_condition.pdf";
                                      var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                                      AapoortiUtilities.ackAlert(context, fileUrl, fileName);
                                    }
                                    else if(eauctionitems[index]['text'] == "Auctioning Units"){
                                      var fileUrl = "https://www.ireps.gov.in//ireps/upload/resources/DepotContactDetails.pdf";
                                      var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                                      AapoortiUtilities.ackAlert(context, fileUrl, fileName);
                                    }
                                  }
                                  else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NoConnection()));
                                  }
                                },
                              );
                            }),
                      )
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: <Widget>[
                      //     Column(
                      //       children: <Widget>[
                      //         GestureDetector(
                      //           child: Column(
                      //             children: <Widget>[
                      //               Card(
                      //                 elevation: 0,
                      //                 color: Colors.white,
                      //                 surfaceTintColor: Colors.transparent,
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.circular(5),
                      //                   side: BorderSide(
                      //                       width: 1, color: Colors.white),
                      //                 ),
                      //                 child: Row(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.center,
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.start,
                      //                   children: [
                      //                     SizedBox(
                      //                       width: 8,
                      //                     ),
                      //                     Column(
                      //                       children: <Widget>[
                      //                         Padding(
                      //                             padding: EdgeInsets.all(
                      //                           5.0,
                      //                         )),
                      //                         Row(
                      //                           children: <Widget>[
                      //                             Image.asset(
                      //                               'assets/bill.png',
                      //                               width: 30,
                      //                               height: 30,
                      //                             )
                      //                           ],
                      //                         ),
                      //                         Padding(
                      //                             padding: EdgeInsets.only(
                      //                                 top: 8.0)),
                      //                         Row(
                      //                           children: <Widget>[
                      //                             Text(
                      //                               'Parcel Payment\nDetails',
                      //                               style: TextStyle(
                      //                                   color: Colors.black,
                      //                                   fontSize: 12),
                      //                               textAlign: TextAlign.center,
                      //                               softWrap: true,
                      //                             ),
                      //                           ],
                      //                         ),
                      //                         Padding(
                      //                             padding:
                      //                                 const EdgeInsets.only(
                      //                                     bottom: 10.0))
                      //                       ],
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           onTap: () {
                      //             Navigator.pushNamed(
                      //                 context, LeasePaymentStatus.routeName);
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //     Column(
                      //       children: <Widget>[
                      //         GestureDetector(
                      //           child: Column(
                      //             children: <Widget>[
                      //               Card(
                      //                 elevation: 0,
                      //                 color: Colors.white,
                      //                 surfaceTintColor: Colors.transparent,
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.circular(5),
                      //                   side: BorderSide(
                      //                       width: 1, color: Colors.white),
                      //                 ),
                      //                 child: Column(
                      //                   children: <Widget>[
                      //                     Padding(
                      //                         padding:
                      //                             EdgeInsets.only(top: 5.0)),
                      //                     Row(
                      //                       children: <Widget>[
                      //                         Image.asset(
                      //                           'assets/radio.png',
                      //                           width: 30,
                      //                           height: 30,
                      //                         )
                      //                       ],
                      //                     ),
                      //                     Padding(
                      //                         padding:
                      //                             EdgeInsets.only(top: 8.0)),
                      //                     Row(
                      //                       children: <Widget>[
                      //                         Text(
                      //                           ' Live   \n' +
                      //                               '(' +
                      //                               CommonParamData
                      //                                       .LiveAucCountVal
                      //                                   .trim() +
                      //                               ')',
                      //                           style: TextStyle(
                      //                               color: Colors.black,
                      //                               fontSize: 12),
                      //                           textAlign: TextAlign.center,
                      //                         ),
                      //                       ],
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           onTap: () async {
                      //             bool check =
                      //                 await AapoortiUtilities.checkConnection();
                      //             if (!check)
                      //               Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                       builder: (context) =>
                      //                           NoConnection()));
                      //             else {
                      //               if (CommonParamData.LiveAucCountVal
                      //                       .trim() ==
                      //                   "") {
                      //                 this.fetchPost();
                      //                 if (CommonParamData.LiveAucCountVal
                      //                         .trim() !=
                      //                     "") {
                      //                   this.fetchPost();
                      //                   _countvisible(true, "fetched");
                      //                 }
                      //                 ScaffoldMessenger.of(context)
                      //                     .showSnackBar(SnackBar(
                      //                   content: Text("Please try again!"),
                      //                   duration: const Duration(seconds: 1),
                      //                   backgroundColor: Colors.redAccent[100],
                      //                 ));
                      //               } else {
                      //                 if (CommonParamData.LiveAucCountVal ==
                      //                     "0") {
                      //                   ScaffoldMessenger.of(context)
                      //                       .showSnackBar(SnackBar(
                      //                     content: Text(
                      //                         "Presently there is no Live Auction!"),
                      //                     duration: const Duration(seconds: 1),
                      //                     backgroundColor:
                      //                         Colors.redAccent[100],
                      //                   ));
                      //                 } else
                      //                   Navigator.pushNamed(
                      //                       context, "/live_auction");
                      //               }
                      //             }
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //     Column(
                      //       children: <Widget>[
                      //         GestureDetector(
                      //           child: Column(
                      //             children: <Widget>[
                      //               Card(
                      //                 elevation: 0,
                      //                 color: Colors.white,
                      //                 surfaceTintColor: Colors.transparent,
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.circular(5),
                      //                   side: BorderSide(
                      //                       width: 1, color: Colors.white),
                      //                 ),
                      //                 child: Column(
                      //                   children: <Widget>[
                      //                     Padding(
                      //                         padding:
                      //                             EdgeInsets.only(top: 5.0)),
                      //                     Row(
                      //                       children: <Widget>[
                      //                         Image.asset(
                      //                           'assets/live.png',
                      //                           width: 30,
                      //                           height: 30,
                      //                         )
                      //                       ],
                      //                     ),
                      //                     Padding(
                      //                         padding:
                      //                             EdgeInsets.only(top: 8.0)),
                      //                     Row(
                      //                       children: <Widget>[
                      //                         Text(
                      //                             '  Upcoming\n' +
                      //                                 '    (' +
                      //                                 CommonParamData
                      //                                         .UpAucCountVal
                      //                                     .trim() +
                      //                                 ')',
                      //                             style: TextStyle(
                      //                                 color: Colors.black,
                      //                                 fontSize: 12),
                      //                             textAlign: TextAlign.center),
                      //                       ],
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           onTap: () async {
                      //             bool check =
                      //                 await AapoortiUtilities.checkConnection();
                      //             if (!check)
                      //               Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                       builder: (context) =>
                      //                           NoConnection()));
                      //             else {
                      //               if (CommonParamData.UpAucCountVal.trim() ==
                      //                   "") {
                      //                 this.fetchPost();
                      //                 if (CommonParamData.UpAucCountVal
                      //                         .trim() !=
                      //                     "") {
                      //                   //visibility of counts true;
                      //                   this.fetchPost();
                      //                   _countvisible(true, "fetched");
                      //                 }
                      //                 ScaffoldMessenger.of(context)
                      //                     .showSnackBar(SnackBar(
                      //                   content: Text("Please try again!"),
                      //                   duration: const Duration(seconds: 1),
                      //                   backgroundColor: Colors.redAccent[100],
                      //                 ));
                      //               } else {
                      //                 if (CommonParamData.UpAucCountVal ==
                      //                     "0") {
                      //                   ScaffoldMessenger.of(context)
                      //                       .showSnackBar(SnackBar(
                      //                     content: Text(
                      //                         "Presently there is no Upcoming Auction!"),
                      //                     duration: const Duration(seconds: 1),
                      //                     backgroundColor:
                      //                         Colors.redAccent[100],
                      //                   ));
                      //                 } else
                      //                   Navigator.pushNamed(
                      //                       context, "/upcoming");
                      //               }
                      //             }
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //     Column(
                      //       children: <Widget>[
                      //         GestureDetector(
                      //           child: Column(
                      //             children: <Widget>[
                      //               Card(
                      //                 elevation: 0,
                      //                 color: Colors.white,
                      //                 surfaceTintColor: Colors.transparent,
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.circular(5),
                      //                   side: BorderSide(
                      //                       width: 1, color: Colors.white),
                      //                 ),
                      //                 child: Column(
                      //                   children: <Widget>[
                      //                     Padding(
                      //                         padding:
                      //                             EdgeInsets.only(top: 5.0)),
                      //                     Row(
                      //                       children: <Widget>[
                      //                         Image.asset(
                      //                           'assets/vpl.png',
                      //                           width: 30,
                      //                           height: 30,
                      //                         )
                      //                       ],
                      //                     ),
                      //                     Padding(
                      //                         padding:
                      //                             EdgeInsets.only(top: 8.0)),
                      //                     Row(
                      //                       children: <Widget>[
                      //                         Text('View Published\nLot   ',
                      //                             style: TextStyle(
                      //                                 color: Colors.black,
                      //                                 fontSize: 12),
                      //                             textAlign: TextAlign.center),
                      //                       ],
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           onTap: () async {
                      //             bool check =
                      //                 await AapoortiUtilities.checkConnection();
                      //             if (check == true)
                      //               Navigator.pushNamed(
                      //                   context, "/published_lot");
                      //             else
                      //               Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                       builder: (context) =>
                      //                           NoConnection()));
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      // Padding(padding: EdgeInsets.all(15.0)),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: <Widget>[
                      //     Column(
                      //       children: <Widget>[
                      //         GestureDetector(
                      //           child: Column(
                      //             children: <Widget>[
                      //               Card(
                      //                 elevation: 0,
                      //                 color: Colors.white,
                      //                 surfaceTintColor: Colors.transparent,
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.circular(5),
                      //                   side: BorderSide(
                      //                       width: 1, color: Colors.white),
                      //                 ),
                      //                 child: Column(
                      //                   children: <Widget>[
                      //                     Padding(
                      //                         padding:
                      //                             EdgeInsets.only(top: 5.0)),
                      //                     Row(
                      //                       children: <Widget>[
                      //                         Image.asset(
                      //                           'assets/closingtoday.png',
                      //                           width: 30,
                      //                           height: 30,
                      //                         )
                      //                       ],
                      //                     ),
                      //                     Padding(
                      //                         padding:
                      //                             EdgeInsets.only(top: 8.0)),
                      //                     Row(
                      //                       children: <Widget>[
                      //                         Text(
                      //                             '   Schedules\n' +
                      //                                 '(' +
                      //                                 CommonParamData
                      //                                         .AucSchedCountVal
                      //                                     .trim() +
                      //                                 ')',
                      //                             style: TextStyle(
                      //                                 color: Colors.black,
                      //                                 fontSize: 12),
                      //                             textAlign: TextAlign.center),
                      //                       ],
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           onTap: () async {
                      //             bool check =
                      //                 await AapoortiUtilities.checkConnection();
                      //             if (!check)
                      //               Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                       builder: (context) =>
                      //                           NoConnection()));
                      //             else {
                      //               if (CommonParamData.AucSchedCountVal
                      //                       .trim() ==
                      //                   "") {
                      //                 this.fetchPost();
                      //                 if (CommonParamData.AucSchedCountVal
                      //                         .trim() !=
                      //                     "") {
                      //                   //visibility of counts true;
                      //                   this.fetchPost();
                      //                   _countvisible(true, "fetched");
                      //                 }
                      //                 ScaffoldMessenger.of(context)
                      //                     .showSnackBar(SnackBar(
                      //                   content: Text("Please try again!"),
                      //                   duration: const Duration(seconds: 1),
                      //                   backgroundColor: Colors.redAccent[100],
                      //                 ));
                      //               } else {
                      //                 if (CommonParamData.AucSchedCountVal ==
                      //                     "0") {
                      //                   ScaffoldMessenger.of(context)
                      //                       .showSnackBar(SnackBar(
                      //                     content: Text(
                      //                         "Presently there is no auction scheduled!"),
                      //                     duration: const Duration(seconds: 1),
                      //                     backgroundColor:
                      //                         Colors.redAccent[100],
                      //                   ));
                      //                 } else
                      //                   Navigator.pushNamed(
                      //                       context, "/schedule");
                      //               }
                      //             }
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //     Column(
                      //       children: <Widget>[
                      //         GestureDetector(
                      //           child: Column(
                      //             children: <Widget>[
                      //               Card(
                      //                 elevation: 0,
                      //                 color: Colors.white,
                      //                 surfaceTintColor: Colors.transparent,
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.circular(5),
                      //                   side: BorderSide(
                      //                       width: 1, color: Colors.white),
                      //                 ),
                      //                 child: Column(
                      //                   children: <Widget>[
                      //                     Padding(
                      //                         padding:
                      //                             EdgeInsets.only(top: 5.0)),
                      //                     Row(
                      //                       children: <Widget>[
                      //                         Image.asset(
                      //                           'assets/search.png',
                      //                           width: 30,
                      //                           height: 30,
                      //                         )
                      //                       ],
                      //                     ),
                      //                     Padding(
                      //                         padding:
                      //                             EdgeInsets.only(top: 8.0)),
                      //                     Row(
                      //                       children: <Widget>[
                      //                         Text('  Lot Search  \n (Sale) ',
                      //                             style: TextStyle(
                      //                                 color: Colors.black,
                      //                                 fontSize: 12),
                      //                             textAlign: TextAlign.center),
                      //                       ],
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           onTap: () async {
                      //             bool check =
                      //                 await AapoortiUtilities.checkConnection();
                      //             if (check == true)
                      //               Navigator.pushNamed(context, "/lot_search");
                      //             else
                      //               Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                       builder: (context) =>
                      //                           NoConnection()));
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //     Column(
                      //       children: <Widget>[
                      //         GestureDetector(
                      //           child: Column(
                      //             children: <Widget>[
                      //               Card(
                      //                 elevation: 0,
                      //                 color: Colors.white,
                      //                 surfaceTintColor: Colors.transparent,
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.circular(5),
                      //                   side: BorderSide(
                      //                       width: 1, color: Colors.white),
                      //                 ),
                      //                 child: Column(
                      //                   children: <Widget>[
                      //                     Padding(
                      //                         padding:
                      //                             EdgeInsets.only(top: 5.0)),
                      //                     Row(
                      //                       children: <Widget>[
                      //                         Image.asset(
                      //                           'assets/pdf.png',
                      //                           width: 30,
                      //                           height: 30,
                      //                         )
                      //                       ],
                      //                     ),
                      //                     Padding(
                      //                         padding:
                      //                             EdgeInsets.only(top: 8.0)),
                      //                     Row(
                      //                       children: <Widget>[
                      //                         Text('e-Sale \n Condition',
                      //                             style: TextStyle(
                      //                                 color: Colors.black,
                      //                                 fontSize: 12),
                      //                             textAlign: TextAlign.center),
                      //                       ],
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           onTap: () async {
                      //             bool check =
                      //                 await AapoortiUtilities.checkConnection();
                      //             if (check == true) {
                      //               var fileUrl =
                      //                   "https://www.ireps.gov.in//ireps/upload/resources/Uniform_E_Sale_condition.pdf";
                      //               var fileName = fileUrl
                      //                   .substring(fileUrl.lastIndexOf("/"));
                      //               AapoortiUtilities.ackAlert(
                      //                   context, fileUrl, fileName);
                      //             } else
                      //               Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                       builder: (context) =>
                      //                           NoConnection()));
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //     Column(
                      //       children: <Widget>[
                      //         GestureDetector(
                      //           child: Column(
                      //             children: <Widget>[
                      //               Card(
                      //                 elevation: 0,
                      //                 color: Colors.white,
                      //                 surfaceTintColor: Colors.transparent,
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.circular(5),
                      //                   side: BorderSide(
                      //                       width: 1, color: Colors.white),
                      //                 ),
                      //                 child: Column(
                      //                   children: <Widget>[
                      //                     Padding(
                      //                         padding:
                      //                             EdgeInsets.only(top: 5.0)),
                      //                     Row(
                      //                       children: <Widget>[
                      //                         Image.asset(
                      //                           'assets/pdf.png',
                      //                           width: 30,
                      //                           height: 30,
                      //                         )
                      //                       ],
                      //                     ),
                      //                     Padding(
                      //                         padding:
                      //                             EdgeInsets.only(top: 8.0)),
                      //                     Row(
                      //                       children: <Widget>[
                      //                         Text('Auctioning \n Units',
                      //                             style: TextStyle(
                      //                                 color: Colors.black,
                      //                                 fontSize: 12),
                      //                             textAlign: TextAlign.center),
                      //                       ],
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           onTap: () async {
                      //             bool check =
                      //                 await AapoortiUtilities.checkConnection();
                      //             if (check == true) {
                      //               var fileUrl =
                      //                   "https://www.ireps.gov.in//ireps/upload/resources/DepotContactDetails.pdf";
                      //               var fileName = fileUrl
                      //                   .substring(fileUrl.lastIndexOf("/"));
                      //               AapoortiUtilities.ackAlert(
                      //                   context, fileUrl, fileName);
                      //             } else
                      //               Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                       builder: (context) =>
                      //                           NoConnection()));
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //     // Column(
                      //     //   children: <Widget>[
                      //     //     GestureDetector(
                      //     //       child: Column(
                      //     //         children: <Widget>[
                      //     //           Container(
                      //     //               child: Image.asset(
                      //     //                 'assets/white.png',
                      //     //                 width: 30,
                      //     //                 height: 30,
                      //     //               )),
                      //     //           Padding(
                      //     //               padding: EdgeInsets.all(5.0)),
                      //     //           Container(
                      //     //             child: Text('                               ',
                      //     //                 style: TextStyle(
                      //     //                     color: Colors.black,
                      //     //                     fontSize: 12),
                      //     //                 textAlign: TextAlign.center),
                      //     //           ),
                      //     //         ],
                      //     //       ),
                      //     //       onTap: () {},
                      //     //     ),
                      //     //   ],
                      //     // ),
                      //     Padding(padding: EdgeInsets.only(bottom: 10.0))
                      //   ],
                      // ),
                      // Padding(padding: EdgeInsets.all(15.0)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String? getCountryCode(String usercountry) {
    String countryJson =
        '''{"CCODE":[{ "name": "Afghanistan", "dial_code": "93", "code": "AF" },
      { "name": "Aland Islands", "dial_code": "358", "code": "AX" },
      { "name": "Albania", "dial_code": "355", "code": "AL" },
      { "name": "Algeria", "dial_code": "213", "code": "DZ" },
      { "name": "AmericanSamoa", "dial_code": "1684", "code": "AS" },
      { "name": "Andorra", "dial_code": "376", "code": "AD" },
      { "name": "Angola", "dial_code": "244", "code": "AO" },
      { "name": "Anguilla", "dial_code": "1264", "code": "AI" },
      { "name": "Antarctica", "dial_code": "672", "code": "AQ" },
      { "name": "Antigua and Barbuda", "dial_code": "1268", "code": "AG" },
      { "name": "Argentina", "dial_code": "54", "code": "AR" },
      { "name": "Armenia", "dial_code": "374", "code": "AM" },
      { "name": "Aruba", "dial_code": "297", "code": "AW" },
      { "name": "Australia", "dial_code": "61", "code": "AU" },
      { "name": "Austria", "dial_code": "43", "code": "AT" },
      { "name": "Azerbaijan", "dial_code": "994", "code": "AZ" },
      { "name": "Bahamas", "dial_code": "1242", "code": "BS" },
      { "name": "Bahrain", "dial_code": "973", "code": "BH" },
      { "name": "Bangladesh", "dial_code": "880", "code": "BD" },
      { "name": "Barbados", "dial_code": "1246", "code": "BB" },
      { "name": "Belarus", "dial_code": "375", "code": "BY" },
      { "name": "Belgium", "dial_code": "32", "code": "BE" },
      { "name": "Belize", "dial_code": "501", "code": "BZ" },
      { "name": "Benin", "dial_code": "229", "code": "BJ" },
      { "name": "Bermuda", "dial_code": "1441", "code": "BM" },
      { "name": "Bhutan", "dial_code": "975", "code": "BT" },
      { "name": "Bolivia, Plurinational State of", "dial_code": "591", "code": "BO" },
      { "name": "Bosnia and Herzegovina", "dial_code": "387", "code": "BA" },
      { "name": "Botswana", "dial_code": "267", "code": "BW" },
      { "name": "Brazil", "dial_code": "55", "code": "BR" },
      { "name": "British Indian Ocean Territory", "dial_code": "246", "code": "IO" },
      { "name": "Brunei Darussalam", "dial_code": "673", "code": "BN" },
      { "name": "Bulgaria", "dial_code": "359", "code": "BG" },
      { "name": "Burkina Faso", "dial_code": "226", "code": "BF" },
      { "name": "Burundi", "dial_code": "257", "code": "BI" },
      { "name": "Cambodia", "dial_code": "855", "code": "KH" },
      { "name": "Cameroon", "dial_code": "237", "code": "CM" },
      { "name": "Canada", "dial_code": "1", "code": "CA" },
      { "name": "Cape Verde", "dial_code": "238", "code": "CV" },
      { "name": "Cayman Islands", "dial_code": " 345", "code": "KY" },
      { "name": "Central African Republic", "dial_code": "236", "code": "CF" },
      { "name": "Chad", "dial_code": "235", "code": "TD" },
      { "name": "Chile", "dial_code": "56", "code": "CL" },
      { "name": "China", "dial_code": "86", "code": "CN" },
      { "name": "Christmas Island", "dial_code": "61", "code": "CX" },
      { "name": "Cocos (Keeling) Islands", "dial_code": "61", "code": "CC" },
      { "name": "Colombia", "dial_code": "57", "code": "CO" },
      { "name": "Comoros", "dial_code": "269", "code": "KM" },
      { "name": "Congo", "dial_code": "242", "code": "CG" },
      { "name": "Congo, The Democratic Republic of the Congo", "dial_code": "243", "code": "CD" },
      { "name": "Cook Islands", "dial_code": "682", "code": "CK" },
      { "name": "Costa Rica", "dial_code": "506", "code": "CR" },
      { "name": "Cote d'Ivoire", "dial_code": "225", "code": "CI" },
      { "name": "Croatia", "dial_code": "385", "code": "HR" },
      { "name": "Cuba", "dial_code": "53", "code": "CU" },
      { "name": "Cyprus", "dial_code": "357", "code": "CY" },
      { "name": "Czech Republic", "dial_code": "420", "code": "CZ" },
      { "name": "Denmark", "dial_code": "45", "code": "DK" },
      { "name": "Djibouti", "dial_code": "253", "code": "DJ" },
      { "name": "Dominica", "dial_code": "1767", "code": "DM" },
      { "name": "Dominican Republic", "dial_code": "1849", "code": "DO" },
      { "name": "Ecuador", "dial_code": "593", "code": "EC" },
      { "name": "Egypt", "dial_code": "20", "code": "EG" },
      { "name": "El Salvador", "dial_code": "503", "code": "SV" },
      { "name": "Equatorial Guinea", "dial_code": "240", "code": "GQ" },
      { "name": "Eritrea", "dial_code": "291", "code": "ER" },
      { "name": "Estonia", "dial_code": "372", "code": "EE" },
      { "name": "Ethiopia", "dial_code": "251", "code": "ET" },
      { "name": "Falkland Islands (Malvinas)", "dial_code": "500", "code": "FK" },
      { "name": "Faroe Islands", "dial_code": "298", "code": "FO" },
      { "name": "Fiji", "dial_code": "679", "code": "FJ" },
      { "name": "Finland", "dial_code": "358", "code": "FI" },
      { "name": "France", "dial_code": "33", "code": "FR" },
      { "name": "French Guiana", "dial_code": "594", "code": "GF" },
      { "name": "French Polynesia", "dial_code": "689", "code": "PF" },
      { "name": "Gabon", "dial_code": "241", "code": "GA" },
      { "name": "Gambia", "dial_code": "220", "code": "GM" },
      { "name": "Georgia", "dial_code": "995", "code": "GE" },
      { "name": "Germany", "dial_code": "49", "code": "DE" },
      { "name": "Ghana", "dial_code": "233", "code": "GH" },
      { "name": "Gibraltar", "dial_code": "350", "code": "GI" },
      { "name": "Greece", "dial_code": "30", "code": "GR" },
      { "name": "Greenland", "dial_code": "299", "code": "GL" },
      { "name": "Grenada", "dial_code": "1473", "code": "GD" },
      { "name": "Guadeloupe", "dial_code": "590", "code": "GP" },
      { "name": "Guam", "dial_code": "1671", "code": "GU" },
      { "name": "Guatemala", "dial_code": "502", "code": "GT" },
      { "name": "Guernsey", "dial_code": "44", "code": "GG" },
      { "name": "Guinea", "dial_code": "224", "code": "GN" },
      { "name": "Guinea-Bissau", "dial_code": "245", "code": "GW" },
      { "name": "Guyana", "dial_code": "595", "code": "GY" },
      { "name": "Haiti", "dial_code": "509", "code": "HT" },
      { "name": "Holy See (Vatican City State)", "dial_code": "379", "code": "VA" },
      { "name": "Honduras", "dial_code": "504", "code": "HN" },
      { "name": "Hong Kong", "dial_code": "852", "code": "HK" },
      { "name": "Hungary", "dial_code": "36", "code": "HU" },
      { "name": "Iceland", "dial_code": "354", "code": "IS" },
      { "name": "India", "dial_code": "91", "code": "IN" },
      { "name": "Indonesia", "dial_code": "62", "code": "ID" },
      { "name": "Iran, Islamic Republic of Persian Gulf", "dial_code": "98", "code": "IR" },
      { "name": "Iraq", "dial_code": "964", "code": "IQ" },
      { "name": "Ireland", "dial_code": "353", "code": "IE" },
      { "name": "Isle of Man", "dial_code": "44", "code": "IM" },
      { "name": "Israel", "dial_code": "972", "code": "IL" },
      { "name": "Italy", "dial_code": "39", "code": "IT" },
      { "name": "Jamaica", "dial_code": "1876", "code": "JM" },
      { "name": "Japan", "dial_code": "81", "code": "JP" },
      { "name": "Jersey", "dial_code": "44", "code": "JE" },
      { "name": "Jordan", "dial_code": "962", "code": "JO" },
      { "name": "Kazakhstan", "dial_code": "77", "code": "KZ" },
      { "name": "Kenya", "dial_code": "254", "code": "KE" },
      { "name": "Kiribati", "dial_code": "686", "code": "KI" },
      { "name": "Korea, Democratic People's Republic of Korea", "dial_code": "850", "code": "KP" },
      { "name": "Korea, Republic of South Korea", "dial_code": "82", "code": "KR" },
      { "name": "Kuwait", "dial_code": "965", "code": "KW" },
      { "name": "Kyrgyzstan", "dial_code": "996", "code": "KG" },
      { "name": "Laos", "dial_code": "856", "code": "LA" },
      { "name": "Latvia", "dial_code": "371", "code": "LV" },
      { "name": "Lebanon", "dial_code": "961", "code": "LB" },
      { "name": "Lesotho", "dial_code": "266", "code": "LS" },
      { "name": "Liberia", "dial_code": "231", "code": "LR" },
      { "name": "Libyan Arab Jamahiriya", "dial_code": "218", "code": "LY" },
      { "name": "Liechtenstein", "dial_code": "423", "code": "LI" },
      { "name": "Lithuania", "dial_code": "370", "code": "LT" },
      { "name": "Luxembourg", "dial_code": "352", "code": "LU" }, 
      { "name": "Macao", "dial_code": "853", "code": "MO" },
      { "name": "Macedonia", "dial_code": "389", "code": "MK" },
      { "name": "Madagascar", "dial_code": "261", "code": "MG" },
      { "name": "Malawi", "dial_code": "265", "code": "MW" },
      { "name": "Malaysia", "dial_code": "60", "code": "MY" },
      { "name": "Maldives", "dial_code": "960", "code": "MV" },
      { "name": "Mali", "dial_code": "223", "code": "ML" },
      { "name": "Malta", "dial_code": "356", "code": "MT" },
      { "name": "Marshall Islands", "dial_code": "692", "code": "MH" },
      { "name": "Martinique", "dial_code": "596", "code": "MQ" },
      { "name": "Mauritania", "dial_code": "222", "code": "MR" },
      { "name": "Mauritius", "dial_code": "230", "code": "MU" },
      { "name": "Mayotte", "dial_code": "262", "code": "YT" },
      { "name": "Mexico", "dial_code": "52", "code": "MX" },
      { "name": "Micronesia, Federated States of Micronesia", "dial_code": "691", "code": "FM" },
      { "name": "Moldova", "dial_code": "373", "code": "MD" },
      { "name": "Monaco", "dial_code": "377", "code": "MC" },
      { "name": "Mongolia", "dial_code": "976", "code": "MN" },
      { "name": "Montenegro", "dial_code": "382", "code": "ME" },
      { "name": "Montserrat", "dial_code": "1664", "code": "MS" }, 
      { "name": "Morocco", "dial_code": "212", "code": "MA" },
      { "name": "Mozambique", "dial_code": "258", "code": "MZ" },
      { "name": "Myanmar", "dial_code": "95", "code": "MM" },
      { "name": "Namibia", "dial_code": "264", "code": "NA" },
      { "name": "Nauru", "dial_code": "674", "code": "NR" }, 
      { "name": "Nepal", "dial_code": "977", "code": "NP" },
      { "name": "Netherlands", "dial_code": "31", "code": "NL" },
      { "name": "Netherlands Antilles", "dial_code": "599", "code": "AN" },
      { "name": "New Caledonia", "dial_code": "687", "code": "NC" }, 
      { "name": "New Zealand", "dial_code": "64", "code": "NZ" },
      { "name": "Nicaragua", "dial_code": "505", "code": "NI" },
      { "name": "Niger", "dial_code": "227", "code": "NE" }, 
      { "name": "Nigeria", "dial_code": "234", "code": "NG" },
      { "name": "Niue", "dial_code": "683", "code": "NU" }, 
      { "name": "Norfolk Island", "dial_code": "672", "code": "NF" },
      { "name": "Northern Mariana Islands", "dial_code": "1670", "code": "MP" },
      { "name": "Norway", "dial_code": "47", "code": "NO" }, 
      { "name": "Oman", "dial_code": "968", "code": "OM" },
      { "name": "Pakistan", "dial_code": "92", "code": "PK" }, 
      { "name": "Palau", "dial_code": "680", "code": "PW" },
      {"name": "Palestinian Territory, Occupied", "dial_code": "970", "code": "PS" }, 
      { "name": "Panama", "dial_code": "507", "code": "PA" },
      { "name": "Papua New Guinea", "dial_code": "675", "code": "PG" }, 
      { "name": "Paraguay", "dial_code": "595", "code": "PY" },
      { "name": "Peru", "dial_code": "51", "code": "PE" }, 
      { "name": "Philippines", "dial_code": "63", "code": "PH" },
      { "name": "Pitcairn", "dial_code": "872", "code": "PN" }, 
      { "name": "Poland", "dial_code": "48", "code": "PL" },
      { "name": "Portugal", "dial_code": "351", "code": "PT" }, 
      { "name": "Puerto Rico", "dial_code": "1939", "code": "PR" },
      { "name": "Qatar", "dial_code": "974", "code": "QA" }, 
      { "name": "Romania", "dial_code": "40", "code": "RO" },
      { "name": "Russia", "dial_code": "7", "code": "RU" }, 
      { "name": "Rwanda", "dial_code": "250", "code": "RW" },
      { "name": "Reunion", "dial_code": "262", "code": "RE" }, 
      { "name": "Saint Barthelemy", "dial_code": "590", "code": "BL" },
      { "name": "Saint Helena, Ascension and Tristan Da Cunha", "dial_code": "290", "code": "SH" },
      { "name": "Saint Kitts and Nevis", "dial_code": "1869", "code": "KN" }, 
      { "name": "Saint Lucia", "dial_code": "1758", "code": "LC" },
      { "name": "Saint Martin", "dial_code": "590", "code": "MF" }, 
      { "name": "Saint Pierre and Miquelon", "dial_code": "508", "code": "PM" },
      { "name": "Saint Vincent and the Grenadines", "dial_code": "1784", "code": "VC" }, 
      { "name": "Samoa", "dial_code": "685", "code": "WS" },
      { "name": "San Marino", "dial_code": "378", "code": "SM" }, 
      { "name": "Sao Tome and Principe", "dial_code": "239", "code": "ST" },
      { "name": "Saudi Arabia", "dial_code": "966", "code": "SA" }, 
      { "name": "Senegal", "dial_code": "221", "code": "SN" },
      { "name": "Serbia", "dial_code": "381", "code": "RS" }, 
      { "name": "Seychelles", "dial_code": "248", "code": "SC" },
      { "name": "Sierra Leone", "dial_code": "232", "code": "SL" }, 
      { "name": "Singapore", "dial_code": "65", "code": "SG" },
      { "name": "Slovakia", "dial_code": "421", "code": "SK" }, 
      { "name": "Slovenia", "dial_code": "386", "code": "SI" },
      { "name": "Solomon Islands", "dial_code": "677", "code": "SB" }, 
      { "name": "Somalia", "dial_code": "252", "code": "SO" },
      { "name": "South Africa", "dial_code": "27", "code": "ZA" }, 
      { "name": "South Sudan", "dial_code": "211", "code": "SS" },
      { "name": "South Georgia and the South Sandwich Islands", "dial_code": "500", "code": "GS" },
      { "name": "Spain", "dial_code": "34", "code": "ES" },
      { "name": "Sri Lanka", "dial_code": "94", "code": "LK" }, 
      { "name": "Sudan", "dial_code": "249", "code": "SD" },
      { "name": "Suriname", "dial_code": "597", "code": "SR" },
      { "name": "Svalbard and Jan Mayen", "dial_code": "47", "code": "SJ" },
      { "name": "Swaziland", "dial_code": "268", "code": "SZ" }, 
      { "name": "Sweden", "dial_code": "46", "code": "SE" },
      { "name": "Switzerland", "dial_code": "41", "code": "CH" }, 
      { "name": "Syrian Arab Republic", "dial_code": "963", "code": "SY" },
      { "name": "Taiwan", "dial_code": "886", "code": "TW" }, 
      { "name": "Tajikistan", "dial_code": "992", "code": "TJ" },
      { "name": "Tanzania, United Republic of Tanzania", "dial_code": "255", "code": "TZ" },
      { "name": "Thailand", "dial_code": "66", "code": "TH" },
      { "name": "Timor-Leste", "dial_code": "670", "code": "TL" },
      { "name": "Togo", "dial_code": "228", "code": "TG" },
      { "name": "Tokelau", "dial_code": "690", "code": "TK" },
      { "name": "Tonga", "dial_code": "676", "code": "TO" },
      { "name": "Trinidad and Tobago", "dial_code": "1868", "code": "TT" },
      { "name": "Tunisia", "dial_code": "216", "code": "TN" },
      { "name": "Turkey", "dial_code": "90", "code": "TR" },
      { "name": "Turkmenistan", "dial_code": "993", "code": "TM" },
      { "name": "Turks and Caicos Islands", "dial_code": "1649", "code": "TC" },
      { "name": "Tuvalu", "dial_code": "688", "code": "TV" },
      { "name": "Uganda", "dial_code": "256", "code": "UG" },
      { "name": "Ukraine", "dial_code": "380", "code": "UA" },
      { "name": "United Arab Emirates", "dial_code": "971", "code": "AE" },
      { "name": "United Kingdom", "dial_code": "44", "code": "GB" },
      { "name": "United States", "dial_code": "1", "code": "US" },
      { "name": "Uruguay", "dial_code": "598", "code": "UY" },
      { "name": "Uzbekistan", "dial_code": "998", "code": "UZ" },
      { "name": "Vanuatu", "dial_code": "678", "code": "VU" },
      { "name": "Venezuela, Bolivarian Republic of Venezuela", "dial_code": "58", "code": "VE" },
      { "name": "Vietnam", "dial_code": "84", "code": "VN" },
      { "name": "Virgin Islands, British", "dial_code": "1284", "code": "VG" },
      { "name": "Virgin Islands, U.S.", "dial_code": "1340", "code": "VI" },
      { "name": "Wallis and Futuna", "dial_code": "681", "code": "WF" },
      { "name": "Yemen", "dial_code": "967", "code": "YE" },
      { "name": "Zambia", "dial_code": "260", "code": "ZM" },
      { "name": "Zimbabwe", "dial_code": "263", "code": "ZW" }]} ''';

    // Parse the JSON string into a Dart map
    Map<String, dynamic> json = jsonDecode(countryJson.toString());

    // Extract the list of countries from the JSON map
    List<dynamic> countriesJson = json['CCODE'];
    debugPrint("countries json ${countriesJson.toString()}");
    // Convert each JSON entry into a Country object
    List<CCODE?> countries =
        countriesJson.map<CCODE>((val) => CCODE.fromJson(val)).toList();
    var countryObj = countries.firstWhere(
        (country) =>
            country?.name?.toLowerCase().trim() ==
            usercountry.toLowerCase().trim(),
        orElse: () => null);
    if (countryObj != null) {
      debugPrint('List contains ${countryObj.name} with dial code ${countryObj.dialCode}');
      return countryObj.dialCode;
    } else {
      debugPrint('Country not found!!');
      return null;
    }
  }

  Future<void> _callLoginWebService(
      String phoneNumber, String countryCode, String uniqueId) async {
    try {
      AapoortiUtilities.getProgressDialog(pr!);

      Map<String, dynamic> urlinput = {
        "userId": "",
        "pass": "",
        "cToken": "",
        "sToken": "",
        "os": "",
        "token4": "MOBILE_OTP",
        "token5": "$countryCode~$phoneNumber~$uniqueId"
      };

      String urlInputString = json.encode(urlinput);
      debugPrint("url input $urlinput");

      //NAME FOR POST PARAM
      String paramName = 'UserLogin';

      //Form Body For URL
      String formBody = paramName + '=' + Uri.encodeQueryComponent(urlInputString);

      var url = "https://ireps.gov.in/Aapoorti/ServiceCall" + 'Login/UserLogin';

      debugPrint("url = " + url);

      final response = await http.post(Uri.parse(url),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
      body: formBody,
      encoding: Encoding.getByName("utf-8"));
      var jsonResult = json.decode(response.body);
      debugPrint("my REs $jsonResult");
      pr!.hide();
      showDialog(context: context, builder: (ctx) => AlertDialog(
                title: const Text("Login Credential for web application"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        "Login ID :: ${jsonResult[0]['MOBILE_NO'].toString()}"),
                    SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'OTP :: '),
                          TextSpan(
                            text: jsonResult[0]['OTP'].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.cyan[400],
                          borderRadius: BorderRadius.circular(8.0)),
                      padding: const EdgeInsets.all(14),
                      child: const Text("okay",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ));
    } on PlatformException catch (e) {
      debugPrint("Failed to get data from native : '${e.message}'.");
      AapoortiUtilities.stopProgress(pr!);
    } catch (e) {
      AapoortiUtilities.stopProgress(pr!);
    }
  }
}

void setStateL(Null Function() param0) {}
