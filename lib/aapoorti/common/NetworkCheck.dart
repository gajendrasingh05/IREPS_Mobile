import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NetworkCheck {
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  dynamic checkInternet() {
    check().then((intenet) {
      if(intenet) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> networkTest() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
    // switch (connectivityResult) {
    //   case ConnectivityResult.none:
    //     return false;
    //   case ConnectivityResult.mobile:
    //   case ConnectivityResult.wifi:
    //     return true;
    //   default:
    //     return false;
    // }
  }
}

class NoNetwork extends StatefulWidget {
  @override
  _NoNetworkState createState() => _NoNetworkState();
}

class _NoNetworkState extends State<NoNetwork> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 90),
                  ),
                  Text(
                    'No Internet Connection!!',
                    style: TextStyle(color: Colors.black87, fontSize: 25),
                  ),
                  Expanded(
                      child: SpinKitFadingCircle(
                    color: Colors.black87,
                    size: 120.0,
                  )),

                  /* Text('Oops! No Internet Connection', style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 21),),

                        Padding(padding: EdgeInsets.only(bottom: 30),)
*/
                ],
              ),
//                    child: SpinKitFadingFour(color: Colors.white, size: 100.0,)
            )));
  }
}
