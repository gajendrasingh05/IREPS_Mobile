import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/providers/SumaryStockProvider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
//import 'package:share/share.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'item_details.dart';
import 'package:flutter_app/udm/widgets/search_app_bar.dart';

class SummaryDetails extends StatefulWidget {
  String? railway,
      userdepot,
      userSubDepot,
      unitType,
      unitName,
      department,
      itemUsage,
      itemType,
      itemCat,
      sNs;
  SummaryDetails(
      this.railway,
      this.userdepot,
      this.userSubDepot,
      this.unitType,
      this.unitName,
      this.department,
      this.itemUsage,
      this.itemType,
      this.itemCat,
      this.sNs);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SummaryDetails>
    with AutomaticKeepAliveClientMixin<SummaryDetails> {
  //List<Post>? users = [];
  //var totalStkValue = 0.0;


  @override
  void initState() {
    super.initState();
    Provider.of<SummaryStockProvider>(context, listen: false).createPost(widget.railway, widget.userdepot, widget.userSubDepot, widget.unitType,
        widget.unitName, widget.department, widget.itemUsage, widget.itemType, widget.itemCat, widget.sNs, context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SearchAppbar(
        title: language.text('userDepotStockSummary'),
        labelData: 'UserDepotOfStock',
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.red[300],
      //   leading: IconButton(
      //     splashRadius: 30,
      //     icon: Icon(
      //       Icons.arrow_back,
      //       color: Colors.white,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   title: Text(language.text('userDepotStockSummary')),
      // ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Consumer<SummaryStockProvider>(builder: (context, value, child){
            if(value.summaryactionstate == SummaryActionStockState.Busy){
              return SingleChildScrollView(
                child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(5),
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: SizedBox(height: size.height * 0.45),
                          );
                        })),
              );
            }
            else if(value.summaryactionstate == SummaryActionStockState.FinishedWithError){
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      child: Lottie.asset('assets/json/no_data.json'),
                    ),
                    AnimatedTextKit(
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          TyperAnimatedText(
                              language.text('dnf'),
                              speed: Duration(milliseconds: 150),
                              textStyle: TextStyle(fontWeight: FontWeight.bold)),
                        ])
                  ],
                ),
              );
            }
            else{
               return Column(
                 children: [
                   Expanded(
                     child: listViewWidget(value.summaryactionitem)
                   ),
                   Align(
                       alignment: Alignment.bottomCenter,
                       child: Container(
                         alignment: Alignment.center,
                         height: 50,
                         width: MediaQuery.of(context).size.width,
                         padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(
                           gradient: LinearGradient(
                               begin: Alignment.topLeft,
                               end: Alignment.bottomRight,
                               stops: [
                                 0.4,
                                 1
                               ],
                               colors: [
                                 Colors.red[300]!,
                                 Colors.orange[400]!,
                               ]),
                         ),
                         child: Text(
                           '${language.text('totalVal')} : ' +
                               (value.totalStkValue.round()).toString(),
                           style: TextStyle(
                               color: Colors.white,
                               fontWeight: FontWeight.bold,
                               fontSize: 18),
                         ),
                       )),
                 ],
               );
            }
        }),
      ),
    );
  }

  Widget listViewWidget(List<Post> article) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        physics: ScrollPhysics(),
        itemCount: article.length,
        itemBuilder: (context, position) {
          return Container(
              padding: EdgeInsets.only(left: 6, top: 9, right: 6, bottom: 9),
              //padding: EdgeInsets.all(4),
              child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 10, left: 8),
                          child: Text(
                            (position + 1).toString() + '.',
                            softWrap: false,
                            style: TextStyle(
                                fontSize: 14, color: Colors.indigo[800]
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                                padding: EdgeInsets.only(
                                    left: 5, top: 5, right: 11, bottom: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              language.text('railway'),
                                              softWrap: false,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.indigo[800]
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 4,
                                              child: Text(
                                                article[position].rlyName,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                ),
                                                // overflow: TextOverflow.ellipsis,
                                              )),
                                        ]),
                                    SizedBox(height: 10),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            language.text('unitType'),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.indigo[800]
                                              //fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            article[position].unitType,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            language.text('unit'),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.indigo[800]
                                              //fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            article[position].unitName,
                                            style: new TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            language.text('department'),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.indigo[800],
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              article[position].departName,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ))
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 3,
                                            child: Text(
                                              language.text('userDepot'),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrangeAccent,
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              article[position].issueCode +
                                                  "-" +
                                                  article[position].depoDetail,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrangeAccent,
                                              ),
                                            )),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 3,
                                            child: Text(
                                              '${language.text('stock')} ${language.text('valueRs')}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrangeAccent,
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              double.parse(article[position]
                                                  .stkValue)
                                                  .toInt()
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.deepOrangeAccent,
                                              ),
                                            )),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  backgroundColor: Colors.red.shade300
                                                ),
                                                onPressed: () => _onShareData(
                                                    "Railway : " +
                                                        article[position]
                                                            .rlyName +
                                                        "\nUnit type : " +
                                                        article[position]
                                                            .unitType +
                                                        "\nUnit : " +
                                                        article[position]
                                                            .unitName +
                                                        "\nDepartment : " +
                                                        article[position]
                                                            .departName +
                                                        "\nUser Depot : " +
                                                        article[position]
                                                            .issueCode +
                                                        "-" +
                                                        article[position]
                                                            .depoDetail +
                                                        "\nStock Value (Rs.) :" +
                                                        article[position]
                                                            .stkValue
                                                            .toString() +
                                                        "\n",
                                                    context),

                                                child: Icon(
                                                  Icons.share,
                                                  color: Colors.white,
                                                )),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(), backgroundColor: Colors.red.shade300
                                                ),
                                                onPressed: () {
                                                  Future.delayed(Duration.zero,
                                                          () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ItemDetails(
                                                                      article[position]
                                                                          .orgZone,
                                                                      article[position]
                                                                          .issueCode,
                                                                      '00')),
                                                        );
                                                      });
                                                },
                                                child: Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                )),
                                          ],
                                        )),
                                  ],
                                )))
                      ])));
        });
  }

  @override
  bool get wantKeepAlive => true;

  // Future<List<Post>?> createPost() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   try {
  //     var response=await Network().postDataWithAPIM('UDM/summarystock/StockSummaryResult/V1.0.0/StockSummaryResult','StockSummaryResult',
  //         widget.railway! +
  //             "~" +
  //             widget.userdepot! +
  //             "~" +
  //             widget.userSubDepot! +
  //             "~" +
  //             widget.unitType!
  //             +
  //             "~" +
  //             widget.unitName! +
  //             "~" +
  //             widget.department! +
  //             "~" +
  //             widget.itemUsage! +
  //             "~" +
  //             widget.itemType! +
  //             "~" +
  //             widget.itemCat! +
  //             "~" +
  //             widget.sNs!,prefs.getString('token'));
  //
  //     print(jsonEncode({
  //       'input_type': 'StockSummaryResult',
  //       'input': widget.railway! +
  //           "~" +
  //           widget.userdepot! +
  //           "~" +
  //           widget.userSubDepot! +
  //           "~" +
  //           widget.unitType! +
  //           "~" +
  //           widget.unitName! +
  //           "~" +
  //           widget.department! +
  //           "~" +
  //           widget.itemUsage! +
  //           "~" +
  //           widget.itemType! +
  //           "~" +
  //           widget.itemCat! +
  //           "~" +
  //           widget.sNs!
  //     }));
  //     var actionData = json.decode(response.body);
  //     if (actionData['status'] != 'OK') {
  //       IRUDMConstants().showSnack("No Data Found", context);
  //     } else {
  //       if (response.statusCode == 200) {
  //         var data = actionData['data'];
  //         users = data.map<Post>((json) => Post.fromJson(json)).toList();
  //         var stkValue = 0.0;
  //         for (int i = 0; i < users!.length; i++) {
  //           stkValue = stkValue + double.parse(users![i].stkValue);
  //           assert(stkValue is double);
  //         }
  //         setState(() {
  //           totalStkValue = stkValue;
  //         });
  //         print(stkValue);
  //         return users;
  //       } else {
  //         print(response.body);
  //         throw Exception('Failed to load post');
  //       }
  //     }
  //   } on HttpException {
  //     IRUDMConstants().showSnack(
  //         "Something Unexpected happened! Please try again.", context);
  //   } on SocketException {
  //     IRUDMConstants()
  //         .showSnack("No connectivity. Please check your connection.", context);
  //   } on FormatException {
  //     IRUDMConstants().showSnack(
  //         "Something Unexpected happened! Please try again.", context);
  //   } catch (err) {
  //     IRUDMConstants().showSnack(err.toString(), context);
  //     //  IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
  //   }
  // }

  _onShareData(String data, BuildContext context) async {
    await Share.share(data + "");
  }
}



class Post {
  var issueCode;
  var rlyName;
  var depoDetail;
  var unitType;
  var departName;
  var irepsUnitType;
  var orgZone;
  var admitUnit;
  var immsDept;
  var stkValue;
  var unitName;
  Post(
      {this.issueCode,
        this.unitName,
        this.rlyName,
        this.depoDetail,
        this.unitType,
        this.admitUnit,
        this.departName,
        this.immsDept,
        this.irepsUnitType,
        this.orgZone,
        this.stkValue});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        issueCode: json['issueccode'],
        rlyName: json['rlyname'],
        depoDetail: json['depodetail'],
        unitType: json['unittype'],
        departName: json['departmentname'],
        irepsUnitType: json['irepsunittype'],
        orgZone: json['orgzone'],
        admitUnit: json['adminunit'],
        immsDept: json['immsdept'],
        stkValue: json['stkvalue'].toString(),
        unitName: json['unitname']
    );
  }
}
