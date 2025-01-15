import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/high_value.dart';
import 'package:flutter_app/udm/models/non_moving.dart';
import 'package:flutter_app/udm/models/stock.dart';
import 'package:flutter_app/udm/providers/highValueProvider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/nonMovingProvider.dart';
import 'package:flutter_app/udm/providers/stockProvider.dart';
import 'package:flutter_app/udm/widgets/search_app_bar.dart';
import 'package:flutter_app/udm/widgets/stock_rightside_drawer.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
//import 'package:share/share.dart';
import 'package:share_plus/share_plus.dart';

class HighValueScreen extends StatefulWidget {
  static const routeName = "/highValue-screen";
  @override
  _StockListScreenState createState() => _StockListScreenState();
}

class _StockListScreenState extends State<HighValueScreen>
    with SingleTickerProviderStateMixin {
  // HighValueProvider HighValueProvider;
  String aacData = '';
  var totalValue = 0.0;
  @override
  void initState() {
    FeatureDiscovery.hasPreviouslyCompleted(context, 'JumpButton')
        .then((value) {
      if (value == true) {
        setState(() {
          _isDiscovering = false;
        });
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    /* Future.delayed(
        Duration.zero, () => HighValueProvider.fetchAndStoreStockList());*/
    super.didChangeDependencies();
  }

  ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;
  bool _showFAB = false;
  bool _isInit = true;
  bool _isDiscovering = true;
  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
        floatingActionButton: _showFAB
            ? IRUDMConstants().floatingAnimat(
            _isScrolling, _isDiscovering, this, _scrollController, context)
            : const SizedBox(width: 56, height: 120),
        appBar: SearchAppbar(
            title: language.text('highValueItems'), labelData: 'highValue'),
        body: Stack(children: [
          Consumer<HighValueProvider>(builder: (_, HighValueProvider, __) {
            if (HighValueProvider.state == HighValueState.Busy) {
              return Center(child: CircularProgressIndicator());
            } else if (HighValueProvider.state ==
                HighValueState.FinishedWithError) {
              Future.delayed(
                  Duration.zero,
                      () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    duration: Duration(seconds: 3),
                    content: Text(
                      HighValueProvider.error!.description.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )));
              return Container();
            } else if (HighValueProvider.state == HighValueState.Finished) {
              Future.delayed(Duration.zero, () {
                //print("setting ${DateTime.now()}");
                if (_isInit) {
                  setState(() {
                    _showFAB = HighValueProvider.highValueList!.length > 20;
                    _isScrolling = false;
                  });
                  //FeatureDiscovery.clearPreferences(context, {'JumpButton'});
                }
              }).then((value) async {
                //await Future.delayed(Duration(milliseconds: 500));
                if (_isInit)
                  FeatureDiscovery.discoverFeatures(context, {'JumpButton'});
                _isInit = false;
              });
              return NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotif) {
                    // //print(scrollNotif);
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
                                    HighValueProvider.countData, true),
                              ],
                            ),
                            Container(
                                height: 50,
                                child: VerticalDivider(color: Colors.grey)),
                            Column(
                              children: [
                                Text(language.text('totalVal')),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  _totalValue(HighValueProvider.highValueList!)
                                      .toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 3,
                        color: Colors.grey,
                      ),
                      Expanded(
                          child: Stack(children: [
                            Scrollbar(
                              thumbVisibility: true,
                              thickness: 8,
                              radius: Radius.circular(20),
                              // interactive: true,
                              controller: _scrollController,
                              child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount:
                                  HighValueProvider.highValueList!.length,
                                  itemBuilder: (_, i) {
                                    return ProductBox(
                                      item: HighValueProvider.highValueList![i],
                                      index: i,
                                    );
                                  }),
                            )
                          ])),
                    ],
                  ));
            } else {
              return Container();
            }
          }),
        ]));
  }

  _totalValue(List<HighValue> list) {
    totalValue = 0.0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].stkvalue != 'NA') {
        totalValue = totalValue + double.parse(list[i].stkvalue!);
        assert(totalValue is double);
      }
    }
    return totalValue.toStringAsFixed(2);
  }
}

class ProductBox extends StatelessWidget {
  final HighValue? item;
  final int? index;

  const ProductBox({this.item, this.index});
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Container(
        padding: EdgeInsets.only(left: 6, top: 9, right: 6, bottom: 9),
        //padding: EdgeInsets.all(4),
        child: Card(
            elevation: 6,
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  color: Colors.white
              ),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10, left: 8),
                      child: Text(
                        (index! + 1).toString() + '.',
                        softWrap: false,
                        style: TextStyle(fontSize: 14, color: Colors.indigo[800]
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          language.text('consigneeDepot'),
                                          softWrap: false,
                                          style:TextStyle(
                                              fontSize: 14,
                                              color: Colors.indigo[800]
                                            //fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 4,
                                          child: Text(
                                            item!.depodetail! +
                                                "\n" +
                                                item!.issueccode! +
                                                " - " +
                                                item!.issconsgdept! +
                                                "\n" +
                                                item!.rlyname!,
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
                                        '${language.text('ledgerNo')} / ${language.text('ledgerFolioNo')}',
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
                                        item!.ledgerno! +
                                            " " +
                                            item!.ledgername! +
                                            "\n" +
                                            item!.ledgerfoliono! +
                                            " " +
                                            item!.ledgerfolioname!,
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
                                        language.text('pl/itemCode'),
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
                                        item!.ledgerfolioplno!,
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
                                        '${language.text('itemType')} /\n ${language.text('usage')} / \n ${language.text('category')}',
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
                                        itemType() +
                                            "\n" +
                                            _itemUsage() +
                                            "\n" +
                                            item!.itemcat!,
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
                                              () {
                                            if (item!.stkitem.toString() == 'S') {
                                              return 'Stock';
                                            } else {
                                              return 'Non-Stock';
                                            }
                                          }(),
                                          style: new TextStyle(
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
                                        '${language.text('lastReceipt')} / ${language.text('issueDate')}',
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
                                          item!.lmrdt! + "\n" + item!.lmidt! + "",
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
                                          '${language.text('stock')} / ${language.text('unit')}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors
                                                .deepOrangeAccent, //fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                    Expanded(
                                        flex: 4,
                                        child: Text(
                                          item!.stkqty! + ' ' + item!.stkunit!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
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
                                          language.text('thresholdLimit'),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.indigo[800],
                                            //fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                    Expanded(
                                        flex: 4,
                                        child: Text(
                                          item!.thresholdlimit!,
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
                                          //fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 4,
                                        child: Text(
                                          item!.bar!,
                                          style:TextStyle(
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
                                          color: Colors
                                              .deepOrangeAccent, //fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 4,
                                        child: Text(
                                          item!.stkvalue!,
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
                                  children: [
                                    Text(
                                      language.text('briefDescription'),
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.indigo[800]
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: ReadMoreText(
                                    item!.ledgerfolioshortdesc!,
                                    style: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    trimLines: 2,
                                    colorClickableText: Colors.blue[700],
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: '... More',
                                    trimExpandedText: '...less',
                                  ),
                                ),
                                //  SizedBox(width: 40),
                                Padding(
                                    padding: EdgeInsets.only(right: 45),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: CircleBorder(),
                                              backgroundColor: Colors.red.shade300
                                            ),
                                            onPressed: () => _onShareData(
                                                "Consignee Depot : " +
                                                    item!.depodetail! +
                                                    "\n" +
                                                    item!.issueccode! +
                                                    " - " +
                                                    item!.issconsgdept! +
                                                    "\n" +
                                                    item!.rlyname! +
                                                    "\nLedger No./\nLedger Folio No. : " +
                                                    item!.ledgerno! +
                                                    " " +
                                                    item!.ledgername! +
                                                    "\n" +
                                                    item!.ledgerfoliono! +
                                                    " " +
                                                    item!.ledgerfolioname! +
                                                    "\nPL/Item Code : " +
                                                    item!.ledgerfolioplno! +
                                                    "\nItem Type/Usage/Category : " +
                                                    itemType() +
                                                    "\n" +
                                                    _itemUsage() +
                                                    "\n" +
                                                    item!.itemcat! +
                                                    "\nStock/Non-Stock : " +
                                                    stkNs(item!.stkitem) +
                                                    "\nLast Receipt/\nIssue Date : " +
                                                    item!.lmidt! +
                                                    "\n" +
                                                    item!.lmrdt! +
                                                    "\nThreshold Limit : " +
                                                    item!.thresholdlimit! +
                                                    "\nAverage Rate (Rs.) : " +
                                                    item!.bar! +
                                                    "\nValue (Rs.) : " +
                                                    item!.stkvalue! +
                                                    "\nStock Quantity :" +
                                                    item!.stkqty.toString() +
                                                    " " +
                                                    item!.stkunit! +
                                                    "\nBrief Description : " +
                                                    item!.ledgerfolioshortdesc! +
                                                    ""
                                                        "\n",
                                                context),

                                            //color: Theme.of(context).accentColor,
                                            child: Icon(
                                              Icons.share,
                                              color: Colors.white,
                                            )),
                                      ],
                                    )),
                              ],
                            )))
                  ]),
            )));
  }

  String stkNs(String? stk) {
    if (stk == 'S') {
      return 'Stock';
    } else {
      return 'Non-Stock';
    }
  }

  String itemType() {
    if (item!.vs.toString() == 'V') {
      return 'Vital';
    } else if (item!.vs.toString() == 'S') {
      return 'Safety';
    } else if (item!.vs.toString() == 'O') {
      return 'Others';
    } else {
      return 'All';
    }
  }

  _itemUsage() {
    if (item!.consumind.toString() == 'C') {
      return 'Consumable';
    } else if (item!.consumind.toString() == 'M') {
      return 'M&P';
    } else if (item!.consumind.toString() == 'S') {
      return 'M&P Spares';
    } else if (item!.consumind.toString() == 'T') {
      return 'T&P';
    } else if (item!.consumind.toString() == 'P') {
      return 'T&P';
    } else if (item!.consumind.toString() == 'O') {
      return 'Others';
    } else {
      return 'All';
    }
  }

  _onShareData(String data, BuildContext context) async {
    await Share.share(data + "");
  }
}
