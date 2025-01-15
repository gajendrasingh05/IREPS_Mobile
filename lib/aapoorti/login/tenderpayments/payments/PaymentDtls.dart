import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Payments.dart';




class PaymentDtls extends StatefulWidget {
  get path => null;
  String? tenderno,deptrlw,closingdate,tendertype,tenderoid;


  @override
  _PaymentDtlsState createState() => _PaymentDtlsState(tenderno!,deptrlw!,closingdate!,tendertype!,tenderoid!);

  PaymentDtls(String tenderno,String deptrlw,String closingdate,String tendertype,String tenderoid)
  {
    this.tenderno=tenderno;
    this.tendertype=tendertype;
    this.deptrlw=deptrlw;
    this.closingdate=closingdate;
    this.tenderoid=tenderoid;
  }
}

class _PaymentDtlsState extends State<PaymentDtls> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? tenderno,deptrlw,closingdate,tendertype,tenderoid;
  String? tndrno;
  List<dynamic>? jsonResult;
  final dbHelper = DatabaseHelper.instance;
  var rowCount=-1;
  Color _backgroundColor=Colors.white;

  void initState() {
    super.initState();
    callWebService();


  }
  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," +AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + AapoortiUtilities.user!.CUSTOM_WK_AREA+","+tenderoid!;

    jsonResult = await AapoortiUtilities.fetchPostPostLogin('Log/PaymentDtls', 'PaymentDtls' ,inputParam1, inputParam2) ;
    print(jsonResult!.length);
    print(jsonResult!.toString());
    if(jsonResult!.length==0)
    {
      jsonResult=null;
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>NoData()));
    }
    else if(jsonResult![0]['ErrorCode']==3)
    {
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
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),

              backgroundColor: Colors.teal,
              title: Text('My Payments',
                  style:TextStyle(
                      color: Colors.white
                  )
              ),
            ),
            drawer :AapoortiUtilities.navigationdrawer(_scaffoldKey, context),
            body: Column(

              children: <Widget>[
                Container(

                  decoration: BoxDecoration(color: Colors.teal[100]),

                  child:
                  ExpansionTile(



                    title: Text('Tender Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle:FontStyle.normal,
                      fontWeight: FontWeight.bold,),
                      ),
                    backgroundColor: Colors.teal[100],
                    onExpansionChanged: _onExpansion,
                    children: <Widget>[

                      Row(

                          children: <Widget>[

                            Container(
                              height: 30,
                              width: 125,

                              child: Text("Tender No.",
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              height: 30,
                              child: Text(
                                tenderno!,
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

                              child: Text("Rly.Unit/Dept.",
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 16),
                              ),
                            ),
                            Expanded(
                                child:   Container(
                                  child: Text(
                                    deptrlw!,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16),
                                  ),
                                )
                            )

                          ]
                      ),
                      Row(

                          children: <Widget>[

                            Container(
                              height: 30,
                              width: 125,

                              child: Text("Dept./Rly. Unit",
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 16),
                              ),
                            ),
                            Expanded(
                                child:        Container(
                                  child: Text(
                                    closingdate!,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16),
                                  ),
                                )
                            )

                          ]
                      ),
                      Row(

                          children: <Widget>[

                            Container(
                              height: 30,
                              width: 125,

                              child: Text("Closing Date",
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              height: 30,
                              child: Text(
                                closingdate!,
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

                              child: Text("Payment Type",
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              height: 30,
                              child: Text(
                                tendertype!,
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
                    child: Expanded(child: jsonResult == null  ?
                    SpinKitFadingCircle(color: Colors.teal, size: 120.0):_myListView(context),)
                )
              ],
            )
        )
    );

  }


  Widget _myListView(BuildContext context) {
    //Dismiss spinner
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);

    return

      ListView.separated(
        itemCount: jsonResult != null ? jsonResult!.length:0,
        itemBuilder: (context, index) {

          return
            Container(

                padding: EdgeInsets.all(10),
                child:InkWell(
                    onTap: ()
                    {
                      print("calling tp functn");

        //  Navigator.push(context,
        //  MaterialPageRoute(builder: (context)=>PaymentDtls(tndrno,tndrno,tndrno)));
                    },
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            (index + 1).toString() + ". ",
                            style: TextStyle(
                                color: Colors.indigo,
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
                                          // height: 50,
                                          width: 125,

                                          child: Text("IREPS Ref. No/Bank Txn ID",
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Expanded(
                                            child:    Container(
                                              child: Text(
                                                jsonResult![index]['IREPS_REF_ID']!=null? jsonResult![index]['IREPS_REF_ID']+"/"+jsonResult![index]['BANK_SETTLEMENT_ID']: "",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            )
                                        )

                                      ]
                                  ),
                                   SizedBox(height:5),


                                  Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Container(
                                          // height: 30,
                                          width: 125,
                                          child: Text("Validity Date",
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 16),
                                          ),
                                        ),

                                        Expanded(
                                          child:Container(
                                            // height: 30,
                                            child: Text(
                                              jsonResult![index]['INSTRUMENT_VALIDITY_DATE']!=null? jsonResult![index]['INSTRUMENT_VALIDITY_DATE'] : "",
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
                                          // height: 50,
                                          width: 125,
                                          child: Text("Date/Time",
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          // height: 30,
                                          child: Text(
                                            jsonResult![index]['BANK_TXN_DATE']!=null? jsonResult![index]['BANK_TXN_DATE'] : "",
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
                                          child: Text("Issue Name",
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Expanded(
                                          child:      Container(

                                            child:Text(
                                              jsonResult![index]['TXN_MADE_VIA']!=null? jsonResult![index]['TXN_MADE_VIA']+"-"+jsonResult![index]['TXN_BANK_NAME']: "",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        )

                                      ]
                                  ),
                                   SizedBox(height:5),

                                  Row(
                                      children: <Widget>[
                                        Container(
                                          // height: 50,
                                          width: 125,
                                          child: Text("Amount/Bank Status",
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Expanded(
                                            child:Container(
                                              // height: 30,
                                              child: Text(
                                                jsonResult![index]['TXN_AMOUNT']!=null? jsonResult![index]['TXN_AMOUNT'].toString()+"INR"+"/"+jsonResult![index]['IREPS_TRANS_STATUS']: "0"+"/"+jsonResult![index]['IREPS_TRANS_STATUS'],
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
                                          child: Text("IREPS Remarks",
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          // height: 30,
                                          child: Text(
                                            jsonResult![index]['USER_REMARKS']!=null? jsonResult![index]['USER_REMARKS'] : "",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        )
                                      ]
                                  ),


                                ]
                            ),
                          ),

                        ]
                        )
                )
            );
        },

        separatorBuilder: (_,indx)=>Divider(thickness:4),

      );
  }

  _PaymentDtlsState(String tenderno,String deptrlw,String closingdate,String tendertype,String tenderoid)
  {
    this.tenderno=tenderno;
    this.tendertype=tendertype;
    this.deptrlw=deptrlw;
    this.closingdate=closingdate;
    this.tenderoid=tenderoid;
  }
  void _onExpansion(bool value) {
    /// Change background color. The ExpansionTile doesn't change to the new
    /// _backgroundColor value. The Text element does.
    _backgroundColor=Colors.grey[100]!;
    setState(() {
      _backgroundColor = Colors.grey[100]!;
    });
  }
}
