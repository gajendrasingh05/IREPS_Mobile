import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_app/mmis/helpers/api.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_app/mmis/controllers/changepin_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePinScreen extends GetWidget<ChangePinController> {

  final changePinController = Get.put(ChangePinController());

  GlobalKey _snackKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController? _emailcontroller = TextEditingController();
  final TextEditingController? _oldpwdcontroller = TextEditingController();
  final TextEditingController? _newpwdcontroller = TextEditingController();
  final TextEditingController? _cnfmpwdcontroller = TextEditingController();


  dynamic jsonResult = null;
  var errorcode = 0;
  late String ohashPassOutput, nhashPassOutput;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _snackKey,
      appBar: AppBar(
        backgroundColor: MyColor.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Change Pin", style: TextStyle(color: Colors.white)),
        //centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                // Card(
                //   elevation: 4,
                //   shape: RoundedRectangleBorder(
                //       side: BorderSide(width: 2.0, color: Colors.indigo),
                //       borderRadius: BorderRadius.circular(10.0)),
                //   child: Padding(
                //     padding: const EdgeInsets.all(15.0),
                //     child: Image.asset('assets/images/cris_logo.png', color: Colors.indigo.shade500),
                //   ),
                // ),
                SizedBox(height: 10.0),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, color: Colors.indigo),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 5.0),
                        Obx(() {
                          return TextFormField(
                            enabled: false,
                            controller: _emailcontroller,
                            onSaved: (value) {},
                            style: TextStyle(),
                            decoration: InputDecoration(
                              hintText: "Enter Registered Email ID",
                              label: Text(controller.emailValue!, style: TextStyle(color: Colors.black)),
                              icon: Icon(
                                Icons.account_circle_sharp,
                                color: Colors.blue[800],
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, color: Colors.indigo),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 5.0),
                          TextFormField(
                            initialValue: null,
                            keyboardType: TextInputType.text,
                            controller: _oldpwdcontroller,
                            validator: ValidationBuilder().minLength(6).maxLength(12).build(),
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter Old Pin',
                              labelText: 'Enter Old Pin',
                              contentPadding: EdgeInsetsDirectional.all(10),
                              border: const OutlineInputBorder(),
                              icon: Icon(
                                Icons.lock_outline_sharp,
                                color: Colors.indigo.shade600,
                              ),
                            ),
                          ),
                          SizedBox(height: 25.0),
                          TextFormField(
                            initialValue: null,
                            keyboardType: TextInputType.text,
                            controller: _newpwdcontroller,
                            validator: ValidationBuilder().minLength(6).maxLength(12).build(),
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter New Pin',
                              labelText: 'Enter New Pin',
                              contentPadding: EdgeInsetsDirectional.all(10),
                              border: const OutlineInputBorder(),
                              icon: Icon(
                                Icons.lock,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                          SizedBox(height: 25.0),
                          TextFormField(
                            initialValue: null,
                            keyboardType: TextInputType.text,
                            validator: ValidationBuilder().minLength(6).maxLength(12).build(),
                            obscureText: true,
                            controller: _cnfmpwdcontroller,
                            decoration: InputDecoration(
                              hintText: 'Confirm Pin',
                              labelText: 'Confirm Pin',
                              contentPadding: EdgeInsetsDirectional.all(10),
                              border: const OutlineInputBorder(),
                              icon: Icon(
                                Icons.lock,
                                color: Colors.indigo.shade600,
                              ),
                            ),
                          ),
                          SizedBox(height: 40.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 45.0,
                                width: Get.width * 0.35,
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                              (color) => Colors.red),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(200.0))),
                                      elevation: MaterialStateProperty.all(7.0),
                                      side: MaterialStateProperty.all(BorderSide(
                                          color: Colors.white, width: 2.0))),
                                  onPressed: () {
                                    _formKey.currentState!.reset();
                                  },
                                  child: Text('Reset',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.0),
                              Container(
                                height: 45.0,
                                width: Get.width * 0.35,
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                              (color) => Colors.indigo.shade400),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(20.0))),
                                      //overlayColor: MaterialStateProperty.resolveWith((color) => Colors.red[300])
                                      elevation: MaterialStateProperty.all(7.0),
                                      side: MaterialStateProperty.all(BorderSide(
                                          color: Colors.white, width: 2.0))),
                                  onPressed: () async {
                                    if(_formKey.currentState!.validate()) {
                                      FocusScope.of(context).unfocus();
                                      _callLoginWebService(controller.emailValue!.trim(), _oldpwdcontroller!.text.trim(), _newpwdcontroller!.text.trim()).then((data){
                                         if(data){
                                           Get.toNamed(Routes.loginScreen);
                                         }
                                      });
                                      //Get.bottomSheet(isDismissible: false, SuccessBottomSheet());
                                    }
                                  },
                                    child: Text('Submit', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _callLoginWebService(String email, String opin, String npin) async {
    debugPrint('Function called ' + email.toString() + "-------" + opin.toString());
    try {
      var oinput = email + "#" + opin;
      var bytes = utf8.encode(oinput);
      ohashPassOutput = sha256.convert(bytes).toString();
      debugPrint("oldhashPass = " + ohashPassOutput.toString());
    } on PlatformException catch (e) {
      debugPrint("Failed to get data from native : '${e.message}'.");
    }
    try {
      var ninput = email + "#" + npin;
      var bytes = utf8.encode(ninput);
      nhashPassOutput = sha256.convert(bytes).toString();

      debugPrint("newhashPass = " + nhashPassOutput.toString());
    } on PlatformException catch (e) {
      debugPrint("Failed to get data from native : '${e.message}'.");
    }
    var random = Random.secure();
    String ctoken = random.nextInt(100).toString();

    for (var i = 1; i < 10; i++) {
      ctoken = ctoken + random.nextInt(100).toString();
    }
    ctoken = ctoken + random.nextInt(10).toString();
    Map<String, dynamic> urlinput = {
      "input_type": "UdmChangePin",
      "input": email + '~' + nhashPassOutput + '~' + ohashPassOutput + '~' + ctoken,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var userinput1={"userId":"vdev@gmail.com","pass":"nLatDbjLGZkywYhA6cxdDqkDHDycKHvKwXBMrI0FPec=","oldpass":"xTDopCCaUsy6xt4cOtMRTOWaRV1O8u8Arvt281elo3o=","cId":"62860158858222445764"};
    debugPrint("input  " + urlinput.toString());
    String urlInputString = json.encode(urlinput);
    try {
      //---------------------- trial Url -------------------
      //var response = await Network.postDataWithPro(UrlContainer.trialbaseUrl+UrlContainer.loginEndPoint,'UdmChangePin', email + '~' + nhashPassOutput + '~' + ohashPassOutput + '~' + ctoken ,prefs.getString('token'));
      //---------------------- prod Url -------------------
      var response = await Network.postDataWithPro(UrlContainer.baseUrl+UrlContainer.loginEndPoint,'UdmChangePin', email + '~' + nhashPassOutput + '~' + ohashPassOutput + '~' + ctoken ,prefs.getString('token'));
      jsonResult = json.decode(response.body);
      debugPrint("json result = " + jsonResult.toString());
      debugPrint("response code = " + response.statusCode.toString());
      if(response.statusCode == 200) {
        if(jsonResult['status'] == 'OK') {

          // IRUDMConstants().showSnack('data', context);
          return true;
        } else
          return false;
      } else {
        //IRUDMConstants.removeProgressIndicator(context);
        return false;
      }
    } on HttpException {
      //IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      //IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      //IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      //IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
  }
}
