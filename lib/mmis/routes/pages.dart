import 'package:flutter_app/mmis/view/screens/dashboard/choose.depart_screen.dart';
import 'package:flutter_app/mmis/view/screens/dashboard/searchdm_data_screen.dart';
import 'package:flutter_app/mmis/view/screens/login/change_pin_screen.dart';
import 'package:flutter_app/mmis/view/screens/dashboard/non_stock_demands_screen.dart';
import 'package:flutter_app/mmis/view/screens/menu/home_screen.dart';
import 'package:flutter_app/mmis/view/screens/login/login_screen.dart';
import 'package:flutter_app/mmis/view/screens/menu/menu_screen.dart';
import 'package:flutter_app/mmis/view/screens/login/otp_screen.dart';
import 'package:flutter_app/mmis/view/screens/menu/performance_dashboard.dart';
import 'package:flutter_app/mmis/view/screens/menu/profile_screen.dart';
import 'package:flutter_app/mmis/view/screens/login/reqsetpin_screen.dart';
import 'package:flutter_app/mmis/view/screens/dashboard/search_demands_screen.dart';
import 'package:flutter_app/mmis/view/screens/login/setpin_screen.dart';
import 'package:get/get.dart';
import '../../aapoorti/common/splash_screen.dart';
import 'routes.dart';

class Pages {
  static var list = [
    GetPage(
      name: Routes.splashScreen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: Routes.loginScreen,
      page: () => LoginScreen(),
      // binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.otpScreen,
      page: () => OtpScreen(),
      // binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.homeScreen,
      page: () => HomeScreen(),
      //binding: AllControllersBinding(),
    ),
    GetPage(
      name: Routes.changepinScreen,
      page: () => ChangePinScreen(),
      // binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.menuScreen,
      page: () => MenuScreen(),
      // binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.profileScreen,
      page: () => Profile(),
      // binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.performanceDB,
      page: () => PerformanceDashBoard(),
      // binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.setPinScreen,
      page: () => SetPinScreen()
    ),
    GetPage(
        name: Routes.reqsetPinScreen,
        page: () => ReqSetPinScreen()
    ),
    GetPage(
        name: Routes.nonStockDemandsScreen,
        page: () => NonStockDemandsScreen()
    ),
    GetPage(
        name: Routes.searchDemandsScreen,
        page: () => SearchDemandsScreen()
    ),
    GetPage(
        name: Routes.searchDemandsDataScreen,
        page: () => SearchdmDataScreen()
    ),
    GetPage(
        name: Routes.chooseDepartScreen,
        page: () => ChooseDepartScreen()
    )
  ];
}
