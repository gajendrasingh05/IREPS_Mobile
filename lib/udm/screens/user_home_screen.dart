import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view/crc_screen.dart';
import 'package:flutter_app/udm/crc_summary/view/crc_summary_screen.dart';
import 'package:flutter_app/udm/crn_digitally_signed/view/crn_screen.dart';
import 'package:flutter_app/udm/crn_summary/view/crn_summary_screen.dart';
import 'package:flutter_app/udm/end_user/view/to_user_end_screen.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/non_stock_demands/views/non_stock_demands_screen.dart';
import 'package:flutter_app/udm/ns_demand_summary/view/nsdemandsummary_screen.dart';
import 'package:flutter_app/udm/onlineBillSummary/summaryDropdown.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/loginProvider.dart';
import 'package:flutter_app/udm/providers/versionProvider.dart';
import 'package:flutter_app/udm/rejection_warranty/views/warranty_rejection_screen.dart';
import 'package:flutter_app/udm/screens/UdmChangePin.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views/stock_items_history_sheet_screen.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/view/stocking_proposal_summary_screen.dart';
import 'package:flutter_app/udm/transaction/transaction_search_dropdown.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/view/Warranty_dropdownScreen.dart';
import 'package:flutter_app/udm/warranty_crn_summary/view/warranty_crn_summary_screen.dart';
import 'package:flutter_app/udm/widgets/bottom_Nav/bottom_nav.dart';
import 'package:flutter_app/udm/widgets/consuptionAnalysisFilter.dart';
import 'package:flutter_app/udm/widgets/consuptionSummaryFilter.dart';
import 'package:flutter_app/udm/widgets/custom_rightside_drawer.dart';
import 'package:flutter_app/udm/widgets/delete_dialog.dart';
import 'package:flutter_app/udm/widgets/highValueFilter.dart';
import 'package:flutter_app/udm/widgets/nonMovingFilter.dart';
import 'package:flutter_app/udm/widgets/poSearch_rightside_drawer.dart';
import 'package:flutter_app/udm/widgets/stock_rightside_drawer.dart';
import 'package:flutter_app/udm/widgets/stock_summary_drawer.dart';
import 'package:flutter_app/udm/widgets/storeDepot_rightside_drawer.dart';
import 'package:flutter_app/udm/widgets/switch_language_button.dart';
import 'package:flutter_app/udm/widgets/valueWiseStockFilter.dart';
import 'package:package_info_plus/package_info_plus.dart';
//import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../gemorder/gem_OrderDetails/view/gem_order_screen.dart';
import '../onlineBillStatus/statusDropdown.dart';

import 'package:permission_handler/permission_handler.dart';

import '../warranty_rejection_register/view/warranty_rejection_register_screen.dart';
import '../widgets/expandablegrid.dart';
import 'Profile.dart';
import 'login_screen.dart';

class UserHomeScreen extends StatefulWidget {
  static const routeName = "/user-home-screen";

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen>
    with TickerProviderStateMixin {

  final _scaffoldKey = GlobalKey<ScaffoldState>();


  List<Map<String, dynamic>> gridOneItems = [
    {'icon': 'assets/item1.png', 'label': 'आइटम ढूँढें\nSearch Item'},
    {
      'icon': 'assets/item_search.png',
      'label': 'स्टॉक उपलब्धता\nStock Availability'
    },
    {
      'icon': 'assets/depot_store.png',
      'label': 'भण्डार डिपो स्टॉक\nStores Depot Stock'
    },
    {
      'icon': 'assets/images/po_search.png',
      'label': 'क्रयादेश ढूँढें \nSearch PO'
    },
    {
      'icon': 'assets/summary.png',
      'label': 'स्टॉक का संक्षिप्त विवरण\nSummary of Stock'
    },
    {
      'icon': 'assets/images/non_moving.png',
      'label': 'नॉन-मूविंग आइटम\nNon-Moving Items'
    },
    {
      'icon': 'assets/valueWise.png',
      'label': 'वैल्यू अनुसार स्टॉक\nValue-Wise Stock'
    },
    {
      'icon': 'assets/highValue.png',
      'label': 'उच्च वैल्यू आइटम\nHigh Value Items'
    },
    {
      'icon': 'assets/analysis.png',
      'label': 'खपत का विश्लेषण\nConsumption Analysis'
    },
    {
      'icon': 'assets/cons_summary.png',
      'label': 'खपत का संक्षिप्त विवरण\nConsumption Summary'
    },
    {
      'icon': 'assets/trans.png',
      'label': 'लेनदेन\nTransactions',
    },
    {
      'icon': 'assets/download.png',
      'label': 'ऑनलाइन बिल की स्थितिं \nOn-Line Bill Status'
    },
    {
      'icon': 'assets/edoc_home.png',
      'label': 'ऑनलाइन बिल सारांश \nOn-Line Bill Summary'
    },
    {
      'icon': 'assets/images/crn.png',
      'label': 'सी.आर.एन \nCRN'
    },
    {
      'icon': 'assets/images/udm_crc.png',
      'label': 'सी.आर.सी \nCRC'
    },
    {
      'icon': 'assets/stock.jpg',
      'label': 'स्टॉक आइटम इतिहास पत्रक \nStk. Item History Sheet'
    },
    {
      'icon': 'assets/images/ns_demands.png',
      'label': 'गैर-स्टॉक मांगें \nNS Demands'
    },
    {
      'icon': 'assets/images/gem.svg',
      'label': 'रत्न-आदेश विवरण \nGeM Order Details'
    },
    {
      'icon': 'assets/images/warranty.png',
      'label': 'अस्वीकृति/वारंटी \nRejection/Warranty'
    },
    {
      'icon': 'assets/images/demand.jpg',
      'label': 'एनएस डिमांड सारांश \nNS Demand Summary'
    },
    {
      'icon': 'assets/report_icon.png',
      'label': 'वारंटी शिकायत सारांश \nWarranty Complaint Summary'
    },
    {
      'icon': 'assets/images/summary.jpg',
      'label': 'सीआरएन सारांश \nCRN Summary'
    },
    {
      'icon': 'assets/images/stock_sm.jpg',
      'label': 'स्टॉकिंग प्रस्ताव सारांश \nStocking Proposal Summary'
    },
    {
      'icon': 'assets/images/rejection.png',
      'label': 'वारंटी अस्वीकृति रजिस्टर \nWarranty Rejection Register'
    },
    {
      'icon': 'assets/images/crc.png',
      'label': 'सीआरसी सारांश \nCRC Summary'
    },
    // {
    //   'icon': 'assets/images/end_user.png',
    //   'label': 'अंतिम उपयोगकर्ता के लिए \nTo End User'
    // },
    // {
    //   'icon': 'assets/images/wcs.png',
    //   'label': 'वारंटी सीआरएन सारांश \nWarranty CRN Summary'
    // },
  ];

  DatabaseHelper dbHelper = DatabaseHelper.instance;
  late List<Map<String, dynamic>> dbResult;
  String? username = '', email = '';
  late LoginProvider itemListProvider;
  VersionProvider? versionProvider;
  String localCurrVer = '', versionName = '';

  // Animation
  bool expand = false;
  late AnimationController controller;
  late Animation<double> animation, animationView;

  void initState() {
    requestWritePermission();
    getVersion();
    fetchUserData();
    //Provider.of<NetworkProvider>(context, listen: false);
    // Animation
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    animation = Tween(begin: 0.0, end: -0.5).animate(controller);
    animationView = CurvedAnimation(parent: controller, curve: Curves.linear);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(milliseconds: 500), () {
        togglePanel();
      });
    });
    super.initState();
  }

  void requestWritePermission() async {
    PermissionStatus permissionStatus = await Permission.storage.request();
    if(!permissionStatus.isGranted) {
      bool isshown = await Permission.storage.shouldShowRequestRationale;
      Map<Permission, PermissionStatus> permissions = await [Permission.storage].request();
      if(this.mounted) setState(() {});
    } else {
      if(this.mounted) setState(() {});
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("notice")) {
      if (prefs.getString("notice") != "") {
        showHomeNoticeDialog(context, prefs.get('notice') as String?,
            prefs.get('noticetitile') as String?);
      }
    }
  }

  Future<void> getVersion() async{
     PackageInfo packageInfo = await PackageInfo.fromPlatform();
     setState(() {
         localCurrVer = packageInfo.version;
         versionName = packageInfo.buildNumber;
    });
  }

  showHomeNoticeDialog(context, String? msg, String? title) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String message = msg!;
        String btnLabel = "Okay";
        return AlertDialog(
          title: Text(title!),
          content: Text(message),
          actions: <Widget>[
            MaterialButton(
                child: Text(btnLabel),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('notice', '');
                  prefs.setString('noticetitile', '');
                  Navigator.of(context, rootNavigator: true).pop();
                }),
          ],
        );
      },
    );
  }

  // void versionControl() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   version = "${packageInfo.version}:${packageInfo.buildNumber}";
  //   print("Versionutil = " + version);
  // }

  // Future<void> getVersion() async {
  //   final _checker = AppVersionChecker();
  //   //Provider.of<VersionProvider>(context, listen: false).fetchVersion(context);
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   setState(() {
  //     localCurrVer = packageInfo.version;
  //     versionName = packageInfo.buildNumber;
  //   });
  //   // _checker.checkUpdate().then((value) {
  //   //   if(value.canUpdate) {
  //   //         showDialog(context: context, builder: (BuildContext context) {
  //   //           return UpdateDialog(
  //   //             allowDismissal: true,
  //   //             description: "Please update your app from ${value.currentVersion} to ${value.newVersion} for access more functionality.",
  //   //             version: value.newVersion!,
  //   //             appLink: value.appURL!,
  //   //           );
  //   //         });
  //   //     }
  //   // });
  // }

  Future<void> fetchUserData() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var dbResult = await dbHelper.fetchSaveLoginUser();
      if (dbResult.isNotEmpty) {
        setState(() {
          username = prefs.getString('name');
          //username = dbResult[0][DatabaseHelper.Tb3_col8_userName];
          email = dbResult[0][DatabaseHelper.Tb3_col5_emailid];
        });
      }
    } catch (err) {}
  }

  Future<void> onTapFunction(String gridno, int itemIndex) async {
    if(gridno == '1') {
      switch (itemIndex) {
        case 0:
          Navigator.push(context, MaterialPageRoute(builder: (context) => CustomRightSideDrawer()));
          break;
        case 1:
          Navigator.push(context, MaterialPageRoute(builder: (context) => StockRightSideDrawer()));
          break;
        case 2:
          Navigator.push(context, MaterialPageRoute(builder: (context) => StoreStkDepotRightSideDrawer()));
          break;
        case 3:
          Navigator.of(context).pushNamed(POSearchRightSideDrawer.routeName);
          //Navigator.push(context, MaterialPageRoute(builder: (context) => POSearchRightSideDrawer()));
          break;
        case 4:
          Navigator.of(context).pushNamed(StockSummarySideDrawer.routeName);
          break;
        case 5:
          Navigator.of(context).pushNamed(NonMovingFilter.routeName);
          break;
        case 6:
          Navigator.of(context).pushNamed(ValueWiseStockFilter.routeName);
          break;
        case 7:
          Navigator.of(context).pushNamed(HighValueFilter.routeName);
          break;
        case 8:
          Navigator.of(context).pushNamed(ConsumtionAnalysisFilter.routeName);
          break;
        case 9:
          Navigator.of(context).pushNamed(ConsumtionSummaryFilter.routeName);
          break;
        case 10:
          Navigator.of(context).pushNamed(TransactionSearchDropDown.routeName);
          break;
        case 11:
          Navigator.of(context).pushNamed(StatusDropDown.routeName);
          break;
        case 12:
          Navigator.of(context).pushNamed(SummaryDropdown.routeName);
          break;
        case 13:
          Navigator.of(context).pushNamed(CrnScreen.routeName);
          break;
        case 14:
          Navigator.of(context).pushNamed(CrcScreen.routeName);
          break;
        case 15:
          Navigator.of(context).pushNamed(StockItemHistorySheetScreen.routeName);
          break;
        case 16:
          Navigator.of(context).pushNamed(NonStockDemandsScreen.routeName);
          break;
        case 17:
          Navigator.of(context).pushNamed(GemOrderScreen.routeName);
          break;
        case 18:
          Navigator.of(context).pushNamed(WarrantyRejectionScreen.routeName);
          break;
        case 19:
          Navigator.of(context).pushNamed(NSDemandSummaryScreen.routeName);
          break;
        case 20:
          Navigator.of(context).pushNamed(WarrantyComplaintDropdown.routeName);
          break;
        case 21:
          Navigator.of(context).pushNamed(CrnSummaryScreen.routeName);
          break;
        case 22:
          Navigator.of(context).pushNamed(StockingProposalSummaryScreen.routeName);
          break;
        case 23:
          Navigator.of(context).pushNamed(WarrantyRejectionRegisterScreen.routeName);
          break;
        case 24:
          Navigator.of(context).pushNamed(CrcSummaryScreen.routeName);
          break;
        case 25:
          Navigator.of(context).pushNamed(ToEndUserScreen.routeName);
          break;
        case 26:
          Navigator.of(context).pushNamed(WarrantyCRNSummaryScreen.routeName);
          break;
        default:
      }
    }
  }

  void togglePanel() {
    if(!expand) {
      controller.forward(from: 0);
    } else {
      controller.reverse();
    }
    expand = !expand;
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async{
        AapoortiUtilities.alertDialog(context, "UDM");
        return true;
      },
      //onWillPop: _onButtonPressed,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
              title: Text(language.text('udmFull'), style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700)),
              elevation: 0.0,
              backgroundColor: Colors.red[300],
              leading: IconButton(
                  icon: SvgPicture.asset('assets/images/dashboard.svg', color: Colors.white, height: 22, width: 22),
                  onPressed: () => _scaffoldKey.currentState!.openDrawer()),
              actions: <Widget>[
                SwitchLanguageButton(),
              ]
          ),
          drawer: navigationdrawer(context, size),
          backgroundColor: Colors.grey.shade100,
          bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
          body: Padding(
            padding: EdgeInsets.all(5),
            child: ExpandableGrid(
              children: gridOneItems,
              action: onTapFunction,
            ),
          )),
    );
  }

  Future<bool> _onButtonPressed() async {
    return await showModalBottomSheet(
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
              // ignore: unnecessary_statements
            }) ??
        false;
  }

  Column _buildBottomNavigationMenu() {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.vpn_key,
              color: Colors.red[300],
              size: 24,
            ),
            SizedBox(width: 5.0),
            Text(
              language.text('logOut'),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Padding(padding: EdgeInsets.only(top: 40.0)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  language.text('cancel'),
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red[300],
                minWidth: 150,
              ),
              MaterialButton(
                onPressed: () {
                  Future.delayed(Duration(milliseconds: 100), () {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Provider.of<LoginProvider>(context, listen: false).setState(LoginState.Idle);
                      Navigator.of(context).pushReplacementNamed("/common_screen");
                      //Navigator.of(context).pop(false);
                      //exit(0);
                    });
                  });
                },
                child: Text(
                  language.text('confirm'),
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red[300],
                minWidth: 150,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35, top: 0.0, right: 55),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(onPressed: (){
                 Navigator.of(context).pop(false);
                 WarningAlertDialog().changeLoginAlertDialog(context, () {callWebServiceLogout();}, language);
                }, child: Text(language.text('changeLogin'), style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: Colors.red.shade300,
                fontSize: 15,
                color: Colors.red[300],
              ))),
              TextButton(onPressed: (){ IRUDMConstants.launchURL(play_store_url);}, child: Text(language.text('rateUs'), style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: Colors.red.shade300,
                fontSize: 15,
                color: Colors.red[300],
              ))),
            ],
          ),
        ),
      ],
    );
  }

  Widget navigationdrawer(BuildContext context, Size size) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Drawer(
      width: size.width * 0.80,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                    constraints: BoxConstraints.expand(height: size.height * 0.25),
                    padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                          Colors.black38,
                          BlendMode.darken,
                        ),
                        image: AssetImage('assets/welcome.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(16.0))
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                      },
                      child: Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(language.text('welcome'), style: TextStyle(color: Colors.white, fontSize: 15.0)),
                              Text(username!, style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0)),
                              Text(email!, style: TextStyle(color: Colors.white, fontSize: 15.0)),
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
                      ),
                    )
                ),
                ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(UdmChangePin.routeName);
                    },
                    leading: Icon(
                      Icons.pin_drop,
                      color: Colors.black, size: 20
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
                    title: Text(
                      language.text('changePin'),
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    )
                ),
                ListTile(
                    onTap: () => IRUDMConstants.launchURL(play_store_url),
                    leading: Icon(
                      Icons.star,
                      color: Colors.black, size: 20
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
                    title: Text(
                      language.text('rateUs'),
                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                    )),
              ],
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  // Text(
                  //   "${language.text('version')} : " +
                  //       localCurrVer +
                  //       ' (' +
                  //       versionName +
                  //       ')',
                  //   style: TextStyle(
                  //     color: Colors.grey,
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      if(_scaffoldKey.currentState!.isDrawerOpen) {
                         _scaffoldKey.currentState!.closeDrawer();
                        //_showConfirmationDialog(context);
                         WarningAlertDialog().changeLoginAlertDialog(context, () {callWebServiceLogout();}, language);
                        //callWebServiceLogout();
                      }
                    },
                    child: Container(
                      height: 45,
                      color: Colors.red.shade300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(width: 10),
                          Text(language.text('logout'), style: TextStyle(fontSize: 16, color: Colors.white))
                        ],
                      ),
                    ),
                  )
                ],
              )
          ),
        ],
      ),
    );
  }

  var play_store_url = 'https://play.google.com/store/apps/details?id=in.gov.ireps';

  void callWebServiceLogout() async {
    IRUDMConstants.showProgressIndicator(context);
    var loginprovider = Provider.of<LoginProvider>(context, listen: false);
    List<dynamic>? jsonResult;
    try {
      jsonResult = await fetchPostPostLogin(loginprovider.user!.ctoken!, loginprovider.user!.stoken!, loginprovider.user!.map_id!);
      IRUDMConstants.removeProgressIndicator(context);
      if(jsonResult![0]['logoutstatus'] == "You have been successfully logged out.") {
        dbHelper.deleteSaveLoginUser();
        loginprovider.setState(LoginState.FinishedWithError);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), ModalRoute.withName("/login-screen"));
          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen());
        });
      }
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
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
      return IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
  }

  void showWarningDialog(BuildContext context) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
        title: const Text("Message!!"),
        content: const Text("This utility has been temporarily discontinued due to scheduled maintenance."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              height : 45,
              width : 60,
              alignment : Alignment.center,
              decoration : BoxDecoration(
                color: Colors.red,
                border: Border.all(
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const Text("OK", style : TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // Future getVersion() async {
  //   String basicAuth;
  //   String url = new UtilsFromHelper().getValueFromKey("mobile_app_version");
  //
  //   basicAuth = await Hrmstokenplugin.hrmsToken;
  //
  //   HttpClient client = new HttpClient();
  //   client.badCertificateCallback =
  //   ((X509Certificate cert, String host, int port) => true);
  //   Map map = {
  //     'name': "anything",
  //   };
  //
  //   HttpClientRequest request = await client.postUrl(Uri.parse(url));
  //   request.headers.set('content-type', 'application/json');
  //
  //   request.headers.set('authorization', basicAuth);
  //   request.add(utf8.encode(json.encode(map)));
  //   HttpClientResponse response = await request.close();
  //
  //   String value = await response.transform(utf8.decoder).join();
  //   var responseJSON = await json.decode(value) as Map;
  //   print('reponse $responseJSON');
  //   if(int.parse(responseJSON['mobileAppData']['utility_value']) >
  //       BuildConfig.VERSION_CODE) {
  //     _showDialog(responseJSON['mobileAppData']['remarks']);
  //   }
  // }

// void _showDialog(String title) {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return WillPopScope(
  //           onWillPop: () {
  //             return Future.value(false);
  //           },
  //           child: AlertDialog(
  //             title: Text("Update Required", style: TextStyle(fontSize: 15.0)),
  //             content: Text(title, style: TextStyle(fontSize: 13.0)),
  //             actions: <Widget>[
  //               MaterialButton(
  //                 child: Text("UPGRADE"),
  //                 onPressed: () {
  //                   _playstorelaunchURL();
  //                 },
  //               ),
  //             ],
  //           ));
  //     },
  //   );
  // }
}
