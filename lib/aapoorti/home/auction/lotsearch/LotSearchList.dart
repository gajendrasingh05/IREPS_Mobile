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
          ? heading = "List of Lots (Published)"
          : heading = "List of Lots (Sold out)";
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
            backgroundColor: Colors.lightBlue[800],
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
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: 400,
                height: 25,
                color: Colors.white,
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  heading,
                  style: new TextStyle(
                      color: Colors.lightBlue.shade800,
                      // backgroundColor: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white, // Set the desired background color here
                  child: jsonResult == null
                      ? SpinKitWave(
                    color: Colors.lightBlue[800],
                    size: 30.0,
                  )
                      : _lotsearchlist(context),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget _lotsearchlist(BuildContext context) {
    return Container(
      color: Colors.white, // Light grey background
      child: ListView.separated(
        itemCount: jsonResult != null ? jsonResult!.length : 0,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              lotId = jsonResult![index]['LOTID'];
              print(lotId);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LotSearchLotDetails(
                    lotId: lotId!,
                    lotType: lotType!,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              color: index % 2 == 0 ? Color(0xFFE3F2FD) : Colors.white, // Alternating card colors
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Spacing
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
                side: BorderSide(
                    color: Colors.grey.shade400, width: 1), // Shaded border
              ),
              child: Padding(
                padding: EdgeInsets.all(8), // Padding inside the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Index Number
                    Text(
                      "${index + 1}. ${jsonResult![index]['ACCNM'] ?? ""}",
                      style: TextStyle(
                        color: Colors.lightBlue[800],
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),

                    // Location
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            "Location",
                            style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Roboto'),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            jsonResult![index]['LOC'] ?? "",
                            style: TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'Roboto'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),

                    // Description
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            "Description",
                            style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Roboto'),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            jsonResult![index]['LOTDESC'] ?? "",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              fontFamily: 'Roboto',
                            ),
                            overflow: TextOverflow.ellipsis, // Prevents overflow issues
                            maxLines: 2, // Adjust the number of lines as needed
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 1); // Space between cards
        },
      ),
    );
  }

}
