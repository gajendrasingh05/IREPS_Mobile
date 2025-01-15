import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/aapoorti/common/CommonScreen.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:flutter_app/aapoorti/dashboard/dashboard.dart';
import 'package:flutter_app/aapoorti/helpdesk/contactdetails/helpdesk.dart';
import 'package:flutter_app/aapoorti/helpdesk/requeststatus/Vendor_Registration_helpdesk.dart';
import 'package:flutter_app/aapoorti/helpdesk/requeststatus/View_Reply_helpdesk.dart';
import 'package:flutter_app/aapoorti/home/auction/lease_payment_status/ChallanStatusDetails.dart';
import 'package:flutter_app/aapoorti/home/auction/lease_payment_status/lease_payment_status_screen.dart';
import 'package:flutter_app/aapoorti/home/auction/live/liveauction.dart';
import 'package:flutter_app/aapoorti/home/auction/lotsearch/lot_search.dart';
import 'package:flutter_app/aapoorti/home/auction/publishedlots/view_published_lot.dart';
import 'package:flutter_app/aapoorti/home/auction/schedules/schedule.dart';
import 'package:flutter_app/aapoorti/home/auction/upcoming/Upcoming.dart';
import 'package:flutter_app/aapoorti/home/home_screen.dart';
import 'package:flutter_app/aapoorti/home/implinks/aac/aac_home.dart';
import 'package:flutter_app/aapoorti/home/implinks/approvedvendors/Approved_Vendors.dart';
import 'package:flutter_app/aapoorti/home/implinks/bannedfirms/BannedFirms.dart';
import 'package:flutter_app/aapoorti/home/implinks/edocs/e_documents.dart';
import 'package:flutter_app/aapoorti/home/tender/closingtoday/closing_today.dart';
import 'package:flutter_app/aapoorti/home/tender/customsearch/custom_search.dart';
import 'package:flutter_app/aapoorti/home/tender/highvaluetender/highvaluetender.dart';
import 'package:flutter_app/aapoorti/home/tender/liveupra/LivUpcomRA.dart';
import 'package:flutter_app/aapoorti/home/tender/searchpoother/search_po_other.dart';
import 'package:flutter_app/aapoorti/home/tender/searchpozonal/searchpozonal.dart';
import 'package:flutter_app/aapoorti/home/tender/tenderstatus/Tender_Status.dart';
import 'package:flutter_app/aapoorti/leftnav/AboutUs.dart';
import 'package:flutter_app/aapoorti/leftnav/Favourites.dart';
import 'package:flutter_app/aapoorti/leftnav/app_info.dart';
import 'package:flutter_app/aapoorti/leftnav/saved_data.dart';
import 'package:flutter_app/aapoorti/login/tenderpayments/payments/Payments.dart';
import 'package:flutter_app/aapoorti/login/bills/pending/PendingBills.dart';
import 'package:flutter_app/aapoorti/home/implinks/edocs/edocs_auction.dart';
import 'package:flutter_app/aapoorti/home/implinks/edocs/edocs_GandS.dart';
import 'package:flutter_app/aapoorti/home/implinks/edocs/edocs_works.dart';
import 'package:flutter_app/aapoorti/provider/generate_otp_provider.dart';
import 'package:flutter_app/mmis/routes/pages.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/services/sharedprefs.dart';
import 'package:flutter_app/udm/crc_digitally_signed/providers/crc_user_type_provider.dart';
import 'package:flutter_app/udm/crc_digitally_signed/providers/crcscreen_update_changes.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view/crc_screen.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcAwaitingViewModel.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcMyfinalisedViewModel.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcMyforwardedViewModel.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcfinalizedViewModel.dart';
import 'package:flutter_app/udm/crc_summary/view/crc_summary_screen.dart';
import 'package:flutter_app/udm/crc_summary/view_model/crc_summary_viewmodel.dart';
import 'package:flutter_app/udm/crn_digitally_signed/providers/crnscreen_update_changes.dart';
import 'package:flutter_app/udm/crn_digitally_signed/view/crn_screen.dart';
import 'package:flutter_app/udm/crn_digitally_signed/view_model/CrnAwaitingViewModel.dart';
import 'package:flutter_app/udm/crn_digitally_signed/view_model/CrnMyfinalisedViewModel.dart';
import 'package:flutter_app/udm/crn_digitally_signed/view_model/CrnMyforwardedViewModel.dart';
import 'package:flutter_app/udm/crn_digitally_signed/view_model/CrnfinalizedViewModel.dart';
import 'package:flutter_app/udm/crn_summary/view/crn_summary_screen.dart';
import 'package:flutter_app/udm/crn_summary/viewModel/crn_summary_viewmodel.dart';
import 'package:flutter_app/udm/end_user/view/to_user_end_screen.dart';
import 'package:flutter_app/udm/end_user/view_models/to_end_user_view_model.dart';
import 'package:flutter_app/udm/gemorder/gem_OrderDetails/providers/gemscreen_update_changes.dart';
import 'package:flutter_app/udm/gemorder/gem_OrderDetails/view/gemOrderdetailsScreen.dart';
import 'package:flutter_app/udm/gemorder/gem_OrderDetails/view/gem_order_screen.dart';
import 'package:flutter_app/udm/gemorder/gem_OrderDetails/view_model/gemViewModel1.dart';
import 'package:flutter_app/udm/new_posearch_recipt/receipt_provider.dart';
import 'package:flutter_app/udm/new_posearch_recipt/receipt_screen.dart';
import 'package:flutter_app/udm/non_stock_demands/providers/change_scroll_visibility_provider.dart';
import 'package:flutter_app/udm/non_stock_demands/providers/change_ui_provider.dart';
import 'package:flutter_app/udm/non_stock_demands/providers/search_screen_provider.dart';
import 'package:flutter_app/udm/non_stock_demands/view_model/non_stock_demand_view_model.dart';
import 'package:flutter_app/udm/non_stock_demands/views/non_stock_demands_screen.dart';
import 'package:flutter_app/udm/ns_demand_summary/providers/search_nsdscreen_provider.dart';
import 'package:flutter_app/udm/ns_demand_summary/view/nsdemandsummary_screen.dart';
import 'package:flutter_app/udm/ns_demand_summary/view_model/NSDemandSummaryViewModel.dart';
import 'package:flutter_app/udm/onlineBillStatus/actionPage.dart';
import 'package:flutter_app/udm/onlineBillStatus/actionProvider.dart';
import 'package:flutter_app/udm/onlineBillStatus/statusDisplayScreen.dart';
import 'package:flutter_app/udm/onlineBillStatus/statusDropdown.dart';
import 'package:flutter_app/udm/onlineBillStatus/statusProvider.dart';
import 'package:flutter_app/udm/onlineBillSummary/summaryDisplayScreen.dart';
import 'package:flutter_app/udm/onlineBillSummary/summaryDropdown.dart';
import 'package:flutter_app/udm/onlineBillSummary/summaryLinkDisplayProvider.dart';
import 'package:flutter_app/udm/onlineBillSummary/summaryLinkDisplayScreen.dart';
import 'package:flutter_app/udm/onlineBillSummary/summaryProvider.dart';
import 'package:flutter_app/udm/rejection_warranty/view_model/rejectionwarranty_view_model.dart';
import 'package:flutter_app/udm/rejection_warranty/views/warranty_rejection_screen.dart';
import 'package:flutter_app/udm/screens/UdmChangePin.dart';
import 'package:flutter_app/udm/screens/advice_note.dart';
import 'package:flutter_app/udm/screens/consAnalysisiListScreen.dart';
import 'package:flutter_app/udm/screens/consSummaryListScreen.dart';
import 'package:flutter_app/udm/screens/consignee_receipt_note.dart';
import 'package:flutter_app/udm/screens/highValueListScreen.dart';
import 'package:flutter_app/udm/screens/issue_note.dart';
import 'package:flutter_app/udm/screens/item_receipt_details.dart';
import 'package:flutter_app/udm/screens/itemlist_screen.dart';
import 'package:flutter_app/udm/screens/login_screen.dart';
import 'package:flutter_app/udm/screens/network_issue_screen.dart';
import 'package:flutter_app/udm/screens/nonMoving_list_screen.dart';
import 'package:flutter_app/udm/screens/stock_list_screen.dart';
import 'package:flutter_app/udm/screens/storeStkDpt_list_screen.dart';
import 'package:flutter_app/udm/screens/sumarystock_list_screen.dart';
import 'package:flutter_app/udm/screens/transaction_issue_against_receipt.dart';
import 'package:flutter_app/udm/screens/udm_splash_screen.dart';
import 'package:flutter_app/udm/screens/user_home_screen.dart';
import 'package:flutter_app/udm/screens/valueWise_list_screen.dart';
import 'package:flutter_app/udm/screens/warranty_claim_details.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/providers/pdf_provider.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/providers/stockhistory_updatechange_screen_provider.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/view_model/StockHistoryViewModel.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views/stock_history_select_list_screen.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views/stock_items_history_sheet_screen.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/view/stocking_proposal_summary_screen.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/view_model/stocking_prosposal_summary_provider.dart';
import 'package:flutter_app/udm/transaction/transactionListDataDisplayScreen.dart';
import 'package:flutter_app/udm/transaction/transactionListDataProvider.dart';
import 'package:flutter_app/udm/transaction/transaction_search_dropdown.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/provider/search.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/view/Warranty_dropdownScreen.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/view_model/WarrantyCompaint_ViewModel.dart';
import 'package:flutter_app/udm/warranty_crn_summary/view/warranty_crn_summary_screen.dart';
import 'package:flutter_app/udm/warranty_crn_summary/view_models/warrantycrnsummary_viewmodel.dart';
import 'package:flutter_app/udm/warranty_rejection_register/view/warranty_rejection_register_screen.dart';
import 'package:flutter_app/udm/warranty_rejection_register/view_model/warranty_rejection_register_view_model.dart';
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
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'aapoorti/common/NoData.dart';
import 'aapoorti/helpdesk/problemreport/ReportOpt.dart';
import 'aapoorti/helpdesk/problemreport/ReportYes.dart';
import 'aapoorti/home/auction/lease_payment_status/leaseApiProvider.dart';
import 'aapoorti/login/IrepsProgress/IrepsProgress.dart';
import 'aapoorti/login/tenderpayments/live/LiveTender.dart';

import 'package:flutter_app/udm/ns_demand_summary/providers/change_nsdscroll_visibility_provider.dart';
import 'package:flutter_app/udm/providers/SumaryStockProvider.dart';
import 'package:flutter_app/udm/providers/change_visibility_provider.dart';
import 'package:flutter_app/udm/providers/consAnalysisProvider.dart';
import 'package:flutter_app/udm/providers/consSummaryProvider.dart';
import 'package:flutter_app/udm/providers/highValueProvider.dart';
import 'package:flutter_app/udm/providers/itemsProvider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/loginProvider.dart';
import 'package:flutter_app/udm/providers/network_provider.dart';
import 'package:flutter_app/udm/providers/nonMovingProvider.dart';
import 'package:flutter_app/udm/providers/poSearchProvider.dart';
import 'package:flutter_app/udm/providers/stockProvider.dart';
import 'package:flutter_app/udm/providers/storeStkDepotProvider.dart';
import 'package:flutter_app/udm/providers/user_provider.dart';
import 'package:flutter_app/udm/providers/valueWiseProvider.dart';
import 'package:flutter_app/udm/providers/versionProvider.dart';
import 'package:path_provider/path_provider.dart'; // For path
import 'package:flutter_app/udm/rejection_warranty/providers/change_rwadscroll_visibility_provider.dart';
import 'package:flutter_app/udm/rejection_warranty/providers/change_rwfcscroll_visibility_provider.dart';
import 'package:flutter_app/udm/rejection_warranty/providers/change_rwscroll_visibility_provider.dart';
import 'package:flutter_app/udm/rejection_warranty/providers/search_rwadscreen_provider.dart';
import 'package:flutter_app/udm/rejection_warranty/providers/search_rwfcscreen_provider.dart';
import 'package:flutter_app/udm/rejection_warranty/providers/search_rwscreen_provider.dart';

import 'mmis/db/adapters/login_resp_adapter.dart';
import 'mmis/db/db_models/userloginrespdb.dart';
import 'package:flutter_app/mmis/helpers/di_services.dart' as di_service;

import 'mmis/localizations/languages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di_service.init();

  SharePreferenceService sharedPreferencesService = SharePreferenceService();

  // Wait for initialization to complete
  await sharedPreferencesService.initPrefs();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);


  await Hive.initFlutter();
  Hive.registerAdapter(LoginRespAdapter());
  await Hive.openBox<UserLoginrespDb>('user');

  runApp(MyApp());
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

var routes = <String, WidgetBuilder>{
  "/closing_today": (BuildContext context) => ClosingToday(),
  "/edoc": (BuildContext context) => Edocs(),
  "/edocs_auction": (BuildContext context) => edocs_auction(),
  "/edocs_GandS": (BuildContext context) => edocs_GandS(),
  "/edocs_works": (BuildContext context) => edocs_works(),
  "/home": (BuildContext context) => HomeScreen(scaffoldKey),
  "/common_screen": (BuildContext context) => CommonScreen(),
  "/custom": (BuildContext context) => CustomSearch(),
  "/aac": (BuildContext context) => DropDown(),
  "/high_tender": (BuildContext context) => DropDownhvt(),
  "/tender_status": (BuildContext context) => Tender(),
  "/favourites": (BuildContext context) => Fav(),
  "/about": (BuildContext context) => AboutUs(),
  "/saved": (BuildContext context) => Saved(),
  "/info": (BuildContext context) => Info(),
  "/lot_search": (BuildContext context) => LotSearch(),
  "/search_zonal": (BuildContext context) => SearchPoZonal(),
  "/help_desk": (BuildContext context) => Help(),
  "/schedule": (BuildContext context) => schedule(),
  "/nodata": (BuildContext context) => NoData(),
  "/noresponse": (BuildContext context) => NoResponse(),

  "/report": (BuildContext context) => ReportaproblemOpt(),
  "/report_yes": (BuildContext context) => ReportaproblemOptYes(),
  "/dashboard": (BuildContext context) => Dashboard(),
  "/approved_vendors": (BuildContext context) => Approvedvendors(),
  "/search_other": (BuildContext context) => SearchPoOther(),

  "/live_auction": (BuildContext context) => Live(),
  "/live_upcoming_ra": (BuildContext context) => LivUpcomRA(),
  "/View_Reply_to_Question": (BuildContext context) => View_Reply_helpdesk(),
  "/helpdesk_vendor": (BuildContext context) => Vendor_Registration_helpdesk1(),
  "/banned_Firms": (BuildContext context) => BannedFirms(),
  "/upcoming": (BuildContext context) => Upcoming(),
  "/published_lot": (BuildContext context) => PublishedLot(),
  //After login routes

  "/pendingbills": (BuildContext context) => PendingBill(),
  "/livetender": (BuildContext context) => LiveTender(),
  "/payments": (BuildContext context) => Payments(),
  "/IrepsProgress": (BuildContext context) => IrepsProgress(),
  "/lease-payment-status": (BuildContext context) => LeasePaymentStatus(),
  ChallanStatusDetails.routename: (BuildContext context) => ChallanStatusDetails(),

  //------------------UDM Application----------------------
  UdmSplashScreen.routeName: (ctx) => UdmSplashScreen(),
  LoginScreen.routeName: (ctx) => LoginScreen(),
  NetworkIssueScreen.routeName: (ctx) => NetworkIssueScreen(),
  UserHomeScreen.routeName: (ctx) => UserHomeScreen(),
  ItemsListScreen.routeName: (ctx) => ItemsListScreen(),
  StatusDiaplayScreen.routeName: (ctx) => StatusDiaplayScreen(),
  ActionPage.routeName: (ctx) => ActionPage(),
  SummaryLinkDisplayScreen.routeName: (ctx) => SummaryLinkDisplayScreen(),
  SummaryDisplayScreen.routeName: (ctx) => SummaryDisplayScreen(),
  UdmChangePin.routeName: (ctx) => UdmChangePin(),
  StockListScreen.routeName: (ctx) => StockListScreen(),
  StockRightSideDrawer.routeName: (ctx) => StockRightSideDrawer(),
  CustomRightSideDrawer.routeName: (ctx) => CustomRightSideDrawer(),
  //new Changes 15-12-2023
  //PoSearchListScreen.routeName: (ctx) => PoSearchListScreen(),
  StoreStkDepotRightSideDrawer.routeName: (ctx) => StoreStkDepotRightSideDrawer(),
  StoreStkDepotListScreen.routeName: (ctx) => StoreStkDepotListScreen(),
  POSearchRightSideDrawer.routeName: (ctx) => POSearchRightSideDrawer(),
  SummaryStockListScreen.routeName: (ctx) => SummaryStockListScreen(),
  StockSummarySideDrawer.routeName: (ctx) => StockSummarySideDrawer(),
  NonMovingFilter.routeName: (ctx) => NonMovingFilter(),
  ValueWiseScreen.routeName: (ctx) => ValueWiseScreen(),
  ValueWiseStockFilter.routeName: (ctx) => ValueWiseStockFilter(),
  HighValueFilter.routeName: (ctx) => HighValueFilter(),
  HighValueScreen.routeName: (ctx) => HighValueScreen(),
  NonMovingScreen.routeName: (ctx) => NonMovingScreen(),
  ConsumtionAnalysisFilter.routeName: (ctx) => ConsumtionAnalysisFilter(),
  ConsumtionSummaryFilter.routeName: (ctx) => ConsumtionSummaryFilter(),
  ConsAnalysisScreen.routeName: (ctx) => ConsAnalysisScreen(),
  ConsSummaryScreen.routeName: (ctx) => ConsSummaryScreen(),
  TransactionSearchDropDown.routeName: (ctx) => TransactionSearchDropDown(),
  TransactionListDataDisplayScreen.routeName: (ctx) => TransactionListDataDisplayScreen('', ''),
  ItemReceiptDetails.routeName: (ctx) => ItemReceiptDetails(),
  ConsigneeReceiptNote.routeName: (ctx) => ConsigneeReceiptNote(),
  AdviceNote.routeName: (ctx) => AdviceNote(),
  IssueNoteDetails.routeName: (ctx) => IssueNoteDetails(),
  WarrantyClaimDetails.routeName: (ctx) => WarrantyClaimDetails(),
  TransactionIssueAgainstReceipt.routeName: (ctx) => TransactionIssueAgainstReceipt(),
  SummaryDropdown.routeName: (ctx) => SummaryDropdown(),
  StatusDropDown.routeName: (ctx) => StatusDropDown(),

  CrnScreen.routeName: (ctx) => CrnScreen(),
  CrcScreen.routeName: (ctx) => CrcScreen(),

  StockItemHistorySheetScreen.routeName: (ctx) => StockItemHistorySheetScreen(),
  StockHistorySelectlistScreen.routeName: (ctx) => StockHistorySelectlistScreen('','', ''),
  Receipt_Screen.routeName: (ctx) => Receipt_Screen(),

  NonStockDemandsScreen.routeName : (ctx) => NonStockDemandsScreen(),

  WarrantyRejectionScreen.routeName : (ctx) => WarrantyRejectionScreen(),

  GemOrderScreen.routeName : (ctx) => GemOrderScreen(),
  GeMBillDetailsScreen.routeName : (ctx) => GeMBillDetailsScreen(''),

  NSDemandSummaryScreen.routeName : (ctx) => NSDemandSummaryScreen(),
  // NSDemandDataSummaryScreen.routeName : (ctx) => ShowCaseWidget(
  //    builder: Builder(builder: (_) => NSDemandDataSummaryScreen("","","","","","","","")),
  // ),

  WarrantyComplaintDropdown.routeName : (ctx) => WarrantyComplaintDropdown(),

  // Stocking Proposal Summary Screen
  StockingProposalSummaryScreen.routeName : (ctx) => StockingProposalSummaryScreen(),

  // CRN Summary Screen
  CrnSummaryScreen.routeName : (ctx) => CrnSummaryScreen(),

  // Warranty Rejection Register
  WarrantyRejectionRegisterScreen.routeName : (ctx) => WarrantyRejectionRegisterScreen(),

  // CRC Summary Screen
  CrcSummaryScreen.routeName : (ctx) => CrcSummaryScreen(),

  //To End User Screen
  ToEndUserScreen.routeName : (ctx) => ToEndUserScreen(),

  //Warranty CRN Summary Screen
  WarrantyCRNSummaryScreen.routeName : (ctx) => WarrantyCRNSummaryScreen()
};

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ChallanStatusProvider()),
          ChangeNotifierProvider(create: (_) => GenerateOtpProvider()),

          //---------------UDM Application-----------------------
          ChangeNotifierProvider(create: (_) => VersionProvider()),
          ChangeNotifierProvider(create: (_) => NetworkProvider()),
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ChangeVisibilityProvider()),

          ChangeNotifierProvider(create: (_) => ItemListProvider()),
          ChangeNotifierProvider(create: (_) => StockListProvider()),
          ChangeNotifierProvider(create: (_) => PoSearchStateProvider()),
          ChangeNotifierProvider(create: (_) => StoreStkDepotStateProvider()),
          ChangeNotifierProvider(create: (_) => SummaryStockProvider()),
          ChangeNotifierProvider(create: (_) => ValueWiseProvider()),
          ChangeNotifierProvider(create: (_) => NonMovingProvider()),
          ChangeNotifierProvider(create: (_) => HighValueProvider()),
          ChangeNotifierProvider(create: (_) => ConsAnalysisProvider()),
          ChangeNotifierProvider(create: (_) => ConsSummaryProvider()),
          ChangeNotifierProvider(create: (_) => TransactionListDataProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => SummaryProvider()),
          ChangeNotifierProvider(create: (_) => ActionProvider()),
          ChangeNotifierProvider(create: (_) => StatusProvider()),
          ChangeNotifierProvider(create: (_) => SummaryLinkDisplayProvider()),

          ChangeNotifierProvider(create: (_) =>  CrnupdateChangesScreenProvider()),
          ChangeNotifierProvider(create: (_) =>  CrcupdateChangesScreenProvider()),

          ChangeNotifierProvider(create: (_) =>  CrnAwaitingViewModel()),
          ChangeNotifierProvider(create: (_) =>  CrnfinalizedViewModel()),
          ChangeNotifierProvider(create: (_) =>  CrnMyforwardedViewModel()),
          ChangeNotifierProvider(create: (_) =>  CrnMyfinalisedViewModel()),

          ChangeNotifierProvider(create: (_) =>  CrcAwaitingViewModel()),
          ChangeNotifierProvider(create: (_) =>  CrcfinalizedViewModel()),
          ChangeNotifierProvider(create: (_) =>  CrcMyforwardedViewModel()),
          ChangeNotifierProvider(create: (_) =>  CrcMyfinalisedViewModel()),

          ChangeNotifierProvider(create: (_) =>  Crcusertype()),
          ChangeNotifierProvider(create: (_) =>  CrcfinalizedViewModel()),

          ChangeNotifierProvider(create: (_) => StockHistoryupdateChangesScreenProvider()),
          ChangeNotifierProvider(create: (_) => StockHistoryViewModel()),
          ChangeNotifierProvider(create: (_) => ReceiptProvider()),

          ChangeNotifierProvider(create: (_) => PdfProvider()),

          ChangeNotifierProvider(create: (_) => NonStockDemandViewModel()),
          ChangeNotifierProvider(create: (_) => ChangeUiProvider()),
          ChangeNotifierProvider(create: (_) => SearchScreenProvider()),
          ChangeNotifierProvider(create: (_) => ChangeScrollVisibilityProvider()),

          ChangeNotifierProvider(create: (_) => RejectionWarrantyViewModel()),
          ChangeNotifierProvider(create: (_) => ChangeRWScrollVisibilityProvider()),
          ChangeNotifierProvider(create: (_) => SearchRWScreenProvider()),

          ChangeNotifierProvider(create: (_) => ChangeRWFCScrollVisibilityProvider()),
          ChangeNotifierProvider(create: (_) => SearchRWFCScreenProvider()),

          ChangeNotifierProvider(create: (_) => ChangeRWADCScrollVisibilityProvider()),
          ChangeNotifierProvider(create: (_) => SearchRWADCScreenProvider()),

          ChangeNotifierProvider(create: (_) => GemOrderupdateChangesScreenProvider()),
          ChangeNotifierProvider(create: (_) => GemOrderViewModel()),

          ChangeNotifierProvider(create: (_) => NSDemandSummaryViewModel()),
          ChangeNotifierProvider(create: (_) => ChangeNSDScrollVisibilityProvider()),
          ChangeNotifierProvider(create: (_) => SearchNSDScreenProvider()),

          ChangeNotifierProvider(create: (_) => WarrantyComplaintViewModel()),
          ChangeNotifierProvider(create: (_) => SearchWarrantyComplaint()),

          // Stocking Proposal Summary
          ChangeNotifierProvider(create: (_) => StockingProposalSummaryProvider()),

          // CRN Summary Screen
          ChangeNotifierProvider(create: (_) => CrnSummaryViewModel()),

          // Warranty Rejection Register
          ChangeNotifierProvider(create: (_) => WarrantyRejectionRegisterViewModel()),

          // CRN Summary Screen
          ChangeNotifierProvider(create: (_) => CrcSummaryViewModel()),

          // To End User Screen
          ChangeNotifierProvider(create: (_) => ToEndUSerViewModel()),

          //Warranry CRN Summary Screen
          ChangeNotifierProvider(create: (_) => WarrantyCrnSummaryViewModel()),
        ],
        child: FeatureDiscovery(
          recordStepsInSharedPreferences: true,
          sharedPreferencesPrefix: 'FeatureDiscovery',
          child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.cyan,
                primaryColor: Colors.cyan[400],
                fontFamily: 'Roboto',
                useMaterial3: true,
                textTheme: TextTheme(
                  bodySmall: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal,
                      color: Colors.blueGrey),
                ),
              ),
              translations: Languages(), // Set up translations
              locale: Locale('en', 'US'), // Default language (English)
              fallbackLocale: Locale('en', 'US'), // Fallback to English if language is not supported
              getPages: Pages.list,
              initialRoute: Routes.splashScreen,
              //initialRoute: Routes.performanceDB,
              routes: routes),
        ));
  }
}
