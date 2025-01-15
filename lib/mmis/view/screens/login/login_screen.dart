import 'package:flutter_app/aapoorti/common/CommonScreen.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:get/get.dart';
import 'package:flutter_app/mmis/controllers/login_controller.dart';
import 'package:flutter_app/mmis/controllers/network_controller.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  //final networkController = Get.find<NetworkController>();

  //final controller = Get.find<LoginController>();
  final controller = Get.put<LoginController>(LoginController());

  final networkController = Get.put<NetworkController>(NetworkController());
  var username, password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    controller.loginState = LoginState.idle.obs;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        //floatingActionButton: SwitchLanguageButton(color: Colors.black),
        //floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CommonScreen()));
              //Navigator.of(context).pop();
            },
          ),
          // actions: [
          //   SwitchLanguageButton(color: Colors.black)
          // ],
          centerTitle: true,
          title: Text(language.text('login'), style: TextStyle(color: Colors.white)), // You can customize the title
          backgroundColor: Colors.indigo,
        ),
        body: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            color : Colors.white
            // image: DecorationImage(
            //   image: AssetImage("assets/images/login_bg.jpg"),
            //   fit: BoxFit.cover,
            // ),
          ),
          child: Column(
            children: [
              Expanded(child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Stack(
                        children: [
                          Card(
                              color: Colors.white.withOpacity(0.8),
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(20),
                              // ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.indigo, width: 1.5)),
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Form(
                                  key: _formKey,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    children: [
                                      // Image.asset('assets/images/cris_logo.png',color: Colors.indigo, width: Get.width / 4, height: Get.width / 4),
                                      // const SizedBox(height: 10),
                                      // Text("क्रिस एमएमआईएस ",
                                      //     textAlign: TextAlign.center,
                                      //     style: TextStyle(fontSize: 16, color: Colors.indigo)),
                                      const SizedBox(height: 10),
                                      Text("CRIS MMIS",
                                          textAlign: TextAlign.center, style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 18)),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.emailAddress,
                                        controller: _usernameController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                          labelText: 'userid'.tr,
                                          prefixIcon: const Icon(Icons.mail),
                                          labelStyle: TextStyle(fontSize: 15),
                                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.indigo, width: 1.0),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          focusColor: Colors.red[300],
                                        ),
                                        validator: ValidationBuilder().email().maxLength(60).build(),
                                        onSaved: (val) {
                                          username = val;
                                        },
                                      ),
                                      const SizedBox(height: 30),
                                      Obx(() => TextFormField(
                                        obscureText: controller.isVisible,
                                        keyboardType: TextInputType.text,
                                        controller: _passwordController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                          labelText: 'pin'.tr,
                                          prefixIcon: Icon(Icons.vpn_key),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              controller.isVisible ? controller.isVisible = false : controller.isVisible = true;
                                            },
                                            icon: controller.isVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                                          ),
                                          labelStyle: TextStyle(fontSize: 15),
                                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.indigo, width: 1.0),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          focusColor: Colors.red[300],
                                        ),
                                        validator: ValidationBuilder().minLength(6).maxLength(12).build(),
                                        onSaved: (val) {
                                          password = val;
                                        },
                                      )),
                                      const SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Obx(() => Checkbox(
                                              value: controller.checkValue,
                                              onChanged: (value) {
                                                controller.checkValue = value!;
                                              })
                                          ),
                                          SizedBox(width: Get.width/100),
                                          Padding(
                                            padding: EdgeInsets.only(top: 11.0),
                                            child: SizedBox(
                                                child: Text('svcred'.tr,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w300))),
                                          )
                                        ],
                                      ),
                                      Obx((){
                                        if(controller.loginState.value == LoginState.idle){
                                          Future.delayed(Duration.zero, () async {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            _usernameController.text = (prefs.containsKey('mmisemail') ? prefs.getString('mmisemail') :  "")!;
                                            _passwordController.text = '';
                                          });
                                          return ElevatedButton(
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, minimumSize: Size.fromHeight(45),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                                  textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                              onPressed: () async{
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                if(networkController.connectionStatus.value != 0){
                                                  if(_formKey.currentState!.validate()){
                                                    controller.loginUsers(_usernameController.text.trim(), _passwordController.text.trim(), controller.checkValue);
                                                  }
                                                }
                                                else{
                                                  ToastMessage.networkError('plcheckconn'.tr);
                                                }
                                              },
                                              child: Text('login'.tr, style: TextStyle(color: Colors.white, fontSize: 18.0)));
                                        }
                                        else if(controller.loginState.value == LoginState.loading){
                                          return Container(height: 55, width: 55, decoration: BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(27.5)), alignment: Alignment.center, child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0)));
                                        }
                                        else if(controller.loginState.value == LoginState.success){
                                          return Container(height: 55, width: 55, child: Icon(Icons.done_rounded,color: Colors.white,  size: 30.0), decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(27.5)));
                                        }
                                        else if(controller.loginState.value == LoginState.failedWithError || controller.loginState.value == LoginState.failed){
                                          return Container(height: 55, width: 55, child: Icon(Icons.clear,color: Colors.white,  size: 30.0), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(27.5)));
                                        }
                                        return ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, minimumSize: Size.fromHeight(45),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                                textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                            onPressed: () {
                                              FocusManager.instance.primaryFocus?.unfocus();
                                              if(networkController.connectionStatus.value != 0){
                                                if(_formKey.currentState!.validate()){
                                                  controller.loginUsers(_usernameController.text.trim(), _passwordController.text.trim(), controller.checkValue);
                                                }
                                              }
                                              else{
                                                ToastMessage.networkError('plcheckconn'.tr);
                                              }
                                            },
                                            child: Text('login'.tr, style: TextStyle(color: Colors.white, fontSize: 18.0)));
                                      }),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextButton ( onPressed: (){
                                            Get.toNamed(Routes.reqsetPinScreen, arguments: ['0']);
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                           ),
                                          child: Text('Set PIN for CRIS MMIS', style:
                                            TextStyle(fontFamily: 'Roboto', decorationColor: Color(0xFF007BFF),  decoration: TextDecoration.underline, color: Color(0xFF007BFF), fontSize: 14, fontWeight: FontWeight.bold))),
                                          SizedBox(width: 15),
                                          Row(
                                            children: [
                                              Container(
                                                height: 15,  // Line thickness
                                                width: 1.5, // Length of the line
                                                color: Colors.blueGrey, // Line color
                                              ),
                                              SizedBox(width: 5),
                                              Container(
                                                height: 15,  // Line thickness
                                                width: 1.5, // Length of the line
                                                color: Colors.blueGrey, // Line color
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 15),
                                          TextButton(
                                              onPressed: (){
                                                Get.toNamed(Routes.reqsetPinScreen, arguments: ['1']);
                                              },
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero, // No padding
                                              ),
                                              child: Text('Forget PIN', style:
                                              TextStyle(fontFamily: 'Roboto', decorationColor: Color(0xFFDC3545), decoration: TextDecoration.underline, color: Color(0xFFDC3545), fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                        ],
                                      ),
                                      //SizedBox(height: 15.0),
                                    ],
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ))
            ],
          ),
        )
    );
  }

  Future<void> _enableAndResetModalSheet(BuildContext context, String type, LanguageProvider language) async {
    return await showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        clipBehavior: Clip.hardEdge,
        builder: (_) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12.0)),
                        alignment: Alignment.center,
                        child: Icon(Icons.clear, size: 15, color: Colors.white),
                      )),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      type == 'reset' ? 'resetpinto'.tr : 'loginaccess'.tr,
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 32.0)),
                    Text("1.", style: TextStyle(fontSize: 16.0)),
                    SizedBox(width: 5),
                    Text('loginto'.tr, style: TextStyle(fontSize: 16.0)),
                    Padding(padding: EdgeInsets.only(left: 35.0)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 32.0)),
                    Text("2.", style: TextStyle(fontSize: 16.0)),
                    SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        'clickon'.tr,
                        style: TextStyle(fontSize: 16.0),
                        softWrap: true,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 32.0)),
                    Text("3.", style: TextStyle(fontSize: 16.0)),
                    SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        type == 'reset' ? 'resetapppin'.tr : 'mobileaccess'.tr,
                        style: TextStyle(fontSize: 16.0,
                          // color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}





