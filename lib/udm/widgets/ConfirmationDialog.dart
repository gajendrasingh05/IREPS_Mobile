import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/providers/loginProvider.dart';
import 'package:flutter_app/udm/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmationDialog extends StatefulWidget {


  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        title: Text('Confirmation!!'),
        content: Text('Do you want to change login now?'),
        actions: [
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green), fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width/3.0, 40))),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              callWebServiceLogout();
            },
            child: Text('Yes'),
          ),
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red), fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width/3.0, 40))),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void callWebServiceLogout() async {
    IRUDMConstants.showProgressIndicator(context);
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    var loginprovider = Provider.of<LoginProvider>(context, listen: false);
    List<dynamic>? jsonResult;
    try {
      jsonResult = await fetchPostPostLogin(loginprovider.user!.ctoken!, loginprovider.user!.stoken!, loginprovider.user!.map_id!);
      IRUDMConstants.removeProgressIndicator(context);
      if(jsonResult![0]['logoutstatus'] == "You have been successfully logged out.") {
        dbHelper.deleteSaveLoginUser();
        loginprovider.setState(LoginState.FinishedWithError);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if(context.mounted){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), ModalRoute.withName("/Login"));
          }
        });
      }
    } on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {}
  }

  Future<List<dynamic>?> fetchPostPostLogin(String cTocken, String sTocken, String mapId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await Network.postDataWithAPIM('UDM/UdmAppLogin/V1.0.0/UdmAppLogin', 'UdmLogout', cTocken + '~' + sTocken + '~' + mapId, prefs.getString('token'));
    if(response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      return jsonResult['data'];
    } else {
      return IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
  }
}
