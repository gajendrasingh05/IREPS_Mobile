import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      //contentPadding: EdgeInsets.zero,
      icon: Image.asset('assets/images/logout.png', height: 32, width: 32, fit: BoxFit.contain),
      title: Text(
        'logoutcfrm'.tr,
        style: TextStyle(color: Colors.black),
      ),
      content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green),
                child: SizedBox(
                  width: 60,
                  child: Text(
                    'yesbtn'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: SizedBox(
                  width: 60,
                  child: Text(
                    'nobtn'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ]),
    );
  }
}
