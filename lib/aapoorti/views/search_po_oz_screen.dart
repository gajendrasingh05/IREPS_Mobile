import 'package:flutter/material.dart';

import '../home/tender/searchpoother/search_po_other.dart';
import '../home/tender/searchpozonal/searchpozonal.dart';

class SearchPoOtherZonalScreen extends StatefulWidget {

  @override
  State<SearchPoOtherZonalScreen> createState() => _SearchPoOtherZonalScreenState();
}

class _SearchPoOtherZonalScreenState extends State<SearchPoOtherZonalScreen> with SingleTickerProviderStateMixin{

  late TabController tabController;

  int _activeindex = 0;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.cyan[400],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Search PO (Zonal & Other)", style: TextStyle(color: Colors.white)),
      ),
      body : Container(
        height: MediaQuery.of(context).size.height,
        child : Column(
          children : [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.cyan[700],
                borderRadius: BorderRadius.circular(0),
              ),
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: TabBar(
                        unselectedLabelColor: Colors.white,
                        labelColor: Colors.black,
                        indicatorColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 0,
                        indicatorPadding: EdgeInsets.zero,
                        isScrollable: false,
                        padding: EdgeInsets.zero,
                        onTap: (tabindex) {
                          _activeindex = tabindex;
                        },
                        indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        controller: tabController,
                        tabs: [
                          Tab(child: Text("Search PO (Zonal)")),
                          Tab(child: Text("Search PO (Other)"))

                        ],
                      )
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child : TabBarView(
                controller: tabController,
                physics: NeverScrollableScrollPhysics(),
                children : [
                  SearchPoZonal(),
                  SearchPoOther()
                ]
              )
            )
          ]
        )
      )
    );
  }
}
