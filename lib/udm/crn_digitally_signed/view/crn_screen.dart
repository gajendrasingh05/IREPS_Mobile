import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:flutter_app/udm/crn_digitally_signed/providers/crnscreen_update_changes.dart';
import 'package:flutter_app/udm/crn_digitally_signed/tabs_views/crn_approval_screen.dart';
import 'package:flutter_app/udm/crn_digitally_signed/tabs_views/crn_finalized_screen.dart';
import 'package:flutter_app/udm/crn_digitally_signed/tabs_views/crn_myfinalised_screen.dart';
import 'package:flutter_app/udm/crn_digitally_signed/tabs_views/crn_myforwaded_screen.dart';
import 'package:flutter_app/udm/crn_digitally_signed/view_model/CrnAwaitingViewModel.dart';
import 'package:flutter_app/udm/crn_digitally_signed/view_model/CrnMyfinalisedViewModel.dart';
import 'package:flutter_app/udm/crn_digitally_signed/view_model/CrnMyforwardedViewModel.dart';
import 'package:flutter_app/udm/crn_digitally_signed/view_model/CrnfinalizedViewModel.dart';
import 'package:flutter_app/udm/onlineBillStatus/statusProvider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/screens/user_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrnScreen extends StatefulWidget {
  static const routeName = "/CRN-Screen";

  @override
  State<CrnScreen> createState() => _CrnScreenState();
}

class _CrnScreenState extends State<CrnScreen>
    with SingleTickerProviderStateMixin {
  double? sheetLeft;
  bool isExpanded = true;
  late StatusProvider statusProvider;

  String? tDate;
  String? fDate;
  TextEditingController description = TextEditingController();

  late TabController tabController;

  //==============================================
  final _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  late List<Map<String, dynamic>> dbResult;
  late SharedPreferences prefs;
  Error? _error;

  final _textsearchController = TextEditingController();

  int _activeindex = 0;

  String gradecode = "";

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    _getUsergradecode();
  }

  _getUsergradecode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      gradecode = prefs.getString("gradecode").toString();
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Future<void> didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language =
        Provider.of<LanguageProvider>(context, listen: false);
    final updatechangeprovider =
        Provider.of<CrnupdateChangesScreenProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red[300],
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        // leading: Consumer<CrnupdateChangesScreenProvider>(
        //     builder: (context, value, child) {
        //       if (value.getSearchValue) {
        //         return SizedBox.shrink();
        //       }
        //       else {
        //         return IconButton(
        //           splashRadius: 30,
        //           icon: Icon(
        //             Icons.arrow_back,
        //             color: Colors.white,
        //           ),
        //           onPressed: () {
        //             Navigator.of(context, rootNavigator: true).pushNamed(UserHomeScreen.routeName);
        //             //Navigator.of(context).pop();
        //             //Navigator.pop(context);
        //           },
        //         );
        //       }
        //     }),
        title: Consumer<CrnupdateChangesScreenProvider>(
            builder: (context, value, child) {
          if (value.getSearchValue) {
            return Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: TextField(
                  cursorColor: Colors.red[300],
                  controller: _textsearchController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.red[300]),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear, color: Colors.red[300]),
                        onPressed: () {
                          if (_activeindex == 0 && gradecode == "N") {
                            _textsearchController.text = "";
                            updatechangeprovider.updateScreen(false);
                            Provider.of<CrnMyforwardedViewModel>(context,
                                    listen: false)
                                .getsearchMyforwardedcrnData(
                                    _textsearchController.text, context);
                          } else if (_activeindex == 0 && gradecode != "N") {
                            _textsearchController.text = "";
                            updatechangeprovider.updateScreen(false);
                            Provider.of<CrnAwaitingViewModel>(context,
                                    listen: false)
                                .getsearchAwaitcrnData(
                                    _textsearchController.text, context);
                          } else if (_activeindex == 1 && gradecode == "N") {
                            _textsearchController.text = "";
                            updatechangeprovider.updateScreen(false);
                            Provider.of<CrnMyfinalisedViewModel>(context,
                                    listen: false)
                                .getsearchMyfinalisedcrnData(
                                    _textsearchController.text, context);
                          } else {
                            _textsearchController.text = "";
                            updatechangeprovider.updateScreen(false);
                            Provider.of<CrnfinalizedViewModel>(context,
                                    listen: false)
                                .getsearchfinalisedcrnData(
                                    _textsearchController.text, context);
                          }
                        },
                      ),
                      hintText: language.text('search'),
                      border: InputBorder.none),
                  onChanged: (query) {
                    if (_activeindex == 0 && gradecode == "N") {
                      Provider.of<CrnMyforwardedViewModel>(context,
                              listen: false)
                          .getsearchMyforwardedcrnData(query, context);
                    } else if (_activeindex == 0 && gradecode != "N") {
                      Provider.of<CrnAwaitingViewModel>(context, listen: false)
                          .getsearchAwaitcrnData(query, context);
                    } else if (_activeindex == 1 && gradecode == "N") {
                      Provider.of<CrnMyfinalisedViewModel>(context,
                              listen: false)
                          .getsearchMyfinalisedcrnData(query, context);
                    } else {
                      Provider.of<CrnfinalizedViewModel>(context, listen: false)
                          .getsearchfinalisedcrnData(query, context);
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
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(UserHomeScreen.routeName);
                      //Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white)),
                SizedBox(width: 10),
                Text(language.text('crndigisigned').length > 25
                    ? '${language.text('crndigisigned').substring(0, 25)}...'
                    : language.text('crndigisigned'), style: TextStyle(color: Colors.white))
              ],
            );
          }
        }),
        actions: [
          Consumer<CrnupdateChangesScreenProvider>(
              builder: (context, value, child) {
            if (value.getSearchValue) {
              return SizedBox();
            } else {
              return IconButton(
                  onPressed: () {
                    updatechangeprovider.updateScreen(true);
                  },
                  icon: Icon(Icons.search, color: Colors.white));
            }
          })
        ],
        // bottom: TabBar(
        //   onTap: (tabindex) {
        //     _activeindex = tabindex;
        //   },
        //   indicator: BoxDecoration(
        //       borderRadius: BorderRadius.all(Radius.circular(60)),
        //       color: Colors.blue),
        //   tabs: [
        //     gradecode == "N"
        //         ? Tab(child: Text(language.text('myforwarded')))
        //         : Tab(child: Text(language.text('awaitingapproval'))),
        //     gradecode == "N"
        //         ? Tab(child: Text(language.text('myfinalised')))
        //         : Tab(child: Text(language.text('finalizedme'))),
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
            Container(
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
                        padding: EdgeInsets.zero,
                        onTap: (tabindex) {
                          _activeindex = tabindex;
                        },
                        indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        controller: tabController,
                        tabs: [

                          gradecode == "N"
                              ? Tab(child: Text(language.text('myforwarded')))
                              : Tab(child: Text(language.text('awaitingapproval'))),
                          gradecode == "N"
                              ? Tab(child: Text(language.text('myfinalised')))
                              : Tab(child: Text(language.text('finalizedme'))),
                        ],
                      )
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(child: TabBarView(
              controller: tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                gradecode == "N"
                    ? CrnmyforwardedScreen()
                    : CrnAwaitingApprovalScreen(),
                gradecode == "N"
                    ? CrnmyfinalisedScreen()
                    : CrnFinalizedScreen(),
              ],
            ))
          ],
        ),
      ),
      // body: TabBarView(
      //   physics: NeverScrollableScrollPhysics(),
      //   children: [
      //     gradecode == "N" ? CrnmyforwardedScreen() : CrnAwaitingApprovalScreen(),
      //     gradecode == "N" ? CrnmyfinalisedScreen() : CrnFinalizedScreen(),
      //   ],
      // ),
    );
  }
}
