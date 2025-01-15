import 'package:flutter_app/mmis/db/db_models/userloginrespdb.dart';

import 'package:get/get.dart';
import 'package:hive/hive.dart';


enum ProfileState {idle, loading, success, failed, failedWithError }
class ProfileController extends GetxController {

  var profileState = ProfileState.idle.obs;

  //-----User Data------
  RxString? initianame = ''.obs;
  RxString? username = ''.obs;
  RxString? mobile = ''.obs;
  RxString? email = ''.obs;
  RxString? usertype = ''.obs;
  RxString? workarea = ''.obs;
  RxString? firmname = ''.obs;
  RxString? lastlogintime = ''.obs;

  @override
  void onInit() {
    getUserloginData();
    super.onInit();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }


  void getUserloginData() async {
    profileState.value = ProfileState.loading;
    try {
      final box = await Hive.openBox<UserLoginrespDb>('user');
      for (var i = 0; i < box.length; i++) {
        var userLoginrespDb = box.getAt(i);
        initianame!.value = getNameToInitials(userLoginrespDb!.userName!);
        username!.value = userLoginrespDb.userName!.toUpperCase();
        mobile!.value = userLoginrespDb.mobile!;
        email!.value = userLoginrespDb.emailId!;
        usertype!.value = userLoginrespDb.uValue!;
        workarea!.value = userLoginrespDb.wkArea!;
        firmname!.value = userLoginrespDb.ouName!;
        lastlogintime!.value = userLoginrespDb.lastLogTime!;
      }
      profileState.value = ProfileState.success;
    }
    catch(e){
      profileState.value = ProfileState.failedWithError;
    }
  }

  String getNameToInitials(String username) {
    String initials = '';
    List<String> splitName = username.split(' ');
    if (splitName.isNotEmpty) {
      initials += splitName[0][0].toUpperCase();
      if (splitName.length > 1 && splitName[splitName.length - 1].isNotEmpty) {
        initials += splitName[splitName.length - 1][0].toUpperCase();
      }
    }
    return initials;
  }

}
