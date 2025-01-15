import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/localization/languageHelper.dart';
import 'package:flutter_app/udm/models/non_moving.dart';
import 'package:flutter_app/udm/models/stock.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/nonMovingProvider.dart';
import 'package:flutter_app/udm/providers/stockProvider.dart';
import 'package:flutter_app/udm/widgets/custom_rightside_drawer.dart';
import 'package:flutter_app/udm/widgets/search_app_bar.dart';
import 'package:flutter_app/udm/widgets/stock_rightside_drawer.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
//import 'package:share/share.dart';
import 'package:share_plus/share_plus.dart';

class NonMovingScreen extends StatefulWidget {
  static const routeName = "/NonMoving-screen";
  @override
  _StockListScreenState createState() => _StockListScreenState();
}

class _StockListScreenState extends State<NonMovingScreen>
    with SingleTickerProviderStateMixin {
  // NonMovingProvider NonMovingProvider;
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
        Duration.zero, () => NonMovingProvider.fetchAndStoreStockList());*/
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
            title: language.text('nonMovingItems'), labelData: 'nonMoving'),
        body: Stack(children: [
          Consumer<NonMovingProvider>(builder: (_, NonMovingProvider, __) {
            if (NonMovingProvider.state == NonMovingState.Busy) {
              return Center(child: CircularProgressIndicator());
            } else if (NonMovingProvider.state ==
                NonMovingState.FinishedWithError) {
              //  Navigator.of(context).pop();
              Future.delayed(
                  Duration.zero,
                      () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    duration: Duration(seconds: 3),
                    content: Text(
                      NonMovingProvider.error!.description.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )));
              return Container();
            } else if (NonMovingProvider.state == NonMovingState.Finished) {
              Future.delayed(Duration.zero, () {
                //print("setting ${DateTime.now()}");
                if (_isInit) {
                  setState(() {
                    _showFAB = NonMovingProvider.nonMovingList!.length > 20;
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
                                    NonMovingProvider.countData, true),
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
                                  _totalValue(NonMovingProvider.nonMovingList!)
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
                                  NonMovingProvider.nonMovingList!.length,
                                  itemBuilder: (_, i) {
                                    return ProductBox(
                                      item: NonMovingProvider.nonMovingList![i],
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

  _totalValue(List<NonMoving> list) {
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
  final NonMoving? item;
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
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Text(
                      (index! + 1).toString() + '.',
                      softWrap: false,
                      style:
                      new TextStyle(fontSize: 14, color: Colors.indigo[800]
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
                                        style: new TextStyle(
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
                                          style: new TextStyle(
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
                                      style: new TextStyle(
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
                                      style: new TextStyle(
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
                                      '${language.text('itemType')} / \n${language.text('usage')} / \n${language.text('category')}',
                                      // 'Item Type /\n Usage / \n Category',
                                      style: new TextStyle(
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
                                      language.text('stockNonStock'),
                                      style: new TextStyle(
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
                                      style: new TextStyle(
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
                                        '${language.text('stock')} / ${language.text('unit')}',
                                        style: new TextStyle(
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
                                        style: new TextStyle(
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
                                        style: new TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800],
                                          //fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        item!.thresholdlimit!,
                                        style: new TextStyle(
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
                                      style: new TextStyle(
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
                                        style: new TextStyle(
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
                                      style: new TextStyle(
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
                                        style: new TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrangeAccent,
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                              ),
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
                                                  item!.lmrdt! +
                                                  "\n" +
                                                  item!.lmidt! +
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
                ])));
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
