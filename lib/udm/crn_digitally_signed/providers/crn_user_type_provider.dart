import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum usercheckType {positive, negative}

class Crnusertype with ChangeNotifier{

  usercheckType _usertype = usercheckType.negative;

  late List<Map<String, dynamic>> dbResult;

  usercheckType get usertype{
    return _usertype;
  }

  void setusertype(usercheckType type){
    _usertype = type;
    notifyListeners();
  }

  Future<void> fetchUserData(BuildContext context) async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbResult = await dbHelper.fetchSaveLoginUser();
      if(dbResult.isNotEmpty) {
        userDetails(dbResult[0][DatabaseHelper.Tb3_col5_emailid].toString(), context);
      }
    } catch (err) {}
  }

  Future<void> userDetails(String emailid, BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await Network.postDataWithAPIM('app/Common/GetListDefaultValue/V1.0.0/GetListDefaultValue','GetListDefaultValue', emailid, prefs.getString('token'));
    if(response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if(jsonResult['message'] == "Success!"){
        if(jsonResult['data'][0]['grade_code'].toString() == "N"){
          setusertype(usercheckType.negative);
        }
        else{
          setusertype(usercheckType.negative);
        }
      }
    } else {
      return IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
  }
}