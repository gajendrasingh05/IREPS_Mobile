import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'PendingBillsDetails.dart';

class PendingBill extends StatefulWidget {
  get path => null;

  @override
  _PendingBillState createState() => _PendingBillState();
}

class _PendingBillState extends State<PendingBill> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic>? jsonResult;
  final dbHelper = DatabaseHelper.instance;
  var rowCount=-1;

  void initState() {
    super.initState();
    callWebService();
  }

  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," +AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + AapoortiUtilities.user!.CUSTOM_WK_AREA;
    jsonResult = await AapoortiUtilities.fetchPostPostLogin('Login/PendingBillList', 'PendingBillList' ,inputParam1, inputParam2) ;
    if(jsonResult!.length==0)    {
      jsonResult=null;
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>NoData()));
    }    else if(jsonResult![0]['ErrorCode']==3)    {
      jsonResult=null;
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>NoResponse()));
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        return true;
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHome('','')));
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          backgroundColor: Colors.teal,
          title: Text('Pending Bills',
              style:TextStyle(
                  color: Colors.white
              )
          ),
        ),
       drawer :AapoortiUtilities.navigationdrawer(_scaffoldKey,context),
        body: Center(
            child: jsonResult == null  ?
            SpinKitFadingCircle(color: Colors.teal, size: 120.0,)
                :_myListView(context)
        ),
      ),
    );
  }


  Widget _myListView(BuildContext context) {
    //Dismiss spinner
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return ListView.separated(
        itemCount: jsonResult != null ? jsonResult!.length:0,
        itemBuilder: (context, index) {

          return GestureDetector(
              child: Container(
              padding: EdgeInsets.all(10),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                      width: 1,
                      color: Colors.grey[300]!
                  ),
                ),
                child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top:8)),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Padding(padding: new EdgeInsets.all(3.0)),
                            Text(
                              (index + 1).toString() + ". ",
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 16
                              ),
                            ),

                            Expanded(
                      child:Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Row(

                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,

                                    child:
                                    AapoortiUtilities.customTextView("Bill No.", Colors.teal),
                                  ),
                                  Container(
                                    height: 30,
                                    child:
                                    AapoortiUtilities.customTextView(jsonResult![index]['INVOICE_BILL_NO'], Colors.black),

                                  )
                                ]
                            ),


                            Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child:
                                    AapoortiUtilities.customTextView("Submission Date", Colors.teal),
                                  ),

                                  Expanded(
                                    child:Container(
                                      height: 30,
                                      child:
                                      AapoortiUtilities.customTextView(jsonResult![index]['BILL_SUBMIT_DATE_DESC'], Colors.black),
                                    ),
                                  ),
                                ]
                            ),


                            Row(
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child:
                                    AapoortiUtilities.customTextView("Contract No.", Colors.teal),
                                  ),
                                  Container(
                                    height: 30,
                                    child:
                                    AapoortiUtilities.customTextView(jsonResult![index]['CONTRACT_NO'], Colors.black),
                                  )
                                ]
                            ),

                            Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[

                                  Container(
                                    height: 30,
                                    width: 125,
                                    child:
                                    AapoortiUtilities.customTextView("Contract Date", Colors.teal),
                                  ),

                                  Container(
                                    height: 30,

                                    child:
                                    AapoortiUtilities.customTextView(jsonResult![index]['CONTRACT_DATE'], Colors.black),
                                  )
                                ]
                            ),

                            Row(
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child:
                                    AapoortiUtilities.customTextView("Submitted To", Colors.teal),
                                  ),
                                  Container(
                                    height: 30,
                                    child:
                                    AapoortiUtilities.customTextView(jsonResult![index]['BILL_PREPARE_DESIG'], Colors.black),
                                  )
                                ]
                            ),
                            Row(
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child:
                                    AapoortiUtilities.customTextView("Status", Colors.teal),
                                  ),
                                  Expanded(
                                                                      child: Container(
                                      height: 30,
                                      child:
                                      AapoortiUtilities.customTextView(jsonResult![index]['BILL_STATUS_DESC'], Colors.black),
                                    ),
                                  )
                                ]
                            ),

                          ]
                      ),
                    ),
                  ]
              )]
              ),
              )
              ),
              onTap: () {
                String pokey = jsonResult![index]['BIDDER_ACK_ID'].toString();
                String desc = jsonResult![index]['BILL_STATUS_DESC'].toString();
                print(pokey);
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => PendingBillDetails(pokeyN: pokey,desc: desc,)));

          });
        }


        ,
        separatorBuilder: (context, index) {
          return Container();
        }

    );
  }
}
