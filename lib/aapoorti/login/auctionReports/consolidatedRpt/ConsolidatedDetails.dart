import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../home/UserHome.dart';

class ConsolidatedDetails extends StatefulWidget {
  get path => null;
  String _catalogueid,_railid,_valuefrom,_valueto;
  @override
  _ConsolidatedDetailsState createState() => _ConsolidatedDetailsState(_railid,_catalogueid,_valuefrom,_valueto);

  ConsolidatedDetails(this._railid,this._catalogueid,this._valuefrom,this._valueto);
}

class _ConsolidatedDetailsState extends State<ConsolidatedDetails> {

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  List<dynamic>? jsonResult;
  List<dynamic>? jsonResultexp;
  final dbHelper = DatabaseHelper.instance;
  var rowCount=-1;
  var _check;
  Color _backgroundColor=Colors.white;
  var _str;
  String _catalogueid,_railid,_valuefrom,_valueto;
  double _totalvalue=0;

  _ConsolidatedDetailsState(this._railid,this._catalogueid,this._valuefrom,this._valueto);

  void initState() {
    super.initState();
    callWebService();
  }
  Future main() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    runApp(new ConsolidatedDetails(_railid, _catalogueid, _valuefrom, _valueto));
  }
  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," +AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," +_railid+","+_catalogueid+","+_valuefrom+","+_valueto;

    jsonResult = await AapoortiUtilities.fetchPostPostLogin('AFLAuction/CONSOLIDATED', 'CONSOLIDATED' ,inputParam1, inputParam2) ;
    print(jsonResult);
    jsonResultexp=jsonResult;
    _check = [];
    String tempvalue;
    String tempname;
    if(jsonResult!.length==0)
    {
      jsonResult = [null];
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>NoData()));
    }
    else if(jsonResult![0]['ErrorCode']==3)
    {
      jsonResult=null;
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>NoResponse()));
    }
    else
      for(int i=0;i<jsonResult!.length;i++)
      {
        tempvalue=jsonResult![i]['DISPOSAL_VALUE'].toString();
        tempvalue+="\n";
        tempname=jsonResult![i]['DEPOT_NAME'];
        tempname+="\n";
        _check[i]=1;
        _totalvalue+=jsonResult![i]['DISPOSAL_VALUE'];
        print("is is: "+i.toString());
        while(i<jsonResult!.length-1&&jsonResultexp![i]['ACCOUNT_NAME']==jsonResultexp![i+1]['ACCOUNT_NAME'])
        {
          print("i is ?: "  +i.toString()+"\n");



          _check[i+1]=0;
          _totalvalue+=jsonResult![i+1]['DISPOSAL_VALUE'];
          tempvalue+=jsonResult![i+1]['DISPOSAL_VALUE'].toString();
          tempvalue+="\n";
          tempname+=jsonResult![i+1]['DEPOT_NAME'];
          tempname+="\n";
          jsonResultexp!.removeAt(i+1);
        }
        jsonResultexp![i]['DISPOSAL_VALUE']=tempvalue;
        jsonResultexp![i]['DEPOT_NAME']=tempname;
//       print(jsonResultexp.toString());
      }
//    jsonResultexp = await AapoortiUtilities.fetchPostPostLogin('AFLAuction/HCATALOG', 'HCATALOG' ,inputParam1, inputParam2) ;
//    print(jsonResultexp);
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
          resizeToAvoidBottomInset: false,
          key: _scaffoldkey,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),

            backgroundColor: Colors.teal,
            title: Text('Consolidated Details',
                style:TextStyle(
                    color: Colors.white
                )
            ),
          ),
          drawer :AapoortiUtilities.navigationdrawer(_scaffoldkey,context),
          body:
          jsonResult == null  ?
          SpinKitFadingCircle(color: Colors.teal, size: 120.0) :
          Column(

            children: <Widget>[


              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),

                child:
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text('Date:  '+_valuefrom+" To "+_valueto,style: TextStyle(fontSize: 16,color: Colors.white),),
                        Text('Grant Total(Lakh Rs.)":  '+_totalvalue.toStringAsFixed(3),style: TextStyle(fontSize: 16,color: Colors.white),),
                      ],
                    ),
                  ],
                ),

              ),

              Container(

                  child: Expanded(

                    child: _myListView(context),)

              )
            ],
          )
      ),
    );
  }


  Widget _myListView(BuildContext context) {
    //Dismiss spinner
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);

    return
      jsonResult!.isEmpty ? Center(
        child: Text('no data'),
      ):
      Container(
          color: Colors.grey[300],
          child: ListView.separated(


              itemCount: jsonResult != null ? jsonResultexp!.length:0,

              itemBuilder: (context, index) {
                double temptotal=0;
                var totalarray=jsonResultexp![index]['DISPOSAL_VALUE'].toString().split("\n");
                debugPrint("total array"+totalarray.toString());
                for(int i=0;i<totalarray.length-1;i++)
                  temptotal+=double.tryParse(totalarray[i])!;
                debugPrint("length is"+totalarray.toString());
                var _str=jsonResultexp![index]['DEPOT_NAME'].toString().split("\n");
                debugPrint(_str.length.toString());
                if(_check[index]==1)
                  return
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white),

                      child:

                      ExpansionTile(
                        backgroundColor: Colors.teal[100],
                        onExpansionChanged: _onExpansion,
                        title:

                        Column(

                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              child: Text(jsonResultexp![index]['ACCOUNT_NAME'],textAlign: TextAlign.left,style: TextStyle(color: Colors.teal,fontStyle:FontStyle.normal,fontWeight: FontWeight.bold,),),

                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(

                              child:Text('Total Value :  '+temptotal.toStringAsFixed(3),textAlign: TextAlign.end,style: TextStyle(color: Colors.grey,fontStyle:FontStyle.normal,fontWeight: FontWeight.bold,),),

                            ),

                          ],
                        ),
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: new EdgeInsets.only(left: 5,right: 5),
                            width: double.infinity,
                            color: Colors.white,
                            child: Row(

                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[

                                Expanded(



                                  child:   Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          AapoortiUtilities.customTextView('List of Depot',Colors.grey)
                                        ],
                                      ),
                                      new Padding(padding: new EdgeInsets.only(top: 10)),
                                      Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            for(int i=0;i<_str.length-1;i++)

                                              Row(

                                                children: <Widget>[
                                                  Expanded(
                                                    child:  Container(
                                                      height: 30,
                                                      width: 300,
                                                      child: AapoortiUtilities.customTextView(_str[i],Colors.teal),
                                                    ),

                                                  ),
                                                ],
                                              )


                                          ]


                                      ),


                                    ],
                                  ),

                                ),



                                new Padding(padding: EdgeInsets.only(left: 10)),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[

                                    Column(
                                      children: <Widget>[
                                        AapoortiUtilities.customTextView('Value',Colors.grey)
                                      ],
                                    ),

                                    new Padding(padding: new EdgeInsets.only(top: 10)),
                                    Column(
                                      children: <Widget>[
                                        for(int i=0;i<totalarray.length-1;i++)
                                          Container(
                                            height: 30,
                                            child: AapoortiUtilities.customTextView(totalarray[i],Colors.teal),
                                          )


                                      ],
                                    )
                                  ],
                                ),

                              ],
                            ),
                          ),





                        ],
                      ),

                    );
              }
              ,
              separatorBuilder: (context, index) {
                return Divider();
              }

          )
      );

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
