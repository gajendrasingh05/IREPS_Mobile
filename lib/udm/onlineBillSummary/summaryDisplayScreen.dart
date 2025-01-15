import 'dart:async';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/onlineBillSummary/summaryLinkDisplayProvider.dart';
import 'package:flutter_app/udm/onlineBillSummary/summaryLinkDisplayScreen.dart';
import 'package:flutter_app/udm/onlineBillSummary/summaryModel.dart';
import 'package:flutter_app/udm/onlineBillSummary/summaryProvider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import '../helpers/shared_data.dart';

import '../widgets/search_app_bar.dart';
import 'package:provider/provider.dart';

//import 'package:share/share.dart';
import 'package:share_plus/share_plus.dart';


class SummaryDisplayScreen extends StatefulWidget {
  static const routeName = "/summaryDisplay-screen";

  @override
  State<SummaryDisplayScreen> createState() => _SummaryDisplayScreenState();
}

class _SummaryDisplayScreenState extends State<SummaryDisplayScreen> with SingleTickerProviderStateMixin {

  late SummaryProvider summaryProvider;
  bool _isAtEnd = false;

  @override
  void initState() {
    summaryProvider = Provider.of<SummaryProvider>(context, listen: false);
    FeatureDiscovery.hasPreviouslyCompleted(context, 'JumpButton').then((value) {
      if(value == true) {
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

  TextStyle _normalTextStyle = TextStyle(
    color: Colors.redAccent,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;
  bool _showFAB = false;
  bool _isInit = true;
  bool _isDiscovering = true;

  var totalValue = 0.0;
  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
        floatingActionButton: _showFAB ? IRUDMConstants().floatingAnimat(_isScrolling, _isDiscovering, this, _scrollController, context) : const SizedBox(width: 56, height: 120),
        appBar: SearchAppbar(title: language.text('on-lineBillSummary'), labelData: 'BillSummary'),
        body: Stack(children: [
          Consumer<SummaryProvider>(builder: (_, summaryProvider, __) {
            if(summaryProvider.state == StatusListState1.Busy) {
              return Center(child: CircularProgressIndicator());
            }
            else if(summaryProvider.state == StatusListState1.FinishedWithError) {
              //  Navigator.of(context).pop();
              Future.delayed(
                  Duration.zero, () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    duration: Duration(seconds: 3),
                    content: Text(
                      summaryProvider.error!.description.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )));
              return Container();
            }
            else if(summaryProvider.state == StatusListState1.Finished) {
              Future.delayed(Duration.zero, () {
                if(_isInit) {
                  saveToDB(summaryProvider.itemList);
                  setState(() {
                    _showFAB = summaryProvider.itemList!.length > 20;
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
                  if(scrollNotif is ScrollEndNotification) {
                    setState(() {
                      _isScrolling = false;
                    });
                  }
                  return false;
                },
                child: Column(
                  children: [
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
                              itemCount: summaryProvider.itemList!.length + 1,
                              itemBuilder: (_, i) {
                                if (i < summaryProvider.itemList!.length) {
                                  return ProductBox(
                                    item: summaryProvider.itemList![i],
                                    index: i,
                                  );
                                }
                                return const SizedBox(height: 75);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          }),
        ]));
  }


  ackAlert(BuildContext context) {
    LanguageProvider language =
    Provider.of<LanguageProvider>(context, listen: false);
    return showDialog(
        context: context,
        builder:
            (_) => Scaffold(
          body: Container(
              padding: EdgeInsets.only(bottom: 50),
              color: Colors.white,
              child: Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  //child: summaryList(context,statusProvider.summaryList!),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "${language.text('totalVal')} = " +summaryProvider.stkValue.toStringAsFixed(2),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.blue[700]),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                      },
                      child:Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.close,color: Colors.black87),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          border: Border.all(
                            width: 3,
                            color: Colors.blue[700]!,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    )
                ),
              ])),
        ));

  }

  void saveToDB(List<Summary>? items) {
    DatabaseHelper.instance.insertonlineSummary(items);
  }
}

class ProductBox extends StatefulWidget {
  final Summary item;
  final int index;

  const ProductBox({
    Key? key,
    required this.item,
    required this.index,
  }) : super(key: key);

 // get fromdate => "15-07-2022";

  @override
  _ProductBoxState createState() => _ProductBoxState();
}

class _ProductBoxState extends State<ProductBox>
    with SingleTickerProviderStateMixin {
  late final LanguageProvider language;
  @override
  void didChangeDependencies() {
    language = Provider.of<LanguageProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _cardTextStyle = TextStyle(
      color: Colors.indigo[900],
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );
    TextStyle _normalTextStyle = TextStyle(
      color: Colors.deepOrangeAccent,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 6, top: 9, right: 6),
          child: Card(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        color: const Color(0xFFFDEDDE),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7.0,
                            horizontal: 12,
                          ).copyWith(right: 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('railname'),
                                            style: _cardTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(widget.item.rAILNAME),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('unitname'),
                                            style: _cardTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child:
                                            Text(widget.item.uNITNAME),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('department'),
                                            style: _cardTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(widget.item.dEPARTMENT),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('consignee'),
                                            style: _cardTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(widget.item.cONSIGNEE),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('payauth'),
                                            style: _cardTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(widget.item.pAUAUTH),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // SizedBox(height: 8),
                                    //============================================================================
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('openbal'),
                                            style: _cardTextStyle,

                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black, fixedSize: Size(160, 36),
                                          ),
                                          onPressed: () {
                                            print("First value ${widget.item.cONSIGNEE!}");
                                            print("Second value ${widget.item.rAILCODE!}");
                                            print("Third value ${widget.item.pAYAUTHCODE!}");
                                            setState(() {
                                             // String fromdate="29-07-2022";
                                              //  reseteValues();
                                              
                                              //var _formKey;
                                              //if (_formKey.currentState!.validate())
                                              {
                                                var summaryLinkDisplayProvider =
                                                Provider.of<SummaryLinkDisplayProvider>(
                                                    context, listen: false);

                                                Navigator.of(context)
                                                    .pushNamed(
                                                    SummaryLinkDisplayScreen
                                                        .routeName);

                                                summaryLinkDisplayProvider
                                                    .fetchOpeningBalance(
                                                    widget.item.cONSIGNEE!.toString().split("-").elementAt(0),
                                                    widget.item.rAILCODE!,
                                                    widget.item.pAYAUTHCODE!,
                                                    //widget.fromdate.toString(),
                                                    widget.item.fROMDATE!,
                                                    context);
                                              }


                                            });
                                          },
                                          //color: Theme.of(context).accentColor,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  widget.item.oPENBAL,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(width: 116),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  size: 20,
                                                  color: Colors.blueAccent,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('billreceived'),
                                            style: _cardTextStyle,
                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black, fixedSize: Size(160, 36),
                                          ),
                                          onPressed: ()
                                          {
                                            setState(() {{
                                                var summaryLinkDisplayProvider =
                                                Provider.of<SummaryLinkDisplayProvider>(
                                                    context, listen: false);
                                                Navigator.of(context)
                                                    .pushNamed(
                                                    SummaryLinkDisplayScreen
                                                        .routeName);
                                                summaryLinkDisplayProvider
                                                    .fetchBillRecived(
                                                    widget.item.cONSIGNEE!.toString().split("-").elementAt(0),
                                                    widget.item.rAILCODE!,
                                                    widget.item.pAYAUTHCODE!,
                                                    widget.item.fROMDATE!,
                                                    context);
                                              }
                                            });
                                          },
                                          child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    widget.item.bILLRECIVED,
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                    SizedBox(width: 116),
                                                  const Icon(
                                                    Icons.arrow_forward,
                                                    size: 20,
                                                    color: Colors.blueAccent,
                                                  ),
                                                ],
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
                                            language.text('billreturned'),
                                            style: _cardTextStyle,

                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black, fixedSize: Size(160, 36),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                                  {
                                                var summaryLinkDisplayProvider =
                                                Provider.of<SummaryLinkDisplayProvider>(
                                                    context, listen: false);

                                                Navigator.of(context)
                                                    .pushNamed(
                                                    SummaryLinkDisplayScreen
                                                        .routeName);

                                                summaryLinkDisplayProvider
                                                    .fetchReturnBill(
                                                    widget.item.cONSIGNEE!.toString().split("-").elementAt(0),
                                                    widget.item.rAILCODE!,
                                                    widget.item.pAYAUTHCODE!,
                                                    //widget.fromdate.toString(),
                                                    widget.item.fROMDATE!,
                                                    context);
                                              }
                                            });
                                          },
                                          //color: Theme.of(context).accentColor,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  widget.item.bILLRETURENED,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(width: 116),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  size: 20,
                                                  color: Colors.blueAccent,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('billpassed'),
                                            style: _cardTextStyle,
                                          ),
                                        ),

                                        TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black, fixedSize: Size(160, 36),
                                          ),
                                          onPressed: () {
                                            setState(() {{
                                                var summaryLinkDisplayProvider =
                                                Provider.of<SummaryLinkDisplayProvider>(
                                                    context, listen: false);

                                                Navigator.of(context)
                                                    .pushNamed(
                                                    SummaryLinkDisplayScreen
                                                        .routeName);

                                                summaryLinkDisplayProvider
                                                    .fetchBillPassed(
                                                    widget.item.cONSIGNEE!.toString().split("-").elementAt(0),
                                                    widget.item.rAILCODE!,
                                                    widget.item.pAYAUTHCODE!,
                                                    //widget.fromdate.toString(),
                                                    widget.item.fROMDATE!,
                                                    widget.item.tODATE!,
                                                    context);
                                              }
                                            });
                                          },
                                          //color: Theme.of(context).accentColor,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  widget.item.bILLPASSED,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(width: 116),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  size: 20,
                                                  color: Colors.blueAccent,
                                                ),
                                              ],
                                            ),
                                          ),

                                        ),
                                      ],
                                    ),
                                    // SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('totalpending'),
                                            style: _cardTextStyle,
                                          ),
                                        ),

                                        TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black, fixedSize: Size(160, 36),
                                          ),
                                          onPressed: () {
                                            setState(() {{
                                                var summaryLinkDisplayProvider =
                                                Provider.of<SummaryLinkDisplayProvider>(context, listen: false);

                                                Navigator.of(context).pushNamed(SummaryLinkDisplayScreen.routeName);

                                                summaryLinkDisplayProvider.fetchPendingBill(
                                                    widget.item.cONSIGNEE!.toString().split("-").elementAt(0),
                                                    widget.item.rAILCODE!,
                                                    widget.item.pAYAUTHCODE!,
                                                    widget.item.tODATE!,
                                                    context);
                                              }
                                            });
                                          },
                                          //color: Theme.of(context).accentColor,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  widget.item.tOTALPENDING,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(width: 116),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  size: 20,
                                                  color: Colors.blueAccent,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //  SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('tttle'),
                                            style: _normalTextStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('pendsevendays'),
                                            style: _cardTextStyle,

                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black, fixedSize: Size(160, 36),
                                          ),
                                          onPressed: () {
                                            setState(() {{
                                                var summaryLinkDisplayProvider =
                                                Provider.of<SummaryLinkDisplayProvider>(
                                                    context, listen: false);

                                                Navigator.of(context)
                                                    .pushNamed(
                                                    SummaryLinkDisplayScreen
                                                        .routeName);

                                                summaryLinkDisplayProvider
                                                    .fetchPending7days(
                                                    widget.item.cONSIGNEE!.toString().split("-").elementAt(0),
                                                    widget.item.rAILCODE!,
                                                    widget.item.pAYAUTHCODE!,
                                                    //widget.fromdate.toString(),
                                                    widget.item.tODATE!,
                                                    context);
                                              }
                                            });
                                          },
                                          //color: Theme.of(context).accentColor,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  widget.item.pENDSEVENDAYS,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(width: 116),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  size: 20,
                                                  color: Colors.blueAccent,
                                                ),
                                              ],
                                            ),
                                          ),

                                        ),
                                      ],
                                    ),
                                    // SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('pendfifteendays'),
                                            style: _cardTextStyle,

                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black, fixedSize: Size(160, 36),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              {
                                                var summaryLinkDisplayProvider =
                                                Provider.of<SummaryLinkDisplayProvider>(
                                                    context, listen: false);
                                                Navigator.of(context)
                                                    .pushNamed(
                                                    SummaryLinkDisplayScreen.routeName);
                                                summaryLinkDisplayProvider
                                                    .fetchPending15days(
                                                    widget.item.cONSIGNEE!.toString().split("-").elementAt(0),
                                                    widget.item.rAILCODE!,
                                                    widget.item.pAYAUTHCODE!,
                                                    //widget.fromdate.toString(),
                                                    widget.item.tODATE!,
                                                    context);
                                              }
                                            });
                                          },
                                          //color: Theme.of(context).accentColor,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  widget.item.pENDFIFTEENDAYS,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(width: 116),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  size: 20,
                                                  color: Colors.blueAccent,
                                                ),
                                              ],
                                            ),
                                          ),

                                        ),
                                      ],
                                    ),
                                    //  SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('pendthirtydays'),
                                            style: _cardTextStyle,

                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black, fixedSize: Size(160, 36),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                                  {
                                                var summaryLinkDisplayProvider =
                                                Provider.of<SummaryLinkDisplayProvider>(
                                                    context, listen: false);

                                                Navigator.of(context)
                                                    .pushNamed(
                                                    SummaryLinkDisplayScreen
                                                        .routeName);

                                                summaryLinkDisplayProvider
                                                    .fetchPending16_30days(
                                                    widget.item.cONSIGNEE!.toString().split("-").elementAt(0),
                                                    widget.item.rAILCODE!,
                                                    widget.item.pAYAUTHCODE!,
                                                    //widget.fromdate.toString(),
                                                    widget.item.tODATE!,
                                                    context);
                                              }
                                            });
                                          },
                                          //color: Theme.of(context).accentColor,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  widget.item.pENDTHIRTYDAYS,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(width: 116),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  size: 20,
                                                  color: Colors.blueAccent,
                                                ),
                                              ],
                                            ),
                                          ),

                                        ),
                                      ],
                                    ),
                                    //  SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            language.text('pendmorethirty'),
                                            style: _cardTextStyle,

                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black, fixedSize: Size(160, 36),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                                  {
                                                var summaryLinkDisplayProvider =
                                                Provider.of<SummaryLinkDisplayProvider>(
                                                    context, listen: false);
                                                Navigator.of(context).pushNamed(SummaryLinkDisplayScreen
                                                        .routeName);
                                                summaryLinkDisplayProvider
                                                    .fetchPendingmore30days(
                                                    widget.item.cONSIGNEE!.toString().split("-").elementAt(0),
                                                    widget.item.rAILCODE!,
                                                    widget.item.pAYAUTHCODE!,
                                                    widget.item.tODATE!,
                                                    context);
                                              }
                                            });
                                          },
                                          //color: Theme.of(context).accentColor,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  widget.item.pENDMORETHIRTY,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,

                                                  ),
                                                ),
                                                SizedBox(width: 116),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  size: 20,
                                                  color: Colors.blueAccent,
                                                ),
                                              ],
                                            ),
                                          ),

                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      //const SizedBox(height: 10),


                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(7.0).copyWith(left: 17),
                        child: AnimatedSize(
                          duration: Duration(milliseconds: 200),
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //===========================================
                              /*Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      language.text('itemdescription'),
                                      style: _cardTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(widget.item.iTEMDESCRIPTION),
                                    ),
                                  ),
                                ],
                              ),*/

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: -7,
                  top: -10,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue[700]!, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: Colors.white,
                      child: Text(
                        (widget.index + 1).toString(),
                        softWrap: false,
                        style: TextStyle(fontSize: 12, color: Colors.blue[900]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _onShareData(String data, BuildContext context) async {
    await Share.share(data + "");
  }
}

class CircleIconData extends StatelessWidget {
  const CircleIconData({
    Key? key,
    //@required this.opacity,
    //@required this.iconData,
    required this.circleBackgroundColor,
    //@required this.iconColor,
    required this.valueTextBackgroundColor,
    required this.valueTextColor,
    required this.descriptionTextColor,
    required this.value,
    required this.description,
    //@required this.iconSize,
    required this.textBgHeight,
    required this.radius,
    required this.fontSize,
    this.shouldSeparate = true,
  }) : super(key: key);

  //final double opacity;
  //final IconData iconData;
  final Color? circleBackgroundColor;
  //final Color iconColor;
  final Color valueTextBackgroundColor;
  final Color valueTextColor;
  final Color? descriptionTextColor;
  final String? value;
  final String description;
  //final double iconSize;
  final double textBgHeight;
  final double radius;
  final double fontSize;
  final bool shouldSeparate;
  @override
  Widget build(BuildContext context) {
    List<String> wordsList = value!.split(RegExp(r'[^a-zA-Z0-9]'));
    String? usableVal;
    if (shouldSeparate) {
      usableVal = value!.splitMapJoin(RegExp(r'[^a-zA-Z0-9]'), onMatch: (str) {
        String val = value!.substring(str.start, str.end).trim();
        //print(val);
        return val;
      }, onNonMatch: (str) {
        //print(str);
        return '\n' + str.trim();
      }).substring(1);
    } else {
      usableVal = value;
    }
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: circleBackgroundColor,
          radius: radius,
          child: ClipOval(
            child: Center(
              child: Container(
                //alignment: Alignment.,
                color: valueTextBackgroundColor,
                constraints: BoxConstraints(
                  maxHeight: radius * 2 - 10,
                ),
                width: double.infinity,
                padding: const EdgeInsets.all(3),

                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    usableVal!,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: fontSize,
                      color: valueTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        Center(
          child: Text(
            description,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize * 0.8,
              color: descriptionTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}




