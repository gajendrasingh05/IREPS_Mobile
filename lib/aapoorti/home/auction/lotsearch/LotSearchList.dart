import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/aapoorti/home/auction/lotsearch/LotSearchLotDetails.dart';

class LotSearchList extends StatefulWidget {
  final String? desc, depotUnit, railUnit;
  final int? lotType;

  LotSearchList({this.lotType, this.railUnit, this.depotUnit, this.desc});

  @override
  _LotSearchListState createState() => _LotSearchListState(
      this.lotType, this.railUnit, this.depotUnit, this.desc);
}

class _LotSearchListState extends State<LotSearchList> {
  String? desc, depotUnit, railUnit;
  int? lotType;
  String heading = "";
  _LotSearchListState(
      int? lotType, String? railUnit, String? depotUnit, String? desc) {
    this.lotType = lotType;
    this.railUnit = railUnit;
    this.depotUnit = depotUnit;
    this.desc = desc;
  }
  List<dynamic>? jsonResult;
  int? lotId;

  void initState() {
    super.initState();
    fetchPost();
  }

  List data = [];
  void fetchPost() async {

    var v = AapoortiConstants.webServiceUrl +
        'Auction/Lotsearch?RLYID=${this.railUnit}&DEPOTID=${this.depotUnit}&DESC=${desc}&LOTTYPE=${lotType}';
    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);
    if (jsonResult![0]['ErrorCode'] == 3) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoData()));
    } else if (jsonResult![0]['ErrorCode'] == 4) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoResponse()));
    }
    setState(() {
      lotType == 0
          ? visibleYes = false
          : visibleYes = true; // setting visibility
      lotType == 0
          ? heading = "List of Lots(Published)"
          : heading = "List of Lots(Sold out)";
      data = jsonResult!;
    });
  }

//https://ireps.gov.in/Aapoorti/ServiceCallAuction/Lotsearch?RLYID=561&DEPOTID=-1&DESC=steel&LOTTYPE=1
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.cyan[400],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Text('Lot Search(Sale)',
                        style: TextStyle(color: Colors.white))),
                // new Padding(padding: new EdgeInsets.only(right: 40.0)),
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/common_screen", (route) => false);
                    //Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            )),
        /*MaterialApp(
      title: 'Lot Search',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: Scaffold(

        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text('Lot Search',
              style:TextStyle(
                  color: Colors.white
              )
          ),
          backgroundColor:Colors.cyan ,
        ),*/
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: 400,
                height: 30,
                color: Colors.cyan.shade600,
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  heading,
                  style: new TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.cyan.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                  child: jsonResult == null
                      ? SpinKitFadingCircle(
                          color: Colors.cyan,
                          size: 120.0,
                        )
                      : _lotsearchlist(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget _lotsearchlist(BuildContext context) {
    //Dismiss spinner

    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return ListView.separated(
      itemCount: jsonResult != null ? jsonResult!.length : 0,
      itemBuilder: (context, index) {
        return GestureDetector(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(width: 1, color: Colors.grey[300]!),
              ),

              // padding: EdgeInsets.all(10),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
                      Widget>[
                Text(
                  (index + 1).toString() + ". ",
                  style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                          //height: 30,
                          child: Text(
                            jsonResult![index]['ACCNM'] != null
                                ? jsonResult![index]['ACCNM']
                                : "",
                            style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ]),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Row(children: <Widget>[
                        Container(
                          height: 30,
                          width: 125,
                          child: Text(
                            "Location",
                            style:
                                TextStyle(color: Colors.indigo, fontSize: 16),
                          ),
                        ),
                        Expanded(
                          //height: 30,
                          child: Text(
                            jsonResult![index]['LOC'] != null
                                ? jsonResult![index]['LOC']
                                : "",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      ]),
                      Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                        Container(
                          height: 30,
                          width: 125,
                          child: Text(
                            "Description",
                            style:
                                TextStyle(color: Colors.indigo, fontSize: 16),
                          ),
                        ),
                      ]),
                      Row(children: <Widget>[
                        Expanded(
                          //height: 30,
                          child: Text(
                            jsonResult![index]['LOTDESC'] != null
                                ? jsonResult![index]['LOTDESC']
                                : "",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      ]),
                    ]))
              ]),
            ),
            onTap: () {
              lotId = jsonResult![index]['LOTID'];
              print(lotId);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LotSearchLotDetails(
                          lotId: lotId!,
                          lotType: lotType!))); //lotType:lotType)));
            });
      },
      separatorBuilder: (context, index) {
        //return Divider();
        return Container(
          height: 10,
        );
      },
    );
  }
}
