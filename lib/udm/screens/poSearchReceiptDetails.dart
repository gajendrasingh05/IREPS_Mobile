import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/new_posearch_recipt/receipt_provider.dart';
import 'package:flutter_app/udm/new_posearch_recipt/receipt_screen.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/shared_data.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class poSearchReceiptDetails extends StatefulWidget {
  String? ponumber, posr, railway;
  poSearchReceiptDetails(this.ponumber, this.posr, this.railway);
  @override
  State<poSearchReceiptDetails> createState() => _poSearchReceiptDetailsState();
}

class _poSearchReceiptDetailsState extends State<poSearchReceiptDetails> with SingleTickerProviderStateMixin {
  List<DataRow> _rowList = [];
  String? railway = '';
  String? rly_name = '';
  String? ponumber= '';
  String? cname= '';
  String? conscode= '';
  String? poqty= '';
  String? pounitrate= '';
  String? podate= '';
  String? accountname= '';
  String? posr= '';
  String? pounitdesc= '';
  String? itemdescription= '';


  String? expirtydate= '';
  String? warrepflag= '';
  String? rnoteurl= '';
  String? reftranskey= '';
  String? transreinspectiondesc= '';
  String? rejtranskey= '';
  String? transkey= '';
  String? totalreinspqty= '';
  String? totalreturnedqty= '';
  String? reinspflag= '';
  String? unitname= '';
  String? trunit= '';
  String? transstatus= '';
  String? voucherno= '';
  String? transdate= '';
  String? qtydispatched= '';
  String? qtyreceived= '';
  String? qtyaccepted= '';
  String? qtyrejected= '';
  String? challandate= '';
  String? challanno= '';
  String? curmakebrand= '';
  String? curproductsrno= '';
  String? billno= '';
  String? billdate= '';
  String? cardcode= '';
  String? rejind= '';
  String? issuemakebrand= '';
  String? issueproductsrno= '';
  String? issueexpirydate= '';
  String? expritydate= '';
  String? receiptexpritydate= '';
  String? sortaccountaldate= '';
  String? vouchernumber= '';
  String? accountaldat= '';
  String? makebrand= '';
  String? productsrno= '';
  String? trqty= '';
  //String? trunit;
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
    LanguageProvider language = Provider.of<LanguageProvider>(context);
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
          language.text('receipt'),
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
                  SizedBox(height: 7,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        language.text('Purchase Order / Contract Supply Status'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red[500],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
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
                                      cname! ,
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
                                    language.text('Consignee Code1'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      conscode!,
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
                                    language.text('PO / Contract No.'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      ponumber!,
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
                                      podate!,
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
                                    language.text('Item Sl. No. in PO / Contract'),
                                    style: _normalTextStyle,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      posr!,
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
                              style: TextStyle(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(flex: 1, child: Text(language.text('Vendor Name'), style: _normalTextStyle)),
                                Expanded(flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      accountname!,
                                      style: TextStyle(
                                        color: Colors.redAccent,
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
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text("$poqty $pounitdesc",
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
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Column(
                children: [
                  ZoomTapAnimation(
                    onTap: (){
                      setState(() {
                        var receiptProvider =
                        Provider.of<ReceiptProvider>(context, listen: false);
                        Navigator.of(context).pushNamed(Receipt_Screen.routeName);
                        receiptProvider.fetchAndStoreReceiptData(
                            ponumber!,
                            posr!,
                            railway!,
                            context);
                      });
                    },
                    child: BlinkText(
                        language.text('heading1'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.red[500],
                        ),
                        textAlign: TextAlign.center,
                        beginColor: Colors.red[500],
                        endColor: Colors.blueAccent,
                        times: 500,
                        duration: Duration(seconds: 2)
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
    fetchAndStoreReceiptDetails().then((_) {
      IRUDMConstants.removeProgressIndicator(context);

      super.didChangeDependencies();
    });
  }

  Future<void> fetchAndStoreReceiptDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var result_Heading_detail = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData','Heading_detail',
          widget.ponumber! + "~" + widget.posr! + "~"+widget.railway!, prefs.getString('token'));

      var itemData = json.decode(result_Heading_detail.body);
      var headingdetails = itemData['data'];

      setState(() {
        rly_name = headingdetails == null ? "NA" : headingdetails![0]['rly_name'];
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
        //_progressHide();
      });

    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    }
  }

}

