import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/udm/non_stock_demands/providers/change_ui_provider.dart';
import 'package:flutter_app/udm/non_stock_demands/providers/search_screen_provider.dart';
import 'package:flutter_app/udm/non_stock_demands/tabs_views/awaiting_action_screen.dart';
import 'package:flutter_app/udm/non_stock_demands/tabs_views/dashboard_screen.dart';
import 'package:flutter_app/udm/non_stock_demands/tabs_views/forwardfinalized_screen.dart';
import 'package:flutter_app/udm/non_stock_demands/view_model/non_stock_demand_view_model.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/screens/user_home_screen.dart';
import 'package:provider/provider.dart';

class NonStockDemandsScreen extends StatefulWidget {
  static const routeName = "/nonstockdemands-screen";

  @override
  State<NonStockDemandsScreen> createState() => _NonStockDemandsScreenState();
}

class _NonStockDemandsScreenState extends State<NonStockDemandsScreen> {

  int _activeindex = 0;

  final _textsearchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
        Provider.of<ChangeUiProvider>(context, listen: false).setVisibility(false);
    });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<SearchScreenProvider>(context, listen: false).updateScreen(false);
    //   Provider.of<ChangeUiProvider>(context, listen: false).setVisibility(false);
    // });
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    final updatechangeprovider = Provider.of<SearchScreenProvider>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red[300],
            automaticallyImplyLeading: false,
            title: Consumer<ChangeUiProvider>(
                builder: (context, value, child) {
                  if(value.getVisibility == true) {
                    if(updatechangeprovider.getSearchValue == true){
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
                                  Provider.of<SearchScreenProvider>(context, listen: false).updateScreen(false);
                                  _textsearchController.text = "";
                                  if(_activeindex == 1){
                                    Future.delayed(const Duration(milliseconds: 400), () {
                                      Provider.of<NonStockDemandViewModel>(context, listen: false).searchingFwdfinalizedData(_textsearchController.text.toString().trim(), context);
                                    });
                                  }
                                  else{
                                    Future.delayed(const Duration(milliseconds: 400), () {
                                      Provider.of<NonStockDemandViewModel>(context, listen: false).searchingAwaitingActionData(_textsearchController.text.toString().trim(), context);
                                    });
                                  }
                                },
                              ),
                              hintText: language.text('search'),
                              border: InputBorder.none),
                          onChanged: (query) {
                            if(_activeindex == 1){
                              Provider.of<NonStockDemandViewModel>(context, listen: false).searchingFwdfinalizedData(_textsearchController.text.toString().trim(), context);
                            }
                            else{
                              Provider.of<NonStockDemandViewModel>(context, listen: false).searchingAwaitingActionData(_textsearchController.text.toString().trim(), context);
                            }
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
                          Text(language.text('dashboard'), maxLines: 1, style: TextStyle(color: Colors.white))
                        ],
                      );
                    }
                  }
                  else {
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
                        Text(language.text('dashboard'), maxLines: 1, style: TextStyle(color: Colors.white))
                      ],
                    );
                  }
                }),
            bottom: TabBar(
              unselectedLabelColor: Colors.white,
              labelColor: Colors.black,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 0,
              indicatorPadding: EdgeInsets.zero,
              isScrollable: false,
              padding: EdgeInsets.zero,
              onTap: (tabindex){
                _activeindex = tabindex;
                Provider.of<SearchScreenProvider>(context, listen: false).updateScreen(false);
                _textsearchController.text = "";
                if(tabindex == 1 || tabindex == 2){
                  Provider.of<ChangeUiProvider>(context, listen: false).setVisibility(true);
                }
                else{
                  Provider.of<ChangeUiProvider>(context, listen: false).setVisibility(false);
                }
              },
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  color: Colors.blue),
              tabs: [
                Tab(child: Text(language.text('dashboard'), style: TextStyle(color: Colors.white))),
                Tab(child: Text(language.text('fwdfnd'),style: TextStyle(color: Colors.white))),
                Tab(child: Text(language.text('awaitingaction'),style: TextStyle(color: Colors.white))),
                //Tab(child: Text(language.text('casetracker'))),
              ],
            ),
            actions: [
              Consumer<ChangeUiProvider>(builder: (context, value, child){
                if(value.getVisibility == false && Provider.of<SearchScreenProvider>(context, listen: false).getSearchValue == false){
                  return SizedBox();
                }
                else if(value.getVisibility == true && Provider.of<SearchScreenProvider>(context, listen: false).getSearchValue == false){
                  return IconButton(
                      onPressed: () {
                        Provider.of<SearchScreenProvider>(context, listen: false).updateScreen(true);
                      },
                      icon: Icon(Icons.search, color: Colors.white));
                }
                else if(value.getVisibility == true && Provider.of<SearchScreenProvider>(context, listen: false).getSearchValue == true){
                  return SizedBox();
                }
                else{
                  return SizedBox();
                }
              })
            ],
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              DashBoardScreen(),
              ForwardedfinalisedScreen(),
              AwaitingActionScreen(),
              //CaseTrackerScreen()
            ],
          )
      ),
    );
  }
}
