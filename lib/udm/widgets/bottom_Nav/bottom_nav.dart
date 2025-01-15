import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_app/udm/localization/languageHelper.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/screens/UdmChangePin.dart';
import 'package:flutter_app/udm/screens/Profile.dart';
import 'package:flutter_app/udm/screens/helpdesk_screen.dart';
import 'package:flutter_app/udm/screens/settings_screen.dart';
import 'package:flutter_app/udm/screens/user_home_screen.dart';
import 'package:provider/provider.dart';


class CustomBottomNav extends StatefulWidget {
  final int currentIndex;
  const CustomBottomNav({Key? key,required this.currentIndex}) : super(key: key);

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {

  var bottomNavIndex = 0;//default index of a first screen

  final List<String> iconList = [
    'assets/images/icon_home.png',
    'assets/images/icon_user.png',
    'assets/images/icon_setting.png',
    'assets/images/icon_help.png',
  ];


  final textList = [
    "होम\nHome",
    "प्रोफ़ाइल\nProfile",
    "सेटिंग\nSettings",
    "सहायता केंद्र\nHelpdesk"
  ];


  @override
  void initState() {
    bottomNavIndex = widget.currentIndex;
    //Get.put(ThemeController(sharedPreferences: Get.find()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<LanguageProvider>(context).language == Language.English;
    return AnimatedBottomNavigationBar.builder(
        elevation: 5,
        itemCount: iconList.length,
        height: 60,
        tabBuilder: (int index, bool isActive) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconList[index], height: 25, width: 25, color: isActive ? Colors.red.shade300 : Colors.black),
              SizedBox(height: 5),
              Text((textList[index]).split('\n')[isEnglish ? 1 : 0],
                style: TextStyle(color: isActive ? Colors.red.shade300 : Colors.black),
              )
            ],
          );
        },
         backgroundColor: Colors.white,
         activeIndex: bottomNavIndex,
         splashColor: Colors.white,
         splashSpeedInMilliseconds: 300,
         notchSmoothness: NotchSmoothness.defaultEdge,
         gapLocation: GapLocation.none,
         leftCornerRadius: 20,
         rightCornerRadius: 20,
         onTap: (index) {
          _onTap(index, widget.currentIndex, context);
         },
      );
    }
  }


void _onTap(int index, int widgetIndex, BuildContext context) {
  if(index == 0) {
    if (!(widgetIndex == 0)) {
      Navigator.of(context).pushReplacementNamed(UserHomeScreen.routeName);
    }
  }
  else if (index == 1) {
    if(!(widgetIndex == 1)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
    }
  }
  else if (index == 2) {
    if(!(widgetIndex == 2)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
    }
  }
  else if (index == 3) {
    if(!(widgetIndex == 3)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HelpDeskScreen(data: 1)));
    }
  }
}




  


