import 'dart:convert';
import 'dart:math';
import 'package:flutter_app/mmis/db/db_models/userloginrespdb.dart';
import 'package:flutter_app/mmis/helpers/api.dart';
import 'package:flutter_app/mmis/models/OtpVerRespData.dart';
import 'package:flutter_app/mmis/models/loginResponse.dart';
import 'package:flutter_app/mmis/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginRepo {

  static List<LoginrespData> loginresp = [];
  static List<OtpRespData> otpverresp = [];

  static Future<List<LoginrespData>> authenticateUser(String email, String? mpin, bool isLoginSaved) async {
    String? hash;
    try {
      var input = email + "#" + mpin!;
      var bytes = utf8.encode(input);
      hash = sha256.convert(bytes).toString();
      debugPrint("Hash Value: $hash");

      //Client Token
      var random = Random.secure();
      String ctoken = random.nextInt(100).toString();
      for (var i = 1; i < 10; i++) {
        ctoken = ctoken + random.nextInt(100).toString();
      }
      debugPrint('ctoken : $ctoken');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      debugPrint("login request: ${email+'~'+"abcd"+"#$hash"+'~'+ctoken}");
      //--------------- trial Url -------------------------
      //var response = await Network.postDataWithPro(UrlContainer.trialbaseUrl+UrlContainer.loginEndPoint, 'UdmLogin', "poonam.crismmis@gmail.com~123456#c00acf01e20797919ee48774b574a3cff155e9e7f9eb5dad48f5281492a79154~8596042133483486716", prefs.getString('token'));
      //--------------- prod Url -------------------------
      //var response = await Network.postDataWithAPIM('UDM/UdmAppLogin/V1.0.0/UdmAppLogin','UdmLogin', email+'~'+"abcd"+"#$hash"+'~'+ctoken, prefs.getString('token'));
      var response = await Network.postDataWithPro(UrlContainer.baseUrl+UrlContainer.loginEndPoint, 'UdmLogin', "${email+'~'+"abcd"+"#$hash"+'~'+ctoken}", prefs.getString('token'));
      //var response = await Network.postDataWithPro(UrlContainer.trialbaseUrl+UrlContainer.loginEndPoint, 'UdmLogin', "poonam.crismmis@gmail.com~123456#c00acf01e20797919ee48774b574a3cff155e9e7f9eb5dad48f5281492a79154~8596042133483486716", prefs.getString('token'));
      if(response.statusCode == 200) {
        var listdata = json.decode(response.body);
        debugPrint("loginresp $listdata");
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(isLoginSaved) {
            if(listJson != null) {
              loginresp = listJson.map<LoginrespData>((val) => LoginrespData.fromJson(val)).toList();
              prefs.setString('mmisemail', loginresp[0].emailId!.trim());
              prefs.setString('mmismpin', mpin.trim());
              saveloginuserData(loginresp);
              return loginresp;
            }
          }
          else{
            if(listJson != null) {
              loginresp = listJson.map<LoginrespData>((val) => LoginrespData.fromJson(val)).toList();
              saveloginuserData(loginresp);
              return loginresp;
            }
          }
        }
      }
    } catch (err) {
      debugPrint("Error " + err.toString());
    }
    return loginresp;
  }

  static Future<List<OtpRespData>> otpVerified(String email, String otp) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await Network.postDataWithPro(UrlContainer.trialbaseUrl+UrlContainer.loginEndPoint,'Otp_verified', "$email~$otp", prefs.getString('token'));
      //var response = await Network.postDataWithPro('https://trial.ireps.gov.in/EPSApi/UDM/UdmAppLogin','UdmLogin', "poonam.crismmis@gmail.com~abcd#c00acf01e20797919ee48774b574a3cff155e9e7f9eb5dad48f5281492a79154~31547377952928523371", prefs.getString('token'));
      //var response = await Network.postDataWithPro('https://trial.ireps.gov.in/EPSApi/UDM/UdmAppLogin','UdmLogin', email+'~'+"abcd"+"#$hash"+'~'+ctoken, prefs.getString('token'));
      if(response.statusCode == 200){
        var listdata = json.decode(response.body);
        if(listdata['status'] == "OK"){
          var listJson = listdata['data'];
          if(listJson != null) {
            otpverresp = listJson.map<OtpRespData>((val) => OtpRespData.fromJson(val)).toList();
            return otpverresp;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return otpverresp;
          }
        }
      }
    } catch (err) {
      debugPrint("Error " + err.toString());
    }
    return otpverresp;
  }

  //Save User login Details to Hive DB
  static void saveloginuserData(List<LoginrespData> loginresp) async{
    // Open the Hive box
    var box = await Hive.openBox<UserLoginrespDb>('user');
    await box.clear();
    var userLoginresp = UserLoginrespDb(
      cToken: loginresp[0].cToken ?? '',
      sToken: loginresp[0].sToken ?? 'NULL',
      mapId: loginresp[0].mapId!,
      emailId: loginresp[0].emailId!,
      mobile: loginresp[0].mobile!,
      userName: loginresp[0].userName!,
      wkArea: loginresp[0].wkArea ?? 'NA',
      userType: loginresp[0].userType!,
      uValue: loginresp[0].uValue!,
      lastLogTime:  loginresp[0].lastLogTime!,
      ouName:  loginresp[0].ouName!,
      orgZone:  loginresp[0].orgZone!,
      moduleAccess: loginresp[0].moduleAccess ?? 'NA',
    );
    await box.add(userLoginresp);
    debugPrint("Data Saved successfully!!");
  }
}
