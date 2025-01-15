import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/mmis/controllers/login_controller.dart';
import 'package:flutter_app/mmis/controllers/network_controller.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';

class ReqSetPinScreen extends StatefulWidget {
  const ReqSetPinScreen({super.key});

  @override
  State<ReqSetPinScreen> createState() => _ReqSetPinScreen();
}

class _ReqSetPinScreen extends State<ReqSetPinScreen> {
  final GlobalKey<FormState> _reqformKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _setformKey = GlobalKey<FormState>();

  final _otpController = TextEditingController();

  final _pinController = TextEditingController();
  final _confirmpinController = TextEditingController();

  final _emailController = TextEditingController();

  final _mobileController = TextEditingController();

  final networkController = Get.find<NetworkController>();
  final controller = Get.find<LoginController>();

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {

    String reqtype = Get.arguments[0];
    debugPrint("Request type $reqtype");

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () {
        //     //Navigator.push(context, MaterialPageRoute(builder: (context) => CommonScreen()));
        //     Navigator.of(context).pop();
        //   },
        // ),
        // actions: [
        //   SwitchLanguageButton(color: Colors.black)
        // ],
        centerTitle: true,
        title: Text("CRIS MMIS", style: TextStyle(color: Colors.white)), // You can customize the title
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: Colors.white
          // image: DecorationImage(
          //   image: AssetImage("assets/images/login_bg.jpg"),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Column(
          children: [
            Expanded(
                child: SafeArea(
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
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: const BorderSide(
                                        color: Colors.indigo, width: 1.5)),
                                elevation: 5.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Form(
                                    key: _reqformKey,
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        Text("Request to set PIN",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          keyboardType:
                                          TextInputType.emailAddress,
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10.0)),
                                            labelText:
                                            "Enter registered email address",
                                            prefixIcon: const Icon(Icons.mail),
                                            labelStyle: TextStyle(fontSize: 15),
                                            floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.indigo,
                                                  width: 1.0),
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                            ),
                                            focusColor: Colors.red[300],
                                          ),
                                          validator: ValidationBuilder().email().maxLength(60).build(),
                                        ),
                                        const SizedBox(height: 30),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: _mobileController,
                                          decoration: InputDecoration(
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10.0)),
                                            labelText:
                                            "Enter registered mobile number",
                                            prefixIcon:
                                            Icon(Icons.mobile_friendly),
                                            labelStyle: TextStyle(fontSize: 15),
                                            floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.indigo,
                                                  width: 1.0),
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                            ),
                                            focusColor: Colors.red[300],
                                          ),
                                          validator: ValidationBuilder()
                                              .maxLength(10)
                                              .build(),
                                        ),
                                        const SizedBox(height: 30),
                                        Obx(() {
                                          if (controller.reqsetpinState.value == ReqSetPinState.idle) {
                                            return ElevatedButton(
                                                onPressed: () {
                                                  FocusManager.instance.primaryFocus?.unfocus();
                                                  if(networkController.connectionStatus.value != 0) {
                                                    if (_reqformKey.currentState!.validate()) {
                                                      if (_mobileController.text.trim().length == 10) {
                                                        Random random = Random();
                                                        int randomNumber = random.nextInt(900000) + 100000;
                                                        controller.reqsetPin(_emailController.text.trim(), _mobileController.text.trim(), 'CM' + randomNumber.toString(), reqtype, context);

                                                      } else {
                                                        ToastMessage.error("Please enter valid mobile number");
                                                      }
                                                    }
                                                  } else {
                                                    ToastMessage.networkError('plcheckconn'.tr);
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                    Colors.indigo,
                                                    minimumSize:
                                                    Size.fromHeight(45),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10.0)),
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.bold)),
                                                child: Text("Submit",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0)));
                                          }
                                          else if (controller.reqsetpinState.value == ReqSetPinState.loading) {
                                            return Container(
                                                height: 55,
                                                width: 55,
                                                decoration: BoxDecoration(
                                                    color: Colors.deepOrange,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        27.5)),
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child:
                                                    CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2.0)));
                                          }
                                          else if (controller.reqsetpinState.value == ReqSetPinState.failed || controller.reqsetpinState.value == ReqSetPinState.failedWithError) {
                                            return InkWell(
                                                onTap: () {
                                                  if (_reqformKey.currentState!
                                                      .validate()) {
                                                    Random random = Random();
                                                    int randomNumber =
                                                        random.nextInt(900000) +
                                                            100000;
                                                    controller.reqsetPin(
                                                        _emailController.text
                                                            .trim(),
                                                        _mobileController.text
                                                            .trim(),
                                                        'CM' +
                                                            randomNumber
                                                                .toString(), reqtype,
                                                        context);
                                                  }
                                                },
                                                child: Container(
                                                    height: 55,
                                                    width: 55,
                                                    child: Icon(Icons.clear,
                                                        color: Colors.white,
                                                        size: 30.0),
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            27.5))));
                                          }
                                          return ElevatedButton(
                                              onPressed: () {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                if (networkController
                                                    .connectionStatus
                                                    .value !=
                                                    0) {
                                                  if (_reqformKey.currentState!
                                                      .validate()) {
                                                    if (_mobileController.text
                                                        .trim()
                                                        .length ==
                                                        10) {
                                                      Random random = Random();
                                                      int randomNumber = random
                                                          .nextInt(900000) +
                                                          100000;
                                                      controller.reqsetPin(
                                                          _emailController.text
                                                              .trim(),
                                                          _mobileController.text
                                                              .trim(),
                                                          'CM' +
                                                              randomNumber
                                                                  .toString(), reqtype,
                                                          context);
                                                    } else {
                                                      ToastMessage.error(
                                                          "Please enter valid mobile number");
                                                    }
                                                  }
                                                } else {
                                                  ToastMessage.networkError(
                                                      'plcheckconn'.tr);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                  Colors.indigo,
                                                  minimumSize:
                                                  Size.fromHeight(45),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold)),
                                              child: Text("Submit",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18.0)));
                                        }),
                                        const SizedBox(height: 20),
                                        Text("(This PIN will be used only for CRIS MMIS login on Mobile App)", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontFamily: 'Roboto', color: Colors.teal[900]))
                                      ],
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
      // body: PageView(
      //   controller: _pageController,
      //   onPageChanged: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //   },
      //   children: [
      //     Container(
      //       height: Get.height,
      //       width: Get.width,
      //       decoration: BoxDecoration(color: Colors.white
      //           // image: DecorationImage(
      //           //   image: AssetImage("assets/images/login_bg.jpg"),
      //           //   fit: BoxFit.cover,
      //           // ),
      //           ),
      //       child: Column(
      //         children: [
      //           Expanded(
      //               child: SafeArea(
      //             child: Center(
      //               child: SingleChildScrollView(
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(15.0),
      //                   child: Stack(
      //                     children: [
      //                       Card(
      //                           color: Colors.white.withOpacity(0.8),
      //                           // shape: RoundedRectangleBorder(
      //                           //   borderRadius: BorderRadius.circular(20),
      //                           // ),
      //                           shape: RoundedRectangleBorder(
      //                               borderRadius: BorderRadius.circular(20.0),
      //                               side: const BorderSide(
      //                                   color: Colors.indigo, width: 1.5)),
      //                           elevation: 5.0,
      //                           child: Padding(
      //                             padding: const EdgeInsets.all(10.0),
      //                             child: Form(
      //                               key: _reqformKey,
      //                               autovalidateMode:
      //                                   AutovalidateMode.onUserInteraction,
      //                               child: Column(
      //                                 children: [
      //                                   const SizedBox(height: 10),
      //                                   Text("Request to set PIN",
      //                                       textAlign: TextAlign.center,
      //                                       style: TextStyle(
      //                                           color: Colors.indigo,
      //                                           fontWeight: FontWeight.bold,
      //                                           fontSize: 18)),
      //                                   const SizedBox(
      //                                     height: 20,
      //                                   ),
      //                                   TextFormField(
      //                                     keyboardType:
      //                                         TextInputType.emailAddress,
      //                                     controller: _emailController,
      //                                     decoration: InputDecoration(
      //                                       contentPadding:
      //                                           EdgeInsets.symmetric(
      //                                               horizontal: 10,
      //                                               vertical: 5),
      //                                       border: OutlineInputBorder(
      //                                           borderRadius:
      //                                               BorderRadius.circular(
      //                                                   10.0)),
      //                                       labelText:
      //                                           "Enter registered email address",
      //                                       prefixIcon: const Icon(Icons.mail),
      //                                       labelStyle: TextStyle(fontSize: 15),
      //                                       floatingLabelBehavior:
      //                                           FloatingLabelBehavior.auto,
      //                                       focusedBorder: OutlineInputBorder(
      //                                         borderSide: const BorderSide(
      //                                             color: Colors.indigo,
      //                                             width: 1.0),
      //                                         borderRadius:
      //                                             BorderRadius.circular(10.0),
      //                                       ),
      //                                       errorBorder: OutlineInputBorder(
      //                                         borderSide: const BorderSide(
      //                                             color: Colors.grey,
      //                                             width: 1.0),
      //                                         borderRadius:
      //                                             BorderRadius.circular(10.0),
      //                                       ),
      //                                       enabledBorder: OutlineInputBorder(
      //                                         borderSide: const BorderSide(
      //                                             color: Colors.grey,
      //                                             width: 1.0),
      //                                         borderRadius:
      //                                             BorderRadius.circular(10.0),
      //                                       ),
      //                                       focusColor: Colors.red[300],
      //                                     ),
      //                                     validator: ValidationBuilder()
      //                                         .email()
      //                                         .maxLength(60)
      //                                         .build(),
      //                                   ),
      //                                   const SizedBox(height: 30),
      //                                   TextFormField(
      //                                     keyboardType: TextInputType.number,
      //                                     controller: _mobileController,
      //                                     decoration: InputDecoration(
      //                                       contentPadding:
      //                                           EdgeInsets.symmetric(
      //                                               horizontal: 10,
      //                                               vertical: 5),
      //                                       border: OutlineInputBorder(
      //                                           borderRadius:
      //                                               BorderRadius.circular(
      //                                                   10.0)),
      //                                       labelText:
      //                                           "Enter registered mobile number",
      //                                       prefixIcon:
      //                                           Icon(Icons.mobile_friendly),
      //                                       labelStyle: TextStyle(fontSize: 15),
      //                                       floatingLabelBehavior:
      //                                           FloatingLabelBehavior.auto,
      //                                       focusedBorder: OutlineInputBorder(
      //                                         borderSide: const BorderSide(
      //                                             color: Colors.indigo,
      //                                             width: 1.0),
      //                                         borderRadius:
      //                                             BorderRadius.circular(10.0),
      //                                       ),
      //                                       errorBorder: OutlineInputBorder(
      //                                         borderSide: const BorderSide(
      //                                             color: Colors.grey,
      //                                             width: 1.0),
      //                                         borderRadius:
      //                                             BorderRadius.circular(10.0),
      //                                       ),
      //                                       enabledBorder: OutlineInputBorder(
      //                                         borderSide: const BorderSide(
      //                                             color: Colors.grey,
      //                                             width: 1.0),
      //                                         borderRadius:
      //                                             BorderRadius.circular(10.0),
      //                                       ),
      //                                       focusColor: Colors.red[300],
      //                                     ),
      //                                     validator: ValidationBuilder()
      //                                         .maxLength(10)
      //                                         .build(),
      //                                   ),
      //                                   const SizedBox(height: 30),
      //                                   Obx(() {
      //                                     if (controller.setpinState.value ==
      //                                         SetPinState.idle) {
      //                                       return ElevatedButton(
      //                                           onPressed: () {
      //                                             FocusManager
      //                                                 .instance.primaryFocus
      //                                                 ?.unfocus();
      //                                             if (networkController
      //                                                     .connectionStatus
      //                                                     .value !=
      //                                                 0) {
      //                                               if (_reqformKey.currentState!
      //                                                   .validate()) {
      //                                                 if (_mobileController.text
      //                                                         .trim()
      //                                                         .length ==
      //                                                     10) {
      //                                                   Random random =
      //                                                       Random();
      //                                                   int randomNumber =
      //                                                       random.nextInt(
      //                                                               900000) +
      //                                                           100000;
      //                                                   controller.reqsetPin(
      //                                                       _emailController
      //                                                           .text
      //                                                           .trim(),
      //                                                       _mobileController
      //                                                           .text
      //                                                           .trim(),
      //                                                       'CM' +
      //                                                           randomNumber
      //                                                               .toString(),
      //                                                       context);
      //                                                 } else {
      //                                                   ToastMessage.error(
      //                                                       "Please enter valid mobile number");
      //                                                 }
      //                                               }
      //                                             } else {
      //                                               ToastMessage.networkError(
      //                                                   Strings.plcheckconn.tr);
      //                                             }
      //                                           },
      //                                           style: ElevatedButton.styleFrom(
      //                                               backgroundColor:
      //                                                   Colors.indigo,
      //                                               minimumSize:
      //                                                   Size.fromHeight(45),
      //                                               shape:
      //                                                   RoundedRectangleBorder(
      //                                                       borderRadius:
      //                                                           BorderRadius
      //                                                               .circular(
      //                                                                   10.0)),
      //                                               textStyle: const TextStyle(
      //                                                   color: Colors.white,
      //                                                   fontWeight:
      //                                                       FontWeight.bold)),
      //                                           child: Text("Submit",
      //                                               style: TextStyle(
      //                                                   color: Colors.white,
      //                                                   fontSize: 18.0)));
      //                                     } else if (controller
      //                                             .setpinState.value ==
      //                                         SetPinState.loading) {
      //                                       return Container(
      //                                           height: 55,
      //                                           width: 55,
      //                                           decoration: BoxDecoration(
      //                                               color: Colors.deepOrange,
      //                                               borderRadius:
      //                                                   BorderRadius.circular(
      //                                                       27.5)),
      //                                           alignment: Alignment.center,
      //                                           child: SizedBox(
      //                                               height: 30,
      //                                               width: 30,
      //                                               child:
      //                                                   CircularProgressIndicator(
      //                                                       color: Colors.white,
      //                                                       strokeWidth: 2.0)));
      //                                     } else if (controller
      //                                                 .setpinState.value ==
      //                                             SetPinState.failed ||
      //                                         controller.setpinState.value ==
      //                                             SetPinState.failedWithError) {
      //                                       return InkWell(
      //                                           onTap: () {
      //                                             if (_reqformKey.currentState!
      //                                                 .validate()) {
      //                                               Random random = Random();
      //                                               int randomNumber =
      //                                                   random.nextInt(900000) +
      //                                                       100000;
      //                                               controller.reqsetPin(
      //                                                   _emailController.text
      //                                                       .trim(),
      //                                                   _mobileController.text
      //                                                       .trim(),
      //                                                   'CM' +
      //                                                       randomNumber
      //                                                           .toString(),
      //                                                   context);
      //                                             }
      //                                           },
      //                                           child: Container(
      //                                               height: 55,
      //                                               width: 55,
      //                                               child: Icon(Icons.clear,
      //                                                   color: Colors.white,
      //                                                   size: 30.0),
      //                                               decoration: BoxDecoration(
      //                                                   color: Colors.red,
      //                                                   borderRadius:
      //                                                       BorderRadius
      //                                                           .circular(
      //                                                               27.5))));
      //                                     }
      //                                     return ElevatedButton(
      //                                         onPressed: () {
      //                                           FocusManager
      //                                               .instance.primaryFocus
      //                                               ?.unfocus();
      //                                           if (networkController
      //                                                   .connectionStatus
      //                                                   .value !=
      //                                               0) {
      //                                             if (_reqformKey.currentState!
      //                                                 .validate()) {
      //                                               if (_mobileController.text
      //                                                       .trim()
      //                                                       .length ==
      //                                                   10) {
      //                                                 Random random = Random();
      //                                                 int randomNumber = random
      //                                                         .nextInt(900000) +
      //                                                     100000;
      //                                                 controller.reqsetPin(
      //                                                     _emailController.text
      //                                                         .trim(),
      //                                                     _mobileController.text
      //                                                         .trim(),
      //                                                     'CM' +
      //                                                         randomNumber
      //                                                             .toString(),
      //                                                     context);
      //                                               } else {
      //                                                 ToastMessage.error(
      //                                                     "Please enter valid mobile number");
      //                                               }
      //                                             }
      //                                           } else {
      //                                             ToastMessage.networkError(
      //                                                 Strings.plcheckconn.tr);
      //                                           }
      //                                         },
      //                                         style: ElevatedButton.styleFrom(
      //                                             backgroundColor:
      //                                                 Colors.indigo,
      //                                             minimumSize:
      //                                                 Size.fromHeight(45),
      //                                             shape: RoundedRectangleBorder(
      //                                                 borderRadius:
      //                                                     BorderRadius.circular(
      //                                                         10.0)),
      //                                             textStyle: const TextStyle(
      //                                                 color: Colors.white,
      //                                                 fontWeight:
      //                                                     FontWeight.bold)),
      //                                         child: Text("Submit",
      //                                             style: TextStyle(
      //                                                 color: Colors.white,
      //                                                 fontSize: 18.0)));
      //                                   })
      //                                 ],
      //                               ),
      //                             ),
      //                           ))
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ))
      //         ],
      //       ),
      //     ),
      //     Container(
      //       height: Get.height,
      //       width: Get.width,
      //       decoration: BoxDecoration(
      //           color : Colors.white
      //         // image: DecorationImage(
      //         //   image: AssetImage("assets/images/login_bg.jpg"),
      //         //   fit: BoxFit.cover,
      //         // ),
      //       ),
      //       child: Column(
      //         children: [
      //           Expanded(child: SafeArea(
      //             child: Center(
      //               child: SingleChildScrollView(
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(15.0),
      //                   child: Stack(
      //                     children: [
      //                       Card(
      //                           color: Colors.white.withOpacity(0.8),
      //                           // shape: RoundedRectangleBorder(
      //                           //   borderRadius: BorderRadius.circular(20),
      //                           // ),
      //                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.indigo, width: 1.5)),
      //                           elevation: 5.0,
      //                           child: Padding(
      //                             padding: const EdgeInsets.all(10.0),
      //                             child: Form(
      //                               key: _setformKey,
      //                               autovalidateMode: AutovalidateMode.onUserInteraction,
      //                               child: Column(
      //                                 children: [
      //                                   const SizedBox(height: 10),
      //                                   Text("Choose your PIN",
      //                                       textAlign: TextAlign.center, style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 18)),
      //                                   const SizedBox(
      //                                     height: 20,
      //                                   ),
      //                                   Row(
      //                                     children: [
      //                                       Text('Request ID : ', style: TextStyle(color: Colors.black, fontSize: 16)),
      //                                       Expanded(child: Text(requestId,style: TextStyle(color: Colors.black,fontSize: 16, fontWeight: FontWeight.bold)))
      //                                     ],
      //                                   ),
      //                                   const SizedBox(
      //                                     height: 5,
      //                                   ),
      //                                   Row(
      //                                     children: [
      //                                       Text('Email Address : ', style: TextStyle(color: Colors.black, fontSize: 16)),
      //                                       Expanded(child: Text(email, style: TextStyle(color: Colors.black,fontSize: 16, fontWeight: FontWeight.bold)),)
      //                                     ],
      //                                   ),
      //                                   const SizedBox(
      //                                     height: 5,
      //                                   ),
      //                                   Row(
      //                                     children: [
      //                                       Text('Mobile No. : ', style: TextStyle(color: Colors.black, fontSize: 16)),
      //                                       Expanded(child: Text(mobile, style: TextStyle(color: Colors.black,fontSize: 16, fontWeight: FontWeight.bold)),)
      //                                     ],
      //                                   ),
      //                                   const SizedBox(
      //                                     height: 15,
      //                                   ),
      //                                   TextFormField(
      //                                     keyboardType: TextInputType.number,
      //                                     controller: _otpController,
      //                                     decoration: InputDecoration(
      //                                       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //                                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      //                                       labelText: "Enter Valid OTP",
      //                                       prefixIcon: const Icon(Icons.mobile_friendly),
      //                                       labelStyle: TextStyle(fontSize: 15),
      //                                       floatingLabelBehavior: FloatingLabelBehavior.auto,
      //                                       focusedBorder: OutlineInputBorder(
      //                                         borderSide: const BorderSide(color: Colors.indigo, width: 1.0),
      //                                         borderRadius: BorderRadius.circular(10.0),
      //                                       ),
      //                                       errorBorder: OutlineInputBorder(
      //                                         borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      //                                         borderRadius: BorderRadius.circular(10.0),
      //                                       ),
      //                                       enabledBorder: OutlineInputBorder(
      //                                         borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      //                                         borderRadius: BorderRadius.circular(10.0),
      //                                       ),
      //                                       focusColor: Colors.red[300],
      //                                     ),
      //                                   ),
      //                                   const SizedBox(height: 20),
      //                                   TextFormField(
      //                                     keyboardType: TextInputType.text,
      //                                     controller: _pinController,
      //                                     decoration: InputDecoration(
      //                                       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //                                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      //                                       labelText: "Enter New PIN",
      //                                       prefixIcon: Icon(Icons.pin),
      //                                       labelStyle: TextStyle(fontSize: 15),
      //                                       floatingLabelBehavior: FloatingLabelBehavior.auto,
      //                                       focusedBorder: OutlineInputBorder(
      //                                         borderSide: const BorderSide(color: Colors.indigo, width: 1.0),
      //                                         borderRadius: BorderRadius.circular(10.0),
      //                                       ),
      //                                       errorBorder: OutlineInputBorder(
      //                                         borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      //                                         borderRadius: BorderRadius.circular(10.0),
      //                                       ),
      //                                       enabledBorder: OutlineInputBorder(
      //                                         borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      //                                         borderRadius: BorderRadius.circular(10.0),
      //                                       ),
      //                                       focusColor: Colors.red[300],
      //                                     ),
      //                                     validator: ValidationBuilder().minLength(6).maxLength(12).build(),
      //                                   ),
      //                                   const SizedBox(height: 20),
      //                                   TextFormField(
      //                                     keyboardType: TextInputType.text,
      //                                     controller: _confirmpinController,
      //                                     decoration: InputDecoration(
      //                                       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //                                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      //                                       labelText: "Enter Confirm PIN",
      //                                       prefixIcon: Icon(Icons.pin),
      //                                       labelStyle: TextStyle(fontSize: 15),
      //                                       floatingLabelBehavior: FloatingLabelBehavior.auto,
      //                                       focusedBorder: OutlineInputBorder(
      //                                         borderSide: const BorderSide(color: Colors.indigo, width: 1.0),
      //                                         borderRadius: BorderRadius.circular(10.0),
      //                                       ),
      //                                       errorBorder: OutlineInputBorder(
      //                                         borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      //                                         borderRadius: BorderRadius.circular(10.0),
      //                                       ),
      //                                       enabledBorder: OutlineInputBorder(
      //                                         borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      //                                         borderRadius: BorderRadius.circular(10.0),
      //                                       ),
      //                                       focusColor: Colors.red[300],
      //                                     ),
      //                                     validator: ValidationBuilder().minLength(6).maxLength(12).build(),
      //                                   ),
      //                                   const SizedBox(height: 30),
      //                                   ElevatedButton(
      //                                       onPressed: () {
      //                                         FocusManager.instance.primaryFocus?.unfocus();
      //                                         if(networkController.connectionStatus.value != 0) {
      //                                           if(_setformKey.currentState!.validate()){
      //                                             //controller.setPin(_emailController.text.trim(), _mobileController.text.trim(), 'cm' + randomNumber.toString(), context);
      //                                           }
      //                                         }
      //                                         else{
      //                                           ToastMessage.networkError(Strings.plcheckconn.tr);
      //                                         }
      //                                       },
      //                                       style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, minimumSize: Size.fromHeight(45),
      //                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      //                                           textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      //                                       child: Text("Submit", style: TextStyle(color: Colors.white, fontSize: 18.0)))
      //                                 ],
      //                               ),
      //                             ),
      //                           )
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ))
      //         ],
      //       ),
      //     )
      //   ],
      // ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap:
      //       _onItemTapped, // Update the index and navigate to the selected screen
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Request PIN',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'Choose PIN',
      //     ),
      //   ],
      // ),
    );
    // return Scaffold(
    //     appBar: AppBar(
    //       elevation: 0,
    //       iconTheme: IconThemeData(color: Colors.white),
    //     // leading: IconButton(
    //     //   icon: const Icon(Icons.arrow_back, color: Colors.white),
    //     //   onPressed: () {
    //     //      //Navigator.push(context, MaterialPageRoute(builder: (context) => CommonScreen()));
    //     //      Navigator.of(context).pop();
    //     //   },
    //     // ),
    //     // actions: [
    //     //   SwitchLanguageButton(color: Colors.black)
    //     // ],
    //        centerTitle: true,
    //        title: Text("CRIS MMIS", style: TextStyle(color: Colors.white)), // You can customize the title
    //        backgroundColor: Colors.indigo,
    //     ),
    //     body:
    // );
  }
}
