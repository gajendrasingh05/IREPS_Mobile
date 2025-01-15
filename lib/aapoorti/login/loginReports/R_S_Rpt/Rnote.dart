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

class RnoteDetails extends StatefulWidget {
  get path => null;
  String year;


  RnoteDetails(this.year);

  @override
  _RnoteDetailsState createState() => _RnoteDetailsState(this.year);
}

class _RnoteDetailsState extends State<RnoteDetails> {
  List<dynamic>? jsonResult;
  String year;
  final dbHelper = DatabaseHelper.instance;
  var rowCount=-1;
  int i=0;
  final GlobalKey<ScaffoldState> _scaffoldkey= GlobalKey<ScaffoldState>();
  ScrollController? _scrollController;


  _RnoteDetailsState(this.year);

  void initState() {
    super.initState();
    i=0;
    _scrollController=new ScrollController();
    _scrollController!.addListener(changeSelection);

    callWebService();
  }
  void changeSelection()
  {
    int tempindex;
    int scrollvalue=_scrollController!.offset.round();
    int maxscroll=_scrollController!.position.maxScrollExtent.round();
    print(scrollvalue.toString());
    print(maxscroll.toString());
    if(scrollvalue>20)
      scrollvalue=scrollvalue-20;

    tempindex=((scrollvalue/(jsonResult!.length*2))).ceil();
    print("tempindex is....."+tempindex.toString());
    setState(() {
      if(jsonResult!=null&&tempindex<jsonResult!.length)
        i=tempindex;
    });



  }
  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," +AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + "-1" + "," + "-1" + "," + "-1" + "," + year;

    jsonResult = await AapoortiUtilities.fetchPostPostLogin('Rpt/RNoteReport', 'RNoteReport' ,inputParam1, inputParam2) ;
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
    return MaterialApp(
      title: 'R-note',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          title: Text(' R-note Report',
              style:TextStyle(
                  color: Colors.white
              )
          ),
        ),
        drawer :AapoortiUtilities.navigationdrawer(_scaffoldkey,context),
        body: Center(
            child:
            jsonResult == null  ?
            SpinKitFadingCircle(color: Colors.teal, size: 120.0,):
            Container(
              color: Colors.white,
              width:MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Container(
                      width:MediaQuery.of(context).size.width/2,
                      child:

                      _myListView(context)



                  ),
                  Padding(padding: new EdgeInsets.only(left: 20),),

                  Expanded(
                    child:    Container
                      (
                        width:(MediaQuery.of(context).size.width)/3,
                        //color: Colors.orangeAccent[100],
                        color: Colors.grey[200],
                      /*  height: MediaQuery.of(context).size.height,*/
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: <Widget>[
                            Padding(
                              padding: new EdgeInsets.only(top: 8),
                            ),
                            Text('Monthly Report',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700,color: Colors.black),),
//                            Padding(
//                              padding: new EdgeInsets.only(top: 10),
//                            ),
                            Text(jsonResult![i]['RLY_NAME']!=null?'('+jsonResult![i]['RLY_NAME']+")":'( )',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black),),
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 45),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  height: 30,
                                  color: Colors.indigo[100],
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:    Text('Apr',textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo,fontSize: 18),),

                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 0),
                                ),
                                Container(
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:Text(jsonResult![i]['APR_PCT']!=null?jsonResult![i]['APR_PCT'].toString():'-',textAlign: TextAlign.center,style: TextStyle(color: Colors.teal,fontSize: 18),),


                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding:EdgeInsets.only(top: 45),
                                ),
                                Container(
                                  padding:EdgeInsets.only(top: 5),
                                  height: 30,
                                  color: Colors.indigo[100],
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:    Text('May',textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo,fontSize: 18),),

                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 0),
                                ),
                                Container(
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:Text(jsonResult![i]['MAY_PCT']!=null?jsonResult![i]['MAY_PCT'].toString():'-',textAlign: TextAlign.center,style: TextStyle(color: Colors.teal,fontSize: 18),),


                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 45),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  height: 30,
                                  color: Colors.indigo[100],
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:    Text('Jun',textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo,fontSize: 18),),

                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 0),
                                ),
                                Container(
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:Text(jsonResult![i]['JUN_PCT']!=null?jsonResult![i]['JUN_PCT'].toString():'-',textAlign: TextAlign.center,style: TextStyle(color: Colors.teal,fontSize: 18),),


                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: new EdgeInsets.only(top: 45),
                                ),
                                Container(
                                  padding: new EdgeInsets.only(top: 5),
                                  height: 30,
                                  color: Colors.indigo[100],
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:    Text('Jul',textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo,fontSize: 18),),

                                ),
                                Padding(
                                  padding: new EdgeInsets.only(left: 0),
                                ),
                                Container(
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:Text(jsonResult![i]['JUL_PCT']!=null?jsonResult![i]['JUL_PCT'].toString():'-',textAlign: TextAlign.center,style: TextStyle(color: Colors.teal,fontSize: 18),),


                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: new EdgeInsets.only(top: 45),
                                ),
                                Container(
                                  padding: new EdgeInsets.only(top: 5),
                                  height: 30,
                                  color: Colors.indigo[100],
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:    Text('Aug',textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo,fontSize: 18),),

                                ),
                                Padding(
                                  padding: new EdgeInsets.only(left: 0),
                                ),
                                Container(
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:Text(jsonResult![i]['AUG_PCT']!=null?jsonResult![i]['AUG_PCT'].toString():'-',textAlign: TextAlign.center,style: TextStyle(color: Colors.teal,fontSize: 18),),


                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: new EdgeInsets.only(top: 45),
                                ),
                                Container(
                                  padding: new EdgeInsets.only(top: 5),
                                  height: 30,
                                  color: Colors.indigo[100],
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:    Text('Sep',textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo,fontSize: 18),),

                                ),
                                Padding(
                                  padding: new EdgeInsets.only(left: 0),
                                ),
                                Container(
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:Text(jsonResult![i]['SEP_PCT']!=null?jsonResult![i]['SEP_PCT'].toString():'-',textAlign: TextAlign.center,style: TextStyle(color: Colors.teal,fontSize: 18),),


                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: new EdgeInsets.only(top: 45),
                                ),
                                Container(
                                  padding: new EdgeInsets.only(top: 5),
                                  height: 30,
                                  color: Colors.indigo[100],
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:    Text('Oct',textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo,fontSize: 18),),

                                ),
                                Padding(
                                  padding: new EdgeInsets.only(left: 0),
                                ),
                                Container(
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:Text(jsonResult![i]['OCT_PCT']!=null?jsonResult![i]['OCT_PCT'].toString():'-',textAlign: TextAlign.center,style: TextStyle(color: Colors.teal,fontSize: 18),),


                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: new EdgeInsets.only(top: 45),
                                ),
                                Container(
                                  padding: new EdgeInsets.only(top: 5),
                                  height: 30,
                                  color: Colors.indigo[100],
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:    Text('Nov',textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo,fontSize: 18),),

                                ),
                                Padding(
                                  padding: new EdgeInsets.only(left: 0),
                                ),
                                Container(
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:Text(jsonResult![i]['NOV_PCT']!=null?jsonResult![i]['NOV_PCT'].toString():'-',textAlign: TextAlign.center,style: TextStyle(color: Colors.teal,fontSize: 18),),


                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: new EdgeInsets.only(top: 45),
                                ),
                                Container(
                                  padding: new EdgeInsets.only(top: 5),
                                  height: 30,
                                  color: Colors.indigo[100],
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:    Text('Dec',textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo,fontSize: 18),),

                                ),
                                Padding(
                                  padding: new EdgeInsets.only(left: 0),
                                ),
                                Container(
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:Text(jsonResult![i]['DEC_PCT']!=null?jsonResult![i]['DEC_PCT'].toString():'-',textAlign: TextAlign.center,style: TextStyle(color: Colors.teal,fontSize: 18),),


                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: new EdgeInsets.only(top: 45),
                                ),
                                Container(
                                  padding: new EdgeInsets.only(top: 5),
                                  height: 30,
                                  color: Colors.indigo[100],
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:    Text('Jan',textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo,fontSize: 18),),

                                ),
                                Padding(
                                  padding: new EdgeInsets.only(left: 0),
                                ),
                                Container(
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:Text(jsonResult![i]['JAN_PCT']!=null?jsonResult![i]['JAN_PCT'].toString():'-',textAlign: TextAlign.center,style: TextStyle(color: Colors.teal,fontSize: 18),),


                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: new EdgeInsets.only(top: 45),
                                ),
                                Container(
                                  padding: new EdgeInsets.only(top: 5),
                                  height: 30,
                                  color: Colors.indigo[100],
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:    Text('Feb',textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo,fontSize: 18),),

                                ),
                                Padding(
                                  padding: new EdgeInsets.only(left: 0),
                                ),
                                Container(
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:Text(jsonResult![i]['FEB_PCT']!=null?jsonResult![i]['FEB_PCT'].toString():'-',textAlign: TextAlign.center,style: TextStyle(color: Colors.teal,fontSize: 18),),


                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: new EdgeInsets.only(top: 45),
                                ),
                                Container(
                                  padding: new EdgeInsets.only(top: 5),
                                  height: 30,
                                  color: Colors.indigo[100],
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:    Text('Mar',textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo,fontSize: 18),),

                                ),
                                Padding(
                                  padding: new EdgeInsets.only(left: 0),
                                ),
                                Container(
                                  width:(MediaQuery.of(context).size.width)/5,
                                  child:Text(jsonResult![i]['MAR_PCT']!=null?jsonResult![i]['MAR_PCT'].toString():'-',textAlign: TextAlign.center,style: TextStyle(color: Colors.teal,fontSize: 18),),


                                ),
                              ],
                            ),


                          ],
                        )
                      //   AapoortiUtilities.customTextView(jsonResult[0]['RLY_NAME'], Colors.black),








                    ),
                  )


                ],
              ),
            )






        ),

      ),
    );
  }


  Widget _myListView(BuildContext context) {
    //Dismiss spinner
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return ListView.separated(
        controller: _scrollController,
        itemCount: jsonResult != null ? jsonResult!.length:0,
        itemBuilder: (context, index) {

          return
            Container(
              child:
              Column(
                children: <Widget>[
                  if(index==0)
                    Container(
                      padding: EdgeInsets.only(top: 15,bottom: 10,left: 5),
                      child:    Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width/15,

                              child:          Text('Sr.',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 15),),

                            ),

                            Container(

                              width: MediaQuery.of(context).size.width/6,

                              child:
                              Text('Zone',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 15)),







                            ),
                            Padding(padding: EdgeInsets.only(left: 5)),
                            Container(
                              width: MediaQuery.of(context).size.width/10,


                              child:
                              Text('Avg',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 15),),








                            ),
                            Padding(padding: EdgeInsets.only(left: 5)),
                            Container(

                              width: MediaQuery.of(context).size.width/8,

                              child:
                              Text('Marks',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 15),),







                            ),

                          ]),
                    ),
                  GestureDetector(
                    child:   Container(
                      padding: EdgeInsets.only(top: 15,bottom: 10,left: 5),
                      color: index==i?Colors.teal[100]:Colors.white,
                      child:    Row(                crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width/15,

                              child:                     AapoortiUtilities.customTextViewWithoutE((index + 1).toString() + ". ", Colors.teal),

                            ),

                            Container(

                              width: MediaQuery.of(context).size.width/6,

                              child:
                              AapoortiUtilities.customTextViewWithoutE(jsonResult![index]['RLY_NAME'], Colors.black),

                            ),
                            Padding(padding: EdgeInsets.only(left: 5)),
                            Container(
                              width: MediaQuery.of(context).size.width/10,


                              child:
                              AapoortiUtilities.customTextViewWithoutE(jsonResult![index]['AVG_PCT'].toString(), Colors.black),







                            ),
                            Padding(padding: EdgeInsets.only(left: 15)),
                            Container(

                              width: MediaQuery.of(context).size.width/10,

                              child:
                              AapoortiUtilities.customTextViewWithoutE(jsonResult![index]['MARKS'].toString(), Colors.black),

                            ),

                          ]),
                    ),
                    onTap: (){
                      i=index;
                      setState(() {
                        i=index;
                      });
                    },
                  ),

                ],
              ),

            );
        },
        separatorBuilder: (context, index) {
          return Divider();
        }

    );
  }
}
