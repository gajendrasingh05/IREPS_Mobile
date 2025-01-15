import 'package:flutter_app/mmis/controllers/theme_controller.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/utils/my_icons.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../dialog/exit_dialog.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool isShowBackBtn;
  final Color bgColor;
  final bool isShowActionBtn;
  final bool isTitleCenter;
  final bool fromAuth;
  final bool isProfileCompleted;
  List<Widget>? actionsList;
  CustomAppBar({Key? key, this.isProfileCompleted = false, this.fromAuth = false, this.isTitleCenter = false, this.bgColor = Colors.transparent, this.isShowBackBtn = true, required this.title, this.isShowActionBtn = false, this.actionsList}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool hasNotification = false;
  @override
  void initState() {
    //Get.put(ApiClient(sharedPreferences: Get.find()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isShowBackBtn ? AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: MyColor.primaryColor,
                statusBarIconBrightness:  Brightness.light,
                systemNavigationBarColor: MyColor.backgroundColor,
                //systemNavigationBarIconBrightness: ThemeController(sharedPreferences: Get.find()).darkTheme ? Brightness.light : Brightness.dark
            ),
            elevation: 0,
            leading: widget.isShowBackBtn ? IconButton(
                    onPressed: () {
                      if (widget.fromAuth) {
                        Get.offAllNamed(Routes.loginScreen);
                      } else if (widget.isProfileCompleted) {
                        showExitDialog(Get.context!);
                      } else {
                        String previousRoute = Get.previousRoute;
                        if (previousRoute == '/splash-screen') {
                          Get.offAndToNamed(Routes.homeScreen);
                        } else {
                          Get.back();
                        }
                      }
                    },
                    icon: Icon(Icons.arrow_back, color: MyColor.primaryTextColor, size: 20)) : const SizedBox.shrink(),
            backgroundColor: widget.bgColor,
            title: Text(widget.title, style: interRegularLarge.copyWith(color: MyColor.primaryTextColor)),
            centerTitle: widget.isTitleCenter,
            actions: widget.actionsList ?? [
                    widget.isShowActionBtn
                        ? Container(
                            height: 30,
                            width: 30,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: MyColor.transparentColor),
                            child: InkWell(
                                onTap: () {
                                  // Get.toNamed(Routes.notificationScreen)?.then((value) {
                                  //   setState(() {
                                  //     hasNotification = false;
                                  //   });
                                  // });
                                },
                                child: SvgPicture.asset(
                                  hasNotification ? MyIcons.activeNotificationIcon : MyIcons.inActiveNotificationIcon,
                                  height: 25,
                                  width: 25,
                                )),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      width: 10,
                    )
                  ])
        : AppBar(
            elevation: 0,
            backgroundColor: widget.bgColor,
            title: Text(widget.title, style: interRegularLarge.copyWith(color: MyColor.primaryTextColor)),
            actions: widget.actionsList ?? [widget.isShowActionBtn ? InkWell(
                            onTap: () {
                              // Get.toNamed(Routes.notificationScreen)?.then((value) {
                              //   setState(() {
                              //     hasNotification = false;
                              //   });
                              // });
                            },
                            child: SvgPicture.asset(
                              hasNotification ? MyIcons.activeNotificationIcon : MyIcons.inActiveNotificationIcon,
                              height: 28,
                              width: 28,
                            ))
                        : const SizedBox.shrink(),
                    const SizedBox(width: 10)
                  ],
            automaticallyImplyLeading: false,
          );
  }
}
