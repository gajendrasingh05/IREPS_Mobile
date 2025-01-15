import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/home/auction/upcoming/upcomingnextpage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Userup {
  final String? upid, category;
  const Userup({
    this.upid,
    this.category,
  });
}

class Upcoming extends StatefulWidget {
  @override
  _UpcomingState createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  List<dynamic>? jsonResult;
  var rowCount = -1;
  void openNewPage() {
    Navigator.of(context).pushNamed("/upcoming");
  }

  void initState() {
    super.initState();
    fetchPost();
  }

  void fetchPost() async {
    var v = AapoortiConstants.webServiceUrl + 'Auction/AucUpcoming?PAGECOUNTER=1';
    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);

    setState(() {});
  }

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
                    child: Text('Upcoming Auctions(Sale)',
                        style: TextStyle(color: Colors.white))),
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            )),
        body: Center(
            child: jsonResult == null
                ? SpinKitFadingCircle(
                    color: Colors.cyan,
                    size: 120.0,
                  )
                : _myListView(context)),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);

    if (jsonResult!.isEmpty) {
      AapoortiUtilities.showInSnackBar(context, "No Upcoming  Tender");
    } else {
      return ListView.separated(
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Card(
                elevation: 4,
                color: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(width: 1, color: Colors.grey[300]!),
                ),
                child: Column(children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 6)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 8)),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Text(
                            (index + 1).toString() + ". ",
                            style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(children: <Widget>[
                                Expanded(
                                    child: Text(
                                  jsonResult![index]['DEPOT_NAME'] != null
                                      ? jsonResult![index]['DEPOT_NAME']
                                      : "",
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ))
                              ]),
                              Padding(padding: EdgeInsets.only(top: 5.0)),
                              Row(children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Catalogue No",
                                    style: TextStyle(
                                        color: Colors.indigo, fontSize: 16),
                                  ),
                                  flex: 4,
                                ),
                                Expanded(
                                  // height: 30,
                                  //padding: EdgeInsets.only(top: 10,right: 9),

                                  child: Text(
                                    jsonResult![index]['CATALOG_NO'] != null
                                        ? jsonResult![index]['CATALOG_NO']
                                        : "",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                  flex: 6,
                                )
                              ]),
                              Row(children: <Widget>[
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      'Auction Start',
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  flex: 4,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 10),
                                    height: 30,
                                    child: Text(
                                      jsonResult![index]['AUCTION_START_DATETIME'] != null ? jsonResult![index]['AUCTION_START_DATETIME'] : "",
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 16),
                                    ),
                                  ),
                                  flex: 6,
                                ),
                              ]),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Auction End',
                                        style: TextStyle(
                                            color: Colors.indigo, fontSize: 16),
                                      ),
                                    ),
                                    flex: 4,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(top: 10),
                                      height: 30,
                                      child: Text(
                                        (jsonResult![index]
                                                    ['AUCTION_END_DATETIME'] !=
                                                null
                                            ? jsonResult![index]
                                                ['AUCTION_END_DATETIME']
                                            : ""),
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 16),
                                      ),
                                    ),
                                    flex: 6,
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 8)),
                            ]),
                      ),
                    ],
                  ),
                ]),
              ),
              onTap: () {
                if (jsonResult![index]['CORRI_DETAILS'] != 'NA') {
                  showDialog(
                      context: context,
                      builder: (_) =>
                          Material(
                              type: MaterialType.transparency,
                              child: Center(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: 200,
                                          bottom: 200,
                                          left: 30,
                                          right: 30),
                                      padding: EdgeInsets.only(
                                          top: 30,
                                          bottom: 0,
                                          left: 30,
                                          right: 30),
                                      color: Colors.white,
                                      // Aligns the container to center
                                      child: Column(children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            'List of Categories',
                                            style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(bottom: 0),
                                            child: Overlay(
                                              context,
                                              jsonResult![index]['DESCRIPTION']
                                                  .toString(),
                                              jsonResult![index]['CATALOG_ID']
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Text('CLICK ON ANY CATEGORY',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.indigo)),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop('dialog');
                                              },
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/close_overlay.png'),
                                                color: Colors.black,
                                                height: 50,
                                              )),
                                        )
                                      ])))));
                }
              },
            );
          },
          separatorBuilder: (context, index) {
            return Container(height: 10);
          },
          itemCount: jsonResult != null ? jsonResult!.length : 0);
    }
    return Container();
  }

  Widget Overlay(BuildContext context, String description, String catid) {
    var UpcomingArray = description.split('#');
    var upcomingcatid = catid;

    return ListView.separated(
        itemCount: description.isNotEmpty || description.length>0 ? UpcomingArray.length : 0,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.all(0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            var route = MaterialPageRoute(
                              builder: (BuildContext context) => upcoming2(
                                  value1: Userup(
                                upid: upcomingcatid,
                                category: UpcomingArray[index],
                              )),
                            );
                            Navigator.of(context).push(route);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                UpcomingArray[index].toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ],
                          ))),
                ],
              ));
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey,
            height: 25,
          );
        });
  }
}
