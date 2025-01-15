import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_app/mmis/db/db_models/userloginrespdb.dart';

class HomeController extends GetxController {
  late RxBool isSelected = true.obs;
  RxInt selectedIndex = 0.obs;

  //-----User Data------
  RxString username = ''.obs;
  RxString mobile = ''.obs;
  RxString email = ''.obs;

  @override
  void onInit() {
    getUserloginData();
    super.onInit();
  }

  List<Map<String, String>> list = [
    {
      'icon': 'assets/images/searchdmd.jpeg',
      'label': "searchdmd".tr,
    },
    {
      'icon': 'assets/images/nonsdmd.jpeg',
      //'label': "nonstkdmd".tr
      'label' : "Coming Soon"
    },
    // {
    //   'icon': 'assets/images/stock_sm.jpg',
    //   'label': Strings.monitoring.tr
    // },
  ].obs;


  List<Map<String, String>> get getlist => list;

  void getUserloginData() async{
    final box = await Hive.openBox<UserLoginrespDb>('user');
    for (var i = 0; i < box.length; i++) {
      var userLoginrespDb = box.getAt(i);
      username.value = userLoginrespDb!.userName;
      mobile.value = userLoginrespDb.mobile!;
      email.value = userLoginrespDb.emailId;
    }
  }

  @override
  void dispose() async{
    //await Hive.close();
    super.dispose();
  }

}
