import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/storeStockDepot.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/storeStkDepotProvider.dart';
import 'package:flutter_app/udm/widgets/search_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
//import 'package:share/share.dart';
import 'package:share_plus/share_plus.dart';


class StoreStkDepotListScreen extends StatefulWidget {
  static const routeName = "/StockDepot-screen";
  @override
  _StoreStkDepotListScreenState createState() =>
      _StoreStkDepotListScreenState();
}

class _StoreStkDepotListScreenState extends State<StoreStkDepotListScreen> with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  late StoreStkDepotStateProvider stkDepotStateProvider;
  @override
  void initState() {
    stkDepotStateProvider =
        Provider.of<StoreStkDepotStateProvider>(context, listen: false);
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
    super.didChangeDependencies();
  }

  _totalValue(List<StoreStkDepot> list) {
    totalValue = 0.0;
    for(int i = 0; i < list.length; i++) {
      if(list[i].rate != 'NA') {
        totalValue = totalValue + double.parse(list[i].rate) * double.parse(list[i].stkqty);
        assert(totalValue is double);
      }
    }
    return totalValue.toStringAsFixed(2);
  }

  bool _isScrolling = false;
  bool _showFAB = false;
  bool _isInit = true;
  bool _isDiscovering = true;
  var totalValue = 0.0;
  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);

    return Scaffold(
        floatingActionButton: _showFAB
            ? IRUDMConstants().floatingAnimat(
            _isScrolling, _isDiscovering, this, _scrollController, context)
            : const SizedBox(width: 56, height: 120),
        appBar: SearchAppbar(
          title: language.text('storesDepotStockList'),
          labelData: 'StoreDepotStk',
        ),
        body: Stack(children: [
          Consumer<StoreStkDepotStateProvider>(
              builder:(_, StoreStkDepotStateProvider, __) {
                if(StoreStkDepotStateProvider.state == StoreStkDepotState.Busy) {
                  return Center(child: CircularProgressIndicator());
                } else if (StoreStkDepotStateProvider.state == StoreStkDepotState.FinishedWithError) {
                  Future.delayed(Duration.zero, () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.redAccent,
                        duration: Duration(seconds: 3),
                        content: Text(
                          StoreStkDepotStateProvider.error!.description.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )));
                  return Container();
                } else if (StoreStkDepotStateProvider.state ==
                    StoreStkDepotState.Finished) {
                  Future.delayed(Duration.zero, () {
                    if (_isInit) {
                      setState(() {
                        _showFAB = stkDepotStateProvider.storeStkDptkList!.length > 20;
                        _isScrolling = false;
                      });
                    }
                  }).then((value) async {
                    if (_isInit)
                      FeatureDiscovery.discoverFeatures(context, {'JumpButton'});
                    _isInit = false;
                  });
                  return NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotif) {
                        if(scrollNotif is ScrollStartNotification || scrollNotif is ScrollUpdateNotification) {
                          setState(() {
                            _isScrolling = true;
                          });
                        }
                        if(scrollNotif is ScrollEndNotification) {
                          setState(() {
                            _isScrolling = false;
                          });
                        }
                        return false;
                      },
                      child: Column(children: [
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
                                  IRUDMConstants.resultCount(stkDepotStateProvider.countData, true),
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
                                    _totalValue(stkDepotStateProvider.storeStkDptkList!).toString(),
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
                                    itemCount: StoreStkDepotStateProvider.storeStkDptkList!.length,
                                    itemBuilder: (_, i) {
                                      return ProductBox(
                                        item: StoreStkDepotStateProvider.storeStkDptkList![i],
                                        index: i,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ))
                      ]));
                } else {
                  return Container();
                }
              }),
        ]));
  }
}

class ProductBox extends StatelessWidget {
  final StoreStkDepot? item;
  final int? index;

  const ProductBox({this.item, this.index});
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);

    return Container(
      padding: EdgeInsets.only(left: 6, top: 9, right: 6, bottom: 9),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10, left: 8),
              child: Text((index! + 1).toString() + '.',
                softWrap: false,
                style: TextStyle(fontSize: 14, color: Colors.indigo[800]),
              ),
            ),
            Expanded(
              child: Container(
                padding:
                EdgeInsets.only(left: 5, top: 5, right: 11, bottom: 10),
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
                              language.text('railway'),
                              softWrap: false,
                              style: TextStyle(fontSize: 14, color: Colors.indigo[800]),
                            ),
                          ),
                          Expanded(
                              flex: 4,
                              child: Text(
                                item?.orgZone ?? 'NA',
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
                          child: Text(
                            language.text('storesDepot'),
                            style: TextStyle(fontSize: 14, color: Colors.indigo[800]),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            item?.storeDepot ?? 'NA',
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
                            language.text('ward'),
                            style: TextStyle(fontSize: 14, color: Colors.indigo[800]
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            item?.ward ??
                                'NA' + '\n' + '(Cat-' + item!.cat + ')',
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
                            language.text('plNo'),
                            style: TextStyle(fontSize: 14, color: Colors.indigo[800],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 4,
                            child: Text(
                              item?.itemCode,
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
                              language.text('rateRs'),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent,
                              ),
                            )),
                        Expanded(
                            flex: 4,
                            child: Text(
                              item?.rate ?? 'NA',
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
                              language.text('stockQty/Unit'),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent,
                              ),
                            )),
                        Expanded(
                          flex: 4,
                          child: Text(
                            (item?.stkqty ?? '') + ' ' + (item?.unit ?? 'NA'),
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
                      children: [
                        Text(
                          language.text('briefDescription'),
                          style: TextStyle(fontSize: 14, color: Colors.indigo[800]),
                        ),
                      ],
                    ),
                    SizedBox(width: 40),
                    Align(
                      alignment: Alignment.topLeft,
                      child: ReadMoreText(
                        this.item?.itemDesc ?? 'NA',
                        style: TextStyle(color: Colors.deepOrangeAccent),
                        trimLines: 2,
                        colorClickableText: Colors.blue[700],
                        trimMode: TrimMode.Line,
                        trimCollapsedText: '... More',
                        trimExpandedText: '...less',
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(shape: CircleBorder(), backgroundColor: Colors.red.shade300),
                                onPressed: () => _onShareData(
                                    "Railway : " +
                                        item!.orgZone +
                                        "\nPL No. :" +
                                        item!.itemCode +
                                        "\nCategory : " +
                                        item!.cat +
                                        "\nStores Depot : " +
                                        item!.storeDepot +
                                        "\nWard : " +
                                        item!.ward +
                                        "\nStock Quantity :" +
                                        item!.stkqty.toString() +
                                        " " +
                                        item!.unit +
                                        "\nBAR : Rs " +
                                        item!.rate +
                                        "\nBrief Description : " +
                                        item!.itemDesc +
                                        "\n",
                                    context),
                                child: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                )),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onShareData(String data, BuildContext context) async {
    await Share.share(data + "");
  }
}
