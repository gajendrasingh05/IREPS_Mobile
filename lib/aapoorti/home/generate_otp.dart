import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/models/CountryCode.dart';
import 'package:flutter_app/aapoorti/provider/generate_otp_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart'  as http;

class GenerateOtpScreen extends StatefulWidget {
  const GenerateOtpScreen({Key? key}) : super(key: key);

  @override
  State<GenerateOtpScreen> createState() => _GenerateOtpScreenState();
}

class _GenerateOtpScreenState extends State<GenerateOtpScreen> {
  //final _authViewModel = Get.put(AuthViewModel());
  final _phoneNumberController = TextEditingController();
  String verificationID = "";
  bool _isGranted = false;
  ProgressDialog? pr;

  String otp = "0";

  @override
  void initState() {
    super.initState();
    //_checkPhonePermission();
    pr = ProgressDialog(context);
  }

  // Future<void> _checkPhonePermission() async {
  //   PermissionStatus status = await Permission.phone.status;
  //   if(status.isGranted) {
  //     Future.delayed(const Duration(milliseconds: 50),(){
  //       Provider.of<GenerateOtpProvider>(context, listen: false).printSimCardsData(pr);
  //     });
  //   }
  //   else if(status.isDenied) {
  //     _requestPhonePermission();
  //   }
  // }
  //
  // Future<void> _requestPhonePermission() async {
  //   PermissionStatus status = await Permission.phone.request();
  //   if(status.isGranted) {
  //     Future.delayed(const Duration(milliseconds: 50),() {
  //       Provider.of<GenerateOtpProvider>(context, listen: false).printSimCardsData(pr);
  //     });
  //   } else if(status.isDenied) {
  //     setState(() {
  //       _isGranted = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0,
          backgroundColor: Colors.cyan[400],
          iconTheme: IconThemeData(color: Colors.white), title : Text("Generate OTP", style: TextStyle(color: Colors.white))),
      body: Container(
        height : MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text("Click on below link to Generate OTP for IREPS Desktop Web Application.",textAlign: TextAlign.center, style: TextStyle(fontSize : 16.0, fontWeight: FontWeight.bold)),
            // Card(
            //   elevation: 2.0,
            //   color: Colors.white,
            //   shape: RoundedRectangleBorder(
            //     side: BorderSide(color: Colors.grey.shade700, width: 1),
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(30.0),
            //     child: Text("Click on below link to Generate OTP for IREPS Web Desktop Application", style: TextStyle(fontSize : 16.0, fontWeight: FontWeight.bold)),
            //   ),
            // ),
            SizedBox(height: 20),
            Card(
              elevation: 2.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade700, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   height: 80,
                    //   width: 80,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(40)
                    //   ),
                    //   child: Image.asset('assets/ic_launcher_app3.png'),
                    // ),
                    // const SizedBox(height : 10),

                    //const Text("OTP for IREPS Desktop Application",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, decoration: TextDecoration.underline)),
                    //const SizedBox(height : 20),
                    const Text("(This option is available for foreign bidders)", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                    // const SizedBox(height : 20),
                    // const Text("Today's OTP"),
                    // const SizedBox(height : 20),
                    // otp == "0" ? Text("- - - -") : Text(otp.toString()),
                    const SizedBox(height : 30),
                    ElevatedButton(onPressed:() async {
                      //var provider = Provider.of<GenerateOtpProvider>(context, listen: false);
                      //DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                      //AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                      AapoortiUtilities.getProgressDialog(pr!);
                      final hasPermission = await _handleLocationPermission(context);
                      if(!hasPermission) return;
                      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
                        _getAddressFromLatLng(position);
                      }).catchError((e) {
                        debugPrint(e.toString());
                      });
                      // if(provider.originalList.length == 0) {
                      //   AapoortiUtilities.showFlushBar(context, "Mobile number not found!!");
                      //   //_callLoginWebService("+918920885084", androidInfo.id);
                      // }
                      // else if(provider.originalList.any((number) => number.contains('+918130797606')) || provider.originalList.any((number) => number.contains('918130797606'))
                      //     || provider.originalList.any((number) => number.contains('+919717402540'))  || provider.originalList.any((number) => number.contains('919717402540'))
                      //     || provider.originalList.any((number) => number.contains('+919717394007'))  || provider.originalList.any((number) => number.contains('919717394007'))
                      //     || provider.originalList.any((number) => number.contains('+919165450304'))  || provider.originalList.any((number) => number.contains('919165450304'))) {
                      //
                      //   //showMobileNumberDialog(context, provider, androidInfo.id);
                      // }
                      // else if(provider.originalList.any((number) => number.startsWith('+91')) || provider.originalList.any((number) => number.startsWith('91'))){
                      //   AapoortiUtilities.showFlushBar(context, "This link is not valid for you; it is only for foreign users.");
                      // }
                      // else{
                      //   //showMobileNumberDialog(context, provider, androidInfo.id);
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.cyan[400],
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))
                     ), child: const Text("Generate OTP for today", style: TextStyle(color: Colors.white))
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  // void showMobileNumberDialog(BuildContext context, GenerateOtpProvider provider, String id) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Get OTP"),
  //         content: Container(
  //           height: 120,
  //           child: Column(
  //             children: <Widget>[
  //               for(int i = 0; i<provider.originalList.length; i++)
  //                 InkWell(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     _callLoginWebService(provider.originalList[i], id);
  //                     //Navigator.of(context, rootNavigator: true).pop();
  //                   },
  //                   child: Column(
  //                     children: <Widget>[
  //                       Container(
  //                         height : 45,
  //                         width: MediaQuery.of(context).size.width,
  //                         alignment: Alignment.center,
  //                         decoration: BoxDecoration(
  //                             border: Border.all(width: 1.0, color: Colors.grey),
  //                             borderRadius: BorderRadius.circular(8.0)
  //                         ),
  //                         //margin: EdgeInsets.all(AllDimensions.eigth),
  //                         //padding: EdgeInsets.all(AllDimensions.twelve),
  //                         child: Text(provider.originalList[i] != null ? getMobile(provider.originalList[i].toString()) : provider.originalList[i], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
  //                       ),
  //                       i == provider.originalList.length - 1 ? const SizedBox.shrink() : const Divider()
  //                     ],
  //                   ),
  //                 ),
  //
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if(permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }


  Future<void> _getAddressFromLatLng(Position position) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isIOS){
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      await placemarkFromCoordinates(position.latitude, position.longitude).then((List<Placemark> placemarks) {
        pr!.hide();
        Placemark place = placemarks[0];
        if(place.country!.isNotEmpty) {
          //AapoortiUtilities.showInSnackBar(context, place.country);
          if(place.country!.toLowerCase().trim().contains("india")) {
            debugPrint("Country ${place.country!}");
            if(iosDeviceInfo.identifierForVendor == "UKQ1.230924.001" || iosDeviceInfo.identifierForVendor == "RP1A.200720.011" || iosDeviceInfo.identifierForVendor == "TP1A.220624.014"){
              String? code = getCountryCode(place.country!);
              debugPrint("Code $code");
              //String code = getCountryCode("Algeria");
              //_callLoginWebService("00000000000", code, 'QR1A.200720.011');
              _callLoginWebService("00000000000", code!, iosDeviceInfo.identifierForVendor!);
            }
            else{
              showDialog(context: context, barrierDismissible: false, builder: (ctx) => AlertDialog(
                title: const Text("Alert!!"),
                content: const Text("This link is not valid for you; it is only for foreign users."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.cyan[400],
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      padding: const EdgeInsets.all(14),
                      child: const Text("okay", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ));
            }
          }
          else{
            String? code = getCountryCode(place.country!);
            //String code = getCountryCode("Algeria");
            //_callLoginWebService("00000000000", code, 'QR1A.200720.011');
            _callLoginWebService("00000000000", code!, iosDeviceInfo.identifierForVendor!);
          }
        }
      }).catchError((e) {
        debugPrint(e.toString());
      });
    }
    else{
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      await placemarkFromCoordinates(position.latitude, position.longitude).then((List<Placemark> placemarks) {
        pr!.hide();
        Placemark place = placemarks[0];
        if(place.country!.isNotEmpty) {
          //AapoortiUtilities.showInSnackBar(context, place.country);
          if(place.country!.toLowerCase().trim().contains("india")) {
            debugPrint("Country ${place.country!}");
            if(androidInfo.id == "UKQ1.230924.001" || androidInfo.id == "RP1A.200720.011" || androidInfo.id == "TP1A.220624.014"){
              String? code = getCountryCode(place.country!);
              debugPrint("Code $code");
              //String code = getCountryCode("Algeria");
              //_callLoginWebService("00000000000", code, 'QR1A.200720.011');
              _callLoginWebService("00000000000", code!, androidInfo.id!);
            }
            else{
              showDialog(context: context, barrierDismissible: false, builder: (ctx) => AlertDialog(
                title: const Text("Alert!!"),
                content: const Text("This link is not valid for you; it is only for foreign users."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.cyan[400],
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      padding: const EdgeInsets.all(14),
                      child: const Text("okay", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ));
            }
          }
          else{
            String? code = getCountryCode(place.country!);
            //String code = getCountryCode("Algeria");
            //_callLoginWebService("00000000000", code, 'QR1A.200720.011');
            _callLoginWebService("00000000000", code!, androidInfo.id!);
          }
        }
      }).catchError((e) {
        debugPrint(e.toString());
      });
    }

  }

  String? getCountryCode(String usercountry) {
    String countryJson = '''{"CCODE":[{ "name": "Afghanistan", "dial_code": "93", "code": "AF" },
      { "name": "Aland Islands", "dial_code": "358", "code": "AX" },
      { "name": "Albania", "dial_code": "355", "code": "AL" },
      { "name": "Algeria", "dial_code": "213", "code": "DZ" },
      { "name": "AmericanSamoa", "dial_code": "1684", "code": "AS" },
      { "name": "Andorra", "dial_code": "376", "code": "AD" },
      { "name": "Angola", "dial_code": "244", "code": "AO" },
      { "name": "Anguilla", "dial_code": "1264", "code": "AI" },
      { "name": "Antarctica", "dial_code": "672", "code": "AQ" },
      { "name": "Antigua and Barbuda", "dial_code": "1268", "code": "AG" },
      { "name": "Argentina", "dial_code": "54", "code": "AR" },
      { "name": "Armenia", "dial_code": "374", "code": "AM" },
      { "name": "Aruba", "dial_code": "297", "code": "AW" },
      { "name": "Australia", "dial_code": "61", "code": "AU" },
      { "name": "Austria", "dial_code": "43", "code": "AT" },
      { "name": "Azerbaijan", "dial_code": "994", "code": "AZ" },
      { "name": "Bahamas", "dial_code": "1242", "code": "BS" },
      { "name": "Bahrain", "dial_code": "973", "code": "BH" },
      { "name": "Bangladesh", "dial_code": "880", "code": "BD" },
      { "name": "Barbados", "dial_code": "1246", "code": "BB" },
      { "name": "Belarus", "dial_code": "375", "code": "BY" },
      { "name": "Belgium", "dial_code": "32", "code": "BE" },
      { "name": "Belize", "dial_code": "501", "code": "BZ" },
      { "name": "Benin", "dial_code": "229", "code": "BJ" },
      { "name": "Bermuda", "dial_code": "1441", "code": "BM" },
      { "name": "Bhutan", "dial_code": "975", "code": "BT" },
      { "name": "Bolivia, Plurinational State of", "dial_code": "591", "code": "BO" },
      { "name": "Bosnia and Herzegovina", "dial_code": "387", "code": "BA" },
      { "name": "Botswana", "dial_code": "267", "code": "BW" },
      { "name": "Brazil", "dial_code": "55", "code": "BR" },
      { "name": "British Indian Ocean Territory", "dial_code": "246", "code": "IO" },
      { "name": "Brunei Darussalam", "dial_code": "673", "code": "BN" },
      { "name": "Bulgaria", "dial_code": "359", "code": "BG" },
      { "name": "Burkina Faso", "dial_code": "226", "code": "BF" },
      { "name": "Burundi", "dial_code": "257", "code": "BI" },
      { "name": "Cambodia", "dial_code": "855", "code": "KH" },
      { "name": "Cameroon", "dial_code": "237", "code": "CM" },
      { "name": "Canada", "dial_code": "1", "code": "CA" },
      { "name": "Cape Verde", "dial_code": "238", "code": "CV" },
      { "name": "Cayman Islands", "dial_code": " 345", "code": "KY" },
      { "name": "Central African Republic", "dial_code": "236", "code": "CF" },
      { "name": "Chad", "dial_code": "235", "code": "TD" },
      { "name": "Chile", "dial_code": "56", "code": "CL" },
      { "name": "China", "dial_code": "86", "code": "CN" },
      { "name": "Christmas Island", "dial_code": "61", "code": "CX" },
      { "name": "Cocos (Keeling) Islands", "dial_code": "61", "code": "CC" },
      { "name": "Colombia", "dial_code": "57", "code": "CO" },
      { "name": "Comoros", "dial_code": "269", "code": "KM" },
      { "name": "Congo", "dial_code": "242", "code": "CG" },
      { "name": "Congo, The Democratic Republic of the Congo", "dial_code": "243", "code": "CD" },
      { "name": "Cook Islands", "dial_code": "682", "code": "CK" },
      { "name": "Costa Rica", "dial_code": "506", "code": "CR" },
      { "name": "Cote d'Ivoire", "dial_code": "225", "code": "CI" },
      { "name": "Croatia", "dial_code": "385", "code": "HR" },
      { "name": "Cuba", "dial_code": "53", "code": "CU" },
      { "name": "Cyprus", "dial_code": "357", "code": "CY" },
      { "name": "Czech Republic", "dial_code": "420", "code": "CZ" },
      { "name": "Denmark", "dial_code": "45", "code": "DK" },
      { "name": "Djibouti", "dial_code": "253", "code": "DJ" },
      { "name": "Dominica", "dial_code": "1767", "code": "DM" },
      { "name": "Dominican Republic", "dial_code": "1849", "code": "DO" },
      { "name": "Ecuador", "dial_code": "593", "code": "EC" },
      { "name": "Egypt", "dial_code": "20", "code": "EG" },
      { "name": "El Salvador", "dial_code": "503", "code": "SV" },
      { "name": "Equatorial Guinea", "dial_code": "240", "code": "GQ" },
      { "name": "Eritrea", "dial_code": "291", "code": "ER" },
      { "name": "Estonia", "dial_code": "372", "code": "EE" },
      { "name": "Ethiopia", "dial_code": "251", "code": "ET" },
      { "name": "Falkland Islands (Malvinas)", "dial_code": "500", "code": "FK" },
      { "name": "Faroe Islands", "dial_code": "298", "code": "FO" },
      { "name": "Fiji", "dial_code": "679", "code": "FJ" },
      { "name": "Finland", "dial_code": "358", "code": "FI" },
      { "name": "France", "dial_code": "33", "code": "FR" },
      { "name": "French Guiana", "dial_code": "594", "code": "GF" },
      { "name": "French Polynesia", "dial_code": "689", "code": "PF" },
      { "name": "Gabon", "dial_code": "241", "code": "GA" },
      { "name": "Gambia", "dial_code": "220", "code": "GM" },
      { "name": "Georgia", "dial_code": "995", "code": "GE" },
      { "name": "Germany", "dial_code": "49", "code": "DE" },
      { "name": "Ghana", "dial_code": "233", "code": "GH" },
      { "name": "Gibraltar", "dial_code": "350", "code": "GI" },
      { "name": "Greece", "dial_code": "30", "code": "GR" },
      { "name": "Greenland", "dial_code": "299", "code": "GL" },
      { "name": "Grenada", "dial_code": "1473", "code": "GD" },
      { "name": "Guadeloupe", "dial_code": "590", "code": "GP" },
      { "name": "Guam", "dial_code": "1671", "code": "GU" },
      { "name": "Guatemala", "dial_code": "502", "code": "GT" },
      { "name": "Guernsey", "dial_code": "44", "code": "GG" },
      { "name": "Guinea", "dial_code": "224", "code": "GN" },
      { "name": "Guinea-Bissau", "dial_code": "245", "code": "GW" },
      { "name": "Guyana", "dial_code": "595", "code": "GY" },
      { "name": "Haiti", "dial_code": "509", "code": "HT" },
      { "name": "Holy See (Vatican City State)", "dial_code": "379", "code": "VA" },
      { "name": "Honduras", "dial_code": "504", "code": "HN" },
      { "name": "Hong Kong", "dial_code": "852", "code": "HK" },
      { "name": "Hungary", "dial_code": "36", "code": "HU" },
      { "name": "Iceland", "dial_code": "354", "code": "IS" },
      { "name": "India", "dial_code": "91", "code": "IN" },
      { "name": "Indonesia", "dial_code": "62", "code": "ID" },
      { "name": "Iran, Islamic Republic of Persian Gulf", "dial_code": "98", "code": "IR" },
      { "name": "Iraq", "dial_code": "964", "code": "IQ" },
      { "name": "Ireland", "dial_code": "353", "code": "IE" },
      { "name": "Isle of Man", "dial_code": "44", "code": "IM" },
      { "name": "Israel", "dial_code": "972", "code": "IL" },
      { "name": "Italy", "dial_code": "39", "code": "IT" },
      { "name": "Jamaica", "dial_code": "1876", "code": "JM" },
      { "name": "Japan", "dial_code": "81", "code": "JP" },
      { "name": "Jersey", "dial_code": "44", "code": "JE" },
      { "name": "Jordan", "dial_code": "962", "code": "JO" },
      { "name": "Kazakhstan", "dial_code": "77", "code": "KZ" },
      { "name": "Kenya", "dial_code": "254", "code": "KE" },
      { "name": "Kiribati", "dial_code": "686", "code": "KI" },
      { "name": "Korea, Democratic People's Republic of Korea", "dial_code": "850", "code": "KP" },
      { "name": "Korea, Republic of South Korea", "dial_code": "82", "code": "KR" },
      { "name": "Kuwait", "dial_code": "965", "code": "KW" },
      { "name": "Kyrgyzstan", "dial_code": "996", "code": "KG" },
      { "name": "Laos", "dial_code": "856", "code": "LA" },
      { "name": "Latvia", "dial_code": "371", "code": "LV" },
      { "name": "Lebanon", "dial_code": "961", "code": "LB" },
      { "name": "Lesotho", "dial_code": "266", "code": "LS" },
      { "name": "Liberia", "dial_code": "231", "code": "LR" },
      { "name": "Libyan Arab Jamahiriya", "dial_code": "218", "code": "LY" },
      { "name": "Liechtenstein", "dial_code": "423", "code": "LI" },
      { "name": "Lithuania", "dial_code": "370", "code": "LT" },
      { "name": "Luxembourg", "dial_code": "352", "code": "LU" }, 
      { "name": "Macao", "dial_code": "853", "code": "MO" },
      { "name": "Macedonia", "dial_code": "389", "code": "MK" },
      { "name": "Madagascar", "dial_code": "261", "code": "MG" },
      { "name": "Malawi", "dial_code": "265", "code": "MW" },
      { "name": "Malaysia", "dial_code": "60", "code": "MY" },
      { "name": "Maldives", "dial_code": "960", "code": "MV" },
      { "name": "Mali", "dial_code": "223", "code": "ML" },
      { "name": "Malta", "dial_code": "356", "code": "MT" },
      { "name": "Marshall Islands", "dial_code": "692", "code": "MH" },
      { "name": "Martinique", "dial_code": "596", "code": "MQ" },
      { "name": "Mauritania", "dial_code": "222", "code": "MR" },
      { "name": "Mauritius", "dial_code": "230", "code": "MU" },
      { "name": "Mayotte", "dial_code": "262", "code": "YT" },
      { "name": "Mexico", "dial_code": "52", "code": "MX" },
      { "name": "Micronesia, Federated States of Micronesia", "dial_code": "691", "code": "FM" },
      { "name": "Moldova", "dial_code": "373", "code": "MD" },
      { "name": "Monaco", "dial_code": "377", "code": "MC" },
      { "name": "Mongolia", "dial_code": "976", "code": "MN" },
      { "name": "Montenegro", "dial_code": "382", "code": "ME" },
      { "name": "Montserrat", "dial_code": "1664", "code": "MS" }, 
      { "name": "Morocco", "dial_code": "212", "code": "MA" },
      { "name": "Mozambique", "dial_code": "258", "code": "MZ" },
      { "name": "Myanmar", "dial_code": "95", "code": "MM" },
      { "name": "Namibia", "dial_code": "264", "code": "NA" },
      { "name": "Nauru", "dial_code": "674", "code": "NR" }, 
      { "name": "Nepal", "dial_code": "977", "code": "NP" },
      { "name": "Netherlands", "dial_code": "31", "code": "NL" },
      { "name": "Netherlands Antilles", "dial_code": "599", "code": "AN" },
      { "name": "New Caledonia", "dial_code": "687", "code": "NC" }, 
      { "name": "New Zealand", "dial_code": "64", "code": "NZ" },
      { "name": "Nicaragua", "dial_code": "505", "code": "NI" },
      { "name": "Niger", "dial_code": "227", "code": "NE" }, 
      { "name": "Nigeria", "dial_code": "234", "code": "NG" },
      { "name": "Niue", "dial_code": "683", "code": "NU" }, 
      { "name": "Norfolk Island", "dial_code": "672", "code": "NF" },
      { "name": "Northern Mariana Islands", "dial_code": "1670", "code": "MP" },
      { "name": "Norway", "dial_code": "47", "code": "NO" }, 
      { "name": "Oman", "dial_code": "968", "code": "OM" },
      { "name": "Pakistan", "dial_code": "92", "code": "PK" }, 
      { "name": "Palau", "dial_code": "680", "code": "PW" },
      {"name": "Palestinian Territory, Occupied", "dial_code": "970", "code": "PS" }, 
      { "name": "Panama", "dial_code": "507", "code": "PA" },
      { "name": "Papua New Guinea", "dial_code": "675", "code": "PG" }, 
      { "name": "Paraguay", "dial_code": "595", "code": "PY" },
      { "name": "Peru", "dial_code": "51", "code": "PE" }, 
      { "name": "Philippines", "dial_code": "63", "code": "PH" },
      { "name": "Pitcairn", "dial_code": "872", "code": "PN" }, 
      { "name": "Poland", "dial_code": "48", "code": "PL" },
      { "name": "Portugal", "dial_code": "351", "code": "PT" }, 
      { "name": "Puerto Rico", "dial_code": "1939", "code": "PR" },
      { "name": "Qatar", "dial_code": "974", "code": "QA" }, 
      { "name": "Romania", "dial_code": "40", "code": "RO" },
      { "name": "Russia", "dial_code": "7", "code": "RU" }, 
      { "name": "Rwanda", "dial_code": "250", "code": "RW" },
      { "name": "Reunion", "dial_code": "262", "code": "RE" }, 
      { "name": "Saint Barthelemy", "dial_code": "590", "code": "BL" },
      { "name": "Saint Helena, Ascension and Tristan Da Cunha", "dial_code": "290", "code": "SH" },
      { "name": "Saint Kitts and Nevis", "dial_code": "1869", "code": "KN" }, 
      { "name": "Saint Lucia", "dial_code": "1758", "code": "LC" },
      { "name": "Saint Martin", "dial_code": "590", "code": "MF" }, 
      { "name": "Saint Pierre and Miquelon", "dial_code": "508", "code": "PM" },
      { "name": "Saint Vincent and the Grenadines", "dial_code": "1784", "code": "VC" }, 
      { "name": "Samoa", "dial_code": "685", "code": "WS" },
      { "name": "San Marino", "dial_code": "378", "code": "SM" }, 
      { "name": "Sao Tome and Principe", "dial_code": "239", "code": "ST" },
      { "name": "Saudi Arabia", "dial_code": "966", "code": "SA" }, 
      { "name": "Senegal", "dial_code": "221", "code": "SN" },
      { "name": "Serbia", "dial_code": "381", "code": "RS" }, 
      { "name": "Seychelles", "dial_code": "248", "code": "SC" },
      { "name": "Sierra Leone", "dial_code": "232", "code": "SL" }, 
      { "name": "Singapore", "dial_code": "65", "code": "SG" },
      { "name": "Slovakia", "dial_code": "421", "code": "SK" }, 
      { "name": "Slovenia", "dial_code": "386", "code": "SI" },
      { "name": "Solomon Islands", "dial_code": "677", "code": "SB" }, 
      { "name": "Somalia", "dial_code": "252", "code": "SO" },
      { "name": "South Africa", "dial_code": "27", "code": "ZA" }, 
      { "name": "South Sudan", "dial_code": "211", "code": "SS" },
      { "name": "South Georgia and the South Sandwich Islands", "dial_code": "500", "code": "GS" },
      { "name": "Spain", "dial_code": "34", "code": "ES" },
      { "name": "Sri Lanka", "dial_code": "94", "code": "LK" }, 
      { "name": "Sudan", "dial_code": "249", "code": "SD" },
      { "name": "Suriname", "dial_code": "597", "code": "SR" },
      { "name": "Svalbard and Jan Mayen", "dial_code": "47", "code": "SJ" },
      { "name": "Swaziland", "dial_code": "268", "code": "SZ" }, 
      { "name": "Sweden", "dial_code": "46", "code": "SE" },
      { "name": "Switzerland", "dial_code": "41", "code": "CH" }, 
      { "name": "Syrian Arab Republic", "dial_code": "963", "code": "SY" },
      { "name": "Taiwan", "dial_code": "886", "code": "TW" }, 
      { "name": "Tajikistan", "dial_code": "992", "code": "TJ" },
      { "name": "Tanzania, United Republic of Tanzania", "dial_code": "255", "code": "TZ" },
      { "name": "Thailand", "dial_code": "66", "code": "TH" },
      { "name": "Timor-Leste", "dial_code": "670", "code": "TL" },
      { "name": "Togo", "dial_code": "228", "code": "TG" },
      { "name": "Tokelau", "dial_code": "690", "code": "TK" },
      { "name": "Tonga", "dial_code": "676", "code": "TO" },
      { "name": "Trinidad and Tobago", "dial_code": "1868", "code": "TT" },
      { "name": "Tunisia", "dial_code": "216", "code": "TN" },
      { "name": "Turkey", "dial_code": "90", "code": "TR" },
      { "name": "Turkmenistan", "dial_code": "993", "code": "TM" },
      { "name": "Turks and Caicos Islands", "dial_code": "1649", "code": "TC" },
      { "name": "Tuvalu", "dial_code": "688", "code": "TV" },
      { "name": "Uganda", "dial_code": "256", "code": "UG" },
      { "name": "Ukraine", "dial_code": "380", "code": "UA" },
      { "name": "United Arab Emirates", "dial_code": "971", "code": "AE" },
      { "name": "United Kingdom", "dial_code": "44", "code": "GB" },
      { "name": "United States", "dial_code": "1", "code": "US" },
      { "name": "Uruguay", "dial_code": "598", "code": "UY" },
      { "name": "Uzbekistan", "dial_code": "998", "code": "UZ" },
      { "name": "Vanuatu", "dial_code": "678", "code": "VU" },
      { "name": "Venezuela, Bolivarian Republic of Venezuela", "dial_code": "58", "code": "VE" },
      { "name": "Vietnam", "dial_code": "84", "code": "VN" },
      { "name": "Virgin Islands, British", "dial_code": "1284", "code": "VG" },
      { "name": "Virgin Islands, U.S.", "dial_code": "1340", "code": "VI" },
      { "name": "Wallis and Futuna", "dial_code": "681", "code": "WF" },
      { "name": "Yemen", "dial_code": "967", "code": "YE" },
      { "name": "Zambia", "dial_code": "260", "code": "ZM" },
      { "name": "Zimbabwe", "dial_code": "263", "code": "ZW" }]} ''';

    // Parse the JSON string into a Dart map
    Map<String, dynamic> json = jsonDecode(countryJson.toString());

    // Extract the list of countries from the JSON map
    List<dynamic> countriesJson = json['CCODE'];
    debugPrint("countries json ${countriesJson.toString()}");
    // Convert each JSON entry into a Country object
    List<CCODE?> countries = countriesJson.map<CCODE>((val) => CCODE.fromJson(val)).toList();
    String? dialCode = getDialCodeByName(usercountry[0].toUpperCase() + usercountry.substring(1), countries);
    return dialCode;
  }

  Future<void> _callLoginWebService(String phoneNumber, String countryCode, String uniqueId) async {
    try {
      AapoortiUtilities.getProgressDialog(pr!);

      Map<String, dynamic> urlinput = {
        "userId": "",
        "pass": "",
        "cToken": "",
        "sToken": "",
        "os": "",
        "token4": "MOBILE_OTP",
        "token5": "$countryCode~$phoneNumber~$uniqueId"
      };

      String urlInputString = json.encode(urlinput);
      debugPrint("url input $urlinput");

      //NAME FOR POST PARAM
      String paramName = 'UserLogin';

      //Form Body For URL
      String formBody = paramName + '=' + Uri.encodeQueryComponent(urlInputString);

      var url = "https://ireps.gov.in/Aapoorti/ServiceCall" + 'Login/UserLogin';

      debugPrint("url = " + url);

      final response = await http.post(Uri.parse(url),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: formBody, encoding: Encoding.getByName("utf-8"));
      var jsonResult = json.decode(response.body);
      debugPrint("my REs $jsonResult");
      pr!.hide();
      showDialog(context: context, barrierDismissible: false, builder: (ctx) => AlertDialog(
        title: const Text("Login Credential for Desktop Web Application"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Text("Login ID :: ${jsonResult[0]['MOBILE_NO'].toString()}"),
            //SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Country Code : ',
                    style: TextStyle(
                      color: Colors.black, // Set the color for the normal text
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: '${jsonResult[0]['MOBILE_NO'].toString().split("-").first} ',
                    style: TextStyle(
                      color: Colors.black, // Set the color for the normal text
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            //Text("Country Code : ${jsonResult[0]['MOBILE_NO'].toString().split("-").first} || Mobile No. : ${jsonResult[0]['MOBILE_NO'].toString().split("-").last}"),
            SizedBox(height: 15),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Mobile No. : ',
                    style: TextStyle(
                      color: Colors.black, // Set the color for the normal text
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: '${jsonResult[0]['MOBILE_NO'].toString().split("-").last}',
                    style: TextStyle(
                      color: Colors.black, // Set the color for the text in bold
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'OTP :: '),
                  TextSpan(
                    text: jsonResult[0]['OTP'].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.cyan[400],
                  borderRadius: BorderRadius.circular(8.0)
              ),
              padding: const EdgeInsets.all(14),
              child: const Text("okay", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ));
    } on PlatformException catch (e) {
      debugPrint("Failed to get data from native : '${e.message}'.");
      AapoortiUtilities.stopProgress(pr!);
    }
    catch(e){
      AapoortiUtilities.stopProgress(pr!);
    }
  }

  Future<String?> getDeviceId() async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  }

  // Function to get the dial code by country name
  String? getDialCodeByName(String name, List<CCODE?> countries) {
    for(var country in countries) {
      if (country?.name == name) {
        return country?.dialCode;
      }
    }
    return null; // Return null if the country is not found
  }

  // String getMobile(String phoneNumber) {
  //      //String countryCode = phoneNumber.substring(1, phoneNumber.length - 10);
  //     //print("my phone $phoneNumber");
  //     // Extracting mobile number
  //     String mobileNumber = phoneNumber.substring(phoneNumber.length - 10);
  //
  //     //print('Country Code: $countryCode'); // Output: Country Code: 1
  //     //print('Mobile Number: $mobileNumber'); // Output: Mobile Number: 234567890
  //
  //     return mobileNumber;
  //
  // }

}
