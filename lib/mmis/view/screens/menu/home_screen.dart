import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/mmis/extention/extension_util.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/view/components/bottom_Nav/bottom_nav.dart';
import 'package:flutter_app/mmis/view/screens/noInternet.dart';
import 'package:flutter_app/mmis/widgets/logout_dialog.dart';
import 'package:flutter_app/mmis/widgets/switch_language_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:fluttericon/iconic_icons.dart';

import 'package:get/get.dart';
import 'package:flutter_app/mmis/controllers/home_controller.dart';
import 'package:flutter_app/mmis/controllers/theme_controller.dart';
import 'package:flutter_app/mmis/controllers/network_controller.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';

//poonam.crismmis@gmail.com

class HomeScreen extends GetWidget<HomeController> {

  final themeController = Get.find<ThemeController>();
  final networkController = Get.put(NetworkController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool onPop) {
        AapoortiUtilities.alertDialog(context, "MMIS");
      },
      child: Obx(() => networkController.connectionStatus.value == 0 ? const NoInternet() : Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.grey.shade400,
              drawer: navDrawer(context, _scaffoldKey, controller, themeController),
              bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
             appBar: AppBar(
               backgroundColor: MyColor.primaryColor,
               iconTheme: IconThemeData(color: Colors.white),
               centerTitle: true,
               title: Text('appName'.tr, style : TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontStyle: FontStyle.italic,fontSize: 18.0))),
               body: Container(
                 height: Get.height,
                 width: Get.width,
                 color: Colors.white,
                 child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.0,
                      crossAxisCount: 2, // Number of items per row
                      crossAxisSpacing: 10.0, // Horizontal space between items
                      mainAxisSpacing: 10.0, // Vertical space between items
                    ),
                    itemCount: controller.getlist.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () {
                            if (index == 0) {
                              Get.toNamed(Routes.searchDemandsScreen);
                            }
                            else if (index == 1) {
                              Get.toNamed(Routes.nonStockDemandsScreen);
                            }
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(strokeAlign: 1.0, color: Colors.indigo)),
                            //clipBehavior: Clip.antiAlias,
                            elevation: 4.0,
                            child: Stack(
                              children: [
                                Image.asset(controller.getlist[index]['icon']!,height: 200, width: 200, fit: BoxFit.cover),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.withOpacity(0.8),
                                      border: Border.all(color: Colors.indigo, strokeAlign: 1.0)
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      controller.getlist[index]['label']!.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            )),
    );
  }
}

Widget navDrawer(BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey,
    HomeController homeController, ThemeController themeController) {
     return Drawer(
    child: Column(
      children: [
        Expanded(
          child: Container(
            child: ListView(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints.expand(height: 180.0),
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/welcome.jpg'),
                        fit: BoxFit.cover),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed(Routes.profileScreen);
                    },
                    child: Row(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            SizedBox(height: 4.0),
                            Obx(() => Text(
                                homeController.username.value.capitalizeFirstLetter(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0))),
                            SizedBox(height: 2.0),
                            Obx(() => Text(homeController.email.value,
                                style:
                                TextStyle(color: Colors.white, fontSize: 15.0)))
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.black,
                  height: 2.0,
                ),
                // drawerTile(Iconic.lock, 'changepin'.tr, () {
                //   //Navigator.pop(context);
                //   _scaffoldKey.currentState!.closeDrawer();
                //   Get.toNamed(Routes.changepinScreen);
                // }),
                // drawerTile(Iconic.star, 'rateus'.tr, () {
                //   //Navigator.pop(context);
                //   _scaffoldKey.currentState!.closeDrawer();
                //   AapoortiUtilities.openStore(context);
                // }),
              ],
            ),
          ),
        ),
        Column(
          children: [
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 5.0),
            //     child: Container(
            //       height: 80.0,
            //       width: 80.0,
            //       decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.grey), borderRadius: BorderRadius.circular(40)),
            //       child: Image.asset('assets/images/crisnew.png', fit: BoxFit.cover, width: 80, height: 80),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 2.0),
            InkWell(
              onTap: () {
                if (_scaffoldKey.currentState!.isDrawerOpen) {
                  _scaffoldKey.currentState!.closeDrawer();
                  AapoortiUtilities.alertDialog(context, "MMIS");
                  //_showConfirmationDialog(context);
                  //WarningAlertDialog().changeLoginAlertDialog(context, () {callWebServiceLogout();}, language);
                  //callWebServiceLogout();
                }
              },
              child: Container(
                height: 45,
                color: Colors.indigo.shade500,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Logout",
                        style: TextStyle(fontSize: 16, color: Colors.white))
                  ],
                ),
              ),
            )
          ],
        ),
        //SizedBox(height: 15),
      ],
    ),
  );
}

ListTile drawerTile(IconData icon, String title, VoidCallback ontap) {
  return ListTile(
    onTap: ontap,
    contentPadding: EdgeInsets.zero,
    horizontalTitleGap: 10,
    leading: Icon(
      icon,
      color: Colors.black,
    ),
    title: Text(
      title,
      style: const TextStyle(color: Colors.black),
    ),
  );
}

DateTime? _lastPressedAt;
Future<bool> _onWillPop() async {
  //Get.dialog(showExitDialog(context));
  //return Future<bool>.value(true);
  if (_lastPressedAt == null ||
      DateTime.now().difference(_lastPressedAt!) > const Duration(seconds: 2)) {
    _lastPressedAt = DateTime.now();
    ToastMessage.backPress('backpress'.tr);
    return false;
  }
  return true;
}
