import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SafetyDetails extends StatefulWidget {
  get path => null;
  String year;


  SafetyDetails(this.year);

  @override
  _SafetyDetailsState createState() => _SafetyDetailsState(this.year);
}

class _SafetyDetailsState extends State<SafetyDetails> {
  List<dynamic>? jsonResult;
  String year;
  int i = 0;

  _SafetyDetailsState(this.year);

  void initState() {
    super.initState();
    i = 0;
    callWebService();
  }

  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," +
        AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + year;

    jsonResult = await AapoortiUtilities.fetchPostPostLogin(
        'Rpt/SReport', 'SReport', inputParam1, inputParam2);
    if (jsonResult!.length == 0) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoData()));
    }
    else if (jsonResult![0]['ErrorCode'] == 3) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoResponse()));
    }
    setState(() {});

    AapoortiUtilities.setLandscapeOrientation();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AapoortiUtilities.setPortraitOrientation();
        return true;
      },

      /*MaterialApp(
      title: 'Safety Report',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text(' Safety Report',
              style: TextStyle(
                  color: Colors.white
              )
          ),
        ),*/
      /*drawer: AapoortiUtilities.navigationdrawer(context),*/
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          backgroundColor: Colors.teal,
          title: Text('Safety Report',
              style: TextStyle(
                  color: Colors.white
              )
          ),
        ),
        body: Container(
            child:
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 25.0,
                  padding: EdgeInsets.only(top: 5.0),
                  child: Row(

                    children:<Widget>[
                      Text(
                        'Zone',
                        style:
                        TextStyle(fontSize: 15, color: Colors.white),
                        textAlign:   TextAlign.center,),
                      Spacer(),
                      Text(
                        'Apr',
                        style:
                        TextStyle(fontSize: 15, color: Colors.white),
                        textAlign:   TextAlign.center,),
                      Spacer(),
                      Text(
                        'May' ,
                        style:
                        TextStyle(fontSize: 15, color: Colors.white),
                        textAlign:   TextAlign.center,),
                      Spacer(),
                      Text(
                        'Jun',
                        style:
                        TextStyle(fontSize: 15, color: Colors.white),
                        textAlign:   TextAlign.center,),
                      Spacer(),
                      Text(
                        'Jul',
                        style:
                        TextStyle(fontSize: 15, color: Colors.white),
                        textAlign:   TextAlign.center,),
                      Spacer(),
                      Text(
                        'Aug',
                        style:
                        TextStyle(fontSize: 15, color: Colors.white),
                        textAlign:   TextAlign.center,),
                      Spacer(),
                      Text(
                        'Sep',
                        style:
                        TextStyle(fontSize: 15, color: Colors.white),
                        textAlign:   TextAlign.center,),
                      Spacer(),
                      Text(
                        'Oct',
                        style:
                        TextStyle(fontSize: 15, color: Colors.white),
                        textAlign:   TextAlign.center,),
                      Spacer(),
                      Text(
                        'Nov',
                        style:
                        TextStyle(fontSize: 15, color: Colors.white),
                        textAlign:   TextAlign.center,),
                      Spacer(),
                      Text(
                        'Dec',
                        style:
                        TextStyle(fontSize: 15, color: Colors.white),
                        textAlign:   TextAlign.center,),
                      Spacer(),
                      Text(
                        'Jan',
                        style:
                        TextStyle(fontSize: 15, color: Colors.white),
                        textAlign:   TextAlign.center,),
                      Spacer(),
                      Text(
                        'Feb',
                        style:
                        TextStyle(fontSize: 15, color: Colors.white),
                        textAlign:   TextAlign.center,),
                      Spacer(),
                      Text(
                        'Mar',
                        style:
                        TextStyle(fontSize: 15, color: Colors.white),
                        textAlign:   TextAlign.center,),
                      Spacer(),
                      Text(
                        'Avg',
                        style:
                        TextStyle(fontSize: 15, color: Colors.white),
                        textAlign:   TextAlign.center,),
                      Spacer(),
                      Text(
                        'Marks',
                        style:
                        TextStyle(fontSize: 15, color: Colors.white),
                        textAlign:  TextAlign.center,),
                      Spacer(),
                    ],
                  ),
                  color: Colors.teal,
                ),
                Padding(padding: EdgeInsets.only(top: 5.0)),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(child: jsonResult == null ?
                      SpinKitFadingCircle(color: Colors.cyan, size: 80.0) : _myListView(context))
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    return jsonResult!.isEmpty
        ? Center(
        child:
        Column(
          children: <Widget>[
            Image.asset("assets/nodatafound.png"),
            Text(
              ' No Response Found ',
              style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            )
          ],
        )
    ) :
    ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: jsonResult != null ? jsonResult!.length : 0,
      itemBuilder: (context, index) {
        return Container(
          color:Colors.grey[200],
          child:
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 2.0)),
                  Container
                    (
                    height: 5.0,
                    color: Colors.white,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/15,
                    child:
                    Text(
                      jsonResult![index]['RLY_NAME'].toString() != 'null'
                          ? jsonResult![index]['RLY_NAME'].toString()
                          : '--',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/15,
                    child:
                    Text(
                      jsonResult![index]['APR_PCT'].toString() !=  'null'
                          ? jsonResult![index]['APR_PCT'].toString()
                          : '--',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/15,
                    child:
                    Text(
                      jsonResult![index]['MAY_PCT'].toString() != 'null'
                          ? jsonResult![index]['MAY_PCT'].toString()
                          : '--',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/15,
                    child:
                    Text(
                      jsonResult![index]['JUN_PCT'].toString() != 'null'
                          ? jsonResult![index]['JUN_PCT'].toString()
                          : "--",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/15,
                    child:
                    Text(
                      jsonResult![index]['JUL_PCT'].toString() != 'null'
                          ? jsonResult![index]['JUL_PCT'].toString()
                          : "--",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/15,
                    child:
                    Text(
                      jsonResult![index]['AUG_PCT'].toString() != 'null'
                          ? jsonResult![index]['AUG_PCT'].toString()
                          : "--",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),

                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/15,
                    child:
                    Text(
                      jsonResult![index]['SEP_PCT'].toString() != 'null'
                          ? jsonResult![index]['SEP_PCT'].toString()
                          : "--",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),

                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/15,
                    child:
                    Text(
                      jsonResult![index]['OCT_PCT'].toString() != 'null'
                          ? jsonResult![index]['OCT_PCT'].toString()
                          : "--",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),

                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/15,
                    child:
                    Text(
                      jsonResult![index]['NOV_PCT'].toString() != 'null'
                          ? jsonResult![index]['NOV_PCT'].toString()
                          : "--",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),

                  ),Container(
                    width: MediaQuery.of(context).size.width/15,
                    child:
                    Text(
                      jsonResult![index]['DEC_PCT'].toString() != 'null'
                          ? jsonResult![index]['DEC_PCT'].toString()
                          : "--",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),

                  ),Container(
                    width: MediaQuery.of(context).size.width/15,
                    child:
                    Text(
                      jsonResult![index]['JAN_PCT'].toString() != 'null'
                          ? jsonResult![index]['JAN_PCT'].toString()
                          : "--",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),Container(
                    width: MediaQuery.of(context).size.width/15,
                    child:
                    Text(
                      jsonResult![index]['FEB_PCT'].toString() != 'null'
                          ? jsonResult![index]['FEB_PCT'].toString()
                          : "--",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),

                  ),Container(
                    width: MediaQuery.of(context).size.width/15,
                    child:
                    Text(
                      jsonResult![index]['MAR_PCT'].toString() != 'null'
                          ? jsonResult![index]['MAR_PCT'].toString()
                          : "--",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),

                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/15,
                    child:
                    Text(
                      jsonResult![index]['AVG_PCT'].toString() != 'null'
                          ? jsonResult![index]['AVG_PCT'].toString()
                          : "--",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),

                  ),Container(
                    width: MediaQuery.of(context).size.width/15,
                    child:
                    Text(
                      jsonResult![index]['MARKS'].toString() != 'null'
                          ? jsonResult![index]['MARKS'].toString()
                          : "--",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),

                  ),
                ],
              ),
              Container(
                height: 5.0,
                color: Colors.white,
              )
            ],
          ),
        );
      },
    );
  }
}



