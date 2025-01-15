import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:flutter_app/udm/providers/network_provider.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/languageProvider.dart';
import 'login_screen.dart';


class UdmSplashScreen extends StatefulWidget {
     static const routeName = "/spash-screen";
  @override
  _UdmSplashScreenState createState() => _UdmSplashScreenState();
}

class _UdmSplashScreenState extends State<UdmSplashScreen> with TickerProviderStateMixin,WidgetsBindingObserver {
  late AnimationController _controller;
  late Animation<double> _animation;
  String? localCurrVer;
  String? globalCurrVer, globalLastAppVer;
  var finalDate;
  AnimationStatus? animationStatus;

  late NetworkProvider? _networkProvider;


  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    super.initState();
    _networkProvider = Provider.of<NetworkProvider>(context, listen: false);
  }

  @override
  Future<void> didChangeDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _animation.addStatusListener((status) {
    if(status==AnimationStatus.completed) {
      debugPrint("Complete");
      if(prefs.containsKey('exp_time')) {
        var expTime = prefs.getString('exp_time');
        var today = DateTime.now();
        DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
        var currentTime = dateFormat.format(today);
        var expTimeformat=dateFormat.format(dateFormat.parse(expTime!));
        if(currentTime.compareTo(expTimeformat)>0){
          fetchToken(context);
        }
        else{
          Future.delayed(Duration(seconds: 0), () async {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          });
        }
      }
      else{
        fetchToken(context);
      }
    }
   });
    super.didChangeDependencies();
    _networkProvider?.addListener(_handleConnectivityChange);
  }

  // Method to handle connectivity changes
  void _handleConnectivityChange() async{
    if(Provider.of<NetworkProvider>(context, listen: false).status == ConnectivityStatus.Offline) {
      UdmUtilities.showWarningFlushBar(context, Provider.of<LanguageProvider>(context, listen: false).text('checkconnection'));
    }
    else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey('exp_time')) {
        var expTime = prefs.getString('exp_time');
        var today = DateTime.now();
        DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
        var currentTime = dateFormat.format(today);
        var expTimeformat=dateFormat.format(dateFormat.parse(expTime!));
        if(currentTime.compareTo(expTimeformat)>0){
          fetchToken(context);
        }
        else{
          Future.delayed(Duration(seconds: 0), () async {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          });
        }
      }
      else{
        fetchToken(context);
      }
    }
  }

 
  @override
  void dispose() {
    _controller.dispose();
    _networkProvider?.removeListener(_handleConnectivityChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: ScaleTransition(
                scale: _animation,
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 40),
                      Image.asset('assets/railway.png', width: 90, height: 90),
                      SizedBox(height: 20),
                      Image.asset('assets/splash_back2.jpg'),
                      Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('यूजर डिपो मॉड्यूल',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                   color: Color(0xFF00008B),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30),
                              ),
                              Text(
                                'User Depot Module (UDM)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF00008B),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ]),
                      ),
                      Image.asset('assets/cris.png', width: 80, height: 65),
                      Text(
                        'Centre for Railway Information Systems',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      SizedBox(height: 5),
                      Text('(An Organisation of the Ministry of Railways, Govt. of India)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10), textAlign: TextAlign.end),
                      SizedBox(height: 5),
                    ]),
              ),
            ),
          ],
        ));
  }
}