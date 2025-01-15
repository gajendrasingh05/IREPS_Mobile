import 'dart:async';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/udm/widgets/custom_progress_indicator.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:ssl_pinning_plugin/ssl_pinning_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

import 'database_helper.dart';

class IRUDMConstants {
  // change for development
  static String webUrl = "https://ireps.gov.in";
  static String webServiceUrl = "https://ireps.gov.in/Aapoorti/ServiceCall";
  static String esbCommonGetTokenApi = "https://ireps.gov.in/EPSCommonAPI/GetTokenV1p";

  //------Stock History Data---------
  static String webstockhisUrl = "https://ireps.gov.in/EPSApi/UDM/HistorySheet/GetData";

  //----- Non-Stock Demands Data--------
  static String webnonstockdemandUrl = "https://ireps.gov.in/EPSApi/UDM/Bill/GetData";
  static String trialwebnonstockdemandUrl = "https://trial.ireps.gov.in/EPSApi/UDM/Bill/GetData";

  // --- Rejection Warranty Data -------
  static String webrejectionwarrantyUrl = "https://ireps.gov.in/EPSApi/UDM/Warranty/Details";
  static String trialwebrejectionwarrantyUrl = "https://trial.ireps.gov.in/EPSApi/UDM/Warranty/Details";

  // --- NS Demand Summary Data ----
  static String webtrialnsDemnadSummaryUrl = "https://trial.ireps.gov.in/EPSApi/UDM/Warranty/GetData";
  static String webnsDemnadSummaryUrl = "https://ireps.gov.in/EPSApi/UDM/Warranty/GetData";

  // -- Stocking Proposal Summary Data ----
  static String webtrialStockingPropSummaryUrl = "https://trial.ireps.gov.in/EPSApi/UDM/Warranty/GetData";
  static String webStockingPropSummaryUrl = "https://ireps.gov.in/EPSApi/UDM/Warranty/GetData";

  // -- Warranty Rejection Register Data ------
  static String webtrialWarrantyRejectionRegister = "https://trial.ireps.gov.in/EPSApi/UDM/warrantyrejectionregister/GetData";
  static String webWarrantyRejectionRegister = "https://ireps.gov.in/EPSApi/UDM/warrantyrejectionregister/GetData";

  // ------- CRC Summary Data ------
  static String webtrialCrcSummary = "https://trial.ireps.gov.in/EPSApi/UDM/crcsummary/GetData";
  static String webCrcSummary = "https://ireps.gov.in/EPSApi/UDM/crcsummary/GetData";

  //----- Issue End User Data--------
  static String webissueEndUserUrl = "https://trial.ireps.gov.in/EPSApi/UDM/enduser/GetData";
  static String trialwebissueEndUserUrl = "https://trial.ireps.gov.in/EPSApi/UDM/enduser/GetData";

  //-------Default User Details--------
  static String defaultUserDetails = dropDownListStatic + 'GetListDefaultValue/UDMItemListDefault?INPUT=';
 // static String defaultUserDetailsSpring = springApi + 'app/Common/GetListDefaultValue';
  static String downTimeUrl = "https://ireps.gov.in/epsapi_maint_out.html";
  static String noticeImageUrl = "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png";

  //-------DropDown API --------
  static String dropDownList =
      "https://ireps.gov.in/Aapoorti/UDMApi/UdmMapList?INPUT_TYPE=";
  static String dropDownListStatic = "https://ireps.gov.in/Aapoorti/UDMApi/";

  static String loginUserEmailID = "";
  static String? hash = "";

  static String trialpath = "https://ireps.gov.in/Aapoorti/ServiceCall";
  static var date = DateTime.now().toString();
  static int? n;
  static String ans = "true";

  //------------- APIM API for ListData----------

  static String apimDropDownList= "https://gw.crisapis.indianrail.gov.in/t/eps.cris.in/EPSApi/app/Common/UDMAppList/V1.0.0/UDMAppList";

  static String apimUrl= "https://gw.crisapis.indianrail.gov.in/t/eps.cris.in/EPSApi/";

  static String apimDef = 'https://gw.crisapis.indianrail.gov.in/t/eps.cris.in/EPSApi/app/Common/GetListDefaultValue/V1.0.0/GetListDefaultValue';

  static var date2 = DateTime.now().toIso8601String();

  showSnack(String? data, BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
        content: Text(
          data!,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ));
    });
  }

  // static void testPin(BuildContext context) async {
  //   String msg = '';
  //   List<String> hashes = [];
  //   hashes.add("56 42 4E 88 F8 F4 71 75 35 4D 96 D0 39 19 74 1D E2 57 A1 71");
  //   try {
  //     msg = await SslPinningPlugin.check(
  //         serverURL: "https://ireps.gov.in/",
  //         headerHttp: Map(),
  //         sha: SHA.SHA1,
  //         allowedSHAFingerprints: hashes,
  //         timeout: 50);
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(msg),
  //         duration: Duration(seconds: 1),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(msg),
  //         duration: Duration(seconds: 1),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //     //  abortWithError(e);
  //   }
  // }

  static showNoticeDialog(context, String msg, String title) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String message = msg;
        String btnLabel = "Okay";
        return new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            MaterialButton(
                child: Text(btnLabel),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  DatabaseHelper dbHelper = DatabaseHelper.instance;
                  await dbHelper.deleteSaveLoginUser();
                  // Provider.of<LoginProvider>(context, listen: false).autologin(context);
                }),
          ],
        );
      },
    );
  }

  static showHomeNoticeDialog(context, String msg) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "UDM APP Notice";
        String message = msg;
        String btnLabel = "Okay";
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            MaterialButton(
                child: Text(btnLabel),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                }),
          ],
        );
      },
    );
  }

  static Widget resultCount(int? countLength, bool countVis) {
    if (countVis) {
      return Container(
        //height: 30,
        child: Center(
          child: Text(
            countLength.toString() + ' record found',
            style:
            TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  static void launchURL(String url) async {
    if(await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static bStyle() {
    return ButtonStyle(
      backgroundColor:
      MaterialStateProperty.resolveWith((color) => Colors.white),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0))),
      elevation: MaterialStateProperty.all(7.0),
      side: MaterialStateProperty.all(
          BorderSide(color: Colors.red[300]!, width: 2.0)),
    );
  }

  Widget floatingAnimat(bool _isScrolling, bool isDiscovering, TickerProvider vsync, ScrollController _scrollController, BuildContext context) {
    var _isDiscovering = isDiscovering;
    return AnimatedSize(
      alignment: Alignment.bottomCenter,
      duration: const Duration(milliseconds: 200),
      // vsync: vsync,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              child: child,
              scale: animation,
            ),
            child: ((_scrollController.offset != 0 && !_isScrolling)) ? FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.red[300],
              child: Icon(
                Icons.expand_less,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                _scrollController.animateTo(
                  _scrollController.offset - 430 * 40,
                  duration: Duration(
                    milliseconds: 500,
                  ),
                  curve: Curves.linear,
                );
              },
            ) : SizedBox(height: 56, width: 56),
          ),
          if ((_scrollController.offset != _scrollController.position.maxScrollExtent))
            const SizedBox(height: 20),
          DescribedFeatureOverlay(
            featureId: 'JumpButton',
            tapTarget: const Icon(
              Icons.expand_more,
              color: Colors.white,
              size: 40,
            ),
            title: const Text('Jump Buttons'),
            description: Column(
              children: [
                const Text('Tap these to jump up and down 20 items'),
                const SizedBox(height: 20),
                TextButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    FeatureDiscovery.completeCurrentStep(context);
                    // setState(() {
                    _isDiscovering = false;
                    // });
                  },
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.blue,
            targetColor: Colors.red[300]!,
            textColor: Colors.white,
            onComplete: () async {
              _isDiscovering = false;
              return true;
            },
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => ScaleTransition(
                child: child,
                scale: animation,
              ),
              child: (_scrollController.offset != _scrollController.position.maxScrollExtent && !_isScrolling) ? FloatingActionButton(
                backgroundColor: Colors.red[300],
                elevation: 0, heroTag: null,
                child: Icon(
                  Icons.expand_more,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  _scrollController.animateTo(
                    _scrollController.offset + 430 * 40,
                    duration: Duration(milliseconds: 500,
                    ),
                    curve: Curves.linear,
                  );
                },
              ) : _scrollController.offset != _scrollController.position.maxScrollExtent
                  ? SizedBox(height: 56, width: 56)
                  : SizedBox(width: 56),
            ),
          ),
        ],
      ),
    );
  }

  static totalValue(List list) {
    var totalValue = 0.0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].stkValue != 'NA') {
        totalValue = totalValue + double.parse(list[i].stkValue);
        assert(totalValue is double);
      }
    }
    return totalValue.toStringAsFixed(2);
  }

  static bool isProgressShowing = false;
  static void showProgressIndicator(BuildContext context) {
    if(!isProgressShowing) {
      isProgressShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                color: Colors.transparent,
                child: const CustomProgressIndicator(),
              ),
            ),
          );
        },
      ).then((value) {
        isProgressShowing = false;
      });
    }
  }

  static void removeProgressIndicator(BuildContext context) {
    if(isProgressShowing) {
      Navigator.pop(context);
    }
  }

}