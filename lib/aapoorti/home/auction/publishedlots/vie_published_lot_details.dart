import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/home/auction/publishedlots/view_published_lot_fiters.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

List<dynamic>? jsonResult;

class PublishedLotDetails extends StatefulWidget {
  final int? id;
  PublishedLotDetails({this.id});

  @override
  PublishedLotDetailsState createState() => PublishedLotDetailsState(this.id!);
}

class PublishedLotDetailsState extends State<PublishedLotDetails> {
  List<dynamic>? jsonResult;
  int? railid;
  bool? keyBoard = true;
  //PublishedLotDetailsState(int id);

  PublishedLotDetailsState(int id) {
    this.railid = id;
  }
  void initState() {
    super.initState();
    this.fetchPost();
  }

  List data = [];
  Future<void> fetchPost() async {
    var v = AapoortiConstants.webServiceUrl +
        '/getData?input=AUCTION_PRELOGIN,VIEW_LOT_DETAILS,${this.railid}';
    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);

    if (jsonResult!.length > 0)
      keyBoard = false;
    else
      keyBoard = true;

    setState(() {
      data = jsonResult!;
    });
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
                    child: Text('Published Lots(Sale)',
                        style: TextStyle(color: Colors.white))),

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
    //Dismiss spinner
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);

    return ListView.separated(
        itemCount: jsonResult != null ? jsonResult!.length : 0,
        itemBuilder: (context, index) {
          return Container(
            //padding: EdgeInsets.all(10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              /* Text(
                    (index + 1).toString() + ". ",

                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 16
                    ),
                  ),*/

              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    //  new Divider(color: Colors.blueAccent,height: 3,),
                    Row(children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.cyan[700],
                        child: Text(
                          "Lot Details ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
                    new Padding(padding: new EdgeInsets.all(5.0)),
                    // new Divider(color: Colors.blueAccent,height: 3,),

                    Row(children: <Widget>[
                      new Padding(padding: new EdgeInsets.only(left: 8.0)),
                      Container(
                        width: 125,
                        child: Text(
                          "Lot No",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['LOT_NO'] != null
                              ? (jsonResult![index]['LOT_NO']).toString()
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 40,
                        width: 125,
                        child: Text(
                          "Railway Unit/Depot",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          jsonResult![index]['RLY_UNIT_DEPOT'] != null
                              ? jsonResult![index]['RLY_UNIT_DEPOT']
                              : "",
                          maxLines: 4,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),

                    Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "Category/Part",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 30,
                          child: Text(
                            jsonResult![index]['CATEGORY_NAME'] != null
                                ? jsonResult![index]['CATEGORY_NAME']
                                : "",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),

                    Row(children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "PL No.",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['PL_NO'] != null
                              ? (jsonResult![index]['PL_NO']).toString()
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),

                    Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 8.0)),
                      Container(
                        // height: 30,
                        width: 125,
                        child: Text(
                          "Approx. Lot Qty",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        // height: 30,
                        child: Text(
                          jsonResult![index]['LOT_QTY'] != null
                              ? (jsonResult![index]['LOT_QTY']).toString()
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ]),
                    new Padding(padding: new EdgeInsets.all(5.0)),
                    new Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),

                    Row(children: <Widget>[
                      new Padding(padding: new EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "Sale Unit",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['SALE_UNIT_NAME'] != null
                              ? jsonResult![index]['SALE_UNIT_NAME']
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Row(children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "Location",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ]),

                    Row(children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 8.0)),
                      Expanded(
                          child: Container(
                        height: 40,
                        child: Text(
                          jsonResult![index]['LOCATION'] != null
                              ? jsonResult![index]['LOCATION']
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ))
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),

                    Row(children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "State",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['STATE'] != null
                              ? jsonResult![index]['STATE']
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Row(children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "Custodian",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          jsonResult![index]['CUSTODIAN'] != null
                              ? jsonResult![index]['CUSTODIAN']
                              : "",
                          maxLines: 4,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                     Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Row(children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "HSN Code",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['HSN_CODE'] != null
                              ? (jsonResult![index]['HSN_CODE']).toString()
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Row(children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "Tax",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['SALES_TAX'] != null
                              ? (jsonResult![index]['SALES_TAX']).toString() +
                                  "%"
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Row(children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "Tax Type",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['ST_TYPE'] != null
                              ? jsonResult![index]['ST_TYPE']
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Row(children: <Widget>[
                      new Padding(padding: new EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 40,
                        width: 125,
                        child: Text(
                          "Whether GST on reverse"
                          "\n charge basis",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['REVERSE_CHARGE'] != null
                              ? jsonResult![index]['REVERSE_CHARGE']
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Row(children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 40,
                        width: 125,
                        child: Text(
                          "CPCB Certificate"
                          "\n required",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['CPCB_REQD'] != null
                              ? jsonResult![index]['CPCB_REQD']
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ]),
                    new Padding(padding: new EdgeInsets.all(5.0)),
                    new Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Row(children: <Widget>[
                      new Padding(padding: new EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 40,
                        width: 125,
                        child: Text(
                          "Book/PD Rate(Rs.)",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['BOOK_RATE'] != null
                              ? (jsonResult![index]['BOOK_RATE']).toString()
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Row(children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "Line Items",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['LINE_ITEMS'] != null
                              ? jsonResult![index]['LINE_ITEMS']
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ]),
                    new Padding(padding: new EdgeInsets.all(5.0)),
                    new Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Row(children: <Widget>[
                      new Padding(padding: new EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 30,
                        child: Text(
                          "Lot weight in MT",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['LOT_QTY_MT'] != null
                              ? (jsonResult![index]['LOT_QTY_MT']).toString()
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                     Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Row(children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 40,
                        width: 125,
                        child: Text(
                          "Qty in wheeler/4 wheeler"
                          "\n units",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['RS_QTY'] != null
                              ? (jsonResult![index]['RS_QTY']).toString() + "No."
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Row(children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "Store Account",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['STORE_ACCOUNT'] != null
                              ? jsonResult![index]['STORE_ACCOUNT']
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ]),
                    new Padding(padding: new EdgeInsets.all(5.0)),
                    new Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Row(children: <Widget>[
                      new Padding(padding: new EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "Allocation",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['ALLOCATION'] != null
                              ? (jsonResult![index]['ALLOCATION']).toString()
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Row(children: <Widget>[
                      new Padding(padding: new EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 40,
                        width: 125,
                        child: Text(
                          "Material Description",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ]),

                    Row(children: <Widget>[
                      new Padding(padding: new EdgeInsets.only(left: 8.0)),
                      Expanded(
                          child: Container(
                        height: 40,
                        child: Text(
                          jsonResult![index]['LOT_MATERIAL_DESC'] != null
                              ? jsonResult![index]['LOT_MATERIAL_DESC']
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ))
                    ]),
                    new Padding(padding: new EdgeInsets.all(5.0)),
                    new Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Row(children: <Widget>[
                      new Padding(padding: new EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 40,
                        width: 125,
                        child: Text(
                          "Special Condition",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ]),

                    Row(children: <Widget>[
                      new Padding(padding: new EdgeInsets.only(left: 8.0)),
                      Expanded(
                          child: Container(
                        height: 40,
                        child: Text(
                          jsonResult![index]['SPECIAL_CONDITIONS'] != null
                              ? jsonResult![index]['SPECIAL_CONDITIONS']
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ))
                    ]),
                    new Padding(padding: new EdgeInsets.all(5.0)),
                    new Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),

                    Row(children: <Widget>[
                      new Padding(padding: new EdgeInsets.only(left: 8.0)),
                      Container(
                        // height: 30,
                        width: 125,
                        child: Text(
                          "Excluded Items",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Container(
                        // height: 30,
                        child: Text(
                          jsonResult![index]['EXCLUDED_ITEMS'] != null
                              ? jsonResult![index]['EXCLUDED_ITEMS']
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ]),
                    new Padding(padding: new EdgeInsets.all(5.0)),
                    new Divider(
                      color: Colors.grey[800],
                      height: 6,
                    ),
                    Row(children: <Widget>[
                      new Padding(padding: new EdgeInsets.only(left: 8.0)),
                      Container(
                        height: 40,
                        width: 125,
                        child: Text(
                          "Note:",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ]),

                    Row(children: <Widget>[
                      new Padding(padding: new EdgeInsets.only(left: 8.0)),
                      Expanded(
                          child: Container(
                        child: Text(
                          "You are advised to check all the lot details carefully and ensure that all the deatils (especially GST Rtae, State ofLot, and HSN Code) are correct. LOt Details Can not bechanged after Auction Sale",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ))
                    ]),
                  ]))
            ]),
            /*onTap: (){

              lotid=jsonResult[index]['LOT_ID'];
              print(lotid);
              Navigator.push(context,MaterialPageRoute(builder: (context) => PublishedLotDetails(id:lotid)));

            },*/
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        });
  }
}
