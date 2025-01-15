import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class AvgSetTimeNEXTpage extends StatefulWidget{
  final String? item1;
  AvgSetTimeNEXTpage({this.item1});

  @override
  _AvgSetTimeNEXTpageState createState() => _AvgSetTimeNEXTpageState(this.item1!);
}
class _AvgSetTimeNEXTpageState extends State<AvgSetTimeNEXTpage> {
  List<dynamic>? jsonResult;
  String? From_date,To_date;
  String? item1;
  List data = [];
  _AvgSetTimeNEXTpageState(String item1){
    this.item1=item1;
  }
  void initState() {
    super.initState();
    callWebService();
  }
  void callWebService() async {
    if(item1=='2018-2019')  {
        From_date="01/04/2018";
        To_date="31/03/2019";
    } else if(item1=='2019-2020') {
        From_date="01/04/2019";
        To_date="31/03/2020";
    }
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," +AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID+","+From_date!+","+To_date!+","+"PT" ;
    jsonResult = await AapoortiUtilities.fetchPostPostLogin('Rpt/AvgSetTimeReport', 'AvgSetTimeReport' ,inputParam1, inputParam2) ;
    if(jsonResult!.length==0)    {
      jsonResult=null;
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>NoData()));
    }  else if(jsonResult![0]['ErrorCode']==3)   {
      jsonResult=null;
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>NoResponse()));
    }
    setState(() {
      data=jsonResult!;
    });
  }

  @override
  var _snackKey = GlobalKey<ScaffoldState>();
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Avg Settlement Time Report',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          //resizeToAvoidBottomPadding: true,
          key:_snackKey,
          appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Row(children: <Widget>[
                Text("Avg Settlement Time Report",style: TextStyle(color: Colors.white),),
                Padding(padding: EdgeInsets.only(left: 100)),
              ],
            ),
          ),
          // backgroundColor: Colors.cyan[400],
          body: Container(
            child:
                Column(
                  children: <Widget>[
                  Container(
                  width:410.0,
                  height: 25.0,
                  padding:  EdgeInsets.only(top: 5.0),
                  child: Text(" Zone   TC Avg    DA Avg     TC Marks     DA Marks   Total   ",
                  style: TextStyle(fontSize: 15,color: Colors.white),
                    textAlign: TextAlign.start,),
                    color: Colors.teal,

                ),
                Padding(padding: EdgeInsets.only(top: 5.0)),
                Expanded(
                child: Row(
                children: <Widget>[

            Expanded(child: jsonResult == null  ?
            SpinKitFadingCircle(color: Colors.teal, size: 80.0)
                :_myListView(context))
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
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);;
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
    )
        : ListView.builder(
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
                       Container(
                         width: MediaQuery.of(context).size.width/6,
                         child:
                           Text(
                             jsonResult![index]['ACCOUNT_NAME'].toString() != null
                                 ? jsonResult![index]['ACCOUNT_NAME'].toString()
                                 : "",
                             style: TextStyle(
                               color: Colors.black,
                               fontSize: 15,
                             ),
                           ),
                       ),
                        Container(
                          width: MediaQuery.of(context).size.width/6,
                          child:
                            Text(
                              jsonResult![index]['AVG_SET_TC'].toString() != null
                                  ? jsonResult![index]['AVG_SET_TC'].toString()
                                  : "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/6,
                          child:
                            Text(
                              jsonResult![index]['AVG_SET_DA'].toString() != null
                                  ? jsonResult![index]['AVG_SET_DA'].toString()
                                  : "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/6,
                          child:
                            Text(
                              jsonResult![index]['TC_MARKS'].toString() != null
                                  ? jsonResult![index]['TC_MARKS'].toString()
                                  : "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/6,
                          child:
                            Text(
                              jsonResult![index]['DA_MARKS'].toString() != null
                                  ? jsonResult![index]['DA_MARKS'].toString()
                                  : "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/6,
                          child:
                            Text(
                              (jsonResult![index]['TC_MARKS']+jsonResult![index]['DA_MARKS']).toString() != null
                                  ? (jsonResult![index]['TC_MARKS']+jsonResult![index]['DA_MARKS']).toString()
                                  : "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                        ),
//                       Padding(padding: EdgeInsets.only(left: 55.0)),
                      ],
                    ),
                    Container
                      (
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

