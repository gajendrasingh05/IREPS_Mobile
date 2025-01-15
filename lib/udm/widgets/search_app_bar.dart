import 'package:flutter/material.dart';
import 'package:flutter_app/udm/models/high_value.dart';
import 'package:flutter_app/udm/new_posearch_recipt/receipt_provider.dart';
import 'package:flutter_app/udm/onlineBillStatus/actionProvider.dart';
import 'package:flutter_app/udm/onlineBillStatus/statusProvider.dart';
import 'package:flutter_app/udm/providers/SumaryStockProvider.dart';
import 'package:flutter_app/udm/providers/consAnalysisProvider.dart';
import 'package:flutter_app/udm/providers/consSummaryProvider.dart';
import 'package:flutter_app/udm/providers/highValueProvider.dart';
import 'package:flutter_app/udm/providers/itemsProvider.dart';
import 'package:flutter_app/udm/providers/nonMovingProvider.dart';
import 'package:flutter_app/udm/providers/poSearchProvider.dart';
import 'package:flutter_app/udm/providers/stockProvider.dart';
import 'package:flutter_app/udm/providers/storeStkDepotProvider.dart';
import 'package:flutter_app/udm/providers/valueWiseProvider.dart';
import 'package:flutter_app/udm/transaction/transactionListDataProvider.dart';
import 'package:provider/provider.dart';
import '../onlineBillSummary/summaryProvider.dart';
import '../widgets/ripplepainter.dart';
import '../widgets/search_bar.dart';

class SearchAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String? title,labelData;
  Size get preferredSize => Size.fromHeight(56.0);
  const SearchAppbar({this.title,this.labelData});
  @override
  _SearchAppbarState createState() => _SearchAppbarState();
}

class _SearchAppbarState extends State<SearchAppbar>
    with SingleTickerProviderStateMixin {
  double? rippleStartX, rippleStartY;
  late AnimationController _controller;
  late Animation _animation;
  bool isInSearchMode = false;
  var focusnode=  FocusNode;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.addStatusListener(animationStatusListener);
    //FocusScope.of(context).requestFocus(FocusNode());
  }

  animationStatusListener(AnimationStatus animationStatus) {
    if (animationStatus == AnimationStatus.completed) {
      setState(() {
        isInSearchMode = true;
      });
    }
  }

  void onSearchTapUp(TapUpDetails details) {
    setState(() {
      rippleStartX = details.globalPosition.dx;
      rippleStartY = details.globalPosition.dy;
    });

    // print("pointer location $rippleStartX, $rippleStartY");
    _controller.forward();
  }

  cancelSearch() {
    setState(() {
      isInSearchMode = false;
    });
    _controller.reverse();
  }

  onSearchQueryChange(String query) {
    if (widget.labelData == "stockAvl") {
      Provider.of<StockListProvider>(context, listen: false).searchDescription(query);
    }else if(widget.labelData=='StoreDepotStk'){
      Provider.of<StoreStkDepotStateProvider>(context, listen: false).searchDescription(query);
    }else if(widget.labelData=='PoSearch'){
      Provider.of<PoSearchStateProvider>(context, listen: false).searchDescription(query);
    }else if(widget.labelData=='SummaryOfStock'){
      Provider.of<SummaryStockProvider>(context, listen: false).searchDescription(query);
    }else if(widget.labelData=='valueWise'){
      Provider.of<ValueWiseProvider>(context, listen: false).searchDescription(query);
    }else if(widget.labelData=='nonMoving'){
      Provider.of<NonMovingProvider>(context, listen: false).searchDescription(query);
    }else if(widget.labelData=='highValue'){
      Provider.of<HighValueProvider>(context, listen: false).searchDescription(query);
    }else if(widget.labelData =='ConsAnalysis'){
      Provider.of<ConsAnalysisProvider>(context, listen: false).searchDescription(query);
    }else if(widget.labelData=='ConsSummary'){
      Provider.of<ConsSummaryProvider>(context, listen: false).searchDescription(query);
    }else if(widget.labelData=='BillSummary'){
      Provider.of<SummaryProvider>(context, listen: false).searchDescription(query);
    }
    else if(widget.labelData == "itemData"){
      Provider.of<ItemListProvider>(context, listen: false).searchDescription(query);
    }
    else if(widget.labelData == "statusData"){
      Provider.of<StatusProvider>(context, listen: false).searchDescription(query);
    }
    else if(widget.labelData == "Transactions"){
      Provider.of<TransactionListDataProvider>(context, listen: false).searchDescription(query);
    }
    else if(widget.labelData == "Actionpage"){
      Provider.of<ActionProvider>(context, listen: false).searchDescription(query);
    }
    else if(widget.labelData == "UserDepotOfStock"){
      Provider.of<SummaryStockProvider>(context, listen: false).searchsummaryactionDescription(query);
    }
    else if(widget.labelData == "ReciptDetailsScreen"){
      Provider.of<ReceiptProvider>(context, listen: false).searchReciptScreen(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(children: [
      AppBar(
        title: Text("${widget.title}", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[300],
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0).copyWith(right: 15),
              child: Icon(Icons.search),
            ),
            onTapUp: onSearchTapUp,
          ),
          // IconButton(
          //   icon: Icon(Icons.more_vert),
          //   onPressed: () {},
          // ),
        ],
      ),
      AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: RipplePainter(
              containerHeight: widget.preferredSize.height,
              center: Offset(rippleStartX ?? 0, rippleStartY ?? 0),
              // increase radius in % from 0% to 100% of screenWidth
              radius: _animation.value * screenWidth,
              context: context,
            ),
          );
        },
      ),
      isInSearchMode ?
      CustomSearchBar(
        onCancelSearch: cancelSearch,
        onSearchQueryChanged: onSearchQueryChange,
      ) : Container()
    ]);
  }
}
