import 'package:flutter_app/mmis/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/mmis/routes/routes.dart';

import 'package:get/get.dart';

import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends GetView<LoginController> {

  @override
  Widget build(BuildContext context) {

    //String? mobileNum = Get.arguments;

    Map<String, dynamic> args = Get.arguments;

    String mobileNum = args['mobile'];
    String email = args['email'];

    String otp = '';

    final loginController = Get.put(LoginController());

    PinTheme defaultTheme = PinTheme(
      height: 45,
      width: 45,
      textStyle: const TextStyle(
        fontSize: 15,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F9),
        border: Border.all(
          color: Colors.grey.shade400,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
    PinTheme focusedTheme = PinTheme(
      height: 45,
      width: 45,
      textStyle: const TextStyle(
        fontSize: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.indigo,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/otp.jpg',height: 280, width: Get.width),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: Get.width * 0.8,
                child: Text(
                  'otpveri'.tr,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Text("${'veriftitle'.tr} ${hidePhoneNumber(mobileNum.toString())}",
                style: TextStyle(
                  color: Color(0xFF8391A1),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: Pinput(
                      length: 5,
                      defaultPinTheme: defaultTheme,
                      focusedPinTheme: focusedTheme,
                      submittedPinTheme: focusedTheme,
                      onCompleted: (pin) => otp = pin,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Obx(() => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      color: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: () {
                        if(otp.toString().isEmpty || otp.toString().length < 5){
                          ToastMessage.error('validotp'.tr);
                        }
                        else{
                          //loginController.verifiedOtp(email, otp);
                          Get.offAndToNamed(Routes.performanceDB);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: loginController.otpverState.value == OtpverState.loading ? CircularProgressIndicator(color: Colors.white, strokeWidth: 3) : Text(
                        'verifybtn'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${'didntrcv'.tr} ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'resend'.tr,
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String hidePhoneNumber(String phoneNumber) {
      int hideLength = 4; // Number of last digits to show
      String lastDigits = phoneNumber.substring(phoneNumber.length - hideLength);
      String hiddenPhoneNumber = '*' * (phoneNumber.length - hideLength) + lastDigits;
      return hiddenPhoneNumber;
  }
}
