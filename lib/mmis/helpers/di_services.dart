import 'package:flutter_app/mmis/controllers/changepin_controller.dart';
import 'package:flutter_app/mmis/controllers/dashboard_controller.dart';
import 'package:flutter_app/mmis/controllers/home_controller.dart';
import 'package:flutter_app/mmis/controllers/language_controller.dart';
import 'package:flutter_app/mmis/controllers/login_controller.dart';
import 'package:flutter_app/mmis/controllers/network_controller.dart';
import 'package:flutter_app/mmis/controllers/search_demand_controller.dart';
import 'package:flutter_app/mmis/controllers/theme_controller.dart';
import 'package:flutter_app/mmis/extention/debuglog.dart';
import 'package:flutter_app/mmis/services/repo/login_repo.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, Map<String, String>>> init() async{

  final sharedPreferences = await SharedPreferences.getInstance();

  final myObject = DebugLog();

  Get.put<ThemeController>(ThemeController());
  //Get.lazyPut(() => ThemeController());
  Get.lazyPut(() => LanguageController());

  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => myObject);

  Get.lazyPut(() => HomeController());
  //Get.put<DashBoardController>(DashBoardController());
  Get.lazyPut(() => DashBoardController());
  //Get.lazyPut<NetworkController>(() => NetworkController());
  Get.put<NetworkController>(NetworkController());
  //Get.put<LoginController>(LoginController(), permanent : true);
  Get.lazyPut<LoginController>(() => LoginController());
  Get.lazyPut<ChangePinController>(() => ChangePinController());
  Get.lazyPut(() => LoginRepo());

  Get.lazyPut<SearchDemandController>(() => SearchDemandController());

  Map<String,Map<String,String>> language = {};
   language['en_US'] = {'':''};
   return language;
}
