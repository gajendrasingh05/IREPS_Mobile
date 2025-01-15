import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/aapoorti/login/home/UserHome.dart';


class ReverseAuction extends StatefulWidget {
  get path => null;

  @override
  _ReverseAuctionState createState() => _ReverseAuctionState();
}

class _ReverseAuctionState extends State<ReverseAuction> {

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  List<dynamic>? jsonResult;
  final dbHelper = DatabaseHelper.instance;
  var rowCount = -1;

  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
        callWebService();
    });
  
  }

  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," +AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + AapoortiUtilities.user!.CUSTOM_WK_AREA;

    jsonResult = await AapoortiUtilities.fetchPostPostLogin('Login/RAList', 'RAList' ,inputParam1, inputParam2).timeout(Duration(seconds:10)) ;
    debugPrint(jsonResult!.length.toString());
    debugPrint(jsonResult.toString());
    if(jsonResult!.length==0)
    {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>NoData()));
    }
    else if(jsonResult![0]['ErrorCode']==3)
      {
        jsonResult=null;
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context)=>NoResponse()));
      }
    if(this.mounted)
    setState(() {

    });

  }

 /* void fetchPost() async {


    print('Fetching from service');

    var v = "https://ireps.gov.in/Aapoorti/ServiceCallLog/PendingBillList?PendingBillList="+ '{"param1":"87014271368745345742,921C6C01A29EDBBCE05340011E0A70C3,Android,0,0","param2":"1486485732,PT,"}';
    var v1='https://trial.ireps.gov.in/Aapoorti/ServiceCallLog/LiveTenderList?LiveTenderList={"param1":"61813473666154124344,921DB39C59F6F661E05340011E0AD822,Android,0,0","param2":"1486485732,PT,"}';
    final response =   await http.post(v1,headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, encoding: Encoding.getByName("utf-8"));
    print('url formed $v1');
    print('respnse is $response and');
    jsonResult = json.decode(response.body);

    //Delete Data in DB before insert starts
//    final rowsDeleted = await dbHelper.delete(rowCount);
//    print('deleted $rowsDeleted row(s): row $rowCount');
    //Delete Data in DB before insert ends


    //DB Insertion starts
    /* for(int index=0; index<jsonResult.length; index++) {
        Map<String, dynamic> row = {
          DatabaseHelper.Tbl9_Col1_SrNo: index.toString(),
          DatabaseHelper.Tbl9_Col2_RlyDept: jsonResult[index]['RLY_DEPT'],
          DatabaseHelper.Tbl9_Col3_tenderNo: jsonResult[index]['TENDER_NUMBER'],
          DatabaseHelper.Tbl9_Col4_tendertitle: jsonResult[index]['TENDER_TITLE'],
          DatabaseHelper.Tbl9_Col5_workArea: jsonResult[index]['WORK_AREA'],
          DatabaseHelper.Tbl9_Col6_StrtDate: jsonResult[index]['RA_START_DT'],
          DatabaseHelper.Tbl9_Col7_EnDDate: jsonResult[index]['RA_CLOSE_DT'],
          DatabaseHelper.Tbl9_Col8_NitPdfUrl: jsonResult[index]['NIT_PDF_URL'],
          DatabaseHelper.Tbl9_Col9_StatusRA: jsonResult[index]['STATUS'],
          DatabaseHelper.Tbl9_Col10_DocsRA: jsonResult[index]['ATTACH_DOCS'],
          DatabaseHelper.Tbl9_Col11_CorrigendumRA: jsonResult[index]['CORRI_DETAILS'],
        };96
        final id = dbHelper.insert(row);
        print('inserted row id: ' + index.toString());
      }
      //DB Insertion ends

*/

    setState(() {

    });

  }


*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: MaterialApp(

      debugShowCheckedModeBanner: false,
       title: 'Reverse Auction',
       theme: ThemeData(
        primarySwatch: Colors.teal,
       ),
        home: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.teal,
          title: Text('Reverse Auction',
              style:TextStyle(
                  color: Colors.white
              )
          ),
        ),
        drawer :AapoortiUtilities.navigationdrawer(_scaffoldkey,context),
        body: Center(
            child: jsonResult == null  ?
            SpinKitFadingCircle(color: Colors.teal, size: 120.0) :_myListView(context)
        ),

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
                            Padding(padding: EdgeInsets.all(3.0)),
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
                                  Expanded(
                                    child:
                                    Text(jsonResult![index]['RAILWAY_ZONE']!=null? jsonResult![index]['RAILWAY_ZONE']+"/"+jsonResult![index]['DEPARTMENT']: "",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),),
                                  )
                                ]
                            ),
                            Padding(padding: EdgeInsets.all(5),),

                            Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                    // height: 30,
                                    width: 125,
                                    child: Text("RA Date",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontSize: 16),
                                    ),
                                  ),

                                  Expanded(
                                    child:Container(
                                      // height: 30,
                                      child: Text(
                                        jsonResult![index]['TENDER_OPENING_DATE']!=null? jsonResult![index]['TENDER_OPENING_DATE'] : "",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16),
                                        overflow: TextOverflow.ellipsis,

                                      ),
                                    ),
                                  ),
                                ]
                            ),
                             SizedBox(height:5),

                            Row(
                                children: <Widget>[
                                  Container(
                                    // height: 30,
                                    width: 125,
                                    child: Text("Tender No.",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    // height: 30,
                                    child: Text(
                                      jsonResult![index]['TENDER_NUMBER']!=null? jsonResult![index]['TENDER_NUMBER'] : "",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16),
                                    ),
                                  )
                                ]
                            ),
                            SizedBox(height:5),

                            Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[

                                  Container(
                                    // height: 30,
                                    width: 125,
                                    child: Text("WorkArea",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontSize: 16),
                                    ),
                                  ),

                                  Container(
                                    // height: 30,

                                    child:Text(
                                      jsonResult![index]['WORK_AREA']!=null? jsonResult![index]['WORK_AREA'] : "",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16),
                                    ),
                                  )
                                ]
                            ),
                             SizedBox(height:5),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    // height: 30,
                                    width: 125,
                                    child: Text("Tender Title",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                      child:Container(
                                        // height: 50,
                                        child: Text(
                                          jsonResult![index]['TENDER_DESCRIPTION']!=null? jsonResult![index]['TENDER_DESCRIPTION'] : "",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      )
                                  ),
                                ]

                            ),
                             SizedBox(height:5),

                            Row(
                                children: <Widget>[
                                  Container(
                                    // height: 30,
                                    width: 125,
                                    child: Text("Type",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    // height: 30,
                                    child: Text(
                                      jsonResult![index]['TENDER_STATUS']!=null? jsonResult![index]['TENDER_STATUS'] : "",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16),
                                    ),
                                  )
                                ]
                            ),
                             SizedBox(height:5),
                            Row(
                                children: <Widget>[
                                  Container(
                                    // height: 30,
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
                                              if(jsonResult![index]['SUMM_REPORT_LINK']!='NA') {
                                                String name="NIT";
//                                                showDialog(
//                                                  context: context,
//                                                  barrierDismissible: false,
//
//
//                                                  child: new Dialog(
//                                                    backgroundColor: Colors.transparent,
//
//                                                    child: new Row(
//                                                      mainAxisAlignment: MainAxisAlignment.center,
//                                                      mainAxisSize: MainAxisSize.min,
//                                                      children: [
//                                                        new CircularProgressIndicator(backgroundColor: Colors.white,),
//                                                        Padding(padding: EdgeInsets.all(10),),
//                                                        new Text("Loading",style: TextStyle(color: Colors.white,fontSize: 24),),
//                                                      ],
//                                                    ),
//                                                  ),
//                                                );
                                                var fileUrl = jsonResult![index]['SUMM_REPORT_LINK'].toString();
                                                var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                                                AapoortiUtilities.ackAlertLogin(context, fileUrl, fileName,name);


                                                //Dismiss dialog
                                              //  Navigator.of(context, rootNavigator: true).pop('dialog');
                                              }

                                              else {
                                                AapoortiUtilities.showInSnackBar(context,"No PDF attached with this Tender!!");
                                              }

                                            },

                                            child: Column(children:<Widget>[Container(
                                              // height: 30,

                                              child: Image(
                                                  image: AssetImage('images/pdf_home.png'),
                                                  height: 30,
                                                  width: 20
                                              ),

                                            ),
                                              new Padding(padding: EdgeInsets.all(0.0)),
                                              new Container(
                                                child:   new Text('NIT', style: new TextStyle(
                                                    color: Colors.blueGrey, fontSize: 9),
                                                    textAlign: TextAlign.center),
                                              ),]),
                                          ),





                                          Padding(padding: EdgeInsets.only(right: 0),),
                                        ]
                                    ),
                                  ),







                                ]
                            ),
                             SizedBox(height:3),
                          ]
                      ),
                    ),
                  ]
              )]
          ),
              )
          );
        }
        ,
        separatorBuilder: (context, index) {
          return Container();
        }

    );
  }
}
