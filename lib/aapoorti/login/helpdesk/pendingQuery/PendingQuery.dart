import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoConnection.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'PendingQueryDtls.dart';

class PendingQuery extends StatefulWidget {
  get path => null;

  @override
  _PendingQueryState createState() => _PendingQueryState();
}

class _PendingQueryState extends State<PendingQuery> {

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  List<dynamic>? jsonResult,jsonResult1;
  final dbHelper = DatabaseHelper.instance;
  var rowCount=-1;
  Color? repback,reptext,repbor,nrepback,nreptext,nrepbor;
  bool replied=false,pending=true;

  void initState() {
    super.initState();
    repback=Colors.white;
    repbor=Colors.blue[700];
    reptext=Colors.blue[700];
     pending=true;
    nrepback=Colors.white;
    nrepbor=Colors.black;
    nreptext=Colors.black;
    // setState(() {
    //   repback=Colors.white;
    //   repbor=Colors.blue[700];
    //   reptext=Colors.blue[700];

    //   nrepback=Colors.black;
    //   nrepbor=Colors.white;
    //   nreptext=Colors.white;
    // });
    Future.delayed(Duration.zero,(){
      callWebService();
    });
    
  }

  void  callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," +AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + "~" +" "+","+AapoortiUtilities.user!.CUSTOM_WK_AREA;

         List? var1 = await AapoortiUtilities.fetchPostPostLogin('HDPostLogin/PendingQueryListDev', 'input' ,inputParam1, inputParam2) ;
       List? var2 = await AapoortiUtilities.fetchPostPostLogin('HDPostLogin/RepliedQueryListDev', 'input' ,inputParam1, inputParam2) ;
  if(var1.length==0)
    {
     var1=null;
      SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);

    }
   if(var2.length==0)
  {
   var2=null;
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);

  }
   if(var1 ==  null &&var2 == null)
   {
    
     Navigator.pop(context);
     Navigator.push(context,MaterialPageRoute(builder: (context)=>NoData()));
   }
   else if(var1![0]['ErrorCode']==3&&var2![0]['ErrorCode']==3)
   {
     var1=null;
     var2=null;
     Navigator.pop(context);
     Navigator.push(context,MaterialPageRoute(builder: (context)=>NoResponse()));
   }
    setState(() {
      jsonResult = var1;
      jsonResult1 = var2;
         repback=Colors.white;
      repbor=Colors.blue[700];
      reptext=Colors.blue[700];

      nrepback=Colors.black;
      nrepbor=Colors.white;
      nreptext=Colors.white;
    });

  }
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: ()  async{
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHome('','')));
        //Navigator.pop(context);
        return true;
      },
      child: Scaffold(
          key: _scaffoldkey,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.teal,
          title: Text('My Pending Queries',
              style:TextStyle(
                  color: Colors.white
              )
          ),
        ),
        drawer :AapoortiUtilities.navigationdrawer(_scaffoldkey,context),
        body:Column(
          children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: nrepback,
                          border: Border.all(
                              color: nrepbor!
                          ),
                          borderRadius: BorderRadius.circular(2.0)
                      ),

                      width: 150,
                      height: 40,
                      child:    MaterialButton(
                        onPressed: ()
                        {
                          setState(() {
                            repback=Colors.white;
                            repbor=Colors.blue[700];
                            reptext=Colors.blue[700];

                            nrepback=Colors.black;
                            nrepbor=Colors.white;
                            nreptext=Colors.white;
                           pending=true;
                           replied=false;
                          //  callWebService();
                          });

                        },
                        child: Text('Pending',style: TextStyle(fontSize: 15,color: nreptext,fontWeight: FontWeight.bold),),
                      )

                  ),
                  Padding(
                    padding: new EdgeInsets.only(left: 10),
                  ),
                  Container(
                    margin: new EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: repback,
                      border: Border.all(
                        color: repbor!
                      ),
                      borderRadius: BorderRadius.circular(2.0)
                    ),

                      width: 150,
                      height: 40,
                      child:    MaterialButton(
                        onPressed: ()
                        {
                          setState(() {
                            repback=Colors.blue[700];
                            repbor=Colors.white;
                            reptext=Colors.white;

                            nrepback=Colors.white;
                            nrepbor=Colors.black;
                            nreptext=Colors.black;
                            replied=true;
                            pending=false;
                          //  callWebService();
                          });
                          //callWebService();
                        },
                        child: Text('Replied',style: TextStyle(fontSize: 15,color: reptext,fontWeight: FontWeight.bold),),
                      )

                  ),
                ],
              ),
            ),

            Container(
                child: Expanded(child: jsonResult == null &&jsonResult1==null ?
                SpinKitFadingCircle(color: Colors.teal, size: 120.0):
                pending==true?
                jsonResult![0]['ErrorCode']!=3?
                _myListView(context):
                    Center(
                      child:    Text('No pending Queries!!',style: TextStyle(color: Colors.black,fontSize: 15),)
                    )

                :
                _myListView1(context),)
            ),
          ],
        )


      ),
    );
  }


  Widget _myListView(BuildContext context) {
    //Dismiss spinner
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return
      ListView.separated(
        itemCount: jsonResult != null ? jsonResult!.length:0,
        itemBuilder: (context, index) {
       if(jsonResult![0]['QUERY_ID']!=null)
          return
            Container(
              width: double.infinity,


              child:
              InkWell(
                onTap: ()
                async {
                  bool check=await AapoortiUtilities.checkConnection();
                  if(check==true)
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  PendingQueryDtls(jsonResult![index]['QUERY_ID'].toString(),jsonResult![index]['EMAIL_ID'],
                      jsonResult![index]['CELL_NO'], jsonResult![index]['USER_TYPE'], jsonResult![index]['WORK_AREA'], jsonResult![index]['DESIGNATION'],jsonResult![index]['QUERY_SUBMITTED_BY'],
                    jsonResult![index]['SEQUENCE_ID'].toString(),jsonResult![index]['QUERY_ROW_ID'].toString(),replied
                  )));
                  else
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>NoConnection()));
                },
               child: Column(

                 children: <Widget>[
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Expanded(
                           child:  Container(
                             width: double.maxFinite,
                             height: 30,
                             color: Colors.teal,
                             padding: EdgeInsets.only(bottom: 5,top: 5),
                             child: Text(jsonResult![index]['QUERY_ID'].toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18),textAlign: TextAlign.center,),
                           )
                       )

                     ],
                   ),
                   Padding(padding: EdgeInsets.all(10),),
                   Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                         Padding(padding: new EdgeInsets.only(left: 2),),
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
                                         AapoortiUtilities.customTextView("Date/Time: ", Colors.teal),
                                       ),
                                       Container(
                                         height: 30,
                                         child:
                                         AapoortiUtilities.customTextView(jsonResult![index]['CREATION_DT_TIME'], Colors.black),

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
                                         AapoortiUtilities.customTextView("Reason", Colors.teal),
                                       ),


                                     ]
                                 ),
                                 Row(
                                   children: <Widget>[
                                     Expanded(
                                       child:Container(
                                         height: 30,
                                         child:
                                         AapoortiUtilities.customTextView(jsonResult![index]['SUBJECT'], Colors.black),
                                       ),
                                     ),
                                   ],
                                 ),

                                 Row(
                                   children: <Widget>[


                                     Container(
                                       height: 30,
                                       width: 125,
                                       child:
                                       AapoortiUtilities.customTextView("Query Description", Colors.teal),
                                     ),



                                   ],
                                 ),



              Text(jsonResult![index]['QUERY_DESC'],style: TextStyle(color: Colors.black,fontSize: 15),)


                               ]
                           ),
                         ),
                       ])
                 ],
               ),
              ),

          );
        }
        ,
        separatorBuilder: (context, index) {
          return Divider();
        }

    );
  }
  Widget _myListView1(BuildContext context) {
    //Dismiss spinner
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);

    return
      ListView.separated(
          itemCount: jsonResult1 != null ? jsonResult1!.length:0,
          itemBuilder: (context, index) {
            if(jsonResult1![index]['QUERY_ID']!=null)
            return
              Container(
                width: double.maxFinite,


                child:
                InkWell(
                  onTap: ()
                  async {
                    bool check=await AapoortiUtilities.checkConnection();
                    if(check==true)
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          PendingQueryDtls(jsonResult1![index]['QUERY_ID'].toString(),jsonResult1![index]['EMAIL_ID'],
                            jsonResult1![index]['CELL_NO'], jsonResult1![index]['USER_TYPE'], jsonResult1![index]['WORK_AREA'], jsonResult1![index]['DESIGNATION'],jsonResult1![index]['QUERY_SUBMITTED_BY'],
                            jsonResult1![index]['SEQUENCE_ID'].toString(),jsonResult1![index]['QUERY_ROW_ID'].toString(),replied
                          )));
                    else
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>NoConnection()));
                  },
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child:  Container(
                                width: double.maxFinite,
                                height: 30,
                                color: Colors.teal,
                                padding: EdgeInsets.only(bottom: 5,top: 5),
                                child: Text(jsonResult1![index]['QUERY_ID'].toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18),textAlign: TextAlign.center,),
                              )
                          )

                        ],
                      ),
                      Padding(padding: EdgeInsets.all(10),),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 2),),
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
                                            AapoortiUtilities.customTextView("Date/Time: ", Colors.teal),
                                          ),
                                          Container(
                                            height: 30,
                                            child:
                                            AapoortiUtilities.customTextView(jsonResult1![index]['CREATION_DT_TIME'], Colors.black),

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
                                            AapoortiUtilities.customTextView("Reason", Colors.teal),
                                          ),


                                        ]
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child:Container(
                                            height: 30,
                                            child:
                                            AapoortiUtilities.customTextView(jsonResult1![index]['SUBJECT'], Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: <Widget>[


                                        Container(
                                          height: 30,
                                          width: 125,
                                          child:
                                          AapoortiUtilities.customTextView("Query Description", Colors.teal),
                                        ),



                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(


                                        )
                                      ],
                                    ),

                Text(jsonResult1![index]['QUERY_DESC'],style: TextStyle(color: Colors.black,fontSize: 15),)


                                  ]
                              ),
                            ),
                          ])
                    ],
                  ),
                ),

              );
          }
          ,
          separatorBuilder: (context, index) {
            return Divider();
          }

      );
  }
}
