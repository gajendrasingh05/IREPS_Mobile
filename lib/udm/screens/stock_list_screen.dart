import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/stock.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/stockProvider.dart';
import 'package:flutter_app/udm/widgets/search_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
//import 'package:share/share.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockListScreen extends StatefulWidget {
  static const routeName = "/Stock-screen";
  @override
  _StockListScreenState createState() => _StockListScreenState();
}

class _StockListScreenState extends State<StockListScreen> with SingleTickerProviderStateMixin {
  String aacData = '';
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
    super.initState();
    _aacData();
  }

  _aacData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('aac') == 'AAC') {
      setState(() {
        debugPrint(prefs.getString('aac'));
        debugPrint('set English AAC');
        aacData = "AAC";
      });
    } else if (prefs.getString('aac') == 'एoएoसीo') {
      setState(() {
        debugPrint('set hindi AAC');
        aacData = "एoएoसीo";
      });
    } else if (prefs.getString('aac') == 'THL') {
      setState(() {
        aacData = 'Threshold Limit';
      });
    } else {
      setState(() {
        aacData = 'सीमा - रेखा';
      });
    }
    // return 0;
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
        floatingActionButton: _showFAB ? IRUDMConstants().floatingAnimat(_isScrolling, _isDiscovering, this, _scrollController, context) : const SizedBox(width: 56, height: 120),
        appBar: SearchAppbar(title: language.text('itemList'), labelData: 'stockAvl'),
        body: Stack(children: [
          Consumer<StockListProvider>(builder: (_, StockListProvider, __) {
            if (StockListProvider.state == StockListState.Busy) {
              return Center(child: CircularProgressIndicator());
            } else if (StockListProvider.state == StockListState.FinishedWithError) {
              Future.delayed(
                    Duration.zero, () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    duration: Duration(seconds: 3),
                    content: Text(
                      StockListProvider.error!.description.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
              )));
              return Container();
            } else if (StockListProvider.state == StockListState.Finished) {
              Future.delayed(Duration.zero, () {
                if (_isInit) {
                  setState(() {
                    _showFAB = StockListProvider.Stockist!.length > 20;
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
                                    StockListProvider.countData, true),
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
                                  _totalValue(StockListProvider.Stockist!)
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
                        child: Stack(
                          children: [
                            Scrollbar(
                              thumbVisibility: true,
                              thickness: 8,
                              radius: Radius.circular(20),
                              // interactive: true,
                              controller: _scrollController,
                              child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: StockListProvider.Stockist!.length,
                                  itemBuilder: (_, i) {
                                    return ProductBox(
                                      item: StockListProvider.Stockist![i],
                                      index: i,
                                      aacdata: aacData,
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
            } else {
              return Container();
            }
          }),
        ]));
  }

  _totalValue(List<Stock> list) {
    totalValue = 0.0;
    for(int i = 0; i < list.length; i++) {
      if(list[i].stkValue != 'NA') {
        totalValue = totalValue + double.parse(list[i].stkValue);
      }
    }
    return totalValue.toStringAsFixed(2);
  }
}

class ProductBox extends StatelessWidget {
  final Stock? item;
  final int? index;
  final String? aacdata;

  const ProductBox({this.item, this.index, this.aacdata});
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Container(
        padding: EdgeInsets.only(left: 6, top: 0, right: 6, bottom: 9),
        child: Card(
            elevation: 6,
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
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
                                    style: TextStyle(fontSize: 14, color: Colors.indigo[800]
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      item!.depotDetail +
                                          "\n" +
                                          item!.issueCode +
                                          " - " +
                                          item!.issueConsgDept +
                                          "\n" +
                                          item!.railway,
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
                                  '${language.text('ledgerNo')}/\n${language.text('ledgerFolioNo')}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.indigo[800]
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  item!.ledgerNo +
                                      " " +
                                      item!.ledgerName +
                                      "\n" +
                                      item!.ledgerFolioNo +
                                      " " +
                                      item!.ledgerFolioName,
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
                                      fontSize: 14, color: Colors.indigo[800]
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  item!.ledgerFolioPlNo,
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
                                  child: Text(() {
                                      if (item!.stkItem.toString() == 'S') {
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
                                child: Text(
                                  '${language.text('lastReceipt')}/\n${language.text('issueDate')}',
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
                                    item!.lmrdt + "\n" + item!.lmidt + "",
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
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  item!.stkqty + ' ' + item!.stkUnit,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text(
                                  aacdata!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.indigo[800],
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Text(() {
                                      if (aacdata == 'AAC') {
                                        debugPrint('aac');
                                        return item!.aac;
                                      } else if (aacdata == 'एoएoसीo') {
                                        debugPrint('एoएoसीo');
                                        return item!.aac;
                                      } else if (aacdata == 'Threshold Limit') {
                                        debugPrint('Threshold Limit');
                                        return item!.thresholdLimit;
                                      } else {
                                        debugPrint('thl');
                                        return item!.thresholdLimit;
                                      }
                                    }(),
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
                                    item!.bar,
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
                                    color: Colors
                                        .deepOrangeAccent, //fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Text(
                                    item!.stkValue,
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
                                style: TextStyle(fontSize: 14, color: Colors.indigo[800]
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 40),
                          ReadMoreText(
                            this.item!.ledgerFolioName +
                                " : " +
                                item!.ledgerFolioShortDesc,
                            style: new TextStyle(
                              color: Colors.deepOrangeAccent,
                            ),
                            trimLines: 2,
                            colorClickableText: Colors.blue[700],
                            trimMode: TrimMode.Line,
                            trimCollapsedText: '... More',
                            trimExpandedText: '...less',
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
                                              item!.depotDetail +
                                              "\n" +
                                              item!.issueCode +
                                              " - " +
                                              item!.issueConsgDept +
                                              "\n" +
                                              item!.railway +
                                              "\nLedger No./\nLedger Folio No. : " +
                                              item!.ledgerNo +
                                              " " +
                                              item!.ledgerName +
                                              "\n" +
                                              item!.ledgerFolioNo +
                                              " " +
                                              item!.ledgerFolioName +
                                              "\nPL/Item Code : " +
                                              item!.ledgerFolioPlNo +
                                              "\nStock/Non-Stock : " +
                                              stkNs(item!.stkItem) +
                                              "\nLast Receipt/\nIssue Date : " +
                                              item!.lmrdt +
                                              "\n" +
                                              item!.lmidt +
                                              "\n$aacdata : " +
                                              (() {
                                                if (aacdata == 'AAC') {
                                                  return item!.aac;
                                                } else if (aacdata ==
                                                    'एoएoसीo') {
                                                  debugPrint('एoएoसीo');
                                                  return item!.aac;
                                                } else if (aacdata ==
                                                    'Threshold Limit') {
                                                  return item!.thresholdLimit;
                                                } else {
                                                  return item!.thresholdLimit;
                                                }
                                              }()) +
                                              "\nAverage Rate (Rs.) : " +
                                              item!.bar +
                                              "\nValue (Rs.) : " +
                                              item!.stkValue +
                                              "\nStock Quantity :" +
                                              item!.stkqty.toString() +
                                              " " +
                                              item!.stkUnit +
                                              "\nBrief Description : " +
                                              item!.ledgerFolioShortDesc +
                                              ""
                                                  "\n",
                                          context),

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

  _onShareData(String data, BuildContext context) async {
    await Share.share(data + "");
  }
}
