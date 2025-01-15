import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/rejection_warranty/providers/search_rwscreen_provider.dart';
import 'package:flutter_app/udm/rejection_warranty/view_tabs/my_approved_dropped_claims_screen.dart';
import 'package:flutter_app/udm/rejection_warranty/view_tabs/my_forwarded_claim_screen.dart';
import 'package:flutter_app/udm/rejection_warranty/view_tabs/warranty_complaint_screen.dart';
import 'package:flutter_app/udm/screens/user_home_screen.dart';
import 'package:provider/provider.dart';


class WarrantyRejectionScreen extends StatefulWidget {
  static const routeName = "/rejection-warranty-screen";

  @override
  State<WarrantyRejectionScreen> createState() => _WarrantyRejectionScreenState();
}

class _WarrantyRejectionScreenState extends State<WarrantyRejectionScreen> with SingleTickerProviderStateMixin{

  String status = "All";
  String statuscode = "-1";

  String fromdate = "";
  String todate = "";

  int _activeindex = 0;

  final _textsearchController = TextEditingController();

  late TabController tabController;

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
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red[300],
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Consumer<SearchRWScreenProvider>(
              builder: (context, value, child) {
                if(value.getSearchValue == true){
                  return Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                    child: Center(child: TextField(
                      cursorColor: Colors.red[300],
                      controller: _textsearchController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.red[300]),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear, color: Colors.red[300]),
                            onPressed: () {
                              Provider.of<SearchRWScreenProvider>(context, listen: false).updateScreen(false);
                              _textsearchController.text = "";
                              Future.delayed(const Duration(milliseconds: 400), () {
                                //Provider.of<NonStockDemandViewModel>(context, listen: false).searchingFwdfinalizedData(_textsearchController.text.toString().trim(), context);
                              });
                            },
                          ),
                          hintText: language.text('search'),
                          border: InputBorder.none),
                      onChanged: (query) {
                        //Provider.of<NonStockDemandViewModel>(context, listen: false).searchingFwdfinalizedData(_textsearchController.text.toString().trim(), context);
                      },
                    ),
                    ),
                  );
                }
                else{
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pushNamed(UserHomeScreen.routeName);
                            //Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, color: Colors.white)),
                      SizedBox(width: 10),
                      Text(language.text('rwtitle'), maxLines: 1, style: TextStyle(color: Colors.white))
                    ],
                  );
                }
              }),
          // bottom: TabBar(
          //   onTap: (tabindex){
          //     _activeindex = tabindex;
          //     _textsearchController.text = "";
          //   },
          //   indicator: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(60)),
          //       color: Colors.blue),
          //   tabs: [
          //     //Tab(child: Text(language.text('rwwarantycmptitle'))),
          //     Tab(child: Text(language.text('fwctitle'))),
          //     Tab(child: Text(language.text('apdtitle'))),
          //     //Tab(child: Text(language.text('casetracker'))),
          //   ],
          //   isScrollable: true,
          //   indicatorColor: Colors.white,
          //   indicatorWeight: 3,
          // ),
        ),
        body: Container(
          height: size.height,
          child: Column(
            children: [
              Container (
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.red.shade300,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(5),
                        child: TabBar(
                          onTap: (tabindex){
                            _activeindex = tabindex;
                            _textsearchController.text = "";
                          },
                          tabs: [
                            //Tab(child: Text(language.text('rwwarantycmptitle'))),
                            Tab(child: Text(language.text('fwctitle'), textAlign: TextAlign.center)),
                            Tab(child: Text(language.text('apdtitle'), textAlign: TextAlign.center)),
                            //Tab(child: Text(language.text('casetracker'))),
                          ],
                          unselectedLabelColor: Colors.white,
                          labelColor: Colors.black,
                          isScrollable: false,
                          indicatorColor: Colors.white,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorWeight: 2,
                          indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                          controller: tabController,
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(child: TabBarView(
                controller: tabController,
                children: [
                      //WarrantyComplaintScreen(),
                      MyForwardedClaimScreen(),
                      MyApprovedDroppedClaimScreen(),
                      //CaseTrackerScreen()
                ],
              ))
            ],
          ),
        ),
        // body: TabBarView(
        //   physics: NeverScrollableScrollPhysics(),
        //   children: [
        //     //WarrantyComplaintScreen(),
        //     MyForwardedClaimScreen(),
        //     MyApprovedDroppedClaimScreen(),
        //     //CaseTrackerScreen()
        //   ],
        // )
    );
  }
}
