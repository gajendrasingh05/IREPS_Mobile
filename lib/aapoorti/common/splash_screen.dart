import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/CommonScreen.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:flutter_app/udm/providers/network_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../udm/helpers/shared_data.dart';
import '../../udm/providers/versionProvider.dart';
import '../../udm/screens/pdfVIewForPoSeach.dart';
import '../../udm/widgets/dailog.dart';
import 'AapoortiConstants.dart';
import 'AapoortiUtilities.dart';
import 'DatabaseHelper.dart';
import 'package:flutter_app/udm/helpers/error.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {


  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  List<dynamic>? jsonResult1;
  int? rowCount;
  int count = 0;
  final dbhelper = DatabaseHelper.instance;
  Map<String, String> versionResult = {};

  String? localCurrVer;
  String? globalCurrVer, globalLastAppVer;
  var finalDate;
  Error? _error;

  var app_store_url = 'https://apps.apple.com/in/app/ireps/1462024189';

  var play_store_url = 'https://play.google.com/store/apps/details?id=in.gov.ireps';

  AnimationStatus? animationStatus;

  late NetworkProvider? _networkProvider;

  @override
  Future<void> didChangeDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _animation!.addStatusListener((status) {
      if(status==AnimationStatus.completed) {
        if(prefs.containsKey('exp_time')) {
          var expTime = prefs.getString('exp_time');
          var today = DateTime.now();
          DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
          var currentTime = dateFormat.format(today);
          var expTimeformat=dateFormat.format(dateFormat.parse(expTime!));
          if(currentTime.compareTo(expTimeformat)>0){
            fetchToken(context).then((value) => checkVersion());
          }
          else{
            Future.delayed(Duration(seconds: 0), () async {
              Navigator.of(context).pushReplacementNamed("/common_screen");
              //Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            });
          }
        }
        else{
          fetchToken(context).then((value) => checkVersion());
        }
      }
    });
    super.didChangeDependencies();
    _networkProvider?.addListener(_handleConnectivityChange);
  }

  // Method to handle connectivity changes
  void _handleConnectivityChange() async{
    if(Provider.of<NetworkProvider>(context, listen: false).status == ConnectivityStatus.Offline) {
      //UdmUtilities.showWarningFlushBar(context, Provider.of<LanguageProvider>(context, listen: false).text('checkconnection'));
    }
    else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey('exp_time')) {
        var expTime = prefs.getString('exp_time');
        var today = DateTime.now();
        DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
        var currentTime = dateFormat.format(today);
        var expTimeformat=dateFormat.format(dateFormat.parse(expTime!));
        if(currentTime.compareTo(expTimeformat) > 0){
          fetchToken(context);
        }
        else{
          Future.delayed(Duration(seconds: 0), () async {
            Navigator.of(context).pushReplacementNamed("/common_screen");
            //Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          });
        }
      }
      else{
        fetchToken(context).then((value) => Provider.of<VersionProvider>(context, listen: false).fetchVersion(context));
      }
    }
  }

  void checkVersion() async{
     try{
       Uri default_url = Uri.parse(IRUDMConstants.downTimeUrl);
       var response = await http.get(default_url);
       if(response.statusCode == 200) {
         Navigator.pop(context);
         Navigator.push(context, MaterialPageRoute(builder: (context) => PdfView(IRUDMConstants.downTimeUrl)));
       }
       else {
         await Provider.of<VersionProvider>(context, listen: false).fetchVersion(context);
         _error = Provider.of<VersionProvider>(context, listen: false).error;
         if(_error!.title == "Exception") {
           Timer.run(() => showDialog(
               context: context,
               builder: (_) => CommonDailog(
                 title: _error!.title,
                 contentText: _error!.description,
                 type: 'Exception',
                 action: action,
               )));
         }
         else if(_error!.title.contains("Error")) {
           Timer.run(() => showDialog(
               context: context,
               builder: (_) => CommonDailog(
                 title: _error!.title,
                 contentText: _error!.description,
                 type: 'Error',
                 action: action,
               )));
         }
         else if(_error!.title.contains("Update")) {
           Timer.run(() => showDialog(
               context: context,
               builder: (_) => CommonDailog(
                 title: _error!.title,
                 contentText: _error!.description,
                 type: 'Error',
                 action: action,
               )));
         }
         else if(_error!.title.contains('title2')) {
           Navigator.of(context).pushReplacementNamed('/common_screen');
           //Provider.of<LoginProvider>(context, listen: false).autologin(context);
         }
       }
     }
     catch(e){
       debugPrint(e.toString());
     }
  }

  void action(){
    if(_error!.title.contains('Error')){}
    else if(_error!.title.contains('Update')){
      AapoortiUtilities.openStore(context);
    }
  }


  @override
  void dispose() {
    _controller!.dispose();
    _networkProvider?.removeListener(_handleConnectivityChange);
    super.dispose();
  }



  Future<void> checkConnection() async {
    try {
      var connectivityresult = await Connectivity().checkConnectivity();
      //var connResult = await InternetAddress.lookup('www.google.com').timeout(Duration(seconds: 5));

      if(!connectivityresult.contains(ConnectivityResult.wifi) || !connectivityresult.contains(ConnectivityResult.mobile)){
        _showInternetDialog(context);
      }
    } on SocketException catch (_) {
      _showInternetDialog(context);
    } on TimeoutException catch (_) {
      _showInternetDialog(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeInOut);
    _controller!.forward();

    _networkProvider = Provider.of<NetworkProvider>(context, listen: false);

    fetchPostBF();
    fetchLoginDtls();
  }

  _showVersionDialog(context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "The updated version of application is available. Kindly update for better experience.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  MaterialButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(app_store_url),
                  ),
                  MaterialButton(
                      child: Text(btnLabelCancel),
                      onPressed: () => Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  // HomeScreen()
                                  CommonScreen()))),
                ],
              )
            : AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  MaterialButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(play_store_url),
                  ),
                  MaterialButton(
                      child: Text(btnLabelCancel),
                      onPressed: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (BuildContext context) => CommonScreen()
                              // HomeScreen()
                              ))),
                ],
              );
      },
    );
  }

  Future<void> _showInternetDialog(BuildContext context) async {
    final String title = "Connectivity Error!";
    final String message = "Please check your internet connection.";
    final String btnLabel = "Retry";

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(btnLabel),
                onPressed: () async {
                  Navigator.of(context).pop();
                  // Handle retry logic
                  await checkConnection(); // Consider handling this async operation if needed
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(
                  btnLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  // Handle retry logic
                  await checkConnection(); // Consider handling this async operation if needed
                },
              ),
            ],
          );
        }
      },
    );
  }

  _showVersionDDialog(context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "Update Needed!";
        String message = "You must update the app for using it continuously.";
        String btnLabel = "Okay";

        return Platform.isIOS ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  MaterialButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(app_store_url),
                  ),
                ],
              )
            : AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  MaterialButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(play_store_url),
                  ),
                ],
              );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void fetchLoginDtls() async {
    int? n = await dbhelper.rowCountLoginUser();
    AapoortiConstants.n = n!;
    debugPrint("Login row count = " + n.toString());
    if (n > 0) {
      List<dynamic> tblResult = await dbhelper.fetchLoginUser();
      List<dynamic> tb2Result = await dbhelper.fetchSaveLoginUser();
      AapoortiConstants.loginUserEmailID = tblResult[0]['EmailId'].toString();
      AapoortiConstants.hash = tb2Result[0]['Hash'].toString();
      AapoortiConstants.date = tb2Result[0]['Date'].toString();
      AapoortiConstants.ans = tb2Result[0]['Ans'].toString();
      AapoortiConstants.check = tb2Result[0]['Log'].toString();

      debugPrint('Value from table = ' +
          tblResult[0]['EmailId'].toString() +
          "  ,  " +
          tblResult[0]['LoginFlag'].toString() +
          " , " +
          tb2Result[0]['Hash'].toString() +
          " , " +
          tb2Result[0]['Date'].toString() +
          " , " +
          tb2Result[0]['Ans'].toString() +
          " , " +
          tb2Result[0]['Log'].toString());
      if (tblResult[0]['LoginFlag'].toString() == "1") {
        AapoortiUtilities.loginflag = true;
        debugPrint("login flag" + tblResult[0]['LoginFlag'].toString());
      } else {
        debugPrint("tb result-------------------------" + tblResult[0]['LoginFlag'].toString());
      }
    }
  }

  final dbHelper1 = DatabaseHelper.instance;

  void fetchPostBF() async {
    rowCount = await dbHelper1.rowCountBanned();
    if (rowCount! > 0) {
      jsonResult1 = await dbHelper1.fetchBanned();
      AapoortiConstants.jsonResult2 = jsonResult1!;
      AapoortiConstants.count = jsonResult1![0]['Count'];
      AapoortiConstants.date2 = jsonResult1![0]['Date1'];
    }
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  stops: [
                    0.1,
                    0.5
                  ],
                  colors: [
                    //Color(0xFF205e2f),
                    //Color(0xFFE60C05),
                    //Color(0xFFfc5b0a),
                    Color(0xff0C67A5),
                    Color(0xff04253C)
                  ]
              ),
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomRight,
              //   stops: [0.3, 0.6],
              //   colors: [
              //     Teal to Light Blue Gradient
              //     Color(0xFF1ABC9C),  // Teal
              //     Color(0xFF16A085),  // Darker Teal
              //     Color(0xFF3498DB),  // Light Blue
              //     Color(0xff04253C),
              //     Color(0xff0C67A5),
              //     Dark Purple to Soft Purple Gradient
              //     Color(0xFF6C3483),  // Dark Purple
              //     Color(0xFF8E44AD),  // Medium Purple
              //     Color(0xFFD2B4DE),  // Light Purple
              //     Color(0xFFBDC3C7),
              //     Color(0xFF2C3E50),
              //     Color(0xFF34495E),  // Darker grey-blue
              //       // Light grey for contrast
              //     Color(0xFF2C3E50),  // Charcoal Grey
              //     Color(0xFF7F8C8D),  // Silver Grey
              //     Color(0xFFBDC3C7),  // Light Silver
              //   ],
              // ),
            ),
            child: ScaleTransition(
                scale: _animation!,
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/nlogo.png',
                                width: 105,
                                height: 105,
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                // 'आपूर्ति (IREPS)',
                                'IREPS',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ]),
                      ),
                      CircularProgressIndicator(color: Colors.white, strokeWidth: 4.0),
                      SizedBox(height : 5.0),
                      Text(
                        'Efficiency - Transparency - Ease of doing business',
                        style: TextStyle(color:  Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        textAlign: TextAlign.end,
                      ),
                      Padding(padding: EdgeInsets.all(10.0))
                    ])))
    );

  }
}