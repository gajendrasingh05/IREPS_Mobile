import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SoldLots extends StatefulWidget {
  get path => null;

  @override
  _SoldLotsState createState() => _SoldLotsState();
}

class _SoldLotsState extends State<SoldLots> {
  List<dynamic>? jsonResult;
  final dbHelper = DatabaseHelper.instance;
  var rowCount=-1;

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    callWebService();
  }

  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," +AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID ;

    jsonResult = await AapoortiUtilities.fetchPostPostLogin('AFLAuction/SOLD_LOT', 'SOLD_LOT' ,inputParam1, inputParam2) ;
    if(jsonResult!.length==0)
    {
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>NoData()));
    }
    setState(() {
    });

  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sold Lots',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldkey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),

          title: Text('Sold Lots',
              style:TextStyle(
                  color: Colors.white
              )
          ),
        ),
        drawer :AapoortiUtilities.navigationdrawer(_scaffoldkey,context),
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

          return Container(
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

                                    child:
                                    AapoortiUtilities.customTextView("Lot No.", Colors.teal),
                                  ),
                                  Container(
                                    height: 30,
                                    child:
                                    AapoortiUtilities.customTextView(jsonResult![index]['LOT_NO'], Colors.black),

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
                                    AapoortiUtilities.customTextView("Catelogue No.", Colors.teal),
                                  ),

                                  Expanded(
                                    child:Container(
                                      height: 30,
                                      child:
                                      AapoortiUtilities.customTextView(jsonResult![index]['CATALOG_NO'], Colors.black),
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
                                    AapoortiUtilities.customTextView("Lot Closing Date/Time", Colors.teal),
                                  ),
                                  Container(
                                    height: 30,
                                    child:
                                    AapoortiUtilities.customTextView(jsonResult![index]['LOT_END_DATETIME'], Colors.black),
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
                                    AapoortiUtilities.customTextView("Bidders name", Colors.teal),
                                  ),

                                  Container(
                                    height: 30,

                                    child:
                                    AapoortiUtilities.customTextView(jsonResult![index]['FIRM_NAME'], Colors.black),
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
                                    AapoortiUtilities.customTextView("Rate/Unit(Rs.)", Colors.teal),
                                  ),

                                  Container(
                                    height: 30,

                                    child:
                                    AapoortiUtilities.customTextView(jsonResult![index]['BID_RATE'].toString(), Colors.black),
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
                                    AapoortiUtilities.customTextView("Sale Qty./Unit", Colors.teal),
                                  ),

                                  Container(
                                    height: 30,

                                    child:
                                    AapoortiUtilities.customTextView(jsonResult![index]['SALE_UNIT'].toString(), Colors.black),
                                  )
                                ]
                            ),


                            Row(
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text("Links",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontSize: 16),
                                    ),
                                  ),

                                  Expanded(
                                    child:Row(

                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: ()  {
                                              if(jsonResult![index]['URL']!='NA') {
                                                var fileUrl = jsonResult![index]['URL'].toString();
                                                var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                                                AapoortiUtilities.ackAlert(context, fileUrl, fileName);


                                                //Dismiss dialog

                                              }

                                              else {
                                                AapoortiUtilities.showInSnackBar(context,"No PDF attached with this Tender!!");
                                              }

                                            },

                                            child:Container(
                                              height: 30,

                                              child: Image(
                                                  image: AssetImage('images/pdf_home.png'),
                                                  height: 30,
                                                  width: 20
                                              ),

                                            ),
                                          ),





                                          Padding(padding: EdgeInsets.only(right: 0),),
                                        ]
                                    ),
                                  ),







                                ]
                            ),


                          ]
                      ),
                    ),
                  ])
          );
        }
        ,
        separatorBuilder: (context, index) {
          return Divider();
        }

    );
  }
}
