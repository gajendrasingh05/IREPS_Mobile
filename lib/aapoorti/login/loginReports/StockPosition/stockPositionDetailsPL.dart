import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';


List<dynamic>? jsonResult;


class StockPLDetails extends StatefulWidget {
  final String item1,item2,zone;

  StockPLDetails(this.item1, this.item2, this.dataZone,this.zone);

  List<dynamic> dataZone;

  @override
  StockPLDetailsState createState() => StockPLDetailsState(this.item1,this.item2,this.dataZone,this.zone);
}
class StockPLDetailsState extends State<StockPLDetails> {
  String? plno, selection,zone;
  String? myselection;
  List<dynamic>? dataZone;
  StockPLDetailsState(String plno, String selection,List<dynamic> dataZone,String zone) {
    this.dataZone=dataZone;
    this.plno = plno;
    this.selection = selection;
    this.zone=zone;
    print("pl no-----" + plno..toString());
    print("selection-----" + selection.toString());
  }

  void initState() {
    super.initState();
    jsonResult=null;
    callWebService();

  }

  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," +
        AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + plno! + "," +
        selection! + "," + "P" + ",";
    print("inputparam1----" + inputParam1);
    print("inputparam2----" + inputParam2);
    try{
    jsonResult = await AapoortiUtilities.fetchPostPostLogin(
        'Rpt/StockReport', 'StockReport', inputParam1, inputParam2);
    print("jsonResult====" + jsonResult.toString());
    if(jsonResult!.length >0){
    if(jsonResult![0]['ErrorCode']==3)
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NoData()));
      }
    else if(jsonResult![0]['ErrorCode']==2)
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NoData()));
    }
    else if(jsonResult![0]['ErrorCode']==4)
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NoData()));
    }
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NoData()));

    }
    setState(() {
      if(zone==''&&jsonResult!=null)
      {
        zone=jsonResult![0]['LONG_NAME'];
      }
    });
    }
    catch(e){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NoResponse()));

    }
  }


  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
    return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.white),

          backgroundColor: Colors.teal,
          title: Text('View Stock Position',
              style: TextStyle(
                  color: Colors.white
              )
          ),
        ),
        body: Center(
            child: jsonResult == null  ?
            SpinKitCircle(color: Colors.teal, size: 120.0,)
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
           if(jsonResult![0]['DESCRIPTION']!=null)
          return Container(

              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //AapoortiUtilities.customTextView((index + 1).toString() + ". ", Colors.teal),
                  if(index==0)
                    Container(
                      padding: EdgeInsets.only(left: 10,right: 10,top: 10,),
                      color: Colors.teal.shade50,
                      child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                    height: 30,
                                    width: 125,

                                    child:
                                    AapoortiUtilities.customTextView("Zone:", Colors.teal),
                                  ),
                                  Container(
                                  margin: EdgeInsets.only(bottom: 10,),
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child:
                                      DropdownButtonHideUnderline(
    child: DropdownButton(
                                        hint: Text(zone!),
                                        items: dataZone!.map((item) {
                                              return DropdownMenuItem(child:
                                              Text(item['NAME']),value: item['ID'].toString());
                                            }).toList(),

                                        onChanged: (newVal1)
                                        {
                                          setState(() {
                                            myselection = newVal1 as String;
                                             plno = newVal1;
                                            print("my selection third"+myselection!);
                                            print("my selection third"+myselection!);
                                            jsonResult=null;
                                             callWebService();

                                          });
                                          // fetchPostZone();
                                        },
                                        value: myselection,
                                      ),
                                  ),
                                  ),




                            Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child:
                                    AapoortiUtilities.customTextView("PL Number", Colors.teal),
                                  ),

                                  Expanded(
                                    child:Container(
                                      height: 30,
                                      child:
                                      AapoortiUtilities.customTextView(jsonResult![index]['PL_NO'], Colors.black),
                                    ),
                                  ),
                                ]
                            ),


                        Column(
                          children: <Widget>[
                            Row(
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child:
                                    AapoortiUtilities.customTextView("Description", Colors.teal),
                                  ),

                                ]
                            ),
                            Row(
                              children: <Widget>[

                                Expanded(
                                //  height: 50,
                                  child:
                                  Text(jsonResult![index]['DESCRIPTION'],style: TextStyle(color: Colors.black,fontSize: 14),)
                                )
                              ],
                            ),


                  Padding(
                  padding: EdgeInsets.only(top: 20),
          )

                          ],
                        ),




                          ]
                      ),
                    ),
                    if(index==0)
                    Container(
                      padding: EdgeInsets.only(left: 10,top: 10,bottom: 10),

                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width/7,
                            child:
                             Text("Sno.",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),


                          ),
                          Container(
                            width: MediaQuery.of(context).size.width/3,
                            child:
                            Text("Depot Name",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),


                          ),
                          Container(
                            width: MediaQuery.of(context).size.width/5,
                            child:
                            Text("Quantity",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),



                          ),
                          Expanded(
                            child:   Container(
                              width: MediaQuery.of(context).size.width/4,
                              child:
                              Text("View",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),


                            ),
                          )

                        ],
                      ),
                    ),
//          if(index==0)
//          Container(
//          height: 0.5,
//          color: Colors.black,
//          ),
                    Container(
                      padding: EdgeInsets.only(left: 10,top: 5,bottom: 5),
                      color: Colors.grey[200],

                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width/7,
                           child:
                              AapoortiUtilities.customTextView((index + 1).toString() + ". ", Colors.black),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width/3,
                            child:
                           Text(jsonResult![index]['LONG_NAME'],style: TextStyle(color: Colors.black),)


                          ),
                          Container(
                            width: MediaQuery.of(context).size.width/5,
                            child:
                              AapoortiUtilities.customTextView((jsonResult![index]['QUANTITY']).toString(), Colors.black),


                          ),
                          Expanded(
                            child:  Container(
                              width: MediaQuery.of(context).size.width/4,
                              child:
                              AapoortiUtilities.customTextView((jsonResult![index]['STOCK_VALUE']).toString(), Colors.black),

                            ),
                          )

                        ],
                      ),
//
                    ),
//                    Container(
//                      height: 0.5,
//                      color: Colors.black,
//                    )
                  ])
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        }

    );
  }

}