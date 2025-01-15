import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/home/auction/live/livenextpage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class User {
  final String? catid, category;
  const User({
    this.catid,
    this.category,
  });
}

class Live extends StatefulWidget {
  @override
  _LiveState createState() => _LiveState();
}

class _LiveState extends State<Live> {
  List<dynamic>? jsonResult;


  void initState() {
    super.initState();
    fetchPost();
  }

  void fetchPost() async {
    var v = AapoortiConstants.webServiceUrl + 'Auction/AucLive?PAGECOUNTER=1';
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
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.cyan[400],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Text('Live Auctions(Sale)',
                        style: TextStyle(color: Colors.white))),
                // new Padding(padding: new EdgeInsets.only(right: 80.0)),
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
            child: jsonResult == null ? SpinKitFadingCircle(color: Colors.cyan, size: 120.0) : _myListView(context)),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    if(jsonResult!.isEmpty) {
      AapoortiUtilities.showInSnackBar(context, "No Live Tender");
      return SizedBox(); // Return an empty widget or a placeholder here
    }
    return ListView.separated(
      itemCount: jsonResult!.length,
      itemBuilder: (context, index) {
        final item = jsonResult![index];
        return GestureDetector(
          child: Card(
            elevation: 4,
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(width: 1, color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 6)),
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 8)),
                    Text(
                      '${index + 1}. ',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 8)),
                          Text((item['ACCNAME'] != null && item['DEPTNM'] != null) ? '${item['ACCNAME']} / ${item['DEPTNM']}' : "", style: TextStyle(color: Colors.indigo, fontSize: 15)),
                          Padding(padding: EdgeInsets.only(top: 10.0)),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Text(
                                  "Catalogue No:",
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                  item['CATNO'] ?? "",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Text(
                                  "Auction Start:",
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                  item['AUCSTRTDT'] ?? "",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Text(
                                  "Auction End:",
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                  item['AUCENDDT'] ?? "",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 6)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            if (item['DESCRIPTION'] != 'NA') {
              showDialog(
                context: context,
                builder: (_) => Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 200),
                      padding: EdgeInsets.all(30),
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'List of Categories',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Expanded(
                            child: livelistListView(
                              context,
                              item['DESCRIPTION'].toString(),
                              item['CATID'].toString(),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'CLICK ON ANY CATEGORY',
                              style: TextStyle(fontSize: 12, color: Colors.indigo),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).pop('dialog');
                              },
                              child: Image.asset(
                                'assets/close_overlay.png',
                                color: Colors.black,
                                height: 50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10);
      },
    );
  }


  Widget livelistListView(
      BuildContext context, String liveString, String catid) {
    var liveArray = liveString.split('#');
    var livecatid = catid;

    return ListView.separated(
        itemCount: liveString.isNotEmpty || liveString.length>0 ? liveArray.length : 0,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.all(0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            debugPrint("live url===" + liveArray[index]);
                            var route = MaterialPageRoute(
                              builder: (BuildContext context) => live2(
                                  value: User(
                                catid: livecatid,
                                category: liveArray[index],
                              )),
                            );
                            Navigator.of(context).push(route);
                            debugPrint("catid===" + livecatid);
                            debugPrint("category===" + liveArray[index]);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                liveArray[index],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ],
                          ))),
                ],
              ));
        },
        separatorBuilder: (context, index) {
          return Divider(height: 25, color: Colors.grey);
        });
  }
}
