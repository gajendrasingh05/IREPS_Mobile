import 'package:flutter/material.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view/crc_screen.dart';
import 'package:flutter_app/udm/crc_summary/view/crc_summary_screen.dart';
import 'package:flutter_app/udm/crn_digitally_signed/view/crn_screen.dart';
import 'package:flutter_app/udm/end_user/view/to_user_end_screen.dart';
import 'package:flutter_app/udm/gemorder/gem_OrderDetails/view/gem_order_screen.dart';
import 'package:flutter_app/udm/localization/languageHelper.dart';
import 'package:flutter_app/udm/non_stock_demands/views/non_stock_demands_screen.dart';
import 'package:flutter_app/udm/ns_demand_summary/view/nsdemandsummary_screen.dart';
import 'package:flutter_app/udm/onlineBillStatus/statusDropdown.dart';
import 'package:flutter_app/udm/onlineBillSummary/summaryDropdown.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/network_provider.dart';
import 'package:flutter_app/udm/rejection_warranty/views/warranty_rejection_screen.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views/stock_items_history_sheet_screen.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/view/stocking_proposal_summary_screen.dart';
import 'package:flutter_app/udm/transaction/transaction_search_dropdown.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/view/Warranty_dropdownScreen.dart';
import 'package:flutter_app/udm/warranty_rejection_register/view/warranty_rejection_register_screen.dart';
import 'package:flutter_app/udm/widgets/bottom_Nav/bottom_nav.dart';
import 'package:flutter_app/udm/widgets/consuptionAnalysisFilter.dart';
import 'package:flutter_app/udm/widgets/consuptionSummaryFilter.dart';
import 'package:flutter_app/udm/widgets/custom_rightside_drawer.dart';
import 'package:flutter_app/udm/widgets/highValueFilter.dart';
import 'package:flutter_app/udm/widgets/nonMovingFilter.dart';
import 'package:flutter_app/udm/widgets/poSearch_rightside_drawer.dart';
import 'package:flutter_app/udm/widgets/stock_rightside_drawer.dart';
import 'package:flutter_app/udm/widgets/stock_summary_drawer.dart';
import 'package:flutter_app/udm/widgets/storeDepot_rightside_drawer.dart';
import 'package:flutter_app/udm/widgets/valueWiseStockFilter.dart';
import 'package:provider/provider.dart';

import '../crn_summary/view/crn_summary_screen.dart';

class SearchScreen extends StatefulWidget {

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  List<Map<String, dynamic>> filteredItems = [];

  List<Map<String, dynamic>> gridOneItems = [
    {'icon': 'assets/item1.png', 'label': 'आइटम ढूँढें\nSearch Item'},
    {
      'icon': 'assets/item_search.png',
      'label': 'स्टॉक उपलब्धता\nStock Availability'
    },
    {
      'icon': 'assets/depot_store.png',
      'label': 'भण्डार डिपो स्टॉक\nStores Depot Stock'
    },
    {
      'icon': 'assets/images/po_search.png',
      'label': 'क्रयादेश ढूँढें \nSearch PO'
    },
    {
      'icon': 'assets/summary.png',
      'label': 'स्टॉक का संक्षिप्त विवरण\nSummary of Stock'
    },
    {
      'icon': 'assets/images/non_moving.png',
      'label': 'नॉन-मूविंग आइटम\nNon-Moving Items'
    },
    {
      'icon': 'assets/valueWise.png',
      'label': 'वैल्यू अनुसार स्टॉक\nValue-Wise Stock'
    },
    {
      'icon': 'assets/highValue.png',
      'label': 'उच्च वैल्यू आइटम\nHigh Value Items'
    },
    {
      'icon': 'assets/analysis.png',
      'label': 'खपत का विश्लेषण\nConsumption Analysis'
    },
    {
      'icon': 'assets/cons_summary.png',
      'label': 'खपत का संक्षिप्त विवरण\nConsumption Summary'
    },
    {
      'icon': 'assets/trans.png',
      'label': 'लेनदेन\nTransactions',
    },
    {
      'icon': 'assets/download.png',
      'label': 'ऑनलाइन बिल की स्थितिं \nOn-Line Bill Status'
    },
    {
      'icon': 'assets/edoc_home.png',
      'label': 'ऑनलाइन बिल सारांश \nOn-Line Bill Summary'
    },
    {
      'icon': 'assets/images/crn.png',
      'label': 'सी.आर.एन \nCRN'
    },
    {
      'icon': 'assets/images/udm_crc.png',
      'label': 'सी.आर.सी \nCRC'
    },
    {
      'icon': 'assets/stock.jpg',
      'label': 'स्टॉक आइटम इतिहास पत्रक \nStk. Item History Sheet'
    },
    {
      'icon': 'assets/images/ns_demands.png',
      'label': 'गैर-स्टॉक मांगें \nNS Demands'
    },
    {
      'icon': 'assets/images/gem.png',
      'label': 'रत्न-आदेश विवरण \nGeM Order Details'
    },
    {
      'icon': 'assets/images/warranty.png',
      'label': 'अस्वीकृति/वारंटी \nRejection/Warranty'
    },
    {
      'icon': 'assets/images/demand.jpg',
      'label': 'एनएस डिमांड सारांश \nNS Demand Summary'
    },
    {
      'icon': 'assets/report_icon.png',
      'label': 'वारंटी शिकायत सारांश \nWarranty Complaint Summary'
    },
    {
      'icon': 'assets/images/summary.jpg',
      'label': 'सीआरएन सारांश \nCRN Summary'
    },
    {
      'icon': 'assets/images/stock_sm.jpg',
      'label': 'स्टॉकिंग प्रस्ताव सारांश \nStocking Proposal Summary'
    },
    {
      'icon': 'assets/images/rejection.png',
      'label': 'वारंटी अस्वीकृति रजिस्टर \nWarranty Rejection Register'
    },
    {
      'icon': 'assets/images/crc.png',
      'label': 'सीआरसी सारांश \nCRC Summary'
    },
    {
      'icon': 'assets/images/end_user.png',
      'label': 'अंतिम उपयोगकर्ता के लिए \nTo End User'
    },
  ];

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(gridOneItems);
  }

  void filterItems(String query) {
    setState(() {
      if(query.isEmpty) {
        filteredItems = List.from(gridOneItems);
      } else {
        filteredItems = gridOneItems.where((item) => item['label'].toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isEnglish = Provider.of<LanguageProvider>(context).language == Language.English;
    return Scaffold(
       appBar: AppBar(backgroundColor: Colors.red.shade300, title: TextField(
        onChanged: (value){
          filterItems(value.trim());
        },
        decoration: InputDecoration(
         filled: true,
         fillColor: Colors.grey[200],
         border: OutlineInputBorder(),
         hintText: 'Search....',
         suffixIcon: Icon(Icons.search),
       )), automaticallyImplyLeading: false),
       bottomNavigationBar: CustomBottomNav(currentIndex: 1),
       resizeToAvoidBottomInset: false,
       extendBodyBehindAppBar: false,
       body: Container(
         height: size.height,
         width: size.width,
         child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
             itemCount: filteredItems.length,
             padding: EdgeInsets.zero,
             itemBuilder: (context, index) {
               return Card(
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                 elevation: 4.0,
                 color: Colors.white,
                 child: InkWell(
                   borderRadius: BorderRadius.circular(10),
                   child: Container(
                     decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.all(Radius.circular(8.0))
                     ),
                     padding: EdgeInsets.all(5),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Expanded(child: Image.asset(
                           filteredItems[index]['icon'],
                           fit: BoxFit.contain,
                           width: 80,
                         )),
                         SizedBox(height: 10),
                         Text((filteredItems[index]['label'] as String).split('\n')[isEnglish ? 1 : 0], maxLines: 3,
                             overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,style: TextStyle(fontSize: 12))
                       ],
                     ),
                   ),
                   onTap: () {
                     if(Provider.of<NetworkProvider>(context, listen: false).status == ConnectivityStatus.Offline) {
                       UdmUtilities.showWarningFlushBar(context, Provider.of<LanguageProvider>(context, listen: false).text('checkconnection'));
                     }
                     else{
                       onTapFunction(filteredItems[index]['label']);
                     }
                   },
                 ),
               );
             }),
       ),

    );
  }

  Future<void> onTapFunction(String label) async {
    switch (label) {
      case 'आइटम ढूँढें\nSearch Item':
        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomRightSideDrawer()));
        break;
      case 'स्टॉक उपलब्धता\nStock Availability':
        Navigator.push(context, MaterialPageRoute(builder: (context) => StockRightSideDrawer()));
        break;
      case 'भण्डार डिपो स्टॉक\nStores Depot Stock':
        Navigator.push(context, MaterialPageRoute(builder: (context) => StoreStkDepotRightSideDrawer()));
        break;
      case 'क्रयादेश ढूँढें \nSearch PO':
        Navigator.push(context, MaterialPageRoute(builder: (context) => POSearchRightSideDrawer()));
        break;
      case 'स्टॉक का संक्षिप्त विवरण\nSummary of Stock':
        Navigator.of(context).pushNamed(StockSummarySideDrawer.routeName);
        break;
      case 'नॉन-मूविंग आइटम\nNon-Moving Items':
        Navigator.of(context).pushNamed(NonMovingFilter.routeName);
        break;
      case 'वैल्यू अनुसार स्टॉक\nValue-Wise Stock':
        Navigator.of(context).pushNamed(ValueWiseStockFilter.routeName);
        break;
      case 'उच्च वैल्यू आइटम\nHigh Value Items':
        Navigator.of(context).pushNamed(HighValueFilter.routeName);
        break;
      case 'खपत का विश्लेषण\nConsumption Analysis':
        Navigator.of(context).pushNamed(ConsumtionAnalysisFilter.routeName);
        break;
      case 'खपत का संक्षिप्त विवरण\nConsumption Summary':
        Navigator.of(context).pushNamed(ConsumtionSummaryFilter.routeName);
        break;
      case 'लेनदेन\nTransactions':
        Navigator.of(context).pushNamed(TransactionSearchDropDown.routeName);
        break;
      case 'ऑनलाइन बिल की स्थितिं \nOn-Line Bill Status':
        Navigator.of(context).pushNamed(StatusDropDown.routeName);
        break;
      case 'ऑनलाइन बिल सारांश \nOn-Line Bill Summary':
        Navigator.of(context).pushNamed(SummaryDropdown.routeName);
        break;
      case 'सी.आर.एन \nCRN':
        Navigator.of(context).pushNamed(CrnScreen.routeName);
        break;
      case 'सी.आर.सी \nCRC':
        Navigator.of(context).pushNamed(CrcScreen.routeName);
        break;
      case 'स्टॉक आइटम इतिहास पत्रक \nStk. Item History Sheet':
        Navigator.of(context).pushNamed(StockItemHistorySheetScreen.routeName);
        break;
      case 'गैर-स्टॉक मांगें \nNS Demands':
        Navigator.of(context).pushNamed(NonStockDemandsScreen.routeName);
        break;
      case 'रत्न-आदेश विवरण \nGeM Order Details':
        Navigator.of(context).pushNamed(GemOrderScreen.routeName);
        break;
      case 'अस्वीकृति/वारंटी \nRejection/Warranty':
        Navigator.of(context).pushNamed(WarrantyRejectionScreen.routeName);
        break;
      case 'एनएस डिमांड सारांश \nNS Demand Summary':
        Navigator.of(context).pushNamed(NSDemandSummaryScreen.routeName);
        break;
      case 'वारंटी शिकायत सारांश \nWarranty Complaint Summary':
        Navigator.of(context).pushNamed(WarrantyComplaintDropdown.routeName);
        break;
      case 'सीआरएन सारांश \nCRN Summary':
        Navigator.of(context).pushNamed(CrnSummaryScreen.routeName);
        break;
      case 'स्टॉकिंग प्रस्ताव सारांश \nStocking Proposal Summary':
        Navigator.of(context).pushNamed(StockingProposalSummaryScreen.routeName);
        break;
      case 'वारंटी अस्वीकृति रजिस्टर \nWarranty Rejection Register':
        Navigator.of(context).pushNamed(WarrantyRejectionRegisterScreen.routeName);
        break;
      case 'सीआरसी सारांश \nCRC Summary':
        Navigator.of(context).pushNamed(CrcSummaryScreen.routeName);
        break;
      case 'अंतिम उपयोगकर्ता के लिए \nTo End User':
        Navigator.of(context).pushNamed(ToEndUserScreen.routeName);
        break;
      default:
    }
  }
}
