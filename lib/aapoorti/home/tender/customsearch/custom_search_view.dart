import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/models/CustomSearchData.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'custom_search_filter.dart';
import 'package:dio/dio.dart';

class Custom_search_view extends StatefulWidget {
  final String? workarea,
      SearchForstring,
      RailZoneIn,
      Dt1In,
      Dt2In,
      searchOption,
      OrgCode,
      ClDate,
      dept,
      unit;

  Custom_search_view(
      {this.workarea,
      this.SearchForstring,
      this.RailZoneIn,
      this.Dt1In,
      this.Dt2In,
      this.searchOption,
      this.OrgCode,
      this.ClDate,
      this.dept,
      this.unit});
  @override
  _CustomSearchViewState createState() => _CustomSearchViewState(
      this.workarea!,
      this.SearchForstring!,
      this.RailZoneIn!,
      this.Dt1In!,
      this.Dt2In!,
      this.searchOption!,
      this.OrgCode!,
      this.ClDate!,
      this.dept!,
      this.unit!);
}

class _CustomSearchViewState extends State<Custom_search_view> implements Exception {
  bool vis = false;
  int i = -1;
  List<dynamic>? jsonResult;
  List<dynamic>? jsonResultUp;
  List<dynamic>? jsonResultLiv;
  int? resultCount;
  final dbHelper = DatabaseHelper.instance;
  var rowCount = -1;
  int count = 0;
  List data = [];
  static bool sfilter = false, keyboardOpen = false;
  String? workarea, SearchForstring, RailZoneIn,
      Dt1In,
      Dt2In,
      searchOption,
      OrgCode,
      ClDate,
      dept,
      unit;

  List<CustomSearchData> customSearchData = [];

  _CustomSearchViewState(
      String workare,
      String SearchForString,
      String RailZoneIn,
      String Dt1In,
      String Dt2In,
      String searchOption,
      String OrgCode,
      String ClDate,
      String dept,
      String unit) {
    this.workarea = workare;
    this.SearchForstring = SearchForString; //"supply";
    this.RailZoneIn = RailZoneIn; //"561";
    this.Dt1In = Dt1In; //"12/Aug/2019";
    this.Dt2In = Dt2In; //"10/Sep/2019";
    this.searchOption = searchOption; //"2";
    this.OrgCode = OrgCode; //"01";
    this.ClDate = ClDate; // "0";
    this.dept = dept; // "-1";
    this.unit = unit; //"-1";*/

    debugPrint("workarea " + this.workarea!);
    debugPrint("SearchForString " + this.SearchForstring!);
    debugPrint("RailZoneIn " + this.RailZoneIn!);
    debugPrint("Dt1In " + this.Dt1In!);
    debugPrint("Dt2In " + this.Dt2In!);
    debugPrint("searchOption " + this.searchOption!);
    debugPrint("OrgCode " + this.OrgCode!);
    debugPrint("ClDate " + this.ClDate!);
    debugPrint("dept " + this.dept!);
    debugPrint("unit " + this.unit!);
  }

  void initState() {
    super.initState();
    fetchPost();
  }

  void fetchPost() async {
    try {
      if(workarea == '#') {
        rowCount = (await dbHelper.rowCountCustomSearch())!;
        if(rowCount > 0) {
          debugPrint('Fetching from local DB');
          jsonResult = await dbHelper.getcustomsearchFilterData(SearchForstring!, RailZoneIn!, Dt1In!);
          debugPrint(jsonResult.toString());
          rowCount = jsonResult!.length;
          setState(() {
            data = jsonResult!;
          });
        }
      }
      else {
        try{
          var v = AapoortiConstants.webServiceUrl+'Tender/CustomSearch?WorkArea=${this.workarea}&SearchForString=${this.SearchForstring}&RailZoneIn=${this.RailZoneIn}&Dt1In=${this.Dt1In}&Dt2In=${this.Dt2In}&searchOption=${this.searchOption}&OrgCode=${this.OrgCode}&ClDate=${this.ClDate}&dept=${this.dept}&unit=${this.unit}';
          debugPrint("my url==>$v");
          final response = await http.post(Uri.parse(v));
          debugPrint("here is response now ${json.decode(response.body)} ");
          if(response.statusCode == 200) {
            jsonResult = json.decode(response.body);

            final rowsDeleted = await dbHelper.deleteCustomSearch(rowCount);
            debugPrint('json Result ${jsonResult.toString()}');
            debugPrint('deleted $rowsDeleted row(s): row $rowCount');

            debugPrint("delete count : data deleted, new data inserted ");
            rowCount = jsonResult!.length;
            if(rowCount == 0) keyboardOpen = true;
            else keyboardOpen = false;
            for(int index = 0; index < jsonResult!.length; index++) {
              Map<String, dynamic> row = {
                DatabaseHelper.COLUMN_SrNo: index.toString(),
                DatabaseHelper.COLUMN_DeptRly: jsonResult![index]['ACC_NAME'],
                DatabaseHelper.COLUMN_WorkArea: jsonResult![index]['WORK_ARA'],
                DatabaseHelper.COLUMN_TenderTitle: jsonResult![index]['TENDER_DESCRIPTION'],
                DatabaseHelper.COLUMN_TenderOPDate: jsonResult![index]['TENDER_OPDATE'],
                DatabaseHelper.COLUMN_oid: jsonResult![index]['OID'],
                DatabaseHelper.COLUMN_TenderNo: jsonResult![index]['TENDER_NUMBER'],
                DatabaseHelper.COLUMN_pdf: jsonResult![index]['PDFURL'],
                DatabaseHelper.COLUMN_Attachdocs: jsonResult![index]['ATTACH_DOCS'],
                DatabaseHelper.COLUMN_Cor: jsonResult![index]['CORRI_DETAILS'],
                DatabaseHelper.COLUMN_TenderStatus: jsonResult![index]['TENDER_STATUS'],
                DatabaseHelper.COLUMN_Type: jsonResult![index]['TENDER_TYPE'],
                DatabaseHelper.COLUMN_BiddingSystem: jsonResult![index]['BIDDING_SYSTEM'],
              };
              final id = dbHelper.insertCustomSearch(row);
              print('inserted row id: ' + index.toString());
            }
            setState(() {
              data = jsonResult!;
            });
          }
          else{
            setState(() {
              jsonResult = [];
            });
          }
        }
        catch(e){
          AapoortiUtilities.showInSnackBar(context, e.toString());
        }

      }
    } catch (e) {
      if(e is SocketException) {
        AapoortiUtilities.showInSnackBar(context, "Check your internet connection!!");
      } else {
        AapoortiUtilities.showInSnackBar(context, "Something Unexpected happened! Please try again.");
      }
    }
  }

  Future<List<CustomSearchData>> getData(String url) async{
    final response = await http.post(Uri.parse(url));
    var data = json.decode(response.body);
    if(data != null) {
      customSearchData = data.map<CustomSearchData>((val) => CustomSearchData.fromJson(val)).toList();
      //crcsummarylinkData.sort((a, b) => a.posr!.compareTo(b.posr!));
      return customSearchData;
    } else {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      return customSearchData;
    }
  }

  var _snackKey = GlobalKey<ScaffoldState>();

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(true);
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.cyan[400],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(child: Text('Custom Search',style: TextStyle(color: Colors.white))),
                  IconButton(
                      icon: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/common_screen", (route) => false);
                      })
                ],
              )),
          body: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    "    List of e-Tender as per " + ((this.ClDate == "0") ? "Closing Dates ( " : " Uploading Dates ( ") + (rowCount != -1 ? rowCount.toString() : "0") + " ) ",
                    style: TextStyle(
                        color: Colors.indigo,
                        backgroundColor: Colors.cyan[50],
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(child: jsonResult == null ? SpinKitFadingCircle(color: Colors.cyan, size: 120.0) : jsonResult.toString().isEmpty ? Center(child: Text("Data not found")) : _myListView(context),
                ),
              ],
            ),
          ),
          floatingActionButton: keyboardOpen ? SizedBox() : FloatingActionButton(
                  onPressed: () {
                    sfilter = true;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Custom_search_filter()));
                  },
                  tooltip: 'Custom Search Filter',
                  elevation: 12,
                  child: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  ),
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    //Dismiss spinner
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return jsonResult!.isEmpty ? Center(child: Text(' No Response Found ', style: TextStyle(color: Colors.indigo, fontSize: 15, fontWeight: FontWeight.w600))) : ListView.separated(
            itemCount: jsonResult == null ? 0 : jsonResult!.length,
            itemBuilder: (context, index) {
              return Container(padding: EdgeInsets.all(10), child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          (index + 1).toString() + ". ",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    data[index]['ACC_NAME'] != null
                                        ? data[index]['ACC_NAME']
                                        : "",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ))
                                ]),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                ),
                                Row(children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "Date",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    child: Text(
                                      jsonResult![index]['TENDER_OPDATE'] != null
                                          ? jsonResult![index]['TENDER_OPDATE']
                                          : "",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  )
                                ]),
                                Row(children: <Widget>[
                                  Container(
                                    // height: 35,
                                    width: 125,
                                    child: Text(
                                      "Tender No.",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Expanded(child: Container(
                                    child: Text(
                                      jsonResult![index]['TENDER_NUMBER'] != null
                                          ? jsonResult![index]['TENDER_NUMBER']
                                          : "",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ))
                                ]),
                                Row(children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "Work Area",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    child: Text(
                                      jsonResult![index]['WORK_ARA'] != null
                                          ? jsonResult![index]['WORK_ARA']
                                          : "",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  )
                                ]),
                                SizedBox(height: 3),
                                Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Container(
                                        width: 125,
                                        child: Text(
                                          "Title",
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          // height: 30,
                                          child: Text(
                                            jsonResult![index][
                                                        'TENDER_DESCRIPTION'] !=
                                                    null
                                                ? jsonResult![index]
                                                    ['TENDER_DESCRIPTION']
                                                : "",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ]),
                                Row(children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "Tender Status",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    child: Text(
                                      jsonResult![index]['TENDER_STATUS'] != null
                                          ? jsonResult![index]['TENDER_STATUS']
                                          : "",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  )
                                ]),
                                Row(children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "Links",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          GestureDetector(
                                              onTap: () {

                                                if (jsonResult![index]
                                                        ['PDFURL'] !=
                                                    'NA') {
                                                  var fileUrl =
                                                      jsonResult![index]
                                                              ['PDFURL']
                                                          .toString();
                                                  var fileName =
                                                      fileUrl.substring(fileUrl
                                                          .lastIndexOf("/"));
                                                  AapoortiUtilities.ackAlert(
                                                      context,
                                                      fileUrl,
                                                      fileName);
                                                } else {
                                                  AapoortiUtilities.showInSnackBar(
                                                      context,
                                                      "No PDF attached with this Tender!!");
                                                }
                                              },
                                              child: Column(children: <Widget>[
                                                Container(
                                                  child: Image(
                                                      image: AssetImage(
                                                          'images/pdf_home.png'),
                                                      height: 30,
                                                      width: 20),
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(0.0)), Container(
                                                  child: Text('  NIT',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 9),
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                              ])),
                                          GestureDetector(
                                              onTap: () {
                                                if (jsonResult![index]
                                                        ['ATTACH_DOCS'] !=
                                                    'NA') {
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) => Material(
                                                          type: MaterialType
                                                              .transparency,
                                                          child: Center(
                                                              child: Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              55),
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              50),
                                                                  color: Color(
                                                                      0xAB000000),

                                                                  // Aligns the container to center
                                                                  child: Column(
                                                                      children: <
                                                                          Widget>[
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: 20),
                                                                            child:
                                                                                AapoortiUtilities.attachDocsListView(context, jsonResult![index]['ATTACH_DOCS'].toString()),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.bottomCenter,
                                                                          child: GestureDetector(
                                                                              onTap: () {
                                                                                Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                              },
                                                                              child: Image(
                                                                                image: AssetImage('images/close_overlay.png'),
                                                                                height: 50,
                                                                              )),
                                                                        )
                                                                      ])))));
                                                } else {
                                                  AapoortiUtilities.showInSnackBar(
                                                      context,
                                                      "No Documents attached with this Tender!!");
                                                }
                                              },
                                              child: Column(children: <Widget>[
                                                Container(
                                                  height: 30,
                                                  child: Image(
                                                      image: AssetImage(
                                                          'images/attach_icon.png'),
                                                      color: jsonResult![index][
                                                                  'ATTACH_DOCS'] !=
                                                              'NA'
                                                          ? Colors.green
                                                          : Colors.brown,
                                                      height: 30,
                                                      width: 20),
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(0.0)),
                                                Container(
                                                  child: Text('  DOCS',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 9),
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                              ])),
                                          GestureDetector(
//
                                              onTap: () {
                                                if (jsonResult![index]
                                                        ['CORRI_DETAILS'] !=
                                                    'NA') {
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) => Material(
                                                            type: MaterialType
                                                                .transparency,
                                                            child: Center(
                                                                child: Container(
                                                                    margin: EdgeInsets.only(top: 55),
                                                                    padding: EdgeInsets.only(bottom: 50),
                                                                    color: Color(0xAB000000),

                                                                    // Aligns the container to center
                                                                    child: Column(children: <Widget>[
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.only(bottom: 20),
                                                                          child: AapoortiUtilities.corrigendumListView(
                                                                              context,
                                                                              jsonResult![index]['CORRI_DETAILS'].toString()),
                                                                        ),
                                                                      ),
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.bottomCenter,
                                                                        child: GestureDetector(
                                                                            onTap: () {
                                                                              Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                            },
                                                                            child: Image(
                                                                              image: AssetImage('images/close_overlay.png'),
                                                                              height: 50,
                                                                            )),
                                                                      )
                                                                    ]))),
                                                          ));
                                                } else {
                                                  AapoortiUtilities.showInSnackBar(context, "No corrigendum issued with this Tender!!");
                                                }
                                              },
                                              child: Column(children: <Widget>[
                                                Container(
                                                  height: 30,
                                                  child: Text(
                                                    "C",
                                                    style: TextStyle(
                                                        color: jsonResult![index]
                                                                    [
                                                                    'CORRI_DETAILS'] !=
                                                                'NA'
                                                            ? Colors.green
                                                            : Colors.brown,
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                new Padding(
                                                    padding:
                                                        EdgeInsets.all(0.0)),
                                                new Container(
                                                  child: new Text(
                                                      '  CORRIGENDA',
                                                      style: new TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 9),
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                              ])),
                                              Padding(padding: EdgeInsets.only(right: 0)),
                                        ]),
                                    flex: 2,
                                  ),
                                ]),
                              ]),
                        ),
                      ]));
            },
            separatorBuilder: (context, index) {
              return Container(
                height: 1.5,
                color: Colors.cyan[400],
              );
            });
  }
}
