import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
// import 'package:simnumber/sim_number.dart';
// import 'package:simnumber/siminfo.dart';

class GenerateOtpProvider with ChangeNotifier{

  var dummyList = <String>[];
  var originalList = <String>[];

  var userotp = 0;

  // void printSimCardsData(ProgressDialog pr) async {
  //   AapoortiUtilities.getProgressDialog(pr);
  //   dummyList.clear();
  //   originalList.clear();
  //   try {
  //     SimInfo simInfo = await SimNumber.getSimData();
  //     //debugPrint("SimInfo ${simInfo.cards.length}");
  //     String phoneNumber;
  //     for(var s in simInfo.cards) {
  //       //debugPrint("display name ${s.displayName}");
  //       phoneNumber = s.phoneNumber;
  //       //phoneNumber = phoneNumber.replaceFirst(RegExp(r'^\+?91'), '');
  //       //debugPrint('Serial number: ${s.slotIndex} ${s.phoneNumber}');
  //
  //       if(phoneNumber != null){
  //         dummyList.add(phoneNumber);
  //       }
  //     }
  //     if(dummyList.isNotEmpty){
  //       originalList = dummyList;
  //       //debugPrint("original1 ${originalList.length}");
  //       //AapoortiUtilities.showInSnackBar(context, provider.originalList[0].toString());
  //     }
  //     // else{
  //     //   originalList.add("+919540174604");
  //     //   originalList.add("918920885084");
  //     //   debugPrint("original2 ${originalList.length}");
  //     // }
  //     AapoortiUtilities.stopProgress(pr);
  //   } on Exception catch (e) {
  //     AapoortiUtilities.stopProgress(pr);
  //     debugPrint("error! code: ${e.toString()} - message: ${e.toString()}");
  //   }
  //   notifyListeners();
  // }
}