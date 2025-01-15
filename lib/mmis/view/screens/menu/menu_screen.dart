import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/mmis/controllers/home_controller.dart';
import 'package:flutter_app/mmis/controllers/language_controller.dart';
import 'package:flutter_app/mmis/controllers/network_controller.dart';
import 'package:flutter_app/mmis/controllers/profile_controller.dart';
import 'package:flutter_app/mmis/controllers/theme_controller.dart';
import 'package:flutter_app/mmis/extention/extension_util.dart';

import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';

import 'package:flutter_app/mmis/view/components/bottom_Nav/bottom_nav.dart';

import 'package:flutter/material.dart';
import 'package:fluttericon/iconic_icons.dart';

import 'package:fluttericon/typicons_icons.dart';
import 'package:get/get.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  final profileController = Get.put(ProfileController());

  final LanguageController _languageController = Get.put(LanguageController());
  final HomeController controller = Get.put(HomeController());
  ThemeController themeController = Get.find<ThemeController>();

  final networkController = Get.put(NetworkController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //controller.loadData();
    });
  }

  @override
  void dispose() {
    //MyUtils.allScreensUtils(themeController.darkTheme);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          backgroundColor: MyColor.primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text('appName'.tr, style : TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontStyle: FontStyle.italic,fontSize: 18.0))),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
      drawer: navDrawer(context, _scaffoldKey, controller, themeController),
      body: Container(
        child: Obx((){
          if(profileController.profileState.value == ProfileState.loading){
            return Center(child: CircularProgressIndicator(strokeWidth: 3));
          }
          else{
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Card(
                    elevation: 0.0,
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color : Colors.indigo,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.grey)),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  profileController.initianame!.value,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color :Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(profileController.username!.value,
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                            Text(profileController.email!.value,
                                style: TextStyle(fontStyle: FontStyle.italic,fontSize: 16))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                //SizedBox(height: 20),
                Container(
                  color: Colors.white,
                  child: Card(
                    elevation: 0.0,
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 50,
                            color: Colors.white,
                            child: Row(
                              children: [
                                Icon(Icons.account_circle),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Text('profile'.tr,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16))),
                                IconButton(
                                    onPressed: () {
                                      Get.toNamed(Routes.profileScreen);
                                    },
                                    icon: Icon(Icons.arrow_forward_ios_outlined,
                                        size: 20))
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: Divider(
                              color: Colors.grey.shade700,
                              height: 0.5,
                              thickness: 0.5),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: Container(
                        //     height: 50,
                        //     color: Colors.white,
                        //     child: Row(
                        //       children: [
                        //         Icon(Typicons.pin_outline),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //             child: Text(Strings.changepin.tr,
                        //                 style: TextStyle(
                        //                     color: Colors.black, fontSize: 16))),
                        //         IconButton(
                        //             onPressed: () {
                        //               Get.toNamed(Routes.changepinScreen);
                        //             },
                        //             icon: Icon(Icons.arrow_forward_ios_outlined,
                        //                 size: 20))
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                        //   child: Divider(
                        //       color: Colors.grey.shade700,
                        //       height: 0.5,
                        //       thickness: 0.5),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: Container(
                        //     height: 50,
                        //     child: Row(
                        //       children: [
                        //         Icon(Icons.language),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //             child: Text(Strings.selectlan.tr,
                        //                 style: TextStyle(
                        //                     color: Colors.black, fontSize: 16))),
                        //         IconButton(
                        //             onPressed: () {
                        //               changeLanguage();
                        //             },
                        //             icon: Icon(Icons.arrow_forward_ios_outlined,
                        //                 size: 20))
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: Divider(
                              color: Colors.grey.shade700,
                              height: 0.5,
                              thickness: 0.5),
                        ),
                        // Start Theme Column Design
                        // Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: Container(
                        //     height: 50,
                        //     color: Colors.white,
                        //     child: Row(
                        //       children: [
                        //         Icon(Icons.account_circle),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //             child: Text(Strings.theme.tr,
                        //                 style: TextStyle(
                        //                     color: Colors.black, fontSize: 16))),
                        //         IconButton(
                        //             onPressed: () {
                        //               themeController.toggleTheme();
                        //               //Get.toNamed(Routes.profileScreen);
                        //             },
                        //             icon: Icon(Icons.arrow_forward_ios_outlined,
                        //                 size: 20))
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                        //   child: Divider(
                        //       color: Colors.grey.shade700,
                        //       height: 0.5,
                        //       thickness: 0.5),
                        // ),
                        // End Theme Column Design
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 50,
                            child: Row(
                              children: [
                                Icon(Typicons.lock),
                                SizedBox(width: 10),
                                Expanded(child: Text('logOut'.tr, style: TextStyle(color: Colors.black, fontSize: 16))),
                                IconButton(
                                    onPressed: () {
                                      AapoortiUtilities.alertDialog(context, "MMIS");
                                      //Get.dialog(LogOutDialog(press: () { }));
                                      //WarningAlertDialog().changeLoginAlertDialog(context, () {callWebServiceLogout();}, language);
                                    },
                                    icon: Icon(Icons.arrow_forward_ios_outlined,
                                        size: 20))
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  void changeLanguage() {
    showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    child: Text('selectlan'.tr, style: TextStyle(fontSize: 16, decoration: TextDecoration.underline)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        _languageController.changeLocale(Locale('en'));
                        //_languageController.setSelectedLanguage(const Locale("en", "US"));
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 45,
                        child: Row(
                          children: [
                            Image.asset('assets/images/translation.png', height: 27, width: 27),
                            SizedBox(width: 15),
                            Expanded(child: Text('English', style: TextStyle(color: Colors.black, fontSize: 16))),
                            if(_languageController.selectedLanguage == "English")
                              const Icon(
                                Icons.check_box,
                                color: Colors.blue,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Divider(
                        color: Colors.grey.shade700,
                        height: 0.5,
                        thickness: 0.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        _languageController.changeLocale(Locale('hi'));
                        //_languageController.setSelectedLanguage(const Locale("hi", "IN"));
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 45,
                        child: Row(
                          children: [
                            Image.asset('assets/images/translation.png', height: 27, width: 27),
                            SizedBox(width: 15),
                            Expanded(child: Text('हिंदी', style: TextStyle(color: Colors.black, fontSize: 16))),
                            if(_languageController.selectedLanguage == "हिंदी")
                              const Icon(Icons.check_box, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
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
                    child: Column(
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
                            homeController.username!.value.capitalizeFirstLetter(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0))),
                        SizedBox(height: 2.0),
                        Obx(() => Text(homeController.email!.value,
                            style:
                            TextStyle(color: Colors.white, fontSize: 15.0)))
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 0.5,
                    color: Colors.black,
                    height: 2.0,
                  ),
                  drawerTile(Iconic.lock, 'changepin'.tr, () {
                    //Navigator.pop(context);
                    _scaffoldKey.currentState!.closeDrawer();
                    Get.toNamed(Routes.changepinScreen);
                  }),
                  drawerTile(Iconic.star, 'rateus'.tr, () {
                    //Navigator.pop(context);
                    _scaffoldKey.currentState!.closeDrawer();
                    AapoortiUtilities.openStore(context);
                  }),
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
                      Text('logOut'.tr,
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
}
