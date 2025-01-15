import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
//import 'package:share/share.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/api.dart';


class POSearchIssueDetails extends StatefulWidget {
  String? ponumber, posr, rLY;
  POSearchIssueDetails(this.ponumber, this.posr, this.rLY);

  @override
  State<POSearchIssueDetails> createState() => _POSearchIssueDetailsState();
}

class _POSearchIssueDetailsState extends State<POSearchIssueDetails> with SingleTickerProviderStateMixin{
  List<DataRow> _rowList = [];
  String? waaranty_upto = '';
  String? rly_name = '';
  String? rLY = '';
  String? ponumber= '';
  String? cname= '';
  String? conscode= '';
  String? poqty= '';
  String? pounitrate;
  String? podate;
  String? accountname= '';
  String? posr= '';
  String? pounitdesc= '';
  String? itemdescription= '';


  String? expirtydate= '';
  String? issuemakebrand= '';
  String? issueproductsrno= '';
  String? issueexpirydate= '';
  String? expritydate= '';
  String? receiptexpritydate= '';
  String? sortaccountaldate= '';
  String? vouchernumber= '';
  String? accountaldate= '';
  String? makebrand;
  String? productsrno= '';
  String? trqty= '';
  String? trunit= '';
  String? renspectionremark= '';
  String? issuevrno= '';
  String? issuevrdate= '';
  String? issueqty= '';
  String? issueunit= '';
  String? issuetransdetails= '';
  String? receiptbalqty= '';
  String? receiptmakebrand= '';
  String? receiptprductsrno= '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  late final LanguageProvider language;
  TextStyle _normalTextStyle = TextStyle(
    color: Colors.indigo[900],
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );


  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          splashRadius: 30,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          language.text('viewissuedetails'),
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        language.text('dtsissue'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red[500],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Card(
                    elevation: 10,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  language.text('Railway'),
                                  style: _normalTextStyle,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    rly_name?? "NA",
                                    // widget.item.railway?? "NA",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  language.text('Consignee Code'),
                                  style: _normalTextStyle,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    conscode?? "NA",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  language.text('PO / Contract No.',),
                                  style: _normalTextStyle,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    ponumber?? "NA",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  language.text('PO / Contract Date',),
                                  style: _normalTextStyle,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    podate ?? "NA",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  language.text('Item Sl. No. in PO / Contract',),
                                  style: _normalTextStyle,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    posr?? "NA",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text(
                                language.text('Item Description'),
                                style: TextStyle(
                                  color: Colors.indigo[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          SizedBox(width: 40),
                          ReadMoreText(
                            itemdescription?? "NA",
                            style:  TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            trimLines: 2,
                            colorClickableText: Colors.blue[700],
                            trimMode: TrimMode.Line,
                            trimCollapsedText: '... More',
                            trimExpandedText: '...less',
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  language.text('Vendor Name',),
                                  style: _normalTextStyle,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    accountname?? "NA",
                                    style: TextStyle(
                                      color: Colors.red[500],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  language.text('Quantity',),
                                  style: _normalTextStyle,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  poqty?? "NA",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  language.text('unitrate',),
                                  style: _normalTextStyle,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  pounitrate?? "NA",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        language.text('heading'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.indigo[900],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(language.text('RcptDetails'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    language.text('vocherno'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      vouchernumber!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                /*  Expanded(flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: vouchernumber == "null" ? Text("NA", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )) : Text(
                                      vouchernumber!.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    language.text('actdate'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      accountaldate!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                /*   Expanded(flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: accountaldate == "null" ? Text("NA", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )) : Text(
                                      accountaldate!.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    language.text('qty'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      trqty!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                /* Expanded(flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: trqty == "null" ? Text("NA", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )) : Text(
                                      trqty!.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    language.text('makebrand'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: makebrand == "null" ? Text("NA", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )) : Text(
                                      makebrand.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    language.text('prdtslno'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: productsrno == "null" ? Text("NA", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )) : Text(
                                      productsrno!.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    language.text('warrantyupto'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: waaranty_upto == "null" ? Text("NA", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )) : Text(
                                      waaranty_upto.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.center,
                              child: Text(language.text('issuedtls'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    language.text('issuenotedate'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      issuevrno!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "",
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      issuevrdate!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    language.text('iisueqty'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      issueqty??"NA",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    language.text('makebrand'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: makebrand == "null" ? Text("NA", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )) : Text(
                                      makebrand.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    language.text('prdtslno'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: productsrno == "null" ? Text("NA", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )) : Text(
                                      productsrno.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    language.text('warrantyupto'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: waaranty_upto == "null" ? Text("NA", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )) : Text(
                                      waaranty_upto.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.center,
                              child: Text(language.text('blc'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    language.text('blcqty'),
                                    style: _normalTextStyle,
                                  ),
                                ),

                                /*  Expanded(flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: receiptbalqty == "null" ? Text("NA", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )) : Text(
                                      receiptbalqty!.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),*/
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      receiptbalqty?? "NA",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    language.text('makebrand'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: makebrand == "null" ? Text("NA", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )) : Text(
                                      makebrand.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                /*  Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      makebrand!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    language.text('prdtslno'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: productsrno == "null" ? Text("NA", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )) : Text(
                                      productsrno.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    language.text('warrantyupto'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: waaranty_upto == "null" ? Text("NA", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )) : Text(
                                      waaranty_upto.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      IRUDMConstants.showProgressIndicator(context);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    language = Provider.of<LanguageProvider>(context);
    fetchAndStoreissuedetails().then((_) {
      IRUDMConstants.removeProgressIndicator(context);

      super.didChangeDependencies();
    });
  }


  Future<void> fetchAndStoreissuedetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var result_Heading_detail = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData','Heading_detail',
          widget.ponumber! + "~" + widget.posr! + "~" + widget.rLY!, prefs.getString('token'));
      debugPrint("response $result_Heading_detail");

      var itemData = json.decode(result_Heading_detail.body);
      debugPrint("data $itemData");
      var headingdetails = itemData['data'];
      debugPrint("data1 $headingdetails");


      var result_View_Issue_details = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData','View_Issue_details',
          widget.ponumber! + "~" + widget.posr! + "~" + widget.rLY!, prefs.getString('token'));
      debugPrint("response $result_View_Issue_details");

      var detailsData = json.decode(result_View_Issue_details.body);
      debugPrint("data $detailsData");
      var issuedetails = detailsData['data'];
      debugPrint("data1 $issuedetails");


      setState(() {
        rly_name = headingdetails == null ? "NA" : headingdetails![0]['rly_name'];
        debugPrint("data2"+rly_name.toString());
        cname = headingdetails == null ? "NA" : headingdetails[0]['cname'];
        ponumber = headingdetails == null ? "NA" :headingdetails![0]['ponumber'].toString() ;
        cname =headingdetails == null ? "NA" : headingdetails![0]['cname'].toString() ;
        conscode = headingdetails == null ? "NA" : headingdetails![0]['conscode'] .toString();
        poqty = headingdetails == null ? "NA" : headingdetails![0]['poqty'].toString() ;
        pounitrate =headingdetails == null ? "NA" : headingdetails![0]['pounitrate'].toString() ;
        podate = headingdetails == null ? "NA" :headingdetails![0]['podate'].toString() ;
        accountname =headingdetails == null ? "NA" : headingdetails![0]['accountname'].toString() ;
        posr =headingdetails == null ? "NA" : headingdetails![0]['posr'] .toString();
        pounitdesc = headingdetails == null ? "NA" :headingdetails![0]['pounitdesc'].toString() ;
        itemdescription =headingdetails == null ? "NA" : headingdetails![0]['itemdescription'].toString() ;

        waaranty_upto=issuedetails == null ? "NA" : issuedetails![0]['waaranty_upto'] .toString();
        expirtydate=issuedetails == null ? "NA" : issuedetails![0]['expirtydate'] .toString();
        issuemakebrand =issuedetails == null ? "NA" : issuedetails![0]['issuemakebrand'].toString() ;
        issueproductsrno =issuedetails == null ? "NA" : issuedetails![0]['issueproductsrno'] .toString();
        issueexpirydate= issuedetails == null ? "NA" :issuedetails![0]['issueexpirydate'].toString() ;
        expritydate= issuedetails == null ? "NA" : issuedetails![0]['expritydate'] .toString();
        receiptexpritydate= issuedetails == null ? "NA" :issuedetails![0]['receiptexpritydate'].toString() ;
        sortaccountaldate =issuedetails == null ? "NA" : issuedetails![0]['sortaccountaldate'].toString() ;
        vouchernumber =issuedetails == null ? "NA" : issuedetails![0]['vouchernumber'].toString() ;
        accountaldate  = issuedetails == null ? "NA" : issuedetails![0]['accountaldate'].toString() ;
        makebrand = issuedetails == null ? "NA" : issuedetails![0]['makebrand'] .toString();
        productsrno  = issuedetails == null ? "NA" : issuedetails![0]['productsrno'] .toString();
        trqty =issuedetails == null ? "NA" : issuedetails![0]['trqty'] .toString();
        trunit =issuedetails == null ? "NA" : issuedetails![0]['trunit'] ;
        renspectionremark =issuedetails == null ? "NA" : issuedetails![0]['renspectionremark'].toString() ;
        issuevrno = issuedetails == null ? "NA" :issuedetails![0]['issuevrno'].toString() ;
        issuevrdate= issuedetails == null ? "NA" : issuedetails![0]['issuevrdate'] .toString();
        issueqty =issuedetails == null ? "NA" : issuedetails![0]['issueqty'] .toString();
        issueunit  = issuedetails == null ? "NA" : issuedetails![0]['issueunit'].toString() ;
        issuetransdetails  = issuedetails == null ? "NA" : issuedetails![0]['issuetransdetails'] .toString();
        receiptbalqty =issuedetails == null ? "NA" : issuedetails![0]['receiptbalqty'].toString() ;
        receiptmakebrand  = issuedetails == null ? "NA" :issuedetails![0]['receiptmakebrand'] .toString();
        receiptprductsrno =issuedetails == null ? "NA" : issuedetails![0]['receiptprductsrno'].toString();
      });
    }
    on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    }
  }




}

