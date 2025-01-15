import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/summaryStock.dart';
import 'package:flutter_app/udm/providers/SumaryStockProvider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/transaction/transactionListDataProvider.dart';
import 'package:flutter_app/udm/widgets/search_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
//import 'package:share/share.dart';
import 'package:share_plus/share_plus.dart';

import 'item_details.dart';

class SummaryStockListScreen extends StatefulWidget {
  static const routeName = "/Sumary-Stock-screen";

  //String userDepot, userSubDepot;
  //SummaryStockListScreen(this.userDepot, this.userSubDepot);

  @override
  _SummaryStockListScreenState createState() => _SummaryStockListScreenState();
}

class _SummaryStockListScreenState extends State<SummaryStockListScreen> with SingleTickerProviderStateMixin {
  var totalValue = 0.0;

  @override
  void initState() {
    FeatureDiscovery.hasPreviouslyCompleted(context, 'JumpButton').then((value) {
      if(value == true) {
        setState(() {
          _isDiscovering = false;
        });
      }
    });
    //final String name = arguments['name'] as String;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // FocusScope.of(context).requestFocus(FocusNode());
    super.didChangeDependencies();
  }

  ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;
  bool _showFAB = false;
  bool _isInit = true;
  bool _isDiscovering = true;
  @override
  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
        floatingActionButton: _showFAB ? IRUDMConstants().floatingAnimat(_isScrolling, _isDiscovering, this, _scrollController, context) : const SizedBox(width: 56, height: 120),
        appBar: SearchAppbar(
          title: language.text('summaryOfStock'),
          labelData: 'SummaryOfStock',
        ),
        body: Stack(children: [
          Consumer<SummaryStockProvider>(
              builder: (_, SummaryStockProvider, __) {
                if (SummaryStockProvider.state == SummaryStockState.Busy) {
                  return Center(child: CircularProgressIndicator());
                } else if(SummaryStockProvider.state == SummaryStockState.FinishedWithError) {
                  Future.delayed(Duration.zero, () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.redAccent,
                        duration: Duration(seconds: 3),
                        content: Text(
                          SummaryStockProvider.error!.description.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )));
                  return Container();
                } else if(SummaryStockProvider.state == SummaryStockState.Finished) {
                  Future.delayed(Duration.zero, () {
                    if(_isInit) {
                      setState(() {
                        _showFAB = SummaryStockProvider.stockist!.length > 20;
                        _isScrolling = false;
                      });
                    }
                  }).then((value) async {
                    if(_isInit)
                      FeatureDiscovery.discoverFeatures(context, {'JumpButton'});
                    _isInit = false;
                  });
                  return NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotif) {
                        if (scrollNotif is ScrollStartNotification ||
                            scrollNotif is ScrollUpdateNotification) {
                          setState(() {
                            _isScrolling = true;
                          });
                        }
                        if (scrollNotif is ScrollEndNotification) {
                          setState(() {
                            _isScrolling = false;
                          });
                        }
                        return false;
                      },
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(language.text('totalCount')),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    IRUDMConstants.resultCount(
                                        SummaryStockProvider.countData, true),
                                  ],
                                ),
                                Container(height: 50, child: VerticalDivider(color: Colors.grey)),
                                Column(
                                  children: [
                                    Text(language.text('totalVal')),
                                    SizedBox(height: 3),
                                    Text(_totalValue(SummaryStockProvider.stockist!).toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 3, color: Colors.grey),
                          Expanded(
                              child: Stack(children: [
                                Scrollbar(
                                  thumbVisibility: true,
                                  thickness: 8,
                                  radius: Radius.circular(20),
                                  controller: _scrollController,
                                  child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: SummaryStockProvider.stockist!.length,
                                      itemBuilder: (_, i) {
                                        return ProductBox(
                                          item: SummaryStockProvider.stockist![i],
                                          index: i,
                                          arguments: arguments,
                                        );
                                      }),
                                )
                              ])
                          ),
                        ],
                      ));
                } else {
                  return Container();
                }
              }),
        ]));
  }

  _totalValue(List<SummaryStock> list) {
    totalValue = 0.0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].sTKVALUE != 'NA') {
        totalValue = totalValue + double.parse(list[i].sTKVALUE!);
        assert(totalValue is double);
      }
    }
    return totalValue.toStringAsFixed(2);
  }
}

class ProductBox extends StatelessWidget {
  final SummaryStock? item;
  final int? index;
  final Map<String, dynamic>? arguments;
  const ProductBox({this.item, this.index, this.arguments});
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Container(
        padding: EdgeInsets.only(left: 6, top: 9, right: 6, bottom: 9),
        child: Card(elevation: 6, surfaceTintColor: Colors.white, color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Text(
                      (index! + 1).toString() + '.',
                      softWrap: false,
                      style: TextStyle(fontSize: 14, color: Colors.indigo[800]
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.only(left: 5, top: 5, right: 11, bottom: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 5),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        language.text('consigneeDepot'),
                                        softWrap: false,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.indigo[800]
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 4,
                                        child: Text(
                                          item!.dEPODETAIL! +
                                              "\n" +
                                              item!.iSSUECCODE! +
                                              " - " +
                                              item!.iSSCONSGDEPT! +
                                              "\n" +
                                              item!.rLYNAME!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        )),
                                  ]),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Text('${language.text('ledgerNo')} / ${language.text('ledgerFolioNo')}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800]
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      item!.lEDGERNO! +
                                          " " +
                                          item!.lEDGERNAME! +
                                          "\n" +
                                          item!.lEDGERFOLIONO! +
                                          " " +
                                          item!.lEDGERFOLIONAME!,
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
                                      language.text('pl/itemCode'),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800]
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      item!.lEDGERFOLIOPLNO!,
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
                                      language.text('stockNonStock'),
                                      // 'Stock/Non-Stock',
                                      style: new TextStyle(
                                        fontSize: 14,
                                        color: Colors.indigo[800],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: Text(() {
                                          if(item!.sTKITEM.toString() == 'S') {
                                            return 'Stock';
                                          } else {
                                            return 'Non-Stock';
                                          }
                                        }(),
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
                                    child: Text('${language.text('lastReceipt')} / ${language.text('issueDate')}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.indigo[800],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: Text(item!.lMRDT! + "\n" + item!.lMIDT! + "", style: TextStyle(fontSize: 14, color: Colors.black87)))
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child: Text('${language.text('stock')} / ${language.text('unit')}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrangeAccent, //fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: Text(item!.sTKQTY! + ' ' + item!.sTKUNIT!,
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
                                        language.text('aac'),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800],
                                        ),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        item!.aNTIANNUALCONSUMP!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
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
                                        language.text('thresholdLimit'),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800],
                                        ),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        item!.tHRESHOLDLIMIT!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
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
                                      language.text('averageRateRs'),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.indigo[800],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        item!.bAR!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
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
                                      language.text('valueRs'),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrangeAccent, //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        item!.sTKVALUE!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrangeAccent,
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    language.text('briefDescription'),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 14, color: Colors.indigo[800]),
                                  ),
                                  SizedBox(height: 5.0),
                                  ReadMoreText(
                                    this.item!.lEDGERFOLIONAME! + " : " + item!.lEDGERFOLIOSHORTDESC!,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    trimLines: 2,
                                    colorClickableText: Colors.blue[700],
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: '... More',
                                    trimExpandedText: '...less',
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      item!.pLIMAGEPATH != "NA" ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                          ),
                                          onPressed: () {
                                            Future.delayed(Duration.zero, () {
                                                  IRUDMConstants.launchURL(IRUDMConstants.webUrl + item!.pLIMAGEPATH!);
                                                });
                                          },
                                          child: Icon(
                                            Icons.image,
                                            color: Colors.white,
                                          )) : SizedBox(),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                            backgroundColor: Colors.red.shade300
                                          ),
                                          onPressed: () => _onShareData(
                                              "Consignee Depot : " +
                                                  item!.dEPODETAIL! +
                                                  "\n" +
                                                  item!.iSSUECCODE! +
                                                  " - " +
                                                  item!.iSSCONSGDEPT! +
                                                  "\n" +
                                                  item!.rLYNAME! +
                                                  "\nLedger No./\nLedger Folio No. : " +
                                                  item!.lEDGERNO! +
                                                  " " +
                                                  item!.lEDGERNAME! +
                                                  "\n" +
                                                  item!.lEDGERFOLIONO! +
                                                  " " +
                                                  item!.lEDGERFOLIONAME! +
                                                  "\nPL/Item Code : " +
                                                  item!.lEDGERFOLIOPLNO! +
                                                  "\nLast Receipt/\nIssue Date : " +
                                                  item!.lMRDT! +
                                                  "\n" +
                                                  item!.lMIDT! +
                                                  "\nAAC : " +
                                                  item!.aNTIANNUALCONSUMP! +
                                                  "\nThreshold Limit : " +
                                                  item!.tHRESHOLDLIMIT! +
                                                  "\nAverage Rate (Rs.) : " +
                                                  item!.bAR! +
                                                  "\nValue (Rs.) : " +
                                                  item!.sTKVALUE! +
                                                  "\nStock Quantity :" +
                                                  item!.sTKQTY.toString() +
                                                  " " +
                                                  item!.sTKUNIT! +
                                                  "\nBrief Description : " +
                                                  item!.lEDGERFOLIOSHORTDESC! +
                                                  ""
                                                      "\n",
                                              context),
                                          child: Icon(
                                            Icons.share,
                                            color: Colors.white,
                                          )),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                              backgroundColor: Colors.red.shade300
                                          ),
                                          onPressed: () {
                                            Future.delayed(Duration.zero, () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetails(item!.oRGZONE, item!.iSSUECCODE, item!.sUBCONSCODE)),
                                              );
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                          )),
                                      // Change code here for new implementation
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                              backgroundColor: Colors.red.shade300
                                          ),
                                          onPressed: () {
                                            DateTime frdate = DateTime.now().subtract(const Duration(days: 31));
                                            DateTime tdate = DateTime.now();
                                            final DateFormat formatter = DateFormat('dd-MM-yyyy');
                                            var fromdate = formatter.format(frdate);
                                            var todate = formatter.format(tdate);
                                            Provider.of<SummaryStockProvider>(context, listen: false).fetchSummaryDetail(
                                                item!.oRGZONE,
                                                arguments!['unitType'].toString(),
                                                arguments!['unitname'].toString(),
                                                arguments!['department'].toString(),
                                                arguments!['userdepot'].toString(),
                                                arguments!['usersubdepot'].toString(),
                                                item!.lEDGERNO,
                                                item!.lEDGERFOLIONO,
                                                item!.lEDGERFOLIOPLNO,
                                                fromdate,
                                                todate,
                                                context).then((value) => _showModelSheet(fromdate, todate, context));
                                          },
                                          child: Provider.of<SummaryStockProvider>(context, listen: false).summarystockresultstate == SummaryStockResultState.Busy ? CircularProgressIndicator(strokeWidth: 2.0, color: Colors.blue) : Icon(Icons.description, color: Colors.white)),
                                      // ElevatedButton(
                                      //     style: ElevatedButton.styleFrom(
                                      //       shape: CircleBorder(),
                                      //     ),
                                      //     onPressed: () {
                                      //
                                      //     },
                                      //     child: Icon(
                                      //       Icons.holiday_village_sharp,
                                      //       color: Colors.white,
                                      //     )
                                      // ),
                                    ],
                                  )),
                            ],
                          )))
                ])));
  }

  _onShareData(String data, BuildContext context) async {
    await Share.share(data + "");
  }

  _showModelSheet(String? fdate, String? tdate, BuildContext context) async{
    LanguageProvider language = Provider.of<LanguageProvider>(context, listen: false);
    SummaryStockProvider provider = Provider.of<SummaryStockProvider>(context, listen: false);
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
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: Text(language.text('consignee') + ' - ' + widget.userDepot + '\n' + language.text('subDepot') + ' - ' + widget.userSubDepot, style: TextStyle(color: Colors.black87)),
                // ),
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
                      child: Text(language.text('from') + "  " + fdate.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        language.text('to') + "  " + tdate.toString(),
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
                  Text('(as on ' + tdate! + ')'),
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
                          provider.headerData[0]['ledgerfolioplno'],
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
                          provider.headerData[0]['ledgerfolioname'],
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
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    provider.headerData[0]['ledgerfolioshortdesc'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
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
                          provider.headerData[0]
                          ['unitweight'] !=
                              null
                              ? provider
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
                          itemType(provider
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
                          _itemUsage(provider
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
                          provider.headerData[0]
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
                provider.headerData[0]['antiannualconsump'] != '0.000' ? Column(
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
                              provider.headerData[0]['antiannualconsump'] + " " + provider.headerData[0]['transunit'],
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
                          provider.headerData[0]['thresholdlimit']+" " + provider.headerData[0]['transunit'],
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
                          provider.headerData[0]['transunit'],
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
                          provider.headerData[0]['ledgerno'] + "-" + provider.headerData[0]['ledgername'],
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
                          provider.headerData[0]['ledgerfoliono'],
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
                        Provider.of<SummaryStockProvider>(context, listen: false).setSummaryStockResultState(SummaryStockResultState.Idle);
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
