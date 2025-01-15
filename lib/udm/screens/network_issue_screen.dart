import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/network_provider.dart';
import 'package:flutter_app/udm/screens/login_screen.dart';
import 'package:provider/provider.dart';

class NetworkIssueScreen extends StatefulWidget {
  static const routeName = "/networkissue-screen";

  const NetworkIssueScreen({Key? key}) : super(key: key);

  @override
  State<NetworkIssueScreen> createState() => _NetworkIssueScreenState();
}

class _NetworkIssueScreenState extends State<NetworkIssueScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<NetworkProvider>(
        builder: (context, provider, child) {
          if(provider.status == ConnectivityStatus.Offline){
            return Container(
              height: size.height,
              width: size.width,
              child: Image.asset('assets/nointernet.jpg'),
            );
          }
          else{
            return Container(
                height: size.height,
                width: size.width,
                child: Center(child: Text("Back Online", style: TextStyle(color: Colors.green))));
            //return Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          }
        },
      ),
    );
  }
}
