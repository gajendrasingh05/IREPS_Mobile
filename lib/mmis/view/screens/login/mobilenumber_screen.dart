import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'otp_screen.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({Key? key}) : super(key: key);

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  final phoneno = TextEditingController();
  var size, sheight, swidth;
  late double w;
  late double h;

  @override
  void dispose() {
    phoneno.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    sheight = size.height;
    swidth = size.width;
    h = sheight;
    w = swidth;
    //final controller = Get.put(SignUpController());
    final _formKey = GlobalKey<FormState>();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: SingleChildScrollView(
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: w / 30, vertical: 40),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                        'assets/images/mobile_screen.jpg',
                        width: double.infinity,
                        height: h / 2,

                        fit: BoxFit.fill),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: w / 30, vertical: 20),
                    child: Center(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Enter your Mobile Number",
                                style: TextStyle(
                                    fontSize: w / 20,
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "You will receive a 4 digit code for phone number verifications",
                                style: TextStyle(
                                  fontSize: w / 25,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            IntlPhoneField(
                              initialCountryCode: "IN",
                              decoration: InputDecoration(
                                  labelText: "Mobile Number",
                                  labelStyle: const TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                  suffixIcon: const Icon(Icons.phone),
                                  iconColor: Colors.grey,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              controller: phoneno,
                            ),
                            //TextField(
                            // maxLength: 10,
                            // decoration: InputDecoration(labelText: "Mobile Number", labelStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                            // prefixIcon: const Icon(Icons.phone), iconColor: Colors.grey,
                            // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                            //controller: controller.phoneNo,
                            //),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  minimumSize: Size.fromHeight(w / 8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                if(phoneno.text.isEmpty || phoneno.text.length < 10) {
                                  //Utils.showToast('Please enter Valid Mobile Number');
                                } else {

                                }
                              },
                              child: Text(
                                "Continue",
                                style: TextStyle(fontSize: h / 30),
                              ),
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
        );
      }
    );
  }
}


