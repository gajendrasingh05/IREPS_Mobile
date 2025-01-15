import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_app/mmis/db/db_models/userloginrespdb.dart';

class ChangePinController extends GetxController{

  final _emailValue = ''.obs;
  String get emailValue => _emailValue.value;
  set emailValue(String value) => _emailValue.value = value!;

  @override
  void onInit() {
    super.onInit();
    getUserloginData();
  }

  void getUserloginData() async{
    final box = await Hive.openBox<UserLoginrespDb>('user');
    for (var i = 0; i < box.length; i++) {
      var userLoginrespDb = box.getAt(i);
      emailValue = userLoginrespDb!.emailId!;
    }
  }

}