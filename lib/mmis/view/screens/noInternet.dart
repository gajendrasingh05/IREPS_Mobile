import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Get.height/6),
            Image.asset('assets/images/connection_error.jpg',height: 300, width: Get.width),
            SizedBox(height: 20),
            Text('errortitle'.tr, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
            SizedBox(height: 10),
            Text('errordesc'.tr, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black)),
            const Spacer(),
            GestureDetector(
             child: Container(
               height: 45.0,
               width: Get.width,
               alignment: Alignment.center,
               color: Colors.deepOrange,
               child: Text('tryagainbtn'.tr, style: TextStyle(color: Colors.white)),
             ),
            )
          ],
        ),
      ),
    );
  }
}
