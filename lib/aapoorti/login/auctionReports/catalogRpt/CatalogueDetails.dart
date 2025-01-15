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

class CatalogueDetails extends StatefulWidget {
  get path => null;
  String catalogueid;
  @override
  _CatalogueDetailsState createState() => _CatalogueDetailsState(catalogueid);

  CatalogueDetails(this.catalogueid);
}

class _CatalogueDetailsState extends State<CatalogueDetails> {

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  List<dynamic>? jsonResult;
  List<dynamic>? jsonResultexp;
  final dbHelper = DatabaseHelper.instance;
  var rowCount=-1;
 String _catalogueid;

  _CatalogueDetailsState(this._catalogueid);

  void initState() {
    super.initState();
    callWebService();
  }

  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," +AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + _catalogueid;

    jsonResult = await AapoortiUtilities.fetchPostPostLogin('AFLAuction/DCATALOG', 'DCATALOG' ,inputParam1, inputParam2) ;
    print(jsonResult);
    jsonResultexp = await AapoortiUtilities.fetchPostPostLogin('AFLAuction/HCATALOG', 'HCATALOG' ,inputParam1, inputParam2) ;
    print(jsonResultexp);
    if(jsonResult!.length==0)
    {
      jsonResult = [];
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>NoData()));
    }
    else if(jsonResult![0]['ErrorCode']==3)
    {
      jsonResult = [];
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>NoResponse()));
    }
    setState(() {

//data1=jsonResult1;
    });

  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),

          backgroundColor: Colors.teal,
          title: Text('Catalogue Details',
              style:TextStyle(
                  color: Colors.white
              )
          ),
        ),
        drawer :AapoortiUtilities.navigationdrawer(_scaffoldkey,context),
        body:
        jsonResult == null  ?
        SpinKitFadingCircle(color: Colors.teal, size: 120.0,):
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.teal[100]),

              child: ExpansionTile(

                title: Text('Catalogue Details ',textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontStyle:FontStyle.normal,fontWeight: FontWeight.bold,),),

                children: <Widget>[
                  Row(

                      children: <Widget>[

                        Container(
                          height: 30,
                          width: 125,

                          child: Text("Account Name",
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16),
                          ),
                        ),
                        Container(
                          height: 30,
                          child: Text(
                            jsonResultexp![0]['ACCOUNT_NAME'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16),
                          ),
                        )
                      ]
                  ),
                  Row(

                      children: <Widget>[

                        Container(
                          height: 30,
                          width: 125,

                          child: Text("Depot Name",
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16),
                          ),
                        ),
                        Container(
                          height: 30,
                          child: Text(
                            jsonResultexp![0]['DEPOT_NAME'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16),
                          ),
                        )
                      ]
                  ),
                  Row(

                      children: <Widget>[

                        Container(
                          height: 30,
                          width: 125,

                          child: Text("Catalogue No.",
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16),
                          ),
                        ),
                        Container(
                          height: 30,
                          child: Text(
                            jsonResultexp![0]['CATALOG_NO'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16),
                          ),
                        )
                      ]
                  ),
                  Row(

                      children: <Widget>[

                        Container(
                          height: 30,
                          width: 125,

                          child: Text("Auction Type",
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16),
                          ),
                        ),
                        Container(
                          height: 30,
                          child: Text(
                            jsonResultexp![0]['AUCTION_TYPE'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16),
                          ),
                        )
                      ]
                  ),
                  Row(

                      children: <Widget>[
                        Container(

                    width: 125,
                        height: 50,
                    child: Text("Auction Start Date",
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16),
                    ),
                  ),


                        Container(
                          height: 30,
                          child: Text(
                            jsonResultexp![0]['AUCTION_START_DATETIME'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16),
                          ),
                        )
                      ]
                  ),
                  Row(

                      children: <Widget>[

                        Container(
                          height: 30,
                          width: 125,

                          child: Text("Lot End Date",
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16),
                          ),
                        ),
                        Container(
                          height: 30,
                          child: Text(
                            jsonResultexp![0]['LOT_END_DATETIME'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16),
                          ),
                        )
                      ]
                  ),
                ],
              ),

            ),
            Container(
              child: Text('Details Of Scrap Materials Sold',style: TextStyle(fontSize: 25,color: Colors.teal,fontWeight: FontWeight.bold),),
            ),
            
            Container(
                child: Expanded(child: _myListView(context),)
            )
          ],
        )
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
                                    Text("Lot Category",style:TextStyle(color:  Colors.teal,fontSize: 15)),
                                  ),
                                  Padding(
                                    padding: new EdgeInsets.only(left: 10),
                                  ),
                                  Container(
                                    height: 30,
                                    child:
                                    AapoortiUtilities.customTextView(jsonResult![index]['CATEGORY'], Colors.black),

                                  )
                                ]
                            ),
 Padding(
          padding: new EdgeInsets.only(top: 5),
          ),

                            Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(

                                    width: 125,
                                    child:
                                    Text("Lot put for Auction",style:TextStyle(color:  Colors.teal,fontSize: 15)),
                                  ),
                                  Padding(
                                    padding: new EdgeInsets.only(left: 10),
                                  ),
                                  Expanded(
                                    child:Container(

                                      child:
                                      AapoortiUtilities.customTextView(jsonResult![index]['TOTAL_LOTS'].toString(), Colors.black),
                                    ),
                                  ),
                                ]
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                            ),

                            Row(
                                children: <Widget>[
                                  Container(

                                    width: 125,
                                    child:
                                    Text("Lot w/d before Auction.",style:TextStyle(color:  Colors.teal,fontSize: 15)),

                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  Container(

                                    child:
                                    AapoortiUtilities.customTextView(jsonResult![index]['BEFORE'].toString(), Colors.black),
                                  )
                                ]
                            ),
                            Padding(
                              padding: new EdgeInsets.only(top: 5),
                            ),
                            Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[

                                  Container(

                                    width: 125,
                                    child:
                                    Text("Lot w/d during Auction",style:TextStyle(color:  Colors.teal,fontSize: 15)),

                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  Container(


                                    child:
                                    AapoortiUtilities.customTextView(jsonResult![index]['AFTER'].toString(), Colors.black),
                                  )
                                ]
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                            ),
                            Row(
                                children: <Widget>[
                                  Container(

                                    width: 125,
                                    child:
                                    Text("No. Bids Recieved",style:TextStyle(color:  Colors.teal,fontSize: 15)),

                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  Container(
                                    height: 30,
                                    child:
                                    AapoortiUtilities.customTextView(jsonResult![index]['NO_BID_LOTS'].toString(), Colors.black),
                                  )
                                ]
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                            ),
                            Row(
                                children: <Widget>[
                                  Container(

                                    width: 125,
                                    child:
                                    Text("Lot Sold",style:TextStyle(color:  Colors.teal,fontSize: 15)),

                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  Container(

                                    child:
                                    AapoortiUtilities.customTextView(jsonResult![index]['SOLD_LOTS'].toString(), Colors.black),
                                  )
                                ]
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                            ),
                            Row(
                                children: <Widget>[
                                  Container(

                                    width: 125,
                                    child:
                                    Text("Lots Rejected",style:TextStyle(color:  Colors.teal,fontSize: 15)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  Container(

                                    child:
                                    AapoortiUtilities.customTextView(jsonResult![index]['REJECTED_LOTS'].toString(), Colors.black),
                                  )
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
