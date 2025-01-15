import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class CommonParamData extends StatefulWidget{
  get path => null;

  /*final Widget child;

  CommonParamData({Key key, this.child}) : super(key: key);*/

  static String LiveAucCountVal="", LiveAucPageVal="",
      UpAucCountVal="", UpAucPageVal="",
      AucSchedCountVal="" , AucSchedPageVal="",
      ClosingTodayCountVal="", ClosingTodayPageVal="",
      mobileNo="",loginFlag="" ,ForceUpFlagVal="0",
      bannedFirmsCount  = "-1", dashboardUpdateFlag = "0",
      closedRACount = "";

  //static DatabaseHelper dbHelper;
  @override
  CommonParamDataState createState() => CommonParamDataState();
}

class CommonParamDataState extends State<CommonParamData> {
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold();
  }
}