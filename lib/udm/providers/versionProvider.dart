import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
//import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/shared_data.dart';
import '../helpers/error.dart';

enum splashState { Loading, Finished }

class VersionProvider with ChangeNotifier {
  String? localCurrVer, versionName;
  String? globalCurrVer, globalLastAppVer;
  var finalDate;
  Map<String, String> versionResult = {};
  Error? _error;
  String noticeData='';
  DatabaseHelper dbHelper = DatabaseHelper.instance;


  splashState _state = splashState.Loading;
  splashState get state => _state;

  void setState(splashState viewState) {
    _state = viewState;
    notifyListeners();
  }

  Error? get error {
    return _error;
  }


  Future<void> fetchVersion(BuildContext context) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      localCurrVer = packageInfo.buildNumber;
      List<dynamic>? jsonResult;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var response = await Network.postDataWithAPIM('UDMAPPVersion/V1.0.0/UDMAPPVersion','UDMAPPVersion', '', prefs.getString('token'));
      //var v = AapoortiConstants.webServiceUrl + 'Common/GetVersionDtls?input=GetVersionDtls,' + version;
     //var response = await Network().postDataWithPro('https://ireps.gov.in/EPSApi/UDMAPPVersion','UDMAPPVersion', '', prefs.getString('token'));
     //final response = await http.post(Uri.parse(v));

      debugPrint("fetchVersion response ${json.decode(response.body)}");
      var jsonData = json.decode(response.body);
      jsonResult = jsonData['data'];
      debugPrint("my version check data ${jsonResult.toString()}");
      if(jsonResult!.isEmpty) {
        _error = Error("Exception", "No data found in version control");
      } else {
        for(int index = 0; index < jsonResult.length; index++) {
          versionResult.putIfAbsent(jsonResult[index]["param_name"].toString(), () => jsonResult![index]["param_value"].toString());
        }
      }
      debugPrint("Version result ${versionResult['UdmLastVersionCode']!}");
      debugPrint("local current version $localCurrVer");
      if(versionResult['UdmLastVersionCode']!.compareTo(localCurrVer!)==0) {
          if(DateTime.now().toIso8601String().compareTo(DateTime.parse(versionResult['UdmAppdaysleft']!).toIso8601String()) > 0) {
            Navigator.of(context).pop();
            _showVersionDDialog(context);
            _error = Error('', '');
            setState(splashState.Finished);
          } else {
            _showVersionDialog(context);
            _error = Error('', '');
            setState(splashState.Finished);
          }
        }
      else if(int.parse(versionResult['UdmLastVersionCode']!) > int.parse(localCurrVer!)) {
          _showVersionDDialog(context);
          _error = Error('', '');
          setState(splashState.Finished);
        }
      else if(versionResult['UdmAppNotice']!='') {
         var notice = versionResult['UdmAppNotice']!.split('~');
         SharedPreferences prefs = await SharedPreferences.getInstance();
          if(notice[0]=='1'){
            await dbHelper.deleteSaveLoginUser();
            prefs.setString('notice','');
            prefs.setString('noticetitile','');
            IRUDMConstants.showNoticeDialog(context,notice[2],notice[1]);
            _error = Error('', '');
            setState(splashState.Finished);
          }
          else if(notice[0]=='2'){
            noticeData=notice[2];
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('notice',noticeData);
            prefs.setString('noticetitile',notice[1]);
            _error = Error('title2', '');
            setState(splashState.Finished);
          }
          else{
            prefs.setString('notice','');
            prefs.setString('noticetitile','');
            _error = Error('title2', '');
            setState(splashState.Finished);
          }
      }
      else {
        _error = Error('title2', '');
        setState(splashState.Finished);
      }
    }  on HttpException {
      _error = Error("Exception", "Something http Exception occur! Please try again.");
      setState(splashState.Finished);
    } on SocketException {
      debugPrint('No Internet connection 😑');
      setState(splashState.Finished);
    }
    on FormatException{
      debugPrint("Format Exception Error");
      setState(splashState.Finished);
    }
    catch (e) {
      debugPrint("fetchVersion exception: ${e.toString()}");
      _error = Error("Exception", "Something Unexpected happened! Please try again. ${e.toString()}");
      setState(splashState.Finished);
    }
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
              onPressed: () => IRUDMConstants.launchURL(app_store_url),
            ),
          ],
        ) : AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            MaterialButton(
              child: Text(btnLabel),
              onPressed: () => IRUDMConstants.launchURL(play_store_url),
            ),
          ],
        );
      },
    );
  }


  _showVersionDialog(context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message = "The updated version of application is available. Kindly update for better experience.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Platform.isIOS ? CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            MaterialButton(
              child: Text(btnLabel),
              onPressed: () => IRUDMConstants.launchURL(app_store_url),
            ),
            MaterialButton(
              child: Text(btnLabelCancel),
              onPressed: () => Timer(Duration(seconds: 0), () {
              //  Provider.of<LoginProvider>(context, listen: false).autologin(context);
                Navigator.pop(context);
              }))],
        ) : AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            MaterialButton(
              child: Text(btnLabel),
              onPressed: () => IRUDMConstants.launchURL(play_store_url),
            ),
            MaterialButton(
                child: Text(btnLabelCancel),
             onPressed: () async {
               Navigator.of(context, rootNavigator: true).pop();
               await dbHelper.deleteSaveLoginUser();
               // Provider.of<LoginProvider>(context, listen: false).autologin(context);
        } )
          ],
        );
      },
    );
  }


  var app_store_url = 'https://apps.apple.com/in/app/ireps/id1462024189';

  var play_store_url = 'https://play.google.com/store/apps/details?id=in.gov.ireps';



}

