import 'dart:async';
import 'dart:io';

import 'package:flutter_app/udm/models/cons_analysis.dart';
import 'package:flutter_app/udm/models/cons_summary.dart';
import 'package:flutter_app/udm/models/high_value.dart';
import 'package:flutter_app/udm/models/item.dart';
import 'package:flutter_app/udm/models/non_moving.dart';
import 'package:flutter_app/udm/models/poSearch.dart';
import 'package:flutter_app/udm/models/stock.dart';
import 'package:flutter_app/udm/models/storeStockDepot.dart';
import 'package:flutter_app/udm/models/summaryStock.dart';
import 'package:flutter_app/udm/models/valueWise.dart';
import 'package:flutter_app/udm/onlineBillStatus/actionModel.dart';
import 'package:flutter_app/udm/onlineBillStatus/statusModel.dart';
import 'package:flutter_app/udm/onlineBillSummary/summaryModel.dart';
import 'package:flutter_app/udm/transaction/transactionListDataModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final _databaseName = "IRUDM.db";
  static final _databaseVersion = 26;


  //TABLE-2 Version Control
  static final String TABLE_NAME_2 = "VersionControl";
  static final String Tbl2_Col1_Date = "Date";
  static final String Tbl2_Col2_UpdateFlag = "UpdateFlag"; //0 - Not Needed   // 1 - Needed  // 2 - Not Necessary(Update Later)
  static final String Tbl2_Col3_LatestVersion = "LatestVersion";



  //TABLE-2 Save Login User
  static final String TABLE_NAME_3 = "SaveLoginUser";
  static final String Tbl3_Col1_Hash = "Hash";
  static final String Tbl3_Col2_Date = "Date";
  static final String Tbl3_Col3_Ans = "Ans";
  static final String Tbl3_Col4_Log = "Log";
  static final String Tb3_col5_emailid = "UserId";
  static final String Tb3_col6_loginFlag = "LoginFlag";
  static final String Tb3_col7_mobile = "Mobile";
  static final String Tb3_col8_userName = "UserName";
  static final String Tb3_col9_UserVlue = "UserValue";
  static final String Tb3_col10_LastLogin = "LastLogin";
  static final String Tb3_col11_WKArea = "WkArea";
  static final String Tb3_col12_OuName = "OuNanme";


  //ItemsTable
  static final String TABLE_NAME_4 = "Items";
  static final String Tbl4_col1_item_code = "cons_code";
  static final String Tbl4_col2_ledger_name = "ledgername";
  static final String Tbl4_col3_stock_qty = "stockqty";
  static final String Tbl4_col5_desc = "itemdescription";
  static final String Tbl4_col4_rate = "booavgrat";
  static final String Tbl4_col5_ORGZONE = "orgzone";
  static final String Tbl4_col6_SUBCONSCODE = "subconscode";
  static final String Tbl4_col7_PLNUMBER = "plnumber";
  static final String Tbl4_col8_DEPODETAIL = "depodetail";
  static final String Tbl4_col9_ISSUEDEPT = "issuedept";
  static final String Tbl4_col10_ISSUEDIV = "issuediv";
  static final String Tbl4_col11_ITEMCAT = "itemcat";
  static final String Tbl4_col12_ISSUECCODE = "issueccode";
  static final String Tbl4_col13_RLYNAME = "rlyname";
  static final String Tbl4_col14_DIVNAME = "divname";
  static final String Tbl4_col15_ISSCONSGDEPT = "issconsgdept";
  static final String Tbl4_col16_POSTNAME = "postname";
  static final String Tbl4_col17_LEDGERNO = "ledgerno";
  static final String Tbl4_col18_FOLIONAME = "folioname";
  static final String Tbl4_col19_PLIMAGEPATH = "plimagepath";
  static final String Tbl4_col20_UNITCODE = "unitcode";
  static final String Tbl4_col21_UNIT = "unit";
  static final String Tbl4_col22_BOOAVGRAT = "rat";
  static final String Tbl4_col23_STKNS = "stkns";

  //Stock Avl item
  static final String TABLE_NAME_5 = "Stock";
  static final String Tbl5_itemCat = "itemcat";
  static final String Tbl5_aac = "aac";
  static final String Tbl5_depoDetail = "depodetail";
  static final String Tbl5_isseCCode = "issueccode";
  static final String Tbl5_railway = "rlyname";
  static final String Tbl5_stkItem = "stkitem";
  static final String Tbl5_issueConsDept = "issconsgdept";
  static final String Tbl5_ledgerNo = "ledgerno";
  static final String Tbl5_vs = "vs";
  static final String Tbl5_consumeId = "consumind";
  static final String Tbl5_ledgerName = "ledgername";
  static final String Tbl5_ledgerFolioNo = "ledgerfoliono";
  static final String Tbl5_ledgerFolioName = "ledgerfolioname";
  static final String Tbl5_ledgerFolioPlNo = "ledgerfolioplno";
  static final String Tbl5_ledgerFolioDesc = "ledgerfolioshortdesc";
  static final String Tbl5_lmrdt = "lmrdt";
  static final String Tbl5_lmidt = "lmidt";
  static final String Tbl5_stkQty = "stkqty";
  static final String Tbl5_bar = "bar";
  static final String Tbl5_stkValue = "stkvalue";
  static final String Tbl5_stkUnit = "stkunit";
  static final String Tbl5_thresholdLimit = "thresholdlimit";

//-------StoreStockDepot-------------
  static final String TABLE_NAME_6 = "StoreStockDepot";
  static final String Tbl6_orgZone = "orgzone";
  static final String Tbl6_Cat = "cat";
  static final String Tbl6_StoreDepot = "storedepot";
  static final String Tbl6_ward = "ward";
  static final String Tbl6_ItemCode = "itemcode";
  static final String Tbl6_itemDescr = "itemdescription";
  static final String Tbl6_rate = "rate";
  static final String Tbl6_stkqty = "stockqty";
  static final String Tbl6_unit = "unit";

  //-------PO Search-------------
  static final String TABLE_NAME_7 = "POSearch";
  static final String Tbl7_railway = "rlyname";
  static final String Tbl7_consg = "consg";
  static final String Tbl7_postStatus = "postatus";
  static final String Tbl7_poKey = "pokey";
  static final String Tbl7_poNo= "pono";
  static final String Tbl7_poDate= "podate";
  static final String Tbl7_vName="vname";
  static final String Tbl7_stkNs= "stkns";
  static final String Tbl7_poValue="povalue";
  static final String Tbl7_unit="unit";
  static final String Tbl7_itemCode = "itemcode";
  static final String Tbl7_des = "des";
  static final String Tbl7_posr= "posr";
  static final String Tbl7_cnsgnName="consigneename";
  static final String Tbl7_poQty = "poqty";
  static final String Tbl7_delPerId="deliveryperiod";
  static final String Tbl7_raiName="rainame";
  static final String Tbl7_splQty="supplyqty";
  static final String Tbl7_canclAtInQty="cancellationqty";
  static final String Tbl7_rly="rly";
  static final String Tbl7_inspAgency="inspectionacgency";
  static final String Tbl7_paidValue="paidvalue";
  //static final String Tbl7_nvl="NVL";
  //static final String Tbl7_instryType="industry_type";
  // static final String Tbl7_poSlot="po_slot";
  static final String Tbl7_itemrate='itemrate';
  static final String Tbl7_viewPdf="viewpdf";


//-------Summary of Stock -----
  static final String TABLE_NAME_8 = "SummaryOfStock";
  static final String Tbl8_pacfirm= "pacfirm";
  static final String Tbl8_stkitem= "stkitem";
  static final String Tbl8_antiannal= "antiannualconsump";
  static final String Tbl8_depodetail="depodetail";
  static final String Tbl8_issuecode="issueccode";
  static final String Tbl8_orgzone="orgzone";
  static final String Tbl8_subconscode="subconscode";
  static final String Tbl8_itemcat="itemcat";
  static final String Tbl8_plimegepath="plimagepath";
  static final String Tbl8_rlyname="rlyname";
  static final String Tbl8_issueconsgdept="issconsgdept";
  static final String Tbl8_ledgerno="ledgerno";
  static final String Tbl8_vs="vs";
  static final String Tbl8_consumeInd="consumind";
  static final String Tbl8_ledgerName="ledgername";
  static final String Tbl8_ledgerFolioNo="ledgerfoliono";
  static final String Tbl8_ledgerFolioName="ledgerfolioname";
  static final String Tbl8_ledgerFolioPlNo="ledgerfolioplno";
  static final String Tbl8_ledgerFolioShortDesc="ledgerfolioshortdesc";
  static final String Tbl8_lmrdt="lmrdt";
  static final String Tbl8_lmidt="lmidt";
  static final String Tbl8_stkQty="stkqty";
  static final String Tbl8_bar="bar";
  static final String Tbl8_stkValue="stkvalue";
  static final String Tbl8_stkUnit="stkunit";
  static final String Tbl8_thershold="thresholdlimit";

  static final String TABLE_NAME_9 = "NonMovingItems";
  static final String Tbl9_pacfirm ="pacfirm";
  static final String Tbl9_itemcat="itemcat";
  static final String Tbl9_depodetail="depodetail";
  static final String Tbl9_issueccode=  "issueccode";
  static final String Tbl9_rlyname="rlyname";
  static final String Tbl9_stkitem="stkitem";
  static final String Tbl9_issconsgdept="issconsgdept";
  static final String Tbl9_ledgerno="ledgerno";
  static final String Tbl9_vs="vs";
  static final String Tbl9_consumind="consumind";
  static final String Tbl9_ledgername="ledgername";
  static final String Tbl9_ledgerfoliono="ledgerfoliono";
  static final String Tbl9_ledgerfolioname="ledgerfolioname";
  static final String Tbl9_ledgerfolioplno="ledgerfolioplno";
  static final String Tbl9_ledgerfolioshortdesc="ledgerfolioshortdesc";
  static final String Tbl9_lmrdt="lmrdt";
  static final String Tbl9_lmidt="lmidt";
  static final String Tbl9_stkqty="stkqty";
  static final String Tbl9_bar="bar";
  static final String Tbl9_stkvalue="stkvalue";
  static final String Tbl9_stkunit="stkunit";
  static final String Tbl9_thresholdlimit="thresholdlimit";

  static final String TABLE_NAME_10 = "ValueViseStock";
  static final String Tbl10_pacfirm ="pacfirm";
  static final String Tbl10_itemcat="itemcat";
  static final String Tbl10_depodetail="depodetail";
  static final String Tbl10_issueccode=  "issueccode";
  static final String Tbl10_rlyname="rlyname";
  static final String Tbl10_stkitem="stkitem";
  static final String Tbl10_issconsgdept="issconsgdept";
  static final String Tbl10_ledgerno="ledgerno";
  static final String Tbl10_vs="vs";
  static final String Tbl10_consumind="consumind";
  static final String Tbl10_ledgername="ledgername";
  static final String Tbl10_ledgerfoliono="ledgerfoliono";
  static final String Tbl10_ledgerfolioname="ledgerfolioname";
  static final String Tbl10_ledgerfolioplno="ledgerfolioplno";
  static final String Tbl10_ledgerfolioshortdesc="ledgerfolioshortdesc";
  static final String Tbl10_lmrdt="lmrdt";
  static final String Tbl10_lmidt="lmidt";
  static final String Tbl10_stkqty="stkqty";
  static final String Tbl10_bar="bar";
  static final String Tbl10_stkvalue="stkvalue";
  static final String Tbl10_stkunit="stkunit";
  static final String Tbl10_thresholdlimit="thresholdlimit";

  static final String TABLE_NAME_11 = "HighValue";
  static final String Tbl11_pacfirm ="pacfirm";
  static final String Tbl11_itemcat="itemcat";
  static final String Tbl11_depodetail="depodetail";
  static final String Tbl11_issueccode=  "issueccode";
  static final String Tbl11_rlyname="rlyname";
  static final String Tbl11_stkitem="stkitem";
  static final String Tbl11_issconsgdept="issconsgdept";
  static final String Tbl11_ledgerno="ledgerno";
  static final String Tbl11_vs="vs";
  static final String Tbl11_consumind="consumind";
  static final String Tbl11_ledgername="ledgername";
  static final String Tbl11_ledgerfoliono="ledgerfoliono";
  static final String Tbl11_ledgerfolioname="ledgerfolioname";
  static final String Tbl11_ledgerfolioplno="ledgerfolioplno";
  static final String Tbl11_ledgerfolioshortdesc="ledgerfolioshortdesc";
  static final String Tbl11_lmrdt="lmrdt";
  static final String Tbl11_lmidt="lmidt";
  static final String Tbl11_stkqty="stkqty";
  static final String Tbl11_bar="bar";
  static final String Tbl11_stkvalue="stkvalue";
  static final String Tbl11_stkunit="stkunit";
  static final String Tbl11_thresholdlimit="thresholdlimit";

  static final String TABLE_NAME_12 = "ConsAnalysis";
  static final String Tbl12_pacfirm ="pacfirm";
  static final String Tbl12_stkunit="stkunit";
  static final String Tbl12_depodetail="depodetail";
  static final String Tbl12_issuecode=  "issuecode";
  static final String Tbl12_rlyname="rlyname";
  static final String Tbl12_issconsgdept="issconsgdept";
  static final String Tbl12_ledgerno="ledgerno";
  static final String Tbl12_vs="vs";
  static final String Tbl12_consumind="consumind";
  static final String Tbl12_ledgername="ledgername";
  static final String Tbl12_ledgerfoliono="ledgerfoliono";
  static final String Tbl12_ledgerfolioname="ledgerfolioname";
  static final String Tbl12_ledgerfolioplno="ledgerfolioplno";
  static final String Tbl12_ledgerfolioshortdesc="ledgerfolioshortdesc";
  static final String Tbl12_consumppercentage="consumppercentage";
  static final String Tbl12_monthlycurrentconsumption="monthlycurrentconsumption";
  static final String Tbl12_monthlypreviousconsumption="monthlypreviousconsumption";

  static final String TABLE_NAME_13 = "ConsSummary";
  static final String Tbl13_aac ="aac";
  static final String Tbl13_pacfirm ="pacfirm";
  static final String Tbl13_stkunit="stkunit";
  static final String Tbl13_depodetail="depodetail";
  static final String Tbl13_issueccode=  "issueccode";
  static final String Tbl13_rlyname="rlyname";
  static final String Tbl13_issconsgdept="issconsgdept";
  static final String Tbl13_ledgerno="ledgerno";
  static final String Tbl13_vs="vs";
  static final String Tbl13_consumind="consumind";
  static final String Tbl13_ledgername="ledgername";
  static final String Tbl13_ledgerfoliono="ledgerfoliono";
  static final String Tbl13_ledgerfolioname="ledgerfolioname";
  static final String Tbl13_ledgerfolioplno="ledgerfolioplno";
  static final String Tbl13_ledgerfolioshortdesc="ledgerfolioshortdesc";
  static final String Tbl13_consumptionqty="consumptionqty";
  static final String Tbl13_consumptionvalue="consumptionvalue";


  //++++++++++++++++++++++onlinesummary++++++++++++++++++++++++++++++

  static final String TABLE_NAME_14 = "Summary";
  static final String Tbl14pONUMBER ="pONUMBER ";
  static final String Tbl14pOSR ="pOSR";
  static final String Tbl14pAYAUTHCODE ="payauthcode";
  static final String Tbl14cONSECODE ="conscode";
  static final String Tbl14rAILNAME="railname";
  static final String Tbl14uNITTYPE="unittype";
  static final String Tbl14uNITNAME=  "unitname";
  static final String Tbl14dEPARTMENT="department";
  static final String Tbl14cONSIGNEE="consignee";
  static final String Tbl14pAUAUTH="payauth";
  static final String Tbl14oPENBAL="openbal";
  static final String Tbl14bILLRECIVED="billreceived";
  static final String Tbl14bILLRETURENED="billreturned";
  static final String Tbl14bILLPASSED="billpassed";
  static final String Tbl14tOTALPENDING="totalpending";
  static final String Tbl14pENDSEVENDAYS="pendsevendays";
  static final String Tbl14pENDFIFTEENDAYS="pendfifteendays";
  static final String Tbl14pENDTHIRTYDAYS="pendthirtydays";
  static final String Tbl14pENDMORETHIRTY="pendmorethirty";
  static final String Tbl14uNIT="unit";
  static final String Tbl14tODATE = "todate";
  static final String Tbl14fROMDATE ="fromdate";
  static final String Tbl14rAILCODE ="railcode";

  //---------- Status Display Screen----------
  static final String TABLE_NAME_15 = "Status";
  static final String Tbl15rlyCode ="rlyCode";
  static final String Tbl15cONSNAME ="cONSNAME";
  static final String Tbl15cONSRLY ="cONSRLY";
  static final String Tbl15pONUMBER ="pONUMBER";
  static final String Tbl15pODATE ="pODATE";
  static final String Tbl15cONSIGNEE ="cONSIGNEE";
  static final String Tbl15aCCOUNTNAME="aCCOUNTNAME";
  static final String Tbl15pOSR ="pOSR";
  static final String Tbl15iTEMDESCRIPTION="iTEMDESCRIPTION";

  // -------------Transactions Screen--------
  static final String TABLE_NAME_16 = "Transactions";
  static final String Tbl16mACHINEDTLS = "mACHINEDTLS";
  static final String Tbl16sTKVERIFIERUSERNAME = "sTKVERIFIERUSERNAME";
  static final String Tbl16sTKVERIFIERPOST = "sTKVERIFIERPOST";
  static final String Tbl16tRANSUSERNAME = "tRANSUSERNAME";
  static final String Tbl16uSERTYPE = "uSERTYPE";
  static final String Tbl16tRANSREMARKS = "tRANSREMARKS";
  static final String Tbl16rEFTRANSKEY = "rEFTRANSKEY";
  static final String Tbl16tRANSKEY = "tRANSKEY";
  static final String Tbl16rEJIND = "rEJIND";
  static final String Tbl16tHRESHOLDLIMIT = "tHRESHOLDLIMIT";
  static final String Tbl16cANCELLEDVOUCHERNO = "cANCELLEDVOUCHERNO";
  static final String Tbl16cANCELLEDVOUCHERDATE = "cANCELLEDVOUCHERDATE";
  static final String Tbl16tRANSSTATUS = "tRANSSTATUS";
  static final String Tbl16iSSEDEPOTTYPE = "iSSEDEPOTTYPE";
  static final String Tbl16pONO = "pONO";
  static final String Tbl16lOANBALQTY = "lOANBALQTY";
  static final String Tbl16lOANINDDESC = "lOANINDDESC";
  static final String Tbl16tRANSTYPEDESCRIPTION = "tRANSTYPEDESCRIPTION";
  static final String Tbl16tRANSCARDCODEDESC = "tRANSCARDCODEDESC";
  static final String Tbl16rEMARKS = "rEMARKS";
  static final String Tbl16aCKNOWLEDGEFLAG = "aCKNOWLEDGEFLAG";
  static final String Tbl16cARDCODE = "cARDCODE";
  static final String Tbl16oPENBALSTKQTY = "oPENBALSTKQTY";
  static final String Tbl16cLOSINGBALSTKQTY = "cLOSINGBALSTKQTY";
  static final String Tbl16oPENBALVALUE = "oPENBALVALUE";
  static final String Tbl16cLOSINGBALVALUE = "cLOSINGBALVALUE";
  static final String Tbl16sTKQTY = "sTKQTY";
  static final String Tbl16sTKVALUE = "sTKVALUE";
  static final String Tbl16bAR = "bAR";
  static final String Tbl16oRG_ZONE = "oRG_ZONE";
  static final String Tbl16rLYNAME = "rLYNAME";
  static final String Tbl16cONS_CODE = "cONS_CODE";
  static final String Tbl16lEDGERNO = "lEDGERNO";
  static final String Tbl16lEDGERNAME = "lEDGERNAME";
  static final String Tbl16lEDGERFOLIONO = "lEDGERFOLIONO";
  static final String Tbl16lEDGERFOLIONAME = "lEDGERFOLIONAME";
  static final String Tbl16lEDGERFOLIOPLNO = "lEDGERFOLIOPLNO";
  static final String Tbl16tRANSUNIT = "tRANSUNIT";
  static final String Tbl16lEDGERFOLIOSHORTDESC = "lEDGERFOLIOSHORTDESC";
  static final String Tbl16tRANSTYPE = "tRANSTYPE";
  static final String Tbl16pO_TYPE = "pO_TYPE";
  static final String Tbl16vOUCHERNO = "vOUCHERNO";
  static final String Tbl16vOUCHERDATE = "vOUCHERDATE";
  static final String Tbl16tRANSDATE = "tRANSDATE";
  static final String Tbl16fIRMACCOUNTNAME = "fIRMACCOUNTNAME";
  static final String Tbl16tRANSQTY = "tRANSQTY";
  static final String Tbl16iSSUEQTY = "iSSUEQTY";
  static final String Tbl16bALANCEQTY = "bALANCEQTY";
  static final String Tbl16iSSUETOTALVALUE = "iSSUETOTALVALUE";
  static final String Tbl16iSSUETOTALQTY = "iSSUETOTALQTY";
  static final String Tbl16rECEIPTTOTALQTY = "rECEIPTTOTALQTY";
  static final String Tbl16rECEIPTTOTALVALUE = "rECEIPTTOTALVALUE";


  //-----------------Action Page-----------------------
  static final String TABLE_NAME_17 = "Actionpage";
  static final String Tbl17pONUMBER = "pONUMBER";
  static final String Tbl17pOSR = "pOSR";
  static final String  Tbl17unit = "unit";
  static final String  Tbl17fROMBILL = "fROMBILL";
  static final String  Tbl17vENDORNAME = "vENDORNAME";
  static final String  Tbl17iTEMDESC = "iTEMDESC";
  static final String  Tbl17dOCNO = "dOCNO";
  static final String  Tbl17dOCDATE = "dOCDATE";
  static final String  Tbl17pAYINGRLY = "pAYINGRLY";
  static final String  Tbl17pAYINGAUTHORITY = "pAYINGAUTHORITY";
  static final String  Tbl17rLY = "rLY";
  static final String  Tbl17dOCTYPE = "dOCTYPE";
  static final String  Tbl17bILLNO = "bILLNO";
  static final String  Tbl17bILLDATE = "bILLDATE";
  static final String  Tbl17iREPSBILLNO = "iREPSBILLNO";
  static final String  Tbl17iREPSBILLDATE = "iREPSBILLDATE";
  static final String  Tbl17bILLTYPE = "bILLTYPE";
  static final String  Tbl17pAYMENTTYPE = "pAYMENTTYPE";
  static final String  Tbl17pAYMENTPERCENTAGE = "pAYMENTPERCENTAGE";
  static final String  Tbl17iTEMNOOFBILL = "iTEMNOOFBILL";
  static final String  Tbl17bILLAMOUNTFORITEM = "bILLAMOUNTFORITEM";
  static final String  Tbl17cO6NO = "cO6NO";
  static final String  Tbl17cO6DATE = "cO6DATE";
  static final String  Tbl17cO7NO = "cO7NO";
  static final String  Tbl17cO7DATE = "cO7DATE";
  static final String  Tbl17pASSEDAMOUNTFORITEM = "pASSEDAMOUNTFORITEM";
  static final String   Tbl17pAYMENTRETURNDATE = "pAYMENTRETURNDATE";
  static final String  Tbl17tOTALAMOUNTFORBILL = "tOTALAMOUNTFORBILL";
  static final String  Tbl17pASSEDAMOUNTFORBILL = "pASSEDAMOUNTFORBILL";
  static final String  Tbl17dEDUCTEDAMOUNTFORBILL = "dEDUCTEDAMOUNTFORBILL";
  static final String  Tbl17pAIDAMOUNTFORBILL = "pAIDAMOUNTFORBILL";
  static final String  Tbl17rETURNREASON = "rETURNREASON";
  static final String  Tbl17rNOTENO = "rNOTENO";
  static final String  Tbl17rNOTEDATE = "rNOTEDATE";
  static final String  Tbl17qTYACCEPTED = "qTYACCEPTED";
  static final String  Tbl17qTYRECEIVED = "qTYRECEIVED";
  static final String  Tbl17cARDCODE= "cARDCODE";
  static final String  Tbl17pODATE = "pODATE";
  static final String  Tbl17qty = "qty";
  static final String  Tbl17pAYAUTH = "pAYAUTH";


  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database?> get database async {
    if(_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate, onUpgrade: _onUpgrade);

  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {

    if(newVersion > oldVersion) {
      List<Map<String, dynamic>> c = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'", null);
      List<String> tables = [];
      tables = c.map((e) => e['name'].toString()).toList();
      for (String table in tables) {
        String dropQuery = "DROP TABLE IF EXISTS " + table;
        await db.rawQuery(dropQuery);
      }
    }
    await _onCreate(db, newVersion);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $TABLE_NAME_3 (
            $Tbl3_Col1_Hash TEXT NOT NULL,
            $Tbl3_Col2_Date TEXT NOT NULL,
            $Tbl3_Col3_Ans TEXT NOT NULL,
            $Tbl3_Col4_Log TEXT NOT NULL,
            $Tb3_col5_emailid TEXT NOT NULL,
            $Tb3_col6_loginFlag TEXT NOT NULL,
            $Tb3_col7_mobile TEXT NOT NULL,
            $Tb3_col8_userName TEXT NOT NULL,
            $Tb3_col9_UserVlue TEXT NOT NULL,
            $Tb3_col10_LastLogin TEXT NOT NULL,
            $Tb3_col11_WKArea TEXT NOT NULL,
            $Tb3_col12_OuName TEXT NOT NULL
          )
          ''');


    await db.execute('''
          CREATE TABLE $TABLE_NAME_6 (
            $Tbl6_orgZone  TEXT,
            $Tbl6_Cat  TEXT,
            $Tbl6_StoreDepot  TEXT,
            $Tbl6_ward  TEXT,
            $Tbl6_ItemCode  TEXT,
            $Tbl6_itemDescr  TEXT,
            $Tbl6_rate  TEXT,
            $Tbl6_stkqty  TEXT,
            $Tbl6_unit  TEXT
                  )
            
                    ''');


    await db.execute('''
          CREATE TABLE $TABLE_NAME_2 (
            $Tbl2_Col1_Date TEXT NOT NULL,
            $Tbl2_Col2_UpdateFlag TEXT NOT NULL,
            $Tbl2_Col3_LatestVersion TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $TABLE_NAME_4 (
            $Tbl4_col1_item_code TEXT,
            $Tbl4_col2_ledger_name TEXT,
            $Tbl4_col3_stock_qty INT,
            $Tbl4_col4_rate TEXT,
            $Tbl4_col5_desc TEXT,
            $Tbl4_col5_ORGZONE TEXT,
            $Tbl4_col6_SUBCONSCODE TEXT,
            $Tbl4_col7_PLNUMBER TEXT,
            $Tbl4_col8_DEPODETAIL TEXT,
            $Tbl4_col9_ISSUEDEPT TEXT,
            $Tbl4_col10_ISSUEDIV TEXT,
            $Tbl4_col11_ITEMCAT TEXT,
            $Tbl4_col12_ISSUECCODE TEXT,
            $Tbl4_col13_RLYNAME TEXT,
            $Tbl4_col14_DIVNAME TEXT,
            $Tbl4_col15_ISSCONSGDEPT TEXT,
            $Tbl4_col16_POSTNAME TEXT,
            $Tbl4_col17_LEDGERNO TEXT,
            $Tbl4_col18_FOLIONAME TEXT,
            $Tbl4_col19_PLIMAGEPATH TEXT,
            $Tbl4_col20_UNITCODE TEXT,
            $Tbl4_col21_UNIT TEXT,
            $Tbl4_col22_BOOAVGRAT TEXT,
            $Tbl4_col23_STKNS TEXT 
          )
          ''');


    await db.execute('''
          CREATE TABLE $TABLE_NAME_5 (
    $Tbl5_itemCat TEXT,
    $Tbl5_aac TEXT,
    $Tbl5_depoDetail TEXT,
    $Tbl5_isseCCode TEXT,
    $Tbl5_railway TEXT,
    $Tbl5_stkItem TEXT,
    $Tbl5_issueConsDept TEXT,
    $Tbl5_ledgerNo TEXT,
    $Tbl5_vs TEXT,
    $Tbl5_consumeId TEXT,
    $Tbl5_ledgerName TEXT,
    $Tbl5_ledgerFolioNo TEXT,
    $Tbl5_ledgerFolioName TEXT,
    $Tbl5_ledgerFolioPlNo TEXT,
    $Tbl5_ledgerFolioDesc TEXT,
    $Tbl5_lmrdt TEXT,
    $Tbl5_lmidt TEXT,
    $Tbl5_stkQty TEXT,
    $Tbl5_bar TEXT,
    $Tbl5_stkValue TEXT,
    $Tbl5_stkUnit TEXT,
    $Tbl5_thresholdLimit TEXT
    )
    ''');

    await db.execute('''
          CREATE TABLE $TABLE_NAME_7 (
            $Tbl7_railway TEXT,
    $Tbl7_consg TEXT,
    $Tbl7_postStatus TEXT,
    $Tbl7_poKey TEXT,
    $Tbl7_poNo TEXT,
    $Tbl7_poDate TEXT,
    $Tbl7_vName TEXT,
    $Tbl7_stkNs TEXT,
    $Tbl7_poValue TEXT,
    $Tbl7_unit TEXT,
    $Tbl7_itemCode TEXT,
    $Tbl7_des TEXT,
    $Tbl7_posr TEXT,
    $Tbl7_cnsgnName TEXT,
    $Tbl7_poQty TEXT,
    $Tbl7_delPerId TEXT,
    $Tbl7_raiName TEXT,
    $Tbl7_splQty TEXT,
    $Tbl7_canclAtInQty TEXT,
    $Tbl7_rly TEXT,
    $Tbl7_inspAgency TEXT,
    $Tbl7_paidValue TEXT,
    $Tbl7_itemrate TEXT,
     $Tbl7_viewPdf TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $TABLE_NAME_8 (
    $Tbl8_pacfirm TEXT,
    $Tbl8_stkitem TEXT,
    $Tbl8_antiannal TEXT,
    $Tbl8_depodetail TEXT,
    $Tbl8_issuecode TEXT,
    $Tbl8_orgzone TEXT,
    $Tbl8_subconscode TEXT,
    $Tbl8_itemcat TEXT,
    $Tbl8_plimegepath TEXT,
    $Tbl8_rlyname TEXT,
    $Tbl8_issueconsgdept TEXT,
    $Tbl8_ledgerno TEXT,
    $Tbl8_vs TEXT,
    $Tbl8_consumeInd TEXT,
    $Tbl8_ledgerName TEXT,
    $Tbl8_ledgerFolioNo TEXT,
    $Tbl8_ledgerFolioName TEXT,
    $Tbl8_ledgerFolioPlNo TEXT,
    $Tbl8_ledgerFolioShortDesc TEXT,
    $Tbl8_lmrdt TEXT,
    $Tbl8_lmidt TEXT,
    $Tbl8_stkQty TEXT,
    $Tbl8_bar TEXT,
    $Tbl8_stkValue TEXT,
    $Tbl8_stkUnit TEXT,
    $Tbl8_thershold TEXT
    )
    ''');

    await db.execute('''
          CREATE TABLE $TABLE_NAME_9 (
    $Tbl9_pacfirm TEXT,
    $Tbl9_itemcat TEXT,
    $Tbl9_depodetail TEXT,
    $Tbl9_issueccode TEXT,
    $Tbl9_rlyname TEXT,
    $Tbl9_stkitem TEXT,
    $Tbl9_issconsgdept TEXT,
    $Tbl9_ledgerno TEXT,
    $Tbl9_vs TEXT,
    $Tbl9_consumind TEXT,
    $Tbl9_ledgername TEXT,
    $Tbl9_ledgerfoliono TEXT,
    $Tbl9_ledgerfolioname TEXT,
    $Tbl9_ledgerfolioplno TEXT,
    $Tbl9_ledgerfolioshortdesc TEXT,
    $Tbl9_lmrdt TEXT,
    $Tbl9_lmidt TEXT,
    $Tbl9_stkqty TEXT,
    $Tbl9_bar TEXT,
    $Tbl9_stkvalue TEXT,
    $Tbl9_stkunit TEXT,
    $Tbl9_thresholdlimit TEXT
 )
    ''');



    await db.execute('''
          CREATE TABLE $TABLE_NAME_10 (
    $Tbl10_pacfirm TEXT,
    $Tbl10_itemcat TEXT,
    $Tbl10_depodetail TEXT,
    $Tbl10_issueccode TEXT,
    $Tbl10_rlyname TEXT,
    $Tbl10_stkitem TEXT,
    $Tbl10_issconsgdept TEXT,
    $Tbl10_ledgerno TEXT,
    $Tbl10_vs TEXT,
    $Tbl10_consumind TEXT,
    $Tbl10_ledgername TEXT,
    $Tbl10_ledgerfoliono TEXT,
    $Tbl10_ledgerfolioname TEXT,
    $Tbl10_ledgerfolioplno TEXT,
    $Tbl10_ledgerfolioshortdesc TEXT,
    $Tbl10_lmrdt TEXT,
    $Tbl10_lmidt TEXT,
    $Tbl10_stkqty TEXT,
    $Tbl10_bar TEXT,
    $Tbl10_stkvalue TEXT,
    $Tbl10_stkunit TEXT,
    $Tbl10_thresholdlimit TEXT
 )
    ''');

    await db.execute('''
          CREATE TABLE $TABLE_NAME_11 (
    $Tbl11_pacfirm TEXT,
    $Tbl11_itemcat TEXT,
    $Tbl11_depodetail TEXT,
    $Tbl11_issueccode TEXT,
    $Tbl11_rlyname TEXT,
    $Tbl11_stkitem TEXT,
    $Tbl11_issconsgdept TEXT,
    $Tbl11_ledgerno TEXT,
    $Tbl11_vs TEXT,
    $Tbl11_consumind TEXT,
    $Tbl11_ledgername TEXT,
    $Tbl11_ledgerfoliono TEXT,
    $Tbl11_ledgerfolioname TEXT,
    $Tbl11_ledgerfolioplno TEXT,
    $Tbl11_ledgerfolioshortdesc TEXT,
    $Tbl11_lmrdt TEXT,
    $Tbl11_lmidt TEXT,
    $Tbl11_stkqty TEXT,
    $Tbl11_bar TEXT,
    $Tbl11_stkvalue TEXT,
    $Tbl11_stkunit TEXT,
    $Tbl11_thresholdlimit TEXT
 )
    ''');


    await db.execute('''
          CREATE TABLE $TABLE_NAME_12 (
    $Tbl12_pacfirm TEXT,
    $Tbl12_depodetail TEXT,
    $Tbl12_issuecode TEXT,
    $Tbl12_rlyname TEXT,
    $Tbl12_issconsgdept TEXT,
    $Tbl12_ledgerno TEXT,
    $Tbl12_vs TEXT,
    $Tbl12_stkunit TEXT,
    $Tbl12_consumind TEXT,
    $Tbl12_ledgername TEXT,
    $Tbl12_ledgerfoliono TEXT,
    $Tbl12_ledgerfolioname TEXT,
    $Tbl12_ledgerfolioplno TEXT,
    $Tbl12_ledgerfolioshortdesc TEXT,
    $Tbl12_consumppercentage TEXT,
    $Tbl12_monthlycurrentconsumption TEXT,
    $Tbl12_monthlypreviousconsumption TEXT
 )
    ''');

    await db.execute('''
          CREATE TABLE $TABLE_NAME_13 (
     $Tbl13_aac TEXT,
    $Tbl13_pacfirm TEXT,
    $Tbl13_depodetail TEXT,
    $Tbl13_issueccode TEXT,
    $Tbl13_rlyname TEXT,
    $Tbl13_issconsgdept TEXT,
    $Tbl13_ledgerno TEXT,
    $Tbl13_vs TEXT,
    $Tbl13_stkunit TEXT,
    $Tbl13_consumind TEXT,
    $Tbl13_ledgername TEXT,
    $Tbl13_ledgerfoliono TEXT,
    $Tbl13_ledgerfolioname TEXT,
    $Tbl13_ledgerfolioplno TEXT,
    $Tbl13_ledgerfolioshortdesc TEXT,
    $Tbl13_consumptionqty TEXT,
    $Tbl13_consumptionvalue TEXT
 )
    ''');

    await db.execute('''
          CREATE TABLE $TABLE_NAME_14 (
      $Tbl14pONUMBER TEXT,
     $Tbl14pOSR TEXT,
     $Tbl14pAYAUTHCODE  TEXT,
    $Tbl14cONSECODE TEXT,
    $Tbl14rAILNAME TEXT,
    $Tbl14uNITTYPE TEXT,
    $Tbl14uNITNAME TEXT,
    $Tbl14dEPARTMENT TEXT,
    $Tbl14cONSIGNEE TEXT,
    $Tbl14pAUAUTH TEXT,
    $Tbl14oPENBAL TEXT,
    $Tbl14bILLRECIVED TEXT,
    $Tbl14bILLRETURENED TEXT,
    $Tbl14bILLPASSED TEXT,
    $Tbl14tOTALPENDING TEXT,
    $Tbl14pENDSEVENDAYS TEXT,
    $Tbl14pENDFIFTEENDAYS TEXT,
    $Tbl14pENDTHIRTYDAYS TEXT,
    $Tbl14pENDMORETHIRTY TEXT,
    $Tbl14uNIT TEXT,
    $Tbl14tODATE TEXT,
    $Tbl14fROMDATE TEXT,
    $Tbl14rAILCODE TEXT
	  
 )
    ''');

    await db.execute('''
          CREATE TABLE $TABLE_NAME_15 (
           $Tbl15rlyCode TEXT,
           $Tbl15cONSNAME TEXT,
           $Tbl15cONSRLY TEXT,
            $Tbl15pONUMBER TEXT,
             $Tbl15pODATE  TEXT,
             $Tbl15cONSIGNEE TEXT,
             $Tbl15aCCOUNTNAME TEXT,
              $Tbl15pOSR TEXT,
               $Tbl15iTEMDESCRIPTION TEXT
             )
          ''');

    await db.execute('''
          CREATE TABLE $TABLE_NAME_16 (
           $Tbl16mACHINEDTLS TEXT,
           $Tbl16sTKVERIFIERUSERNAME TEXT,
           $Tbl16sTKVERIFIERPOST TEXT,
            $Tbl16tRANSUSERNAME TEXT,
             $Tbl16uSERTYPE  TEXT,
             $Tbl16tRANSREMARKS TEXT,
             $Tbl16rEFTRANSKEY TEXT,
             $Tbl16tRANSKEY TEXT,
              $Tbl16rEJIND TEXT,
               $Tbl16tHRESHOLDLIMIT TEXT,
                $Tbl16cANCELLEDVOUCHERNO TEXT,
                 $Tbl16cANCELLEDVOUCHERDATE TEXT,
                 $Tbl16tRANSSTATUS TEXT,
                 $Tbl16iSSEDEPOTTYPE TEXT,
                 $Tbl16pONO TEXT,
                 $Tbl16lOANBALQTY TEXT,
                 $Tbl16lOANINDDESC TEXT,
                 $Tbl16tRANSTYPEDESCRIPTION TEXT,
                 $Tbl16tRANSCARDCODEDESC TEXT,
                 $Tbl16rEMARKS TEXT, 
                 $Tbl16aCKNOWLEDGEFLAG TEXT,
                 $Tbl16cARDCODE TEXT,
                 $Tbl16oPENBALSTKQTY TEXT,
                 $Tbl16cLOSINGBALSTKQTY TEXT,
                 $Tbl16oPENBALVALUE TEXT,
                 $Tbl16cLOSINGBALVALUE TEXT,
                 $Tbl16sTKQTY TEXT,
                 $Tbl16sTKVALUE TEXT,
                 $Tbl16bAR TEXT,
                 $Tbl16oRG_ZONE TEXT,
                 $Tbl16rLYNAME TEXT,
                 $Tbl16cONS_CODE TEXT,
                 $Tbl16lEDGERNO TEXT,
                 $Tbl16lEDGERNAME TEXT,
                 $Tbl16lEDGERFOLIONO TEXT,
                 $Tbl16lEDGERFOLIONAME TEXT,
                 $Tbl16lEDGERFOLIOPLNO TEXT,
                 $Tbl16tRANSUNIT TEXT,
                 $Tbl16lEDGERFOLIOSHORTDESC TEXT,
                 $Tbl16tRANSTYPE TEXT,
                 $Tbl16pO_TYPE TEXT,
                 $Tbl16vOUCHERNO TEXT,
                 $Tbl16vOUCHERDATE TEXT,
                 $Tbl16tRANSDATE TEXT,
                 $Tbl16fIRMACCOUNTNAME TEXT,
                 $Tbl16tRANSQTY TEXT,
                 $Tbl16iSSUEQTY TEXT,
                 $Tbl16bALANCEQTY TEXT,
                 $Tbl16iSSUETOTALVALUE TEXT,
                 $Tbl16iSSUETOTALQTY TEXT,
                 $Tbl16rECEIPTTOTALQTY TEXT,
                 $Tbl16rECEIPTTOTALVALUE TEXT
             )
          ''');

    await db.execute('''
          CREATE TABLE $TABLE_NAME_17 (
           $Tbl17pONUMBER TEXT,
           $Tbl17pOSR TEXT,
           $Tbl17unit TEXT,
           $Tbl17fROMBILL TEXT,
           $Tbl17vENDORNAME TEXT,
           $Tbl17iTEMDESC TEXT,
           $Tbl17dOCNO TEXT,
           $Tbl17dOCDATE TEXT,
           $Tbl17pAYINGRLY TEXT,
           $Tbl17pAYINGAUTHORITY TEXT,
           $Tbl17rLY TEXT,
           $Tbl17dOCTYPE TEXT,
           $Tbl17bILLNO TEXT,
           $Tbl17bILLDATE TEXT,
           $Tbl17iREPSBILLNO TEXT,
           $Tbl17iREPSBILLDATE TEXT,
           $Tbl17bILLTYPE TEXT,
           $Tbl17pAYMENTTYPE TEXT,
           $Tbl17pAYMENTPERCENTAGE TEXT,
           $Tbl17iTEMNOOFBILL TEXT,
           $Tbl17bILLAMOUNTFORITEM TEXT,
           $Tbl17cO6NO TEXT,
           $Tbl17cO6DATE TEXT,
           $Tbl17cO7NO TEXT,
           $Tbl17cO7DATE TEXT,
           $Tbl17pASSEDAMOUNTFORITEM TEXT,
           $Tbl17pAYMENTRETURNDATE TEXT,
           $Tbl17tOTALAMOUNTFORBILL TEXT,
           $Tbl17pASSEDAMOUNTFORBILL TEXT,
           $Tbl17dEDUCTEDAMOUNTFORBILL TEXT,
           $Tbl17pAIDAMOUNTFORBILL TEXT,
           $Tbl17rETURNREASON TEXT,
           $Tbl17rNOTENO TEXT,
           $Tbl17rNOTEDATE TEXT,
           $Tbl17qTYACCEPTED TEXT,
           $Tbl17qTYRECEIVED TEXT,
           $Tbl17cARDCODE TEXT,
           $Tbl17pODATE TEXT,
           $Tbl17qty TEXT,
           $Tbl17pAYAUTH TEXT
             )
          ''');


    Future<int> insert(Map<String, dynamic> row, table) async {
      Database? db = await (instance.database);
      return await db!.insert(table, row);
    }
  }

  //***************Save LOGIN USER FUNCTIONS START*******************************************************************************
  Future<List<Map<String, dynamic>>> fetchSaveLoginUser() async {
    Database? db = await (instance.database );
    return await db!.query(TABLE_NAME_3);
  }
  Future<int> insertSaveLoginUser(Map<String, dynamic> row) async {
    Database? db = await (instance.database);
    return await db!.insert(TABLE_NAME_3, row);
  }

  Future<int> insertSaveLoginUserforProfile(Map<String, dynamic> row) async {
    Database? db = await (instance.database );
    return await db!.insert(TABLE_NAME_3, row);
  }
  Future<List<Map<String, dynamic>>> fetchSaveLoginUserForProfile() async {
    Database? db = await (instance.database );
    return await db!.query(TABLE_NAME_3);
  }
  Future<int> deleteSaveLoginUser() async {
    Database? db = await (instance.database );
    return await db!.delete(TABLE_NAME_3);
  }

  Future<int> deleteLoginUser(int id) async {
    Database? db = await (instance.database);
    return await db!.delete(TABLE_NAME_3);
  }
//***************LOGIN USER FUNCTIONS END*******************************************************************************
  Future<int?> rowCountVersionDtls() async {
    Database? db = await (instance.database);
    return Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM $TABLE_NAME_2'));
  }
  Future<List<Map<String, dynamic>>> fetchVersionDtls() async {
    Database? db = await (instance.database);
    return await db!.query(TABLE_NAME_2);
  }
  Future<int> insertVersionDtls(Map<String, dynamic> row) async {
    Database? db = await (instance.database);
    return await db!.insert(TABLE_NAME_2, row);
  }
  Future<int> deleteVersionDtls(int id) async {
    Database? db = await (instance.database);
    return await db!.delete(TABLE_NAME_2);
  }
  Future<int> updateVersionDtls(Map<String, dynamic> row) async {
    Database? db = await (instance.database);
    return await db!.update(TABLE_NAME_2, row);
  }
// /*---------------------Items Table Function-------------------- */
  Future<List<Map<String, dynamic>>> fetchSavedItem() async {
    Database? db = await (instance.database);
    return await db!.query(TABLE_NAME_4);
  }
  Future<int> insertItem(List<Item>? row) async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      Batch batch=txn.batch();
      row!.forEach((element) async{ batch.insert(TABLE_NAME_4, element.toJson());});
      await batch.commit();
    });
    return 0;
  }
  Future<int> deleteItems() async {
    Database? db = await (instance.database);
    // return await db.delete(TABLE_NAME_4);
    await db!.transaction((txn) async {
      await txn.delete(TABLE_NAME_4);
    });
    return 0;
  }

  Future<List<Item>> getItemList() async {
    final List<Map<String, dynamic>> maps = await _database!.query('Items');
    return List.generate(maps.length, (i) {
      return Item(
          item_code: maps[i]['plnumber'].toString() + '',
          ledger_name: maps[i]['ledgername'].toString() + '',
          qty: maps[i]['stockqty'].toString() + '',
          unit: maps[i]['unit'].toString() + '',
          description: maps[i]['itemdescription'].toString() + '',
          booavgrat: maps[i]['booavgrat'].toString() + '',
          subConsCode: maps[i]['subconscode'].toString() + '',
          orgZone: maps[i]['orgzone'].toString() + '',
          depoDetail: maps[i]['depodetail'].toString() + '',
          cons_code: maps[i]['cons_code'].toString() + '',
          isscongDept: maps[i]['issconsgdept'].toString() + '',
          rlyName: maps[i]['rlyname'].toString() + '',
          rate: maps[i]['booavgrat'].toString() + '',
          itemcat: maps[i]['itemcat'],
          plimagePath: maps[i]['plimagepath'],
          folioName: maps[i]['folioname']

      );
    });
  }

  // /*---------------------Stock Table Function-------------------- */
  Future<List<Map<String, dynamic>>> fetchSavedStockItem() async {
    Database? db = await (instance.database);
    return await db!.query(TABLE_NAME_5);
  }
  Future insertStockItem(List<Stock>? row) async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      Batch batch=txn.batch();
      row!.forEach((element) async{batch.insert(TABLE_NAME_5, element.toJson());});
      await batch.commit();
    });
    return 0;
  }

  Future<int> deleteStockItems() async {
    Database? db = await (instance.database);
    // return await db.delete(TABLE_NAME_5);
    await db!.transaction((txn) async {
      await txn.delete(TABLE_NAME_5);
    });
    return 0;
  }

  Future<List<Stock>> getStockItemList() async {
    final List<Map<String, dynamic>> maps = await _database!.query('Stock');
    return List.generate(maps.length, (i) {
      return Stock(
        itemCat: maps[i]['itemcat'].toString(),
        aac: maps[i]['aac'].toString(),
        depotDetail: maps[i]['depodetail'].toString(),
        issueCode: maps[i]['issueccode'].toString(),
        railway: maps[i]['rlyname'].toString(),
        stkItem: maps[i]['stkitem'].toString(),
        issueConsgDept: maps[i]['issconsgdept'].toString(),
        ledgerNo: maps[i]['ledgerno'].toString(),
        vs: maps[i]['vs'].toString(),
        consumInd: maps[i]['consumind'].toString(),
        ledgerName: maps[i]['ledgername'].toString(),
        ledgerFolioNo: maps[i]['ledgerfoliono'].toString(),
        ledgerFolioName: maps[i]['ledgerfolioname'].toString(),
        ledgerFolioPlNo: maps[i]['ledgerfolioplno'].toString(),
        ledgerFolioShortDesc: maps[i]['ledgerfolioshortdesc'].toString(),
        stkqty: maps[i]['stkqty'].toString(),
        stkUnit: maps[i]['stkunit'].toString(),
        stkValue: maps[i]['stkvalue'].toString(),
        lmidt: maps[i]['lmidt'],
        lmrdt: maps[i]['lmrdt'],
        bar: maps[i]['bar'],
      );
    });
  }



  // /*---------------------StoreStockDepot Table Function-------------------- */
  Future<List<Map<String, dynamic>>> fetchSavedStoreStockDepotItem() async {
    Database? db = await (instance.database);
    return  await db!.query(TABLE_NAME_6);
  }

  Future<int> insertStoreStk(List<StoreStkDepot>? row) async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      Batch batch=txn.batch();
      row!.forEach((element) async{batch.insert(TABLE_NAME_6, element.toJson());});
      await batch.commit();
    });
    return 0;
  }

  Future<int> deleteStoreStockDepotItems() async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      await txn.delete(TABLE_NAME_6);
    });
    return 0;
  }

  Future<List<StoreStkDepot>> getStoreStockDepotItemList() async {
    final List<Map<String, dynamic>> maps = await _database!.query('StoreStockDepot');
    return List.generate(maps.length, (i) {
      return StoreStkDepot(
        orgZone: maps[i]['orgzone'].toString(),
        cat: maps[i]['cat'].toString(),
        storeDepot: maps[i]['storedepot'].toString(),
        ward: maps[i]['ward'].toString(),
        itemCode: maps[i]['itemcode'].toString(),
        itemDesc: maps[i]['itemdescription'].toString(),
        rate: maps[i]['rate'].toString(),
        stkqty: maps[i]['stockqty'].toString(),
        unit: maps[i]['unit'].toString(),
      );
    });
  }


  // /*---------------------PO Search Table Function-------------------- */
  Future<List<Map<String, dynamic>>> fetchSavedPOSearchItem() async {
    Database? db = await (instance.database);
    return  await db!.query(TABLE_NAME_7);
  }

  Future<int> insertPOSearch(List<POSearch>? row) async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      Batch batch=txn.batch();
      row!.forEach((element) async{ batch.insert(TABLE_NAME_7, element.toJson());});
      await batch.commit();
    });
    return 0;
  }


  Future<int> deletePOSearchItems() async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      await txn.delete(TABLE_NAME_7);
    });
    return 0;
  }

  Future<List<POSearch>> getPoSearchItemList() async {
    final List<Map<String, dynamic>> maps = await _database!.query('POSearch');
    return List.generate(maps.length, (i) {
      return POSearch(
        itemRate: maps[i]['orgzone'].toString(),
        cANCELLATIONQTY: maps[i]['cat'].toString(),
        cONSG: maps[i]['storedepot'].toString(),
        cONSIGNEENAME: maps[i]['ward'].toString(),
        dELIVERYPERIOD: maps[i]['itemcode'].toString(),
        dES: maps[i]['itemdescription'].toString(),
        iNSPECTIONACGENCY: maps[i]['rate'].toString(),
        iTEMCODE: maps[i]['stockqty'].toString(),
        pAIDVALUE: maps[i]['unit'].toString(),
        pODATE: maps[i]['itemdescription'].toString(),
        pOKEY: maps[i]['rate'].toString(),
        pONO: maps[i]['stockqty'].toString(),
        pOQTY: maps[i]['unit'].toString(),
        pOSR: maps[i]['itemdescription'].toString(),
        pOSTATUS: maps[i]['rate'].toString(),
        pOVALUE: maps[i]['stockqty'].toString(),
        rAINAME: maps[i]['unit'].toString(),
        rLY: maps[i]['unit'].toString(),
        rLYNAME: maps[i]['itemdescription'].toString(),
        sTKNS: maps[i]['rate'].toString(),
        sUPPLYQTY: maps[i]['stockqty'].toString(),
        uNIT: maps[i]['unit'].toString(),
        vNAME: maps[i]['itemdescription'].toString(),
        vIEWPDF: maps[i]['rate'].toString(),
      );
    });
  }


  // /*---------------------Summary of Stock Table Function-------------------- */
  Future<List<Map<String, dynamic>>> fetchSavedSummaryStockItem() async {
    Database? db = await (instance.database);
    return  await db!.query(TABLE_NAME_8);
  }

  Future<int> insertSummaryStock(List<SummaryStock>? row) async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      Batch batch=txn.batch();
      row!.forEach((element) async{ batch.insert(TABLE_NAME_8, element.toJson());});
      await batch.commit();
    });
    return 0;
  }

  Future<int> deleteSummaryStock() async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      await txn.delete(TABLE_NAME_8);
    });
    return 0;
  }


  // /*---------------------NonMoving Table Function-------------------- */
  Future<List<Map<String, dynamic>>> fetchSavedNonMovingItem() async {
    Database? db = await (instance.database);
    return await db!.query(TABLE_NAME_9);
  }

  Future<int> insertNonMoving(List<NonMoving>? row) async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      Batch batch=txn.batch();
      row!.forEach((element) async{ batch.insert(TABLE_NAME_9, element.toJson());});
      await batch.commit();
    });
    return 0;
  }

  Future<int> deleteNonMoving() async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      await txn.delete(TABLE_NAME_9);
    });
    return 0;
  }


  // /*---------------------ValueViseStock Table Function-------------------- */
  Future<List<Map<String, dynamic>>> fetchSavedValueViseStock() async {
    Database? db = await (instance.database);
    return  await db!.query(TABLE_NAME_10);
  }

  Future<int> insertValueViseStock(List<ValueWise>? row) async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      Batch batch=txn.batch();
      row!.forEach((element) async{ batch.insert(TABLE_NAME_10, element.toJson());});
      await batch.commit();
    });
    return 0;
  }

  Future<int> deleteValueViseStock() async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      await txn.delete(TABLE_NAME_10);
    });
    return 0;
  }

  // /*---------------------HighValue Table Function-------------------- */
  Future<List<Map<String, dynamic>>> fetchSavedHighValue() async {
    Database? db = await (instance.database);
    return  await db!.query(TABLE_NAME_11);
  }

  Future<int> insertHighValue(List<HighValue>? row) async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      Batch batch=txn.batch();
      row!.forEach((element) async{ batch.insert(TABLE_NAME_11, element.toJson());});
      await batch.commit();
    });
    return 0;
  }


  Future<int> deleteHighValue() async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      await txn.delete(TABLE_NAME_11);
    });
    return 0;
  }


  // /*---------------------CpnsAnalysisi Table Function-------------------- */
  Future<List<Map<String, dynamic>>> fetchConsAnalysis() async {
    Database? db = await (instance.database);
    return  await db!.query(TABLE_NAME_12);
  }

  Future<int> insertConsAnalysis(List<ConsAnalysis>? row) async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      Batch batch=txn.batch();
      row!.forEach((element) async{ batch.insert(TABLE_NAME_12, element.toJson());});
      await batch.commit();
    });
    return 0;
  }


  Future<int> deleteConsAnalysis() async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      await txn.delete(TABLE_NAME_12);
    });
    return 0;
  }

  // /*---------------------CpnsSummary Table Function-------------------- */
  Future<List<Map<String, dynamic>>> fetchConsSummary() async {
    Database? db = await (instance.database);
    return  await db!.query(TABLE_NAME_13);
  }

  Future<int> insertConsSummary(List<ConsSummary>? row) async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      Batch batch=txn.batch();
      row!.forEach((element) async{ batch.insert(TABLE_NAME_13, element.toJson());});
      await batch.commit();
    });
    return 0;
  }


  Future<int> deleteConsSummary() async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      await txn.delete(TABLE_NAME_13);
    });
    return 0;
  }

  // /*---------------------onlineSummary Table Function-------------------- */
  Future<List<Map<String, dynamic>>> fetchonlineSummary() async {
    Database? db = await (instance.database);
    return  await db!.query(TABLE_NAME_14);
  }

  Future<int> insertonlineSummary(List<Summary>? row) async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      Batch batch=txn.batch();
      row!.forEach((element) async{ batch.insert(TABLE_NAME_14, element.toJson());});

      await batch.commit();
    });
    return 0;
  }


  Future<int> deleteonlineSummary() async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      await txn.delete(TABLE_NAME_14);
    });
    return 0;
  }

  //----- Status Display Screen DB------

  Future<List<Map<String, dynamic>>> fetchonlineStatus() async {
    Database? db = await (instance.database);
    return  await db!.query(TABLE_NAME_15);
  }

  Future<int> insertonlineStatus(List<Status>? row) async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      Batch batch=txn.batch();
      row!.forEach((element) async{ batch.insert(TABLE_NAME_15, element.toJson());});
      await batch.commit();
    });
    return 0;
  }

  Future<int> deleteonlineStatus() async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      await txn.delete(TABLE_NAME_15);
    });
    return 0;
  }

  Future<List<Status>> getOnlineBillStatusItemList() async {
    final List<Map<String, dynamic>> maps = await _database!.query('Status');
    return List.generate(maps.length, (i) {
      return Status(
        cONSNAME: maps[i]['consname'].toString(),
        cONSRLY: maps[i]['consrly'].toString(),
        pONUMBER: maps[i]['ponumber'].toString(),
        pODATE: maps[i]['podate'].toString(),
        cONSIGNEE: maps[i]['consignee'].toString(),
        aCCOUNTNAME: maps[i]['accountname'].toString(),
        pOSR: maps[i]['posr'].toString(),
       /* item_code: maps[i]['plnumber'].toString(),
        ledger_name: maps[i]['ledgername'].toString(),
        description: maps[i]['itemdescription'].toString(),*/
        iTEMDESCRIPTION: maps[i]['itemdescription'].toString(),
       /* qty: maps[i]['qty'].toString(),
        rate: maps[i]['booavgrat'].toString(),
        orgZone: maps[i]['orgzone'].toString(),
        subConsCode: maps[i]['subconscode'].toString(),
        booavgrat: maps[i]['booavgrat'].toString(),
        depoDetail: maps[i]['depodetail'].toString(),
        rLY: maps[i]['rly'].toString(),
        cons_code: maps[i]['cons_code'].toString(),
        isscongDept: maps[i]['issconsgdept'].toString(),
        rlyName: maps[i]['rlyname'].toString(),
        unit: maps[i]['unit'].toString(),
        itemcat: maps[i]['itemcat'].toString(),
        folioName: maps[i]['folioname'].toString(),
        plimagePath: maps[i]['plimagepath'].toString(),*/
      );
    });
  }


  // ---------------Trasactions Screen DB--------------

  Future<List<Map<String, dynamic>>> fetchTransactionsData() async {
    Database? db = await (instance.database);
    return  await db!.query(TABLE_NAME_16);
  }

  Future<int> insertTransactionsData(List<TransactionListDataModel>? row) async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      Batch batch=txn.batch();
      row!.forEach((element) async{ batch.insert(TABLE_NAME_16, element.toJson());});
      await batch.commit();
    });
    return 0;
  }

  Future<int> deleteTransactionsData() async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      await txn.delete(TABLE_NAME_16);
    });
    return 0;
  }

  Future<List<TransactionListDataModel>> getTransactionsData() async {
    final List<Map<String, dynamic>> maps = await _database!.query('Transactions');
    return List.generate(maps.length, (i) {
      return TransactionListDataModel(
        mACHINEDTLS: maps[i]['machinedtls'].toString(),
        sTKVERIFIERUSERNAME: maps[i]['stkverifierusername'].toString(),
        sTKVERIFIERPOST: maps[i]['stkverifierpost'].toString(),
        tRANSUSERNAME: maps[i]['transusername'].toString(),
        uSERTYPE: maps[i]['usertype'].toString(),
        tRANSREMARKS: maps[i]['transremarks'].toString(),
        rEFTRANSKEY: maps[i]['reftranskey'].toString(),
        tRANSKEY: maps[i]['transkey'].toString(),
        rEJIND: maps[i]['rejind'].toString(),
        tHRESHOLDLIMIT: maps[i]['thresholdlimit'].toString(),
        cANCELLEDVOUCHERNO: maps[i]['cancelledvoucherno'].toString(),
        cANCELLEDVOUCHERDATE: maps[i]['cancelledvoucherdate'].toString(),
        tRANSSTATUS : maps[i]['transstatus'].toString(),
        iSSEDEPOTTYPE: maps[i]['issedepottype'].toString(),
        pONO: maps[i]['pono'].toString(),
        lOANBALQTY: maps[i]['loanbalqty'].toString(),
        lOANINDDESC: maps[i]['loaninddesc'].toString(),
        tRANSTYPEDESCRIPTION: maps[i]['transtypedescription'].toString(),
        tRANSCARDCODEDESC: maps[i]['transcardcodedesc'].toString(),
        rEMARKS: maps[i]['remarks'].toString(),
        aCKNOWLEDGEFLAG: maps[i]['acknowledgeflag'].toString(),
        cARDCODE: maps[i]['cardcode'].toString(),
        oPENBALSTKQTY: maps[i]['openbalstkqty'].toString(),
        cLOSINGBALSTKQTY: maps[i]['closingbalstkqty'].toString(),
        oPENBALVALUE: maps[i]['openbalvalue'].toString(),
        cLOSINGBALVALUE: maps[i]['closingbalvalue'].toString(),
        sTKQTY: maps[i]['stkqty'].toString(),
        sTKVALUE: maps[i]['stkvalue'].toString(),
        bAR: maps[i]['bar'].toString(),
        oRG_ZONE: maps[i]['org_zone'].toString(),
        rLYNAME: maps[i]['rlyname'].toString(),
        cONS_CODE: maps[i]['cons_code'].toString(),
        lEDGERNO: maps[i]['ledgerno'].toString(),
        lEDGERNAME: maps[i]['ledgername'].toString(),
        lEDGERFOLIONO: maps[i]['ledgerfoliono'].toString(),
        lEDGERFOLIONAME: maps[i]['ledgerfolioname'].toString(),
        lEDGERFOLIOPLNO: maps[i]['ledgerfolioplno'].toString(),
        tRANSUNIT: maps[i]['transunit'].toString(),
        lEDGERFOLIOSHORTDESC: maps[i]['ledgerfolioshortdesc'].toString(),
        tRANSTYPE: maps[i]['transtype'].toString(),
        pO_TYPE: maps[i]['po_type'].toString(),
        vOUCHERNO: maps[i]['voucherno'].toString(),
        vOUCHERDATE: maps[i]['voucherdate'].toString(),
        tRANSDATE: maps[i]['transdate'].toString(),
        fIRMACCOUNTNAME: maps[i]['firmaccountname'].toString(),
        tRANSQTY: maps[i]['transqty'].toString(),
        iSSUEQTY: maps[i]['issueqty'].toString(),
        bALANCEQTY: maps[i]['balanceqty'].toString(),
        iSSUETOTALVALUE: maps[i]['issuetotalvalue'].toString(),
        iSSUETOTALQTY: maps[i]['issuetotalqty'].toString(),
        rECEIPTTOTALQTY: maps[i]['receipttotalqty'].toString(),
        rECEIPTTOTALVALUE: maps[i]['receipttotalvalue'].toString(),
      );
    });
  }


  //-----------------action page----------------------

  Future<List<Map<String, dynamic>>> fetchonlineStatusAction() async {
    Database? db = await (instance.database);
    return  await db!.query(TABLE_NAME_15);
  }

  Future<int> insertonlineStatusAction(List<ActionModel>? row) async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      Batch batch=txn.batch();
      row!.forEach((element) async{ batch.insert(TABLE_NAME_15, element.toJson());});
      await batch.commit();
    });
    return 0;
  }

  Future<int> deleteonlineStatusAction() async {
    Database? db = await (instance.database);
    await db!.transaction((txn) async {
      await txn.delete(TABLE_NAME_15);
    });
    return 0;
  }

  Future<List<ActionModel>> getActionModelData() async {
    final List<Map<String, dynamic>> maps = await _database!.query('Actionpage');
    return List.generate(maps.length, (i) {
      return ActionModel(
        pONUMBER: maps[i]['pono'].toString(),
        pOSR: maps[i]['posr'].toString(),
        unit : maps[i]['unit'].toString(),
        fROMBILL: maps[i]['frombill'].toString(),
        vENDORNAME : maps[i]['vendorname'].toString(),
        iTEMDESC: maps[i]['itemdesc'].toString(),
        dOCNO : maps[i]['docno'].toString(),
        dOCDATE : maps[i]['docdate'].toString(),
        pAYINGRLY: maps[i]['payingrly'].toString(),
        pAYINGAUTHORITY : maps[i]['payingauthority'].toString(),
        rLY : maps[i]['rly'].toString(),
        dOCTYPE : maps[i]['doctype'].toString(),
        bILLNO : maps[i]['billno'].toString(),
        bILLDATE : maps[i]['billdate'].toString(),
        iREPSBILLNO : maps[i]['irepsbillno'].toString(),
        iREPSBILLDATE : maps[i]['irepsbilldate'].toString(),
        bILLTYPE : maps[i]['billtype'].toString(),
        pAYMENTTYPE : maps[i]['paymenttype'].toString(),
        pAYMENTPERCENTAGE : maps[i]['paymentpercentage'].toString(),
        iTEMNOOFBILL : maps[i]['itemnoofbill'].toString(),
        bILLAMOUNTFORITEM : maps[i]['billamountforitem'].toString(),
        cO6NO : maps[i]['co6no'].toString(),
        cO6DATE : maps[i]['co6date'].toString(),
        cO7NO : maps[i]['co7no'].toString(),
        cO7DATE: maps[i]['co7date'].toString(),
        pASSEDAMOUNTFORITEM : maps[i]['passedamountforitem'].toString(),
        pAYMENTRETURNDATE : maps[i]['paymentreturndate'].toString(),
        tOTALAMOUNTFORBILL : maps[i]['totalamountforbill'].toString(),
        pASSEDAMOUNTFORBILL : maps[i]['passedamountforbill'].toString(),
        dEDUCTEDAMOUNTFORBILL : maps[i]['deductedamountforbill'].toString(),
        pAIDAMOUNTFORBILL : maps[i]['paidamountforbill'].toString(),
        rETURNREASON : maps[i]['returnreason'].toString(),
        rNOTENO : maps[i]['rnoteno'].toString(),
        rNOTEDATE : maps[i]['rnotedate'].toString(),
        qTYACCEPTED : maps[i]['qtyaccepted'].toString(),
        pODATE : maps[i]['podate'].toString(),
        qty: maps[i]['qty'].toString(),
        pAYAUTH: maps[i]['payauth'].toString(),
      );
    });
  }

}



