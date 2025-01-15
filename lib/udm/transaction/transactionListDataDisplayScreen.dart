import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/screens/advice_note.dart';
import 'package:flutter_app/udm/screens/consignee_receipt_note.dart';
import 'package:flutter_app/udm/screens/issue_note.dart';
import 'package:flutter_app/udm/screens/item_receipt_details.dart';
import 'package:flutter_app/udm/screens/warranty_claim_details.dart';
import 'package:flutter_app/udm/transaction/transactionListDataModel.dart';
import 'package:flutter_app/udm/transaction/transactionListDataProvider.dart';
import 'package:flutter_app/udm/widgets/expandable_text_widget.dart';
import 'package:flutter_app/udm/widgets/search_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
//import 'package:share/share.dart';
import 'package:share_plus/share_plus.dart';

class TransactionListDataDisplayScreen extends StatefulWidget {

  static const routeName = "/TransactionDataList-Result-screen";
  String userDepot, userSubDepot;
  TransactionListDataDisplayScreen(this.userDepot, this.userSubDepot);

  @override
  _TransactionListDataDisplayState createState() => _TransactionListDataDisplayState();
}

class _TransactionListDataDisplayState
    extends State<TransactionListDataDisplayScreen> {
  @override
  void initState() {
    super.initState();
    print("user depot txn ${widget.userDepot}");
    print("user Sub depot txn ${widget.userSubDepot}");
  }

  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('dd-MM-yyyy');

  @override
  void didChangeDependencies() {
    FocusScope.of(context).requestFocus(FocusNode());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
        appBar: SearchAppbar(
          title: language.text('transactionSummary'),
          labelData: 'Transactions',
        ),
        body: Stack(children: [
          Consumer<TransactionListDataProvider>(builder: (_, TransactionListDataProvider, __) {
            if (TransactionListDataProvider.state == TransactionListDataState.Busy) {
              return Center(child: CircularProgressIndicator());
            } else if(TransactionListDataProvider.state == TransactionListDataState.FinishedWithError) {
              Future.delayed(
                  Duration.zero, () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.redAccent,
                        duration: Duration(seconds: 3),
                        content: Text(TransactionListDataProvider.error!.description.toString(),
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )));
              return Container();
            } else if(TransactionListDataProvider.state == TransactionListDataState.Finished) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      transactionDetails(TransactionListDataProvider),
                      transactionSummary(TransactionListDataProvider),
                    ],
                  ),
                  TransactionListDataProvider.transactionList!.length > 0 ? Expanded(
                          child: ListView.builder(
                              itemCount: TransactionListDataProvider.transactionList!.length,
                              itemBuilder: (_, i) {
                                return ProductBox(
                                  item: TransactionListDataProvider.transactionList![i],
                                  index: i,
                                );
                              }),
                        )
                      : Container(),
                ],
              );
            } else {
              return Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    transactionDetails(TransactionListDataProvider),
                    transactionSummary(TransactionListDataProvider),
                  ],
                ),
              );
            }
          }),
        ]));
  }

  Widget transactionDetails(TransactionListDataProvider transactionListDataProvider) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Container(
        child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.blue, disabledForegroundColor: Colors.grey.withOpacity(0.38),
            ),
            child: Text(
              language.text('itemDetails'),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {{
                showModalBottomSheet (
                    isScrollControlled: true,
                    context: context,
                    builder: (_) => Container(
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.only(left: 10, right: 10, top: 40),
                        color: const Color(0xFFFDEDDE),
                        child: SingleChildScrollView(
                          child: Column(children: <Widget>[
                            Image(
                              image: AssetImage("assets/indian_railway.png"),
                              height: 55,
                            ),
                            SizedBox(height: 8),
                            Text(
                              language.text('itemDetails'),
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  language.text('consignee') +
                                      ' - ' +
                                      widget.userDepot +
                                      '\n' +
                                      language.text('subDepot') +
                                      ' - ' +
                                      widget.userSubDepot,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    // fontWeight:
                                    // FontWeight.bold,
                                  )),
                            ),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  language.text('transactionDetailsFor'),
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Expanded(
                                  child: Text(language.text('from') + "  " + transactionListDataProvider.from_Date.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    language.text('to') + "  " + transactionListDataProvider.to_Date.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Align(
                              alignment: Alignment.center,
                              child:
                                  Text('(as on ' + formatter.format(now) + ')'),
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    language.text('pl/itemCode'),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold
                                        ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      transactionListDataProvider.headerData[0]['ledgerfolioplno'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    language.text('folioName'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      transactionListDataProvider.headerData[0]
                                          ['ledgerfolioname'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                language.text('nameOfArticleItem'),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              transactionListDataProvider.headerData[0]['ledgerfolioshortdesc'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    language.text('unitWeight'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      transactionListDataProvider.headerData[0]
                                                  ['unitweight'] !=
                                              null
                                          ? transactionListDataProvider
                                              .headerData[0]['unitweight']
                                          : '',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    language.text('itemType'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      itemType(transactionListDataProvider
                                          .headerData[0]['vs']),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    language.text('itemUsage'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      _itemUsage(transactionListDataProvider
                                          .headerData[0]['consumind']),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    language.text('itemCategory'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      transactionListDataProvider.headerData[0]
                                          ['itemcategory'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            transactionListDataProvider.headerData[0]['antiannualconsump'] != '0.000' ? Column(
                                    children: [
                                      SizedBox(height: 8),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              language.text('aac'),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 4,
                                              child: Text(
                                                transactionListDataProvider.headerData[0]['antiannualconsump'] + " " + transactionListDataProvider.headerData[0]['transunit'],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                ),
                                              ))
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Divider(
                                        height: 3,
                                        color: Colors.black87,
                                      ),
                                    ],
                                  ) : Container(),
                            SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    language.text('existingThresholdUnit'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      transactionListDataProvider.headerData[0]['thresholdlimit']+" " + transactionListDataProvider.headerData[0]['transunit'],
                                      style: TextStyle(fontSize: 14, color: Colors.black87,
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    language.text('transactionUnit'),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold
                                        ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      transactionListDataProvider.headerData[0]['transunit'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    language.text('ledger'),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold
                                        // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      transactionListDataProvider.headerData[0]['ledgerno'] + "-" + transactionListDataProvider.headerData[0]['ledgername'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    language.text('ledgerFolioNo'),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold
                                        ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      transactionListDataProvider.headerData[0]['ledgerfoliono'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true).pop('dialog');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.black87,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0)),
                                      border: Border.all(
                                        width: 3,
                                        color: Colors.black87,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                )),
                          ]),
                        ))
                );
              }
            }));
  }

  Widget transactionSummary(TransactionListDataProvider transactionListDataProvider) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Container(
        child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.blue, disabledForegroundColor: Colors.grey.withOpacity(0.38),
            ),
            child: Text(
              language.text('itemSummary'),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (_) => Container(
                          height: MediaQuery.of(context).size.height,
                          // margin: EdgeInsets.only(top: 40),
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 40),
                          color: const Color(0xFFFDEDDE),
                          child: SingleChildScrollView(
                              child: Column(children: <Widget>[
                                 Image(
                              image: AssetImage("assets/indian_railway.png"),
                              height: 55,
                              ),
                                 SizedBox(height: 8),
                                 Text(
                              language.text('itemSummary'),
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    language.text('pl/itemCode'),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold
                                        // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      transactionListDataProvider.headerData[0]['ledgerfolioplno'],
                                      style: new TextStyle(
                                          fontSize: 14,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                language.text('nameOfArticleItem'),
                                style: new TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              transactionListDataProvider.headerData[0]['ledgerfolioshortdesc'],
                              style: new TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            transactionListDataProvider.recQty != '' && transactionListDataProvider.headerData[0]['transunit'] != ''
                                ? Column(children: [
                                    SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          language.text(
                                              'recepitsDuringSelectedPeriod'),
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            language.text('quantity'),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            transactionListDataProvider.recQty! + ' ' + transactionListDataProvider.headerData[0]['transunit'],
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            language.text('valueRs'),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            transactionListDataProvider.recValue,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Divider(
                                      height: 3,
                                      color: Colors.black87,
                                    ),
                                  ])
                                : Container(),
                            transactionListDataProvider.issueQty != ''
                                ? Column(
                                    children: [
                                      SizedBox(height: 8),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            language.text(
                                                'issueDuringSelectedPeriod'),
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              language.text('quantity'),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${transactionListDataProvider.issueQty}' + ' ' + '${transactionListDataProvider.headerData[0]['transunit']}',
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              language.text('valueRs'),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              transactionListDataProvider.issuValue ?? '',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Divider(
                                        height: 3,
                                        color: Colors.black87,
                                      ),
                                    ],
                                  )
                                : Container(), transactionListDataProvider.headerData[0]['stkqty'] != ''
                                ? Column(
                                    children: [
                                      SizedBox(height: 8),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            language.text('balanceAtEndOfPeriod'),
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              language.text('quantity'),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              transactionListDataProvider.headerData[0]['stkqty'] + ' ' + transactionListDataProvider.headerData[0]['transunit'],
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              language.text('valueRs'),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              transactionListDataProvider.headerData[0]['stkvalue'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Divider(
                                        height: 3,
                                        color: Colors.black87,
                                      ),
                                    ],
                                  )
                                : Container(),
                            SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    language.text('currentClosingBalance'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      transactionListDataProvider.headerData[0]['stkqty'] + ' ' + transactionListDataProvider.headerData[0]['transunit'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    language.text('currentClosingBalanceValue'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      transactionListDataProvider.headerData[0]['stkvalue'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    language.text('averageRate'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      transactionListDataProvider.headerData[0]['bar'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(
                              height: 3,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true).pop('dialog');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.black87,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0)),
                                      border: Border.all(
                                        width: 3,
                                        color: Colors.black87,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                )),
                          ])),
                        )
                );
              }
            }));
  }

  String itemType(String? item) {
    if (item == 'V') {
      return 'Vital';
    } else if (item == 'S') {
      return 'Safety';
    } else if (item == 'O') {
      return 'Others';
    } else {
      return 'All';
    }
  }

  _itemUsage(String? item) {
    if (item == 'C') {
      return 'Consumable';
    } else if (item == 'M') {
      return 'M&P';
    } else if (item == 'S') {
      return 'M&P Spares';
    } else if (item == 'T') {
      return 'T&P';
    } else if (item == 'P') {
      return 'T&P';
    } else if (item == 'O') {
      return 'Others';
    } else {
      return 'All';
    }
  }
}

class ProductBox extends StatelessWidget {
  final TransactionListDataModel? item;
  final int? index;

  const ProductBox({this.item, this.index});

  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Container(
        padding: EdgeInsets.all(6),
        child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              Container(
                padding: EdgeInsets.only(top: 13, left: 8),
                child: Text((index! + 1).toString() + '.',
                  softWrap: false,
                  style: TextStyle(
                      fontSize: 14,
                      color: item!.cARDCODE == '41'
                          ? Colors.deepOrangeAccent
                          : Colors.indigo[800]
                      ),
                ),
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: 5, top: 5, right: 11, bottom: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 8),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    language.text('date'),
                                    softWrap: false,
                                    style: new TextStyle(
                                        fontSize: 14,
                                        color: item!.cARDCODE == '41'
                                            ? Colors.deepOrangeAccent
                                            : Colors.indigo[800]
                                        ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      item!.tRANSDATE!,
                                      style: new TextStyle(
                                          fontSize: 14,
                                          color: item!.cARDCODE == '41'
                                              ? Colors.deepOrangeAccent
                                              : Colors.black87),
                                      // overflow: TextOverflow.ellipsis,
                                    )),
                              ]),
                          SizedBox(height: 10),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    language.text('noDateOfReceipt'),
                                    softWrap: false,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: item!.cARDCODE == '41'
                                            ? Colors.deepOrangeAccent
                                            : Colors.indigo[800]
                                        ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text.rich(() {
                                    if(item!.tRANSTYPE == 'R') {if (item!.tRANSQTY == '0.000' && item!.cARDCODE == '41' && item!.lOANINDDESC == '1') {
                                        //return item.vOUCHERNO+'\ndt. '+item.tRANSDATE+'\n'+"No discrepancy found during Stock Verification \nOn Loan \nIssues against Receipt Vr.";
                                        return TextSpan(children: <InlineSpan>[
                                          TextSpan(
                                              text: 'RO No.',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          TextSpan(
                                              text: item!.vOUCHERNO,
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          TextSpan(
                                              text: '\ndt. ' + item!.tRANSDATE!,
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          TextSpan(
                                              text:
                                                  'No discrepancy found during Stock Verification \nOn Loan  \n',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text:
                                                  'Issues against Receipt Vr.',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => _toast(
                                                    item!.cARDCODE, context,
                                                    temp: item!)),
                                        ]);
                                      } else if (item!.tRANSQTY == '0.000' &&
                                          item!.cARDCODE == '41' &&
                                          item!.lOANINDDESC == '2') {
                                        return TextSpan(children: <InlineSpan>[
                                          TextSpan(
                                              text: 'RO No.  ',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          TextSpan(
                                              text: item!.vOUCHERNO,
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          TextSpan(
                                              text: '\ndt. ' + item!.tRANSDATE!,
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          TextSpan(
                                              text:
                                                  '\nNo discrepancy found during Stock Verification \nnReturn On Loan  \n',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text:
                                                  'Issues against Receipt Vr.',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => _toast(
                                                    item!.cARDCODE, context,
                                                    temp: item!)),
                                        ]);
                                      } else if (item!.tRANSQTY == '0.000' &&
                                          item!.cARDCODE == '41') {
                                        return TextSpan(children: <InlineSpan>[
                                          TextSpan(
                                              text: 'RO No.  ',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          TextSpan(
                                              text: item!.vOUCHERNO,
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          TextSpan(
                                              text: '\ndt. ' + item!.tRANSDATE!,
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          TextSpan(
                                              text:
                                                  '\nNo discrepancy found during Stock Verification\n',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text:
                                                  'Issues against Receipt Vr.',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => _toast(
                                                    item!.cARDCODE, context,
                                                    temp: item!)),
                                        ]);
                                      } else if (item!.lOANINDDESC == '1') {
                                        return TextSpan(children: <InlineSpan>[
                                          TextSpan(
                                              text: 'RO No.  ',
                                              style: TextStyle(
                                                  color: Colors.black87)),
                                          TextSpan(
                                              text: item!.vOUCHERNO,
                                              style: TextStyle(
                                                  color: Colors.black87)),
                                          TextSpan(
                                              text: '\ndt. ' + item!.tRANSDATE!,
                                              style: TextStyle(
                                                  color: Colors.black87)),
                                          TextSpan(
                                              text: '\nOn Loan\n',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text:
                                                  'Issues against Receipt Vr.',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => _toast(
                                                    item!.cARDCODE, context,
                                                    temp: item!)),
                                        ]);
                                      } else if (item!.lOANINDDESC == '2') {
                                        return TextSpan(children: <InlineSpan>[
                                          TextSpan(
                                              text: 'RO No.  ',
                                              style: TextStyle(
                                                  color: Colors.black87)),
                                          TextSpan(
                                              text: item!.vOUCHERNO,
                                              style: TextStyle(
                                                  color: Colors.black87)),
                                          TextSpan(
                                              text: '\ndt. ' + item!.tRANSDATE!,
                                              style: TextStyle(
                                                  color: Colors.black87)),
                                          TextSpan(
                                              text: '\nReturn On Loan\n',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: 'Issues against Receipt Vr.',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => _toast(
                                                    item!.cARDCODE, context,
                                                    temp: item!)),
                                        ]);
                                      } else {
                                        return TextSpan(children: <InlineSpan>[
                                          TextSpan(
                                              text: 'RO No.  ',
                                              style: TextStyle(
                                                  color: Colors.black87)),
                                          TextSpan(
                                              text: item!.vOUCHERNO,
                                              style: TextStyle(
                                                  color: Colors.blue),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => _toast(
                                                    item!.cARDCODE, context,
                                                    temp: item!)),
                                          TextSpan(
                                              text: '\ndt. ' + item!.tRANSDATE!,
                                              style: TextStyle(
                                                  color: Colors.black87)),
                                          TextSpan(
                                              text:
                                                  '\nIssues against Receipt Vr.',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold)
                                              ),
                                        ]);
                                      }
                                    } else if (item!.tRANSTYPE == 'I') {
                                      if (item!.tRANSQTY == '0.000' &&
                                          item!.cARDCODE == '41' &&
                                          item!.lOANINDDESC == '1') {
                                        // return item.vOUCHERNO+'\ndt. '+item.tRANSDATE+'\n'+"No discrepancy found during Stock Verification \nOn Loan";
                                        // TODO Here is the issue note no.
                                        return TextSpan(children: <InlineSpan>[
                                          TextSpan(
                                              text: () {
                                                if (item!.cARDCODE == '30' &&
                                                    item!.rEJIND == 'W') {
                                                  return 'Warranty Claim No. ';
                                                } else {
                                                  return 'Issue Note No. ';
                                                }
                                              }(),
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          TextSpan(
                                              text: item!.vOUCHERNO,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  print(item!.cARDCODE);
                                                  _toast(
                                                      item!.cARDCODE, context,
                                                      temp: item!);
                                                  if (item!.cARDCODE == '47') {
                                                    print('Launched Screen');
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                      ItemReceiptDetails
                                                          .routeName,
                                                    );
                                                  }
                                                }),
                                          TextSpan(
                                              text:
                                                  '\ndt. ' + item!.tRANSDATE!),
                                          TextSpan(
                                              text: '\nOn Loan',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                        ]);
                                      } else if (item!.tRANSQTY == '0.000' &&
                                          item!.cARDCODE == '41' &&
                                          item!.lOANINDDESC == '2') {
                                        return TextSpan(children: <InlineSpan>[
                                          TextSpan(
                                            text: () {
                                              if (item!.cARDCODE == '30' &&
                                                  item!.rEJIND == 'W') {
                                                return 'Warranty Claim No. ';
                                              } else {
                                                return 'Issue Note No. ';
                                              }
                                            }(),
                                          ),
                                          TextSpan(
                                              text: item!.vOUCHERNO,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => _toast(
                                                    item!.cARDCODE, context,
                                                    temp: item!)),
                                          TextSpan(
                                              text:
                                                  '\ndt. ' + item!.tRANSDATE!) ,
                                          TextSpan(
                                              text: '\nReturn On Loan',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                        ]);
                                      } else if (item!.tRANSQTY == '0.000' &&
                                          item!.cARDCODE == '41') {
                                        return TextSpan(children: <InlineSpan>[
                                          TextSpan(text: () {
                                            if (item!.cARDCODE == '30' &&
                                                item!.rEJIND == 'W') {
                                              return 'Warranty Claim No. ';
                                            } else {
                                              return 'Issue Note No. ';
                                            }
                                          }()),
                                          TextSpan(
                                              text: item!.vOUCHERNO,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => _toast(
                                                    item!.cARDCODE, context,
                                                    temp: item!)),
                                          TextSpan(
                                              text:
                                                  '\ndt. ' + item!.tRANSDATE!),
                                          TextSpan(
                                              text:
                                                  '\nNo discrepancy found during Stock Verification',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                        ]);
                                      } else if (item!.lOANINDDESC == '1') {
                                        return TextSpan(children: <InlineSpan>[
                                          TextSpan(text: () {
                                            if (item!.cARDCODE == '30' &&
                                                item!.rEJIND == 'W') {
                                              return 'Warranty Claim No. ';
                                            } else {
                                              return 'Issue Note No. ';
                                            }
                                          }()),
                                          TextSpan(
                                              text: item!.vOUCHERNO,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => _toast(
                                                    item!.cARDCODE, context,
                                                    temp: item!)),
                                          TextSpan(
                                              text:
                                                  '\ndt. ' + item!.tRANSDATE!),
                                          TextSpan(
                                              text: '\nOn Loan',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                        ]);
                                      } else if (item!.lOANINDDESC == '2') {
                                        // return item.vOUCHERNO+'\ndt. '+item.tRANSDATE+'\n'+"\nReturn On Loan";
                                        return TextSpan(children: <InlineSpan>[
                                          TextSpan(text: () {
                                            if (item!.cARDCODE == '30' &&
                                                item!.rEJIND == 'W') {
                                              return 'Warranty Claim No. ';
                                            } else {
                                              return 'Issue Note No. ';
                                            }
                                          }()),
                                          TextSpan(
                                              text: item!.vOUCHERNO,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => _toast(
                                                    item!.cARDCODE, context,
                                                    temp: item!)),
                                          TextSpan(
                                              text:
                                                  '\ndt. ' + item!.tRANSDATE!),
                                          TextSpan(
                                              text: '\nReturn On Loan',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                        ]);
                                      } else {
                                        return TextSpan(children: <InlineSpan>[
                                          TextSpan(text: () {
                                            if (item!.cARDCODE == '30' &&
                                                item!.rEJIND == 'W') {
                                              return 'Warranty Claim No. ';
                                            } else {
                                              return 'Issue Note No. ';
                                            }
                                          }()),
                                          TextSpan(
                                              text: item!.vOUCHERNO,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => _toast(
                                                    item!.cARDCODE, context,
                                                    temp: item!)),
                                          TextSpan(
                                              text:
                                                  '\ndt. ' + item!.tRANSDATE!),
                                          TextSpan(
                                              text: '\n' +
                                                  item!.tRANSTYPEDESCRIPTION!),
                                        ]);
                                      }
                                    } else {
                                      return TextSpan(children: <InlineSpan>[
                                        TextSpan(text: () {
                                          if(item!.cARDCODE == '30' &&
                                              item!.rEJIND == 'W') {
                                            return 'Warranty Claim No. ';
                                          } else {
                                            return 'Issue Note No. ';
                                          }
                                        }()),
                                        TextSpan(
                                            text: item!.vOUCHERNO,
                                            style:
                                                TextStyle(color: Colors.blue),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () => _toast(
                                                  item!.cARDCODE, context,
                                                  temp: item!)),
                                        TextSpan(
                                            text: '\ndt. ' + item!.tRANSDATE!),
                                        TextSpan(
                                            text: item!.tRANSTYPEDESCRIPTION == null  || item!.tRANSTYPEDESCRIPTION.toString().isEmpty ||  item!.tRANSTYPEDESCRIPTION.toString().length == 0 ? '\n' "NA" :
                                                item!.tRANSTYPEDESCRIPTION!),
                                      ]);
                                    }
                                  }()),
                                ),
                              ]),
                          SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                language.text('receiptQuantity'),
                                softWrap: false,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: item!.cARDCODE == '41'
                                        ? Colors.deepOrangeAccent
                                        : Colors.indigo[800]
                                    //fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            Expanded(
                                flex: 4,
                                child: Text(
                                  item!.tRANSQTY != null && item!.tRANSTYPE == "R" ? item!.tRANSQTY! : '',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: item!.cARDCODE == '41'
                                          ? Colors.deepOrangeAccent
                                          : Colors.black87),
                                  // overflow: TextOverflow.ellipsis,
                                )),
                          ]),
                          SizedBox(height: 10),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    language.text('issueQuantity'),
                                    softWrap: false,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: item!.cARDCODE == '41'
                                            ? Colors.deepOrangeAccent
                                            : Colors.indigo[800]
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      item!.tRANSQTY != null && item!.tRANSTYPE == "I" ? item!.tRANSQTY! : '',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: item!.cARDCODE == '41'
                                              ? Colors.deepOrangeAccent
                                              : Colors.black87),
                                      // overflow: TextOverflow.ellipsis,
                                    )),
                              ]),
                          SizedBox(height: 10),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    language.text('balanceQuantity'),
                                    softWrap: false,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: item!.cARDCODE == '41'
                                            ? Colors.deepOrangeAccent
                                            : Colors.indigo[800]
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      item!.cLOSINGBALSTKQTY ?? '',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: item!.cARDCODE == '41'
                                              ? Colors.deepOrangeAccent
                                              : Colors.black87),
                                      // overflow: TextOverflow.ellipsis,
                                    )),
                              ]),
                          SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                language.text('initials'),
                                softWrap: false,
                                style:  TextStyle(
                                    fontSize: 14,
                                    color: item!.cARDCODE == '41'
                                        ? Colors.deepOrangeAccent
                                        : Colors.indigo[800]
                                    //fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            Expanded(
                                flex: 4,
                                child: Text(
                                  item!.cARDCODE == '41'
                                      ? item!.sTKVERIFIERUSERNAME! +
                                          '\n' +
                                          item!.sTKVERIFIERPOST! +
                                          '\n' +
                                          item!.tRANSUSERNAME! +
                                          '\n' +
                                          '${item!.uSERTYPE}'
                                      : item!.tRANSUSERNAME ??=
                                          ('${item!.tRANSUSERNAME}' +
                                              '\n' +
                                              '${item!.uSERTYPE}'),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: item!.cARDCODE == '41'
                                          ? Colors.deepOrangeAccent
                                          : Colors.black87),
                                  // overflow: TextOverflow.ellipsis,
                                )),
                          ]),
                          SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                language.text('remarks'),
                                softWrap: false,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: item!.cARDCODE == '41'
                                        ? Colors.deepOrangeAccent
                                        : Colors.indigo[800]
                                    //fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text.rich(() {
                                  if(item!.tRANSTYPE == 'R') {
                                    if (item!.lOANINDDESC == '1' && int.parse(item!.lOANBALQTY!) > 0) {
                                      return TextSpan(children: <InlineSpan>[
                                        TextSpan(
                                            text: 'Balance Loan to return: \n' +
                                                item!.lOANBALQTY! +
                                                '\n' +
                                                item!.tRANSUNIT!,
                                            style:
                                                TextStyle(color: Colors.blue),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () => _toast(
                                                  item!.cARDCODE, context,
                                                  temp: item!)),
                                      ]);
                                    } else {
                                      return TextSpan(children: <InlineSpan>[
                                        TextSpan(
                                            text: item!.tRANSREMARKS,
                                            style: TextStyle(
                                                color: Colors.black87),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () => _toast(
                                                  item!.cARDCODE, context)),
                                      ]);
                                    }
                                  } else {
                                    if (item!.aCKNOWLEDGEFLAG == '0' &&
                                        item!.tRANSSTATUS != 'XX' &&
                                        (item!.cARDCODE == '43' ||
                                            item!.cARDCODE == '59')) {
                                      // return item.tRANSREMARKS+'\nAcknowledge Pending';
                                      return TextSpan(children: <InlineSpan>[
                                        TextSpan(text: item!.tRANSREMARKS),
                                        TextSpan(
                                          text: '\nAcknowledgement Pending',
                                          style: TextStyle(color: Colors.red),
                                        )
                                      ]);
                                    } else if (item!.cARDCODE == '48') {
                                      if (item!.tRANSSTATUS == 'XX') {
                                      } else if (item!.rEMARKS == null) {
                                        return TextSpan(children: <InlineSpan>[
                                          TextSpan(text: item!.tRANSREMARKS),
                                          TextSpan(
                                            text: '\nAccountable by Store Depot Pending',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ]);
                                      } else {
                                        return TextSpan(text: item!.tRANSREMARKS! + '\n' + item!.rEMARKS!);
                                      }
                                    } else if (item!.lOANINDDESC == '1' &&
                                        int.parse(item!.lOANBALQTY!) > 0 &&
                                        item!.tRANSSTATUS != 'XX') {
                                      return TextSpan(children: <InlineSpan>[
                                        TextSpan(text: item!.tRANSREMARKS),
                                        TextSpan(
                                            text:
                                                '\nBalance Loan to receive: \n' +
                                                    item!.lOANBALQTY! +
                                                    '\n' +
                                                    item!.tRANSUNIT!,
                                            style:
                                                TextStyle(color: Colors.blue)),
                                      ]);
                                    } else if (item!.tRANSSTATUS == 'XX') {
                                      return TextSpan(children: <InlineSpan>[
                                        TextSpan(text: item!.tRANSREMARKS),
                                        TextSpan(
                                            text:
                                                '\nCancelled vide Voucher No. ' +
                                                    item!.cANCELLEDVOUCHERNO! +
                                                    ' dt. ' +
                                                    item!.cANCELLEDVOUCHERDATE!,
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ]);
                                    } else {
                                      return TextSpan(children: <InlineSpan>[
                                        TextSpan(text: item!.tRANSREMARKS),
                                      ]);
                                    }
                                  }
                                }() as InlineSpan,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: item!.cARDCODE == '41'
                                        ? Colors.deepOrangeAccent
                                        : Colors.black87),
                              ),
                            ),
                          ]),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                language.text('receivedFromIssuedTo'),
                                style: TextStyle(
                                    color: item!.cARDCODE == '41'
                                        ? Colors.deepOrangeAccent
                                        : Colors.indigo[800]
                                    // fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                  item!.cARDCODE == '51' && item!.tRANSCARDCODEDESC.toString().length > 0
                                  ? item!.tRANSCARDCODEDESC! + '\n' + item!.mACHINEDTLS!
                                  : item!.tRANSCARDCODEDESC.toString().length == 0 || item!.tRANSCARDCODEDESC.toString() == "null" ? "NA" : item!.tRANSCARDCODEDESC.toString(),
                              style: TextStyle(
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                          ),
                        ],
                      )))
            ])));
  }

  _toast(String? cARDCODE, BuildContext context, {TransactionListDataModel? temp}) {
    print(cARDCODE);
    print(temp?.cARDCODE);
    print(temp?.iSSEDEPOTTYPE);
    if((cARDCODE == '43' || cARDCODE == '47') && temp?.iSSEDEPOTTYPE == '1') {
      Navigator.of(context).pushNamed(
        IssueNoteDetails.routeName,
        arguments: temp?.tRANSKEY,
      );
    }
    else if(cARDCODE == '44' || cARDCODE == '33') {
      Navigator.of(context).pushNamed(
        ConsigneeReceiptNote.routeName,
        arguments: temp?.tRANSKEY,
      );
    }
    // cardcode == 40, 46 or 48, launch item receipt details
    else if (cARDCODE == '40' || cARDCODE == '46' || cARDCODE == '48') {
      print(temp?.tRANSKEY);
      Navigator.of(context).pushNamed(
        ItemReceiptDetails.routeName,
        arguments: temp?.tRANSKEY,
      );
    }
    // cardcode == 47 and loanIndDesc == 2, launch item receipt details
    else if (cARDCODE == '47' && temp?.lOANINDDESC == '2') {
      Navigator.of(context).pushNamed(
        ItemReceiptDetails.routeName,
        arguments: temp?.tRANSKEY,
      );
    }
    // cardcode == 48, launch Advice Note
    else if (cARDCODE == '48') {
      Navigator.of(context).pushNamed(
        AdviceNote.routeName,
        arguments: temp?.tRANSKEY,
      );
    }
    // cardcode == 43, 53, 55, 57, 59, launch issue note
    else if(cARDCODE == '43' ||
        cARDCODE == '53' ||
        cARDCODE == '55' ||
        cARDCODE == '57' ||
        cARDCODE == '59') {
      Navigator.of(context).pushNamed(
        IssueNoteDetails.routeName,
        arguments: temp?.tRANSKEY,
      );
    }
    // cardcode == 30 && ledgerData.rejInd eq 'W', launch warranty claim
    else if(cARDCODE == '30' && temp?.rEJIND == 'W') {
      Navigator.of(context).pushNamed(
        WarrantyClaimDetails.routeName,
        arguments: temp?.tRANSKEY,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Coming Soon",
        backgroundColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        // backgroundColor: Colors.gre,
        textColor: Colors.black87,
        fontSize: 16.0,
      );
    }
  }

  _onShareData(String data, BuildContext context) async {
    await Share.share(data + "");
  }
}
