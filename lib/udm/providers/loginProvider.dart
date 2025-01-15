import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/screens/user_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_app/udm/helpers/error.dart';
import '../models/user.dart';
import '../helpers/database_helper.dart';

enum LoginState { Idle, Complete, Busy, Finished, FinishedWithError }

class LoginProvider with ChangeNotifier {
  User? _user;
  Error? _error;
  List<Map<String, dynamic>>? dbResult;
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  LoginState _state = LoginState.Idle;

  //Change icon color state
  bool _hasError = false;
  void setErrorState(bool errorvalue){
    _hasError = errorvalue;
    notifyListeners();
  }
  bool get errorValue{
    return _hasError;
  }

  void setState(LoginState viewState) {
    _state = viewState;
    notifyListeners();
  }

  LoginState get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  User? get user {
    return _user;
  }

  Future<void> autologin(BuildContext context) async {
    try {
      dbResult = await dbHelper.fetchSaveLoginUser();
      if(dbResult!.isNotEmpty && dbResult![0][DatabaseHelper.Tb3_col6_loginFlag] == '1') {
        _user = User(emailid: dbResult![0][DatabaseHelper.Tb3_col5_emailid]);
        DateTime dbDate = DateTime.parse(dbResult![0][DatabaseHelper.Tbl3_Col2_Date]);
        DateTime dateTimeNow = DateTime.now();
        final difference = dateTimeNow.difference(dbDate).inDays;
        if(difference<=5){
           await authenticateUser(dbResult![0][DatabaseHelper.Tb3_col5_emailid], dbResult![0][DatabaseHelper.Tbl3_Col1_Hash], true, true, context);
        }else{
          await dbHelper.deleteSaveLoginUser();
          dbResult!.clear();
        }
        notifyListeners();
      }
    } catch (err) {
      _error = Error("Exception", "Auto Login not working.");
      setState(LoginState.FinishedWithError);
    }
  }

  showSnack(String data, BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
        content: Text(
          data,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ));
    });
  }

  Future<void> authenticateUser(String email, String? mpin, bool isLoginSaved, bool autoLogin, BuildContext context) async {
    debugPrint("Autologin is  $autoLogin");
    debugPrint("Email $email");
    debugPrint("Password $mpin");
    debugPrint("isLogin $isLoginSaved");
    setState(LoginState.Busy);
    String? hash;
    try {
      if(autoLogin) {
        DatabaseHelper dbHelper = DatabaseHelper.instance;
        dbResult = await dbHelper.fetchSaveLoginUser();
        debugPrint("DB resp $dbResult");
        if(dbResult!.isNotEmpty && dbResult![0][DatabaseHelper.Tb3_col6_loginFlag] == '1') {
          IRUDMConstants.hash = dbResult![0][DatabaseHelper.Tbl3_Col1_Hash];
          hash = dbResult![0][DatabaseHelper.Tbl3_Col1_Hash];
        }
        else {
          var input = email + "#" + mpin!;
          var bytes = utf8.encode(input);
          hash = sha256.convert(bytes).toString();
        }
        //Client Token
        var random = Random.secure();
        String ctoken = random.nextInt(100).toString();
        for (var i = 1; i < 10; i++) {
          ctoken = ctoken + random.nextInt(100).toString();
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        debugPrint('hash : ' + hash!);
        debugPrint("cToken : $ctoken");
        debugPrint("login request: ${email+'~'+"abcd"+"#$hash"+'~'+ctoken}  token value : ${prefs.getString('token')}");
        var response = await Network.postDataWithAPIM('UDM/UdmAppLogin/V1.0.0/UdmAppLogin','UdmLogin', email+'~'+"abcd"+"#$hash"+'~'+ctoken, prefs.getString('token'));
        //var response = await Network().postDataWithPro('https://ireps.gov.in/EPSApi/UDM/UdmAppLogin','UdmLogin', email+'~'+"abcd"+"#$hash"+'~'+ctoken, prefs.getString('token'));
        var jsonResult = json.decode(response.body);
        debugPrint("login response: ${json.decode(response.body)}");
        if(response.statusCode == 200) {
          if(jsonResult['status'] == 'OK') {
            var loginData=jsonResult['data'];
            prefs.setString('email', email);
            if(isLoginSaved) {
              await dbHelper.deleteSaveLoginUser();
              final String timestamp = DateTime.now().toIso8601String();
              Map<String, dynamic> row = {
                DatabaseHelper.Tb3_col5_emailid: email,
                DatabaseHelper.Tbl3_Col1_Hash: hash,
                DatabaseHelper.Tbl3_Col2_Date: timestamp,
                DatabaseHelper.Tbl3_Col3_Ans: '',
                DatabaseHelper.Tbl3_Col4_Log: '123456', //Save token for 1 days for production we will get auth token
                DatabaseHelper.Tb3_col6_loginFlag: '1',
                DatabaseHelper.Tb3_col7_mobile: loginData[0]['mobile'],
                DatabaseHelper.Tb3_col8_userName: loginData[0]['user_name'],
                DatabaseHelper.Tb3_col9_UserVlue: loginData[0]['u_value'],
                DatabaseHelper.Tb3_col10_LastLogin: loginData[0]['last_log_time'],
                DatabaseHelper.Tb3_col11_WKArea: loginData[0]['wk_area'],
                DatabaseHelper.Tb3_col12_OuName: loginData[0]['ou_name'],
              };
              _user = User(
                  emailid: email,
                  date: timestamp,
                  ans: '',
                  ctoken: ctoken,
                  stoken: loginData[0]['s_token'].toString(),
                  log: '123456',
                  map_id: loginData[0]['map_id'].toString(),
                  loginFlag: '1');
              await dbHelper.insertSaveLoginUser(row);
            }
            else {
              await dbHelper.deleteSaveLoginUser();
              final String timestamp = DateTime.now().toIso8601String();
              debugPrint("Timestamp $timestamp");
              Map<String, dynamic> row = {
                DatabaseHelper.Tb3_col5_emailid: email,
                DatabaseHelper.Tbl3_Col1_Hash: hash,
                DatabaseHelper.Tbl3_Col2_Date: timestamp,
                DatabaseHelper.Tbl3_Col3_Ans: '',
                DatabaseHelper.Tbl3_Col4_Log: '123456', //Save token for 1 days for production we will get auth token
                DatabaseHelper.Tb3_col6_loginFlag: '0',
                DatabaseHelper.Tb3_col7_mobile: loginData[0]['mobile'],
                DatabaseHelper.Tb3_col8_userName: loginData[0]['user_name'],
                DatabaseHelper.Tb3_col9_UserVlue: loginData[0]['u_value'],
                DatabaseHelper.Tb3_col10_LastLogin: loginData[0]['last_log_time'],
                DatabaseHelper.Tb3_col11_WKArea: loginData[0]['wk_area'],
                DatabaseHelper.Tb3_col12_OuName: loginData[0]['ou_name'],
              };
              _user = User(
                  emailid: email,
                  date: timestamp,
                  ans: '',
                  log: '123456',
                  ctoken: ctoken,
                  stoken: loginData[0]['s_token'].toString(),
                  map_id: loginData[0]['map_id'].toString(),
                  loginFlag: '0'
              );
              await dbHelper.insertSaveLoginUser(row);
            }
            SchedulerBinding.instance.addPostFrameCallback((_) {
              userDetails(email, context);
            });
          } else {
            _error = Error("Error", "Invalid Credentials !!");
            showSnack("Invalid Login email-id or PIN.", context);
            setState(LoginState.Idle);
          }
        }
      }
      else{
        var input = email + "#" + mpin!;
        var bytes = utf8.encode(input);
        hash = sha256.convert(bytes).toString();
        var random = Random.secure();
        String ctoken = random.nextInt(100).toString();
        for (var i = 1; i < 10; i++) {
          ctoken = ctoken + random.nextInt(100).toString();
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        debugPrint('hash2 : ' + hash!);
        debugPrint("cToken : $ctoken");
        debugPrint("login request: ${email+'~'+"abcd"+"#$hash"+'~'+ctoken}  token value : ${prefs.getString('token')}");
        var response = await Network.postDataWithAPIM('UDM/UdmAppLogin/V1.0.0/UdmAppLogin','UdmLogin', email+'~'+"abcd"+"#$hash"+'~'+ctoken, prefs.getString('token'));
        //var response = await Network().postDataWithPro('https://ireps.gov.in/EPSApi/UDM/UdmAppLogin','UdmLogin', email+'~'+"abcd"+"#$hash"+'~'+ctoken, prefs.getString('token'));
        var jsonResult = json.decode(response.body);
        debugPrint("login response: ${json.decode(response.body)}");
        if(response.statusCode == 200) {
          if(jsonResult['status'] == 'OK') {
            var loginData=jsonResult['data'];
            prefs.setString('email', email);
            if(isLoginSaved) {
              await dbHelper.deleteSaveLoginUser();
              final String timestamp = DateTime.now().toIso8601String();
              Map<String, dynamic> row = {
                DatabaseHelper.Tb3_col5_emailid: email,
                DatabaseHelper.Tbl3_Col1_Hash: hash,
                DatabaseHelper.Tbl3_Col2_Date: timestamp,
                DatabaseHelper.Tbl3_Col3_Ans: '',
                DatabaseHelper.Tbl3_Col4_Log: '123456', //Save token for 1 days for production we will get auth token
                DatabaseHelper.Tb3_col6_loginFlag: '1',
                DatabaseHelper.Tb3_col7_mobile: loginData[0]['mobile'],
                DatabaseHelper.Tb3_col8_userName: loginData[0]['user_name'],
                DatabaseHelper.Tb3_col9_UserVlue: loginData[0]['u_value'],
                DatabaseHelper.Tb3_col10_LastLogin: loginData[0]['last_log_time'],
                DatabaseHelper.Tb3_col11_WKArea: loginData[0]['wk_area'],
                DatabaseHelper.Tb3_col12_OuName: loginData[0]['ou_name'],
              };
              _user = User(
                  emailid: email,
                  date: timestamp,
                  ans: '',
                  ctoken: ctoken,
                  stoken: loginData[0]['s_token'].toString(),
                  log: '123456',
                  map_id: loginData[0]['map_id'].toString(),
                  loginFlag: '1');
              await dbHelper.insertSaveLoginUser(row);
            }
            else {
              await dbHelper.deleteSaveLoginUser();
              final String timestamp = DateTime.now().toIso8601String();
              debugPrint("Timestamp $timestamp");
              Map<String, dynamic> row = {
                DatabaseHelper.Tb3_col5_emailid: email,
                DatabaseHelper.Tbl3_Col1_Hash: hash,
                DatabaseHelper.Tbl3_Col2_Date: timestamp,
                DatabaseHelper.Tbl3_Col3_Ans: '',
                DatabaseHelper.Tbl3_Col4_Log: '123456', //Save token for 1 days for production we will get auth token
                DatabaseHelper.Tb3_col6_loginFlag: '0',
                DatabaseHelper.Tb3_col7_mobile: loginData[0]['mobile'],
                DatabaseHelper.Tb3_col8_userName: loginData[0]['user_name'],
                DatabaseHelper.Tb3_col9_UserVlue: loginData[0]['u_value'],
                DatabaseHelper.Tb3_col10_LastLogin: loginData[0]['last_log_time'],
                DatabaseHelper.Tb3_col11_WKArea: loginData[0]['wk_area'],
                DatabaseHelper.Tb3_col12_OuName: loginData[0]['ou_name'],
              };
              _user = User(
                  emailid: email,
                  date: timestamp,
                  ans: '',
                  log: '123456',
                  ctoken: ctoken,
                  stoken: loginData[0]['s_token'].toString(),
                  map_id: loginData[0]['map_id'].toString(),
                  loginFlag: '0'
              );
              await dbHelper.insertSaveLoginUser(row);
            }
            SchedulerBinding.instance.addPostFrameCallback((_) {
              userDetails(email, context);
            });
          }
          else {
            _error = Error("Error", "Invalid Credentials !!");
            showSnack("Invalid Login email-id or PIN.", context);
            setState(LoginState.Idle);
          }
        }
      }
    }
    on HttpException {
      _error = Error("Exception", "Something http Exception occur! Please try again.");
      setState(LoginState.FinishedWithError);
      showSnack("Something http Exception occur! Please try again.", context);
    } on SocketException {
      debugPrint('No Internet connection 😑');
      setState(LoginState.FinishedWithError);
      showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      debugPrint("Bad response format 👎");
      setState(LoginState.FinishedWithError);
      showSnack("Bad response format ! Please try again.", context);
    } catch (err) {
      debugPrint("Error " + err.toString());
      setState(LoginState.FinishedWithError);
      showSnack(err.toString().substring(0,70), context);
    }
  }

  Future<void> userDetails(String emailid, BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
    var response = await Network.postDataWithAPIM('app/Common/GetListDefaultValue/V1.0.0/GetListDefaultValue','GetListDefaultValue', emailid, prefs.getString('token'));
      if(response.statusCode == 200) {
        //IRUDMConstants.removeProgressIndicator(context);
        var jsonResult = json.decode(response.body);
        debugPrint("User Records "+jsonResult.toString());
        if(jsonResult['message'] == "Success!"){
          setState(LoginState.Complete);

          prefs.setString('userid', jsonResult['data'][0]['user_id'].toString());
          prefs.setString('name', jsonResult['data'][0]['name'].toString());
          prefs.setString('deptid', jsonResult['data'][0]['department_id'].toString());
          prefs.setString('adminunit', jsonResult['data'][0]['admin_unit'].toString());
          prefs.setString("userzone", jsonResult['data'][0]['org_zone'].toString());
          prefs.setString("userpostid", jsonResult['data'][0]['post_id'].toString());
          prefs.setString("gradecode", jsonResult['data'][0]['grade_code'].toString());
          prefs.setString("consigneecode", jsonResult['data'][0]['ccode'].toString());
          prefs.setString("subconsigneecode", jsonResult['data'][0]['sub_cons_code'].toString());
          prefs.setString('orgsubunit', jsonResult['data'][0]['org_subunit_dept'].toString());
          prefs.setString('orgunittype', jsonResult['data'][0]['org_unit_type'].toString());

          debugPrint("User Records complete");
          Navigator.of(context).pushReplacementNamed(UserHomeScreen.routeName);
        }
        else if(jsonResult['status'] == "ERROR"){
          setState(LoginState.FinishedWithError);
          IRUDMConstants().showSnack(jsonResult['message'].toString(), context);
        }
        else {
          setState(LoginState.FinishedWithError);
          IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
        }
      } else {
        setState(LoginState.FinishedWithError);
        IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
      }
    }
    on HttpException {
      _error = Error("Exception", "Something http Exception occur! Please try again.");
      setState(LoginState.FinishedWithError);
      showSnack("Something http Exception occur! Please try again.", context);
    } on SocketException {
      setState(LoginState.FinishedWithError);
      showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      setState(LoginState.FinishedWithError);
      showSnack("Bad response format ! Please try again.", context);
    } catch (err) {
      setState(LoginState.FinishedWithError);
      showSnack(err.toString().substring(0,70), context);
    }

  }
}
