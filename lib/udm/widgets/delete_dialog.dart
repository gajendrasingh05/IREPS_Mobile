import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';


class WarningAlertDialog {
  const WarningAlertDialog();

  void logOut(BuildContext context, VoidCallback press){
    showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40, bottom: 15, left: 15, right: 15),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Text(
                        "Confirmation!!",
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Are you want to logout from application?',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                side: BorderSide(color: Colors.white, width: 1),
                                textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontStyle: FontStyle.normal),
                              ),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text('Cancel',style: TextStyle(fontSize: 14, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                side: BorderSide(color: Colors.white, width: 1),
                                textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontStyle: FontStyle.normal),
                              ),
                              onPressed: press,
                              child: Text('Yes', style: TextStyle(fontSize: 14, color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: -30,
                  left: MediaQuery.of(context).padding.left,
                  right: MediaQuery.of(context).padding.right,
                  child: Image.asset(
                    "assets/web.png",
                    height: 60,
                    width: 60,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void changeLoginAlertDialog(BuildContext context, VoidCallback press, [LanguageProvider? language]) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40, bottom: 15, left: 15, right: 15),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Text(
                        language!.text('confirmtitle'),
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        language.text('cdesc'),
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                side: BorderSide(color: Colors.white, width: 1),
                                textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontStyle: FontStyle.normal),
                              ),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text(language.text('wdno'),style: TextStyle(fontSize: 14, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                side: BorderSide(color: Colors.white, width: 1),
                                textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontStyle: FontStyle.normal),
                              ),
                              onPressed: press,
                              child: Text(language.text('wdyes'), style: TextStyle(fontSize: 14, color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: -30,
                  left: MediaQuery.of(context).padding.left,
                  right: MediaQuery.of(context).padding.right,
                  child: Image.asset(
                    "assets/web.png",
                    height: 60,
                    width: 60,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  // void actionAlertDialog(BuildContext context, VoidCallback press,String title) {
  //   showDialog(
  //       context: context,
  //       builder: (context) => Dialog(
  //         backgroundColor: MyColor.getCardBg(),
  //         insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.space40),
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  //         child: SingleChildScrollView(
  //           physics: const ClampingScrollPhysics(),
  //           child: Stack(
  //             clipBehavior: Clip.none,
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.only(top: Dimensions.space40, bottom: Dimensions.space15, left: Dimensions.space15, right: Dimensions.space15),
  //                 alignment: Alignment.center,
  //                 width: MediaQuery.of(context).size.width,
  //                 decoration: BoxDecoration(color: MyColor.getCardBg(), borderRadius: BorderRadius.circular(5)),
  //                 child: Column(
  //                   children: [
  //                     const SizedBox(height: Dimensions.space5),
  //                     Text(
  //                      title,
  //                       style: interRegularDefault.copyWith(color: MyColor.getTextColor()),
  //                       textAlign: TextAlign.center,
  //                       overflow: TextOverflow.ellipsis,
  //                       maxLines: 4,
  //                     ),
  //                     const SizedBox(height: Dimensions.space15),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Expanded(
  //                           child: RoundedButton(
  //                             text: Strings.no.tr,
  //                             press: () {
  //                               Navigator.pop(context);
  //                             },
  //                             horizontalPadding: 3,
  //                             verticalPadding: 3,
  //                             color: MyColor.getScreenBgColor(),
  //                             textColor: MyColor.getTextColor(),
  //                           ),
  //                         ),
  //                         const SizedBox(width: Dimensions.space10),
  //                         Expanded(
  //                           child: RoundedButton(text: Strings.yes.tr, press: press, horizontalPadding: 3, verticalPadding: 3, color: MyColor.getPrimaryColor(), textColor: MyColor.colorWhite),
  //                         )
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               Positioned(
  //                 top: -30,
  //                 left: MediaQuery.of(context).padding.left,
  //                 right: MediaQuery.of(context).padding.right,
  //                 child: Image.asset(
  //                   MyImages.warningImage,
  //                   height: 60,
  //                   width: 60,
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ));
  // }
}
