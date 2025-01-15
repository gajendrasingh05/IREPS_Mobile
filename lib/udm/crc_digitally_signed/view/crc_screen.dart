import 'package:flutter/material.dart';
import 'package:flutter_app/udm/crc_digitally_signed/providers/crcscreen_update_changes.dart';
import 'package:flutter_app/udm/crc_digitally_signed/tabs_views/crc_approval_screen.dart';
import 'package:flutter_app/udm/crc_digitally_signed/tabs_views/crc_finalized_screen.dart';
import 'package:flutter_app/udm/crc_digitally_signed/tabs_views/crc_myfinalised_screen.dart';
import 'package:flutter_app/udm/crc_digitally_signed/tabs_views/crc_myforwaded_screen.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcAwaitingViewModel.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcMyfinalisedViewModel.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcMyforwardedViewModel.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcfinalizedViewModel.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/screens/user_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrcScreen extends StatefulWidget {
  static const routeName = "/crc-screen";

  @override
  State<CrcScreen> createState() => _CrcScreenState();
}

class _CrcScreenState extends State<CrcScreen> with SingleTickerProviderStateMixin {

  final _textsearchController = TextEditingController();

  int _activeindex = 0;

  String gradecode = "";

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    _getUsergradecode();
    //Provider.of<Crcusertype>(context, listen: false).fetchUserData(context);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }


  _getUsergradecode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      gradecode = prefs.getString("gradecode").toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    final updatechangeprovider = Provider.of<CrcupdateChangesScreenProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.red[300],
          automaticallyImplyLeading: false,
          // leading: Consumer<CrcupdateChangesScreenProvider>(builder: (context, value, child) {
          //    if(value.getSearchValue){
          //       return SizedBox.shrink();
          //    }
          //    else{
          //      return IconButton(
          //        splashRadius: 30,
          //        icon: Icon(
          //          Icons.arrow_back,
          //          color: Colors.white,
          //        ),
          //        onPressed: () {
          //          Navigator.of(context, rootNavigator: true).pushNamed(UserHomeScreen.routeName);
          //        },
          //      );
          //    }
          // }),
          title: Consumer<CrcupdateChangesScreenProvider>(
              builder: (context, value, child) {
                if(value.getSearchValue) {
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
                              if(_activeindex == 0 && gradecode == "N"){
                                _textsearchController.text = "";
                                updatechangeprovider.updateScreen(false);
                                Provider.of<CrcMyforwardedViewModel>(context, listen: false).getsearchMyforwardedcrcData(_textsearchController.text, context);
                              }
                              else if(_activeindex == 0 && gradecode != "N"){
                                _textsearchController.text = "";
                                updatechangeprovider.updateScreen(false);
                                Provider.of<CrcAwaitingViewModel>(context, listen: false).getsearchAwaitcrcData(_textsearchController.text, context);
                              }
                              else if(_activeindex == 1 && gradecode == "N"){
                                _textsearchController.text = "";
                                updatechangeprovider.updateScreen(false);
                                Provider.of<CrcMyfinalisedViewModel>(context, listen: false).getsearchMyfinalisedcrcData(_textsearchController.text, context);
                              }
                              else{
                                _textsearchController.text = "";
                                updatechangeprovider.updateScreen(false);
                                Provider.of<CrcfinalizedViewModel>(context, listen: false).getsearchfinalisedcrcData(_textsearchController.text, context);
                              }
                            },
                          ),
                          hintText: language.text('search'),
                          border: InputBorder.none),
                      onChanged: (query) {
                        if(_activeindex == 0 && gradecode == "N"){
                          Provider.of<CrcMyforwardedViewModel>(context, listen: false).getsearchMyforwardedcrcData(query, context);
                        }
                        else if(_activeindex == 0 && gradecode != "N"){
                          Provider.of<CrcAwaitingViewModel>(context, listen: false).getsearchAwaitcrcData(query, context);
                        }
                        else if(_activeindex == 1 && gradecode == "N"){
                          Provider.of<CrcMyfinalisedViewModel>(context, listen: false).getsearchMyfinalisedcrcData(query, context);
                        }
                        else{
                          Provider.of<CrcfinalizedViewModel>(context, listen: false).getsearchfinalisedcrcData(query, context);
                        }
                      },
                    ),
                    ),
                  );
                } else {
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
                      Text(language.text('crcdigisigned').length > 25
                          ? '${language.text('crcdigisigned').substring(0, 25)}...'
                          : language.text('crcdigisigned'), style: TextStyle(color: Colors.white, fontSize: 21))
                    ],
                  );
                }
              }),
          actions: [
            Consumer<CrcupdateChangesScreenProvider>(builder: (context, value, child){
              if(value.getSearchValue){
                return SizedBox();
              }
              else{
                return IconButton(
                    onPressed: () {
                      updatechangeprovider.updateScreen(true);
                    },
                    icon: Icon(Icons.search, color: Colors.white));
              }
            })
          ],
          // bottom: TabBar(
          //   onTap: (tabindex){
          //     _activeindex = tabindex;
          //   },
          //   indicator: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(60)),
          //       color: Colors.blue),
          //   tabs: [
          //     gradecode == "N" ? Tab(child: Text(language.text('myforwarded'))) : Tab(child: Text(language.text('awaitingapproval'))),
          //     gradecode == "N" ?  Tab(child: Text(language.text('myfinalised'))) : Tab(child: Text(language.text('finalizedme'))),
          //   ],
          //   isScrollable: false,
          //   indicatorColor: Colors.white,
          //   indicatorWeight: 3,
          // ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.red[300],
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
                            onTap: (tabindex) {
                              _activeindex = tabindex;
                            },
                            indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                            controller: tabController,
                            tabs: [
                              gradecode == "N" ? Tab(child: Text(language.text('myforwarded'))) : Tab(child: Text(language.text('awaitingapproval'))),
                              gradecode == "N" ?  Tab(child: Text(language.text('myfinalised'))) : Tab(child: Text(language.text('finalizedme'))),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [
                    gradecode == "N" ? CrcmyforwardedScreen() : CrcAwaitingApprovalScreen(),
                    gradecode == "N" ? CrcmyfinalisedScreen() : CrcFinalizedScreen(),
                  ],
                )
              )
            ],
          ),
        ),
        // body: TabBarView(
        //   physics: NeverScrollableScrollPhysics(),
        //   children: [
        //     gradecode == "N" ? CrcmyforwardedScreen() : CrcAwaitingApprovalScreen(),
        //     gradecode == "N" ? CrcmyfinalisedScreen() : CrcFinalizedScreen(),
        //   ],
        // )
    );
  }

}
