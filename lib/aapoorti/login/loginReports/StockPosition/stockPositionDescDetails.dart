import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:flutter_app/aapoorti/login/loginReports/StockPosition/stockPositionDetailsPL.dart';
import 'package:flutter_app/aapoorti/login/loginReports/StockPosition/stock_posiion.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

List<dynamic>? jsonResult;


class StockPLDetailsDesc extends StatefulWidget {
  final String item1,zoneid,zone;
  List<dynamic> dataZone;


  StockPLDetailsDesc(this.item1, this.zoneid,this.dataZone,this.zone);

  @override
  StockPLDetailsDescState createState() => StockPLDetailsDescState(this.item1,this.zoneid,this.dataZone,this.zone);
}
class StockPLDetailsDescState extends State<StockPLDetailsDesc> {

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  String? result,zoneid,zone;
  List<dynamic>? dataZone;
  StockPLDetailsDescState(String result,String zoneid,  List<dynamic> dataZone,String zone){
    this.result=result;
    this.zoneid=zoneid;
    this.dataZone=dataZone;
    this.zone=zone;
  }
  void initState() {
    super.initState();
    jsonResult=null;
    callWebService();
  }

  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," +AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," +zoneid!+","+","+"D"+","+result!;
    try{
    jsonResult = await AapoortiUtilities.fetchPostPostLogin('Rpt/StockReport', 'StockReport' ,inputParam1, inputParam2) ;
    if(jsonResult!.length >0){
    if(jsonResult![0]['ErrorCode']==3) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NoData()));
    }
    else if(jsonResult![0]['ErrorCode']==2)
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NoData()));
    }
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NoData()));
    }
 setState(() {
   debugPrint(jsonResult.toString());
 });
    }
    catch(e){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NoResponse()));
    }


 //   https://ireps.gov.in/Aapoorti/ServiceCall/getData?input=SPINNERS,ZONE,01
  }



  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>StockPosition()));
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldkey,
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Descriptions',
              style:TextStyle(
                  color: Colors.white
              )
          ),
        ),
        drawer : AapoortiUtilities.navigationdrawer(_scaffoldkey,context),
        body: Center(
            child: jsonResult == null  ?
            SpinKitFadingCircle(color: Colors.teal, size: 80.0) : _myListView(context)
        ),

      ),
    );
  }

  Widget _myListView(BuildContext context) {
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return ListView.separated(
        itemCount: jsonResult != null ? jsonResult!.length:0,
        itemBuilder: (context, index) {
         if(jsonResult![0]['PL_NO']!=null)
          return
          GestureDetector(
            onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => StockPLDetails(zoneid!,jsonResult![index]['PL_NO'].toString(),dataZone!,zone!)));
              //AapoortiUtilities.user.ORG_ZONE;
            },
            child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AapoortiUtilities.customTextView((index + 1).toString() + ". ", Colors.teal),

                      Expanded(
                        child:Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                  children: <Widget>[
                                    Container(
                                      height: 30,
                                      width: 125,
                                      child: AapoortiUtilities.customTextView("PL Number", Colors.teal),
                                    ),
                                    Container(
                                      height: 30,
                                      child:
                                      AapoortiUtilities.customTextView(jsonResult![index]['PL_NO'], Colors.black),

                                    )
                                  ]
                              ),
                              Row(

                                  children: <Widget>[
                                    Container(
                                      height: 30,
                                      width: 125,

                                      child: AapoortiUtilities.customTextView("Zone:", Colors.teal),
                                    ),
                                    Container(
                                      height: 30,
                                      child:
                                      AapoortiUtilities.customTextView(jsonResult![index]['ZONE'], Colors.black),

                                    )
                                  ]
                              ),

                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Container(
                                      height: 30,
                                      width: 125,
                                      child:
                                      AapoortiUtilities.customTextView("DESCRIPTION", Colors.teal),
                                    ),
                                    Container(

                                      child:
                                        Text(jsonResult![index]['DESCRIPTION'],style: TextStyle(color: Colors.black,fontSize: 15),)
                                    ),
                                    Padding(
                                 padding: EdgeInsets.only(bottom: 10),
          )
                                  ]
                              ),

                            ]
                        ),
                      ),
                    ])
            ),
          );

        },
        separatorBuilder: (context, index) {
          return Divider( thickness: 2,
          color: Colors.teal,);
        }

    );
  }

  }