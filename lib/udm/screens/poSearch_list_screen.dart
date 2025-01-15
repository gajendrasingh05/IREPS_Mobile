import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/poSearch.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/poSearchProvider.dart';
import 'package:flutter_app/udm/screens/pdfVIewForPoSeach.dart';
import 'package:flutter_app/udm/screens/poSearchAction.dart';
import 'package:flutter_app/udm/screens/poSearchIssueDetails.dart';
import 'package:flutter_app/udm/screens/poSearchReceiptDetails.dart';
import 'package:flutter_app/udm/widgets/search_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
//import 'package:share/share.dart';
import 'package:share_plus/share_plus.dart';

class PoSearchListScreen extends StatefulWidget {
  static const routeName = "/poSearch-screen";

  String rlyCode;
  String deptCode;
  String depotCode;
  String purchaseSection;
  String stknonstck;
  String plno;
  String coverageStatus;
  String pofrom;
  String poto;
  String pono;
  String industype;
  String tendertype;
  String datefrom;
  String dateto;
  String potype;
  String vendorname;
  String consigneeCode;
  String inspectionAgency;
  String desc1;
  String desc2;
  String flag;
  String poplacingAuth;
  PoSearchListScreen(
      this.rlyCode,
      this.deptCode,
      this.depotCode,
      this.purchaseSection,
      this.stknonstck,
      this.plno,
      this.coverageStatus,
      this.pofrom,
      this.poto,
      this.pono,
      this.industype,
      this.tendertype,
      this.datefrom,
      this.dateto,
      this.potype,
      this.vendorname,
      this.consigneeCode,
      this.inspectionAgency,
      this.desc1,
      this.desc2,
      this.flag,
      this.poplacingAuth);

  @override
  _PoSearchListScreenState createState() => _PoSearchListScreenState();
}

class _PoSearchListScreenState extends State<PoSearchListScreen>
    with SingleTickerProviderStateMixin {
  late PoSearchStateProvider poSearchStateProvider;

  @override
  void initState() {
    poSearchStateProvider =
        Provider.of<PoSearchStateProvider>(context, listen: false);
    // _scrollController.addListener(_onScrollEvent);
    Future.delayed(Duration.zero, () {
      FeatureDiscovery.hasPreviouslyCompleted(context, 'JumpButton')
          .then((value) {
        if (value == true) {
          setState(() {
            _isDiscovering = false;
          });
        }
      });
      poSearchStateProvider.fetchAndStoreItemsListwithdata(
          widget.rlyCode,
          widget.stknonstck,
          widget.consigneeCode,
          widget.depotCode,
          widget.plno,
          widget.desc1,
          widget.desc2,
          widget.poplacingAuth,
          widget.purchaseSection,
          widget.coverageStatus,
          widget.tendertype,
          widget.inspectionAgency,
          widget.industype,
          widget.potype,
          widget.pono,
          widget.vendorname,
          widget.pofrom,
          widget.poto,
          widget.datefrom,
          widget.dateto,
          context,
          widget.flag,
          widget.deptCode);
    });

    super.initState();
  }

  bool _showFAB = false;
  bool _isScrolling = false;
  bool _isInit = true;
  bool _isDiscovering = true;
  var totalValue = 0.0;
  ScrollController _scrollController = ScrollController();

  // void _onScrollEvent() {
  //   final extentAfter = _scrollController.position.pixels;
  //   if (extentAfter == _scrollController.position.maxScrollExtent || extentAfter == 0.0) {
  //     Provider.of<PoSearchStateProvider>(context, listen: false).setFabState(false);
  //   }
  //   else{
  //     Provider.of<PoSearchStateProvider>(context, listen: false).setFabState(true);
  //   }
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (mounted) {
      _showFAB = false;
      _isInit = false;
      _isDiscovering = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
        floatingActionButton: _showFAB
            ? IRUDMConstants().floatingAnimat(
                _isScrolling, _isDiscovering, this, _scrollController, context)
            : const SizedBox(width: 56, height: 120),
        appBar: SearchAppbar(
          title: language.text('poSearch'),
          labelData: 'PoSearch',
        ),
        body: Stack(children: [
          Consumer<PoSearchStateProvider>(builder: (_, poSearchStateProvider, __) {
            if(poSearchStateProvider.state == PoSearchState.Busy) {
              return Center(child: CircularProgressIndicator());
            }
            else if (poSearchStateProvider.state == PoSearchState.FinishedWithError) {
              Future.delayed(Duration.zero, () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.redAccent,
                        duration: Duration(seconds: 3),
                        content: Text(
                          poSearchStateProvider.error!.description.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )));
              return Container();
            }
            else if (poSearchStateProvider.state == PoSearchState.Finished) {
              Future.delayed(Duration.zero, () {
                if (_isInit) {
                  setState(() {
                    _showFAB = poSearchStateProvider.poSearchList!.length > 4;
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
                    if (scrollNotif is ScrollStartNotification ||
                        scrollNotif is ScrollUpdateNotification) {
                      //poSearchStateProvider.setFabState(true);
                      setState(() {
                        _isScrolling = true;
                      });
                    }
                    if (scrollNotif is ScrollEndNotification) {
                      // poSearchStateProvider.setFabState(true, false);
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
                                    poSearchStateProvider.countData, true),
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
                                  _totalValue(
                                          poSearchStateProvider.poSearchList!)
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
                        child: ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: poSearchStateProvider.poSearchList!.length,
                            itemBuilder: (_, i) {
                              return ProductBox(
                                item: poSearchStateProvider.poSearchList![i],
                                index: i,
                              );
                            }),
                      ),
                    ],
                  ));
            }
            else {
              return Material(
                elevation: 5,
                child: AlertDialog(
                  titleTextStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  title: Text(language.text('noDataFound')),
                  content: Text(language.text('searchWithSameInput')),
                  actions: [
                    TextButton(
                      child: Text(
                        language.text('yes'),
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        poSearchStateProvider.fetchData(context);
                        //Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        language.text('no'),
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            }
          }),
        ]));
  }

  _totalValue(List<POSearch> list) {
    totalValue = 0.0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].pOVALUE != 'NA' || list[i].pOVALUE != null) {
        try {
          totalValue = totalValue + double.parse(list[i].pOVALUE!);
          assert(totalValue is double);
        } catch (e) {
          print(e);
        }
      }
    }
    return totalValue.toStringAsFixed(2);
  }
}

class ProductBox extends StatelessWidget {
  final POSearch? item;
  final int? index;
  const ProductBox({this.item, this.index});

  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Container(
        padding: EdgeInsets.all(5.0),
        color: Colors.white,
        child: Card(
            elevation: 6,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(top: 10, left: 8),
                          child: Text(
                            (index! + 1).toString() + '.',
                            softWrap: false,
                            style:
                                TextStyle(fontSize: 14, color: Colors.indigo[800]
                                    //fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.only(
                                    left: 0, top: 5, right: 0, bottom: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    SizedBox(height: 5),
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              language.text('PONoAndDate'),
                                              softWrap: false,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.indigo[800]),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 4,
                                              child: Text(
                                                item!.pONO! +
                                                    '\n' +
                                                    item!.pODATE! +
                                                    '\n' +
                                                    '(' +
                                                    item!.rAINAME! +
                                                    ')',
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
                                            '${language.text('vendorName')}/\n ${language.text('code')}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.deepOrangeAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            item!.vNAME!,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.deepOrangeAccent,
                                              fontWeight: FontWeight.bold,
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
                                            language.text('POSrNo'),
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
                                            item!.pOSR!,
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
                                            language.text('PLNo'),
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
                                              item!.iTEMCODE!,
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
                                              language.text('consigneeCode'),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.indigo[800],
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              item!.cONSG! +
                                                  " : " +
                                                  item!.cONSIGNEENAME!,
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
                                              language.text('itemQuantity'),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.deepOrangeAccent,
                                                fontWeight: FontWeight.bold,
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              item!.pOQTY! + ' ' + item!.uNIT!,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.deepOrangeAccent,
                                                fontWeight: FontWeight.bold,
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
                                              language.text('deliveryDate'),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.indigo[800],
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              item!.dELIVERYPERIOD!,
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
                                              language.text('itemUnitRate'),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.deepOrangeAccent,
                                                fontWeight: FontWeight.bold,
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              item!.itemRate!,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.deepOrangeAccent,
                                                fontWeight: FontWeight.bold,
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
                                              language.text('itemValue'),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.indigo[800],
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              item!.pOVALUE!,
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
                                              language.text('quantityReceived'),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.indigo[800],
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              item!.sUPPLYQTY!,
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
                                              language.text('paidValue'),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.indigo[800],
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              item!.pAIDVALUE!,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            )),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          language.text('itemDescription'),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.indigo[800]
                                              // fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 40),
                                    ReadMoreText(
                                      this.item!.dES!,
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
                                ))),
                      ]),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Colors.red.shade300),
                            onPressed: () {
                              Future.delayed(Duration.zero, () {
                                if(item!.vIEWPDF!.isEmpty) {
                                  IRUDMConstants()
                                      .showSnack("PDF not found", context);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PdfView(item!.vIEWPDF)),
                                  );
                                }
                              });
                            },
                            child: Icon(
                              Icons.picture_as_pdf_rounded,
                              color: Colors.white,
                            )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Colors.red.shade300),
                            onPressed: () {
                              Future.delayed(Duration.zero, () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PoSearch(item!.rLY, item!.pOKEY)),
                                );
                              });
                            },
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Colors.red.shade300),
                            onPressed: () => _onShareData(
                                "Railway : " +
                                    item!.rAINAME! +
                                    "\nPO No.& Date : " +
                                    item!.pONO! +
                                    " " +
                                    item!.pODATE! +
                                    "\nVendor Name/\n Code : " +
                                    item!.vNAME! +
                                    "\nPO Sr. No. : " +
                                    item!.pOSR! +
                                    "\nPL No. : " +
                                    item!.iTEMCODE! +
                                    "\nConsignee Code :" +
                                    item!.cONSG! +
                                    " : " +
                                    item!.cONSIGNEENAME! +
                                    "\nDelivery Date : " +
                                    item!.dELIVERYPERIOD! +
                                    "\nItem Qty. : " +
                                    item!.pOQTY! +
                                    " " +
                                    item!.uNIT! +
                                    "\nItem Unit Rate (Rs.) : " +
                                    item!.itemRate! +
                                    "\nItem Value (Rs.) : " +
                                    item!.pOVALUE! +
                                    "\nQty.Recd. : " +
                                    item!.sUPPLYQTY! +
                                    "\nPaid Value (Rs.) : " +
                                    item!.pAIDVALUE! +
                                    "\nItem Description : " +
                                    item!.dES! +
                                    "\n",
                                context),
                            child: Icon(
                              Icons.share,
                              color: Colors.white,
                            )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Colors.red.shade300),
                            onPressed: () {
                              Future.delayed(Duration.zero, () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          poSearchReceiptDetails(
                                              item!.pONO, item!.pOSR, item!.rLY)),
                                );
                              });
                            },
                            child: Icon(
                              Icons.receipt,
                              color: Colors.white,
                            )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Colors.red.shade300),
                            onPressed: () {
                              Future.delayed(Duration.zero, () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            POSearchIssueDetails(item!.pONO,
                                                item!.pOSR, item!.rLY)));
                              });
                            },
                            child: Icon(
                              Icons.details_rounded,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  _onShareData(String data, BuildContext context) async {
    await Share.share(data + "");
  }
}
