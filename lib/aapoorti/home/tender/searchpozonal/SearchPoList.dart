import 'dart:io';
import 'dart:convert';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/aapoorti/home/tender/searchpozonal/searchpozonal.dart';
import 'SearchPoZonalDetails.dart';

class SearchPoList extends StatefulWidget {
  final String? supName;
  final String? plNo;
  final String? railUnit;
  final String? pv1;
  final String? pv2;
  final String? valuefrom;
  final String? valueto;
  @override
  _SearchPoListState createState() => _SearchPoListState(
      this.supName!,
      this.plNo!,
      this.railUnit!,
      this.pv1!,
      this.pv2!,
      this.valuefrom!,
      this.valueto!);
  SearchPoList(
      {this.supName,
      this.plNo,
      this.railUnit,
      this.pv1,
      this.pv2,
      this.valuefrom,
      this.valueto});
}

class _SearchPoListState extends State<SearchPoList> {
  List<dynamic>? jsonResult;
  String? supName;
  String? plNo;
  String? railUnit;
  String? pv1;
  String? pv2;
  String? valuefrom;
  String? valueto;
  int? pokey;

  _SearchPoListState(String supName, String plNo, String railUnit, String pv1,
      String pv2, String valuefrom, String valueto) {
    this.supName = supName;
    this.plNo = plNo;
    this.railUnit = railUnit;
    this.pv1 = pv1;
    this.pv2 = pv2;
    this.valuefrom = valuefrom;
    this.valueto = valueto;
  }

  void initState() {
    super.initState();
    fetchPost();
  }

  List data = [];
  void fetchPost() async {
    var v = AapoortiConstants.webServiceUrl + 'Tender/SearchPO?mmiszone=${this.railUnit}&dateFrom=${this.valuefrom}&dateTo=${this.valueto}&firmAcctId=${this.supName}&pl1=${this.plNo}&val1=${this.pv1}&val2=${this.pv2}&PageNo=1';
    //https://ireps.gov.in/Aapoorti/ServiceCallTender/SearchPO?mmiszone=561&dateFrom=8/Sep/2019&dateTo=12/Sep/2019&firmAcctId=&pl1=&val1=0&val2=1&PageNo=1
    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);
    setState(() {
      data = jsonResult!;
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
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.cyan[400],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Purchase Order Search',
                  style: TextStyle(color: Colors.white, fontSize: 20.0)),
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/common_screen", (route) => false);
                },
              ),
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: 400,
                height: 30,
                color: Colors.cyan.shade600,
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '  List of Purchase Orders',
                  style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.cyan.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: jsonResult == null ? SpinKitFadingCircle(color: Colors.cyan, size: 120.0) : _searchPoZonalList(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchPoZonalList(BuildContext context) {
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return jsonResult!.isEmpty
        ? Center(
            child: Text(
            ' No Response Found ',
            style: TextStyle(
                color: Colors.indigo,
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ))
        : ListView.separated(
            itemCount: jsonResult == null ? 0 : jsonResult!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  child: Card(
                    surfaceTintColor: Colors.white,
                    color: Colors.white,
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                (index + 1).toString() + ". ",
                                style: TextStyle(
                                    color: Colors.indigo, fontSize: 16),
                              ),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                    Row(children: <Widget>[
                                      Expanded(
                                          child: Text(
                                        data[index]['ADDR'] != null
                                            ? "M/s." + data[index]['ADDR']
                                            : "",
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ))
                                    ]),
                                    Padding(padding: EdgeInsets.all(5)),
                                    Row(children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "Item Desc",
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 16),
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: Text(
                                          jsonResult![index]['DES'] != null
                                              ? jsonResult![index]['DES']
                                              : "",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        flex: 8,
                                      )
                                    ])
                                  ]))
                            ])),
                  ),
                  onTap: () {
                    pokey = jsonResult![index]['POKEY'];
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SearchPoZonalDetails(pokey: pokey!)));
                  });
            },
            separatorBuilder: (context, index) {
              return Container(
                height: 2.0,
                color: Colors.white,
              );
            });
  }
}
