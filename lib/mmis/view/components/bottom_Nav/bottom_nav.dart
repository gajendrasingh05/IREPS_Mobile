import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_app/mmis/utils/dimensions.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/utils/my_images.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class CustomBottomNav extends StatefulWidget {
  final int currentIndex;
  const CustomBottomNav({Key? key,required this.currentIndex}) : super(key: key);

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {

  var bottomNavIndex = 0;//default index of a first screen

  List<String> iconList = [
    MyImages.homeIcon,
    MyImages.dashboardIcon,
    //MyImages.profileIcon,
    //MyImages.menuIcon
  ];

  final textList = [
    'home'.tr,
    'dashboard'.tr,
    //'profile'.tr,
    //'menu'.tr
  ];

  @override
  void initState() {
    bottomNavIndex = widget.currentIndex;
    //Get.put(ThemeController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar.builder(
      height: 65,
      elevation: 10,
      itemCount: iconList.length,
      tabBuilder: (int index, bool isActive) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconList[index].contains("svg") ? SvgPicture.asset(iconList[index], height: 22, width: 22, color: isActive ? MyColor.primaryColor : Colors.black) : Image.asset(iconList[index], height: 22, width: 22, color: isActive ? MyColor.primaryColor : Colors.black),
            const SizedBox(height: Dimensions.space5),
            Text(textList[index], style: interRegularSmall.copyWith(color: isActive ? MyColor.primaryColor : Colors.black),
            )
          ],
        );
      },
      //backgroundColor: Colors.white,
      activeIndex: bottomNavIndex,
      splashColor: Colors.white,
      splashSpeedInMilliseconds: 200,
      notchSmoothness: NotchSmoothness.defaultEdge,
      gapLocation: GapLocation.none,
      leftCornerRadius: 0,
      rightCornerRadius: 0,
      onTap: (index) {
        _onTap(index);
      },
    );
  }


  void _onTap(int index) {
    if (index == 0) {
      if (!(widget.currentIndex == 0)) {
        Get.toNamed(Routes.homeScreen);
      }
    }
    else if (index == 1) {
      if (!(widget.currentIndex == 1)) {
        Get.toNamed(Routes.performanceDB);
      }
    }
    else if (index == 2) {
      if (!(widget.currentIndex == 2)) {
        Get.toNamed(Routes.profileScreen);
      }
    }
    else if (index == 3) {
      if (!(widget.currentIndex == 3)) {
        Get.toNamed(Routes.menuScreen);
      }
    }

  }
}




  


