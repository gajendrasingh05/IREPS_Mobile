import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
//----------------------------------------Changes by Gurmeet begins-------------------------
  static final _databaseName = "AapoortiFlite1.db";
  static final _databaseVersion = 8;


  //TABLE-2 Version Control
  static final String TABLE_NAME_2 = "VersionControl";
  static final String Tbl2_Col1_Date = "Date";
  static final String Tbl2_Col2_UpdateFlag = "UpdateFlag"; //0 - Not Needed   // 1 - Needed  // 2 - Not Necessary(Update Later)
  static final String Tbl2_Col3_LatestVersion = "LatestVersion";

  //TABLE-2 Login User
  static final String TABLE_NAME_5   = "LoginUser";
  static final String Tbl5_Col1_EmailId   = "EmailId";
  static final String Tbl5_Col2_LoginFlag   = "LoginFlag";


  //TABLE-2 Save Login User
  static final String TABLE_NAME_3   = "SaveLoginUser";
  static final String Tbl3_Col1_Hash  = "Hash";
  static  var Tbl3_Col2_Date  = "Date";
  static final String Tbl3_Col3_Ans  = "Ans";
  static final String Tbl3_Col4_Log = "Log";

  //Table For BannedFirms
  static final String TABLE_BANNED ="Bannedfirms";
  static final String Tblb_Col1_Title ="VNAME";
  static final String Tblb_Col2_Letter ="LET_NO";
  static final String Tblb_Col3_Date ="LET_DT_S";
  static final String Tblb_Col4_Address ="VADDRESS";
  static final String Tblb_Col5_Type ="SUBJ";
  static final String Tblb_Col6_Banned ="BAN_UPTO";
  static final String Tblb_Col7_Remarks ="REMARKS";
  static final String Tblb_Col8_Id ="DOC_ID";
  static final String Tblb_Col9_view ="DOC_PATH";
  static final String Tblb_Col10_Date ="Date1";
  static final String Tblb_Col11_Count ="Count";


  //Table For AuctionSchedule
  static final String TABLE_SCHEDULE="Schedule";
  static final String Tblb_Col1_rail ="RLYNAME";
  static final String Tblb_Col2_dept ="DEPTNAME";
  static final String Tblb_Col3_schdlno ="SCHDLNO";
  static final String Tblb_Col4_start ="START_DATETIME";
  static final String Tblb_Col5_end ="END_DATETIME";
  static final String Tblb_Col7_desc ="DESCRIPTION";
  static final String Tblb_Col12_corr="CORRI_DETAILS";
  static final String Tblb_Col8_catid="CATID";

  //Table For AuctionScheduleNEXT
  static final String TABLE_SCHDLNEXT="ScheduleNext";
  static final String Tblb_Col1_lotno ="LOTNO";
  static final String Tblb_Col2_status ="LOT_STATUS";
  static final String Tblb_Col3_start ="LOT_START_DATETIME";
  static final String Tblb_Col4_end ="LOT_END_DATETIME";
  static final String Tblb_Col5_qty ="LOT_QTY";
  static final String Tblb_Col7_min ="MIN_INCR_AMT";
  static final String Tblb_Col8_desc ="LOTMATDESC";
  static final String Tblb_Col19_id ="LOTID";

  //Table for schedule third page
  static final String TABLE_SCHDLTHRD="ScheduleThird";
  static final String Tblb_Col1_accnm ="ACCNM";
  static final String Tblb_Col2_deptnm ="DEPTNM";
  static final String Tblb_Col3_lotno ="LOTNO";
  static final String Tblb_Col4_cat ="CATNM";
  static final String Tblb_Col5_pl ="PLN";
  static final String Tblb_Col7_lotdesc ="LOTMATDESC";
  static final String Tblb_Col8_spcl ="SPCLCOND";
  static final String Tblb_Col19_cust ="CUST";
  static final String Tblb_Col20_loc ="LOC";
  static final String Tblb_Col21_gst ="GST";
  static final String Tblb_Col22_itm ="EXCLDITMS";
  static final String Tblb_Col23_qty ="LOTQTY";

  //Table for dashboard data
  static final String TABLE_NAME_DASH  = "Dash";
  static final String Tbld_Col1_MODULE="MODULE";
  static final String Tbld_Col2_UNIQUEGRAPHID="UNIQURGRAPHID";
  static final String Tbld_Col3_HEADING= "HEADING";
  static final String Tbld_Col4_XAXIS="XAXIS";
  static final String Tbld_Col5_YAXIS="YAXIS";
  static final String Tbld_Col6_LEGEND="LEGEND";
  static final String Tbld_Col7_LASTUPDATEDON="LASTUPDATEDON";
  static final String Tbld_Col9_UPDATEDFLAG="UPDATEDFLAG";
  static final String Tbld_Col8_CREATION_TIME="CREATION_TIME";



  //TABLE-9 Closed RA
  static final String TABLE_NAME_9 = "ClosedRA";
  static final String Tbl9_Col1_SrNo = "SrNo";
  static final String Tbl9_Col2_RlyDept = "RLY_DEPT";
  static final String Tbl9_Col3_tenderNo = "TENDER_NUMBER";
  static final String Tbl9_Col4_tendertitle = "TENDER_TITLE";
  static final String Tbl9_Col5_workArea = "WORK_AREA";
  static final String Tbl9_Col6_StrtDate = "RA_START_DT";
  static final String Tbl9_Col7_EnDDate = "RA_CLOSE_DT";
  static final String Tbl9_Col8_NitPdfUrl = "NIT_PDF_URL";
  static final String Tbl9_Col9_StatusRA = "STATUS";
  static final String Tbl9_Col10_DocsRA = "ATTACH_DOCS";
  static final String Tbl9_Col11_CorrigendumRA = "CORRI_DETAILS";



  static final String TABLE_NAME_8 = "CustomSearch";
  static final String COLUMN_SrNo = "SrNo";
  static final String COLUMN_DeptRly = "ACC_NAME";
  static final String COLUMN_WorkArea = "WORK_ARA";
  static final String COLUMN_TenderTitle = "TENDER_DESCRIPTION";
  static final String COLUMN_TenderOPDate = "TENDER_OPDATE";
  static final String COLUMN_oid = "OID";
  static final String COLUMN_TenderNo = "TENDER_NUMBER";
  static final String COLUMN_pdf = "PDFURL";
  static final String COLUMN_Attachdocs = "ATTACH_DOCS";
  static final String COLUMN_Cor = "CORRI_DETAILS";
  static final String COLUMN_TenderStatus = "TENDER_STATUS";
  static final String COLUMN_Type = "TENDER_TYPE";
  static final String COLUMN_BiddingSystem = "BIDDING_SYSTEM";

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,onUpgrade: _onUpgrade);
  }
   Future _onUpgrade(Database db,int oldVersion,int newVersion) async
  {
    print("database upgrading");

   if(newVersion>oldVersion)
     {
       await db.execute("DROP TABLE IF EXISTS $TABLE_BANNED ;");
       await db.execute("DROP TABLE IF EXISTS $TABLE_SCHEDULE ;");
       await db.execute("DROP TABLE IF EXISTS $TABLE_SCHDLNEXT ;");
       await db.execute("DROP TABLE IF EXISTS $TABLE_SCHDLTHRD ;");
       await db.execute('''
          CREATE TABLE $TABLE_BANNED (
            $Tblb_Col1_Title TEXT NOT NULL,
            $Tblb_Col2_Letter TEXT NOT NULL,
            $Tblb_Col3_Date TEXT NOT NULL,
            $Tblb_Col4_Address TEXT NOT NULL,
            $Tblb_Col5_Type TEXT NOT NULL,
            $Tblb_Col6_Banned TEXT NOT NULL,
            $Tblb_Col7_Remarks TEXT NOT NULL,
            $Tblb_Col8_Id TEXT NOT NULL,
            $Tblb_Col9_view TEXT NOT NULL,
            $Tblb_Col10_Date TEXT NOT NULL,
            $Tblb_Col11_Count TEXT NOT NULL
 
          )
          ''');
       await db.execute('''
          CREATE TABLE $TABLE_SCHEDULE(
            $Tblb_Col1_rail TEXT NOT NULL,
            $Tblb_Col2_dept TEXT NOT NULL,
            $Tblb_Col3_schdlno TEXT NOT NULL,
            $Tblb_Col4_start TEXT NOT NULL,
            $Tblb_Col5_end TEXT NOT NULL,
            $Tblb_Col7_desc TEXT NOT NULL,
             $Tblb_Col12_corr TEXT NOT NULL,
             $Tblb_Col8_catid TEXT NOT NULL
 
          )
          ''');
       await db.execute('''
          
                CREATE TABLE $TABLE_SCHDLNEXT (                
            $Tblb_Col1_lotno TEXT NOT NULL,
            $Tblb_Col2_status TEXT NOT NULL,
            $Tblb_Col3_start TEXT NOT NULL,
            $Tblb_Col4_end TEXT NOT NULL,
            $Tblb_Col5_qty TEXT NOT NULL,
            $Tblb_Col7_min TEXT NOT NULL,
            $Tblb_Col8_desc TEXT NOT NULL,
            $Tblb_Col19_id TEXT NOT NULL
               )       
          
          ''');
       await db.execute('''                                 
      CREATE TABLE $TABLE_SCHDLTHRD (                
            $Tblb_Col1_accnm TEXT NOT NULL,
            $Tblb_Col2_deptnm TEXT NOT NULL,
            $Tblb_Col3_lotno TEXT NOT NULL,
            $Tblb_Col4_cat TEXT NOT NULL,
            $Tblb_Col5_pl TEXT NOT NULL,
            $Tblb_Col7_lotdesc TEXT NOT NULL,
            $Tblb_Col8_spcl TEXT NOT NULL,
            $Tblb_Col19_cust TEXT NOT NULL,
            $Tblb_Col20_loc TEXT NOT NULL,
            $Tblb_Col21_gst TEXT NOT NULL,
            $Tblb_Col22_itm TEXT NOT NULL,
            $Tblb_Col23_qty TEXT NOT NULL
                                                     
      )                                              
      ''');
     }
  }
   // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    print("Database Created");

    await db.execute('''
    CREATE TABLE $TABLE_NAME_8 ( 
    $COLUMN_SrNo TEXT NOT NULL,
    $COLUMN_DeptRly  TEXT NOT NULL,
    $COLUMN_WorkArea TEXT NOT NULL,
    $COLUMN_TenderTitle TEXT NOT NULL, 
    $COLUMN_TenderOPDate TEXT NOT NULL,
    $COLUMN_oid TEXT NOT NULL, 
    $COLUMN_TenderNo TEXT NOT NULL, 
    $COLUMN_pdf TEXT NOT NULL, 
    $COLUMN_Attachdocs TEXT NOT NULL,
    $COLUMN_Cor TEXT NOT NULL,
    $COLUMN_TenderStatus TEXT NOT NULL,
    $COLUMN_Type TEXT NOT NULL, 
    $COLUMN_BiddingSystem TEXT  NOT NULL
    )
    ''');


    await db.execute('''
          CREATE TABLE $TABLE_NAME_9 (
            $Tbl9_Col1_SrNo TEXT NOT NULL,
            $Tbl9_Col2_RlyDept TEXT NOT NULL,
            $Tbl9_Col3_tenderNo TEXT NOT NULL,
            $Tbl9_Col4_tendertitle TEXT NOT NULL,
            $Tbl9_Col5_workArea TEXT NOT NULL,
            $Tbl9_Col6_StrtDate TEXT NOT NULL,
            $Tbl9_Col7_EnDDate TEXT NOT NULL,
            $Tbl9_Col8_NitPdfUrl TEXT NOT NULL,
            $Tbl9_Col9_StatusRA TEXT NOT NULL,
            $Tbl9_Col10_DocsRA TEXT NOT NULL,
            $Tbl9_Col11_CorrigendumRA TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $TABLE_NAME_5 (
            $Tbl5_Col1_EmailId TEXT NOT NULL,
            $Tbl5_Col2_LoginFlag TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $TABLE_NAME_3 (
            $Tbl3_Col1_Hash TEXT NOT NULL,
            $Tbl3_Col2_Date TEXT NOT NULL,
            $Tbl3_Col3_Ans TEXT NOT NULL,
            $Tbl3_Col4_Log TEXT NOT NULL
           
          )
          ''');

    await db.execute('''
          CREATE TABLE $TABLE_BANNED (
            $Tblb_Col1_Title TEXT NOT NULL,
            $Tblb_Col2_Letter TEXT NOT NULL,
            $Tblb_Col3_Date TEXT NOT NULL,
            $Tblb_Col4_Address TEXT NOT NULL,
            $Tblb_Col5_Type TEXT NOT NULL,
            $Tblb_Col6_Banned TEXT NOT NULL,
            $Tblb_Col7_Remarks TEXT NOT NULL,
            $Tblb_Col8_Id TEXT NOT NULL,
            $Tblb_Col9_view TEXT NOT NULL,
            $Tblb_Col10_Date TEXT NOT NULL,
            $Tblb_Col11_Count TEXT NOT NULL
 
          )
          ''');
    await db.execute('''
          CREATE TABLE $TABLE_SCHEDULE(
            $Tblb_Col1_rail TEXT NOT NULL,
            $Tblb_Col2_dept TEXT NOT NULL,
            $Tblb_Col3_schdlno TEXT NOT NULL,
            $Tblb_Col4_start TEXT NOT NULL,
            $Tblb_Col5_end TEXT NOT NULL,
            $Tblb_Col7_desc TEXT NOT NULL,  
            $Tblb_Col12_corr TEXT NOT NULL,
            $Tblb_Col8_catid TEXT NOT NULL
          )
          ''');


    await db.execute('''                                 
      CREATE TABLE $TABLE_NAME_DASH (                
        $Tbld_Col1_MODULE TEXT NOT NULL,             
        $Tbld_Col2_UNIQUEGRAPHID TEXT NOT NULL,      
        $Tbld_Col3_HEADING TEXT NOT NULL,            
        $Tbld_Col4_XAXIS TEXT NOT NULL,              
        $Tbld_Col5_YAXIS TEXT NOT NULL,              
        $Tbld_Col6_LEGEND TEXT NOT NULL,             
        $Tbld_Col7_LASTUPDATEDON TEXT NOT NULL,      
        $Tbld_Col8_CREATION_TIME TEXT NOT NULL,      
        $Tbld_Col9_UPDATEDFLAG TEXT NOT NULL         
                                                     
      )                                              
      ''');
    await db.execute('''                                 
      CREATE TABLE $TABLE_SCHDLNEXT (                
            $Tblb_Col1_lotno TEXT NOT NULL,
            $Tblb_Col2_status TEXT NOT NULL,
            $Tblb_Col3_start TEXT NOT NULL,
            $Tblb_Col4_end TEXT NOT NULL,
            $Tblb_Col5_qty TEXT NOT NULL,
            $Tblb_Col7_min TEXT NOT NULL,
            $Tblb_Col8_desc TEXT NOT NULL,
            $Tblb_Col19_id TEXT NOT NULL
                                                     
      )                                              
      ''');
    await db.execute('''                                 
      CREATE TABLE $TABLE_SCHDLTHRD (                
            $Tblb_Col1_accnm TEXT NOT NULL,
            $Tblb_Col2_deptnm TEXT NOT NULL,
            $Tblb_Col3_lotno TEXT NOT NULL,
            $Tblb_Col4_cat TEXT NOT NULL,
            $Tblb_Col5_pl TEXT NOT NULL,
            $Tblb_Col7_lotdesc TEXT NOT NULL,
            $Tblb_Col8_spcl TEXT NOT NULL,
            $Tblb_Col19_cust TEXT NOT NULL,
            $Tblb_Col20_loc TEXT NOT NULL,
            $Tblb_Col21_gst TEXT NOT NULL,
            $Tblb_Col22_itm TEXT NOT NULL,
            $Tblb_Col23_qty TEXT NOT NULL
                                                     
      )                                              
      ''');


    await db.execute('''
          CREATE TABLE $TABLE_NAME_2 (
            $Tbl2_Col1_Date TEXT NOT NULL,
            $Tbl2_Col2_UpdateFlag TEXT NOT NULL,
            $Tbl2_Col3_LatestVersion TEXT NOT NULL
          )
          ''');


  }
  //************************************** custom search Begin ******************************************************

  Future<int?> rowCountCustomSearch() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $TABLE_NAME_8'));
  }

  Future<List<Map<String, dynamic>>> fetchCustomSearch() async {
    Database db = await instance.database;
    return await db.query(TABLE_NAME_8);
  }

  Future<int> insertCustomSearch(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(TABLE_NAME_8, row);
  }

  Future<int> deleteCustomSearch(int id) async {
    Database db = await instance.database;
    return await db.delete(TABLE_NAME_8);
  }

  //********************dashboard
  Future<int?> rowCountd() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $TABLE_NAME_DASH'));
  }
  Future<List<Map<String, dynamic>>> fetchd() async {
    Database db = await instance.database;
    return await db.query(TABLE_NAME_DASH);
  }
  Future<int> insertd(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(TABLE_NAME_DASH, row);
  }
  Future<int> deleted(int id) async {
    Database db = await instance.database;
    return await db.delete(TABLE_NAME_DASH);
  }
  Future<int> insertds(Map<String, dynamic> row, table) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }
  //***************CLOSED RA FUNCTIONS BEGIN*******************************************************************************
  Future<int?> rowCountClosedRA() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $TABLE_NAME_9'));
  }
  Future<List<Map<String, dynamic>>> fetchClosedRA() async {
    Database db = await instance.database;
    return await db.query(TABLE_NAME_9);
  }
  Future<int> insertClosedRA(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(TABLE_NAME_9, row);
  }
  Future<int> deleteClosedRA(int id) async {
    Database db = await instance.database;
    return await db.delete(TABLE_NAME_9);
  }
  Future<int> insert(Map<String, dynamic> row, table) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }
//***************CLOSED RA FUNCTIONS END*******************************************************************************
//insert into CustomSearch

  void insertRecordcustomsearch(
      String DeptRly,
      String WorkArea,
      String TenderTitle,
      String TenderOPDate,
      int oid,
      String TenderNo,
      String pdf,
      String Attachdocs,
      String Cor,
      String TenderStatus,
      String Type,
      String BiddingSystem) async {
    final dbHelper = DatabaseHelper.instance;
    Map<String, dynamic> row = {
      DatabaseHelper.COLUMN_DeptRly: DeptRly,
      DatabaseHelper.COLUMN_WorkArea: WorkArea,
      DatabaseHelper.COLUMN_TenderTitle: TenderTitle,
      DatabaseHelper.COLUMN_TenderOPDate: TenderOPDate,
      DatabaseHelper.COLUMN_oid: oid,
      DatabaseHelper.COLUMN_TenderNo: TenderNo,
      DatabaseHelper.COLUMN_pdf: pdf,
      DatabaseHelper.COLUMN_Attachdocs: Attachdocs,
      DatabaseHelper.COLUMN_Cor: Cor,
      DatabaseHelper.COLUMN_TenderStatus: TenderStatus,
      DatabaseHelper.COLUMN_Type: Type,
      DatabaseHelper.COLUMN_BiddingSystem: BiddingSystem
    };

    final id = await dbHelper.insert(row, TABLE_NAME_8);
    print('inserted row id: $id');
  }

  Future<List<Map<String, dynamic>>> getcustomsearchdata() async {
    Database db = await instance.database;
    return await db.rawQuery("Select * from " + TABLE_NAME_8);
  }

  Future<List<Map<String, dynamic>>> getcustomsearchFilterData(
      String status, String type, String bidding) async {
    Database db = await instance.database;
    String query = "";
    //If only status is available
    if (status != "All" && type == "All" && bidding == "All")
      query = "Select * from " +
          TABLE_NAME_8 +
          " where " +
          COLUMN_TenderStatus +
          " LIKE '%" +
          status +
          "%'";

    //If only type is available
    if (type != "All" && status == "All" && bidding == "All")
      query = "Select * from " +
          TABLE_NAME_8 +
          " where " +
          COLUMN_Type +
          " LIKE '%" +
          type +
          "%'";

    //If only bidding is available
    if (bidding != "All" && type == "All" && status == "All")
      query = "Select * from " +
          TABLE_NAME_8 +
          " where " +
          COLUMN_BiddingSystem +
          " LIKE '%" +
          bidding +
          "%'";

    //If only status and type are available
    if (status != "All" && type != "All" && bidding == "All")
      query = "Select * from " +
          TABLE_NAME_8 +
          " where " +
          COLUMN_TenderStatus +
          " LIKE '%" +
          status +
          "%'" +
          " AND " +
          COLUMN_Type +
          " LIKE '%" +
          type +
          "%'";

    //If only status aand bidding are available
    if (status != "All" && type == "All" && bidding != "All")
      query = "Select * from " +
          TABLE_NAME_8 +
          " where " +
          COLUMN_TenderStatus +
          " LIKE '%" +
          status +
          "%'" +
          " AND " +
          COLUMN_BiddingSystem +
          " LIKE '%" +
          bidding +
          "%'";

    //If only bidding and type are available
    if (status == "All" && type != "All" && bidding != "All")
      query = "Select * from " +
          TABLE_NAME_8 +
          " where " +
          COLUMN_Type +
          " LIKE '%" +
          type +
          "%'" +
          " AND " +
          COLUMN_BiddingSystem +
          " LIKE '%" +
          bidding +
          "%'";

    //If all params are available
    if (status != "All" && type != "All" && bidding != "All")
      query = "Select * from " +
          TABLE_NAME_8 +
          " where " +
          COLUMN_TenderStatus +
          " LIKE '%" +
          status +
          "%'" +
          " AND " +
          COLUMN_Type +
          " LIKE '%" +
          type +
          "%'" +
          " AND " +
          COLUMN_BiddingSystem +
          " LIKE '%" +
          bidding +
          "%'";

    if (status == "All" && type == "All" && bidding == "All")
      query = "Select * from " + TABLE_NAME_8;

    print(db.rawQuery(query));
    return db.rawQuery(query);
  }

//***************CLOSED RA FUNCTIONS END*******************************************************************************

//***************BANNED FIRMS*******************************************************************************
  Future<int?> rowCountBanned() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $TABLE_BANNED'));
  }
  Future<List<Map<String, dynamic>>> fetchBanned() async {
    Database db = await instance.database;
    return await db.query(TABLE_BANNED);
  }
  Future<int> insertBanned(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(TABLE_BANNED, row);
  }
  Future<int> deleteBanned(int id) async {
    Database db = await instance.database;
    return await db.delete(TABLE_BANNED);
  }


//***************LOGIN USER FUNCTIONS START*******************************************************************************
  Future<int?> rowCountLoginUser() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $TABLE_NAME_5'));
  }
  Future<List<Map<String, dynamic>>> fetchLoginUser() async {
    Database db = await instance.database;
    return await db.query(TABLE_NAME_5);
  }
  Future<int> insertLoginUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(TABLE_NAME_5, row);
  }
  Future<int> deleteLoginUser(int id) async {
    Database db = await instance.database;
    return await db.delete(TABLE_NAME_5);
  }
  //***************Save LOGIN USER FUNCTIONS START*******************************************************************************
  Future<List<Map<String, dynamic>>> fetchSaveLoginUser() async {
    Database db = await instance.database;
    return await db.query(TABLE_NAME_3);
  }
  Future<int> insertSaveLoginUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(TABLE_NAME_3, row);
  }
  Future<int> deleteSaveLoginUser(int id) async {
    Database db = await instance.database;
    return await db.delete(TABLE_NAME_3);
  }
//***************LOGIN USER FUNCTIONS END*******************************************************************************
  Future<int?> rowCountVersionDtls() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $TABLE_NAME_2'));
  }
  Future<List<Map<String, dynamic>>> fetchVersionDtls() async {
    Database db = await instance.database;
    return await db.query(TABLE_NAME_2);
  }
  Future<int> insertVersionDtls(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(TABLE_NAME_2, row);
  }
  Future<int> deleteVersionDtls(int id) async {
    Database db = await instance.database;
    return await db.delete(TABLE_NAME_2);
  }
  Future<int> updateVersionDtls(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.update(TABLE_NAME_2, row);
  }
  //***************************************AUCTION SCHEDULE START**********************************************************************

  Future<int?> rowCountSchedule() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $TABLE_SCHEDULE'));
  }
  Future<List<Map<String, dynamic>>> fetchSchedule() async {
    Database db = await instance.database;
    return await db.query(TABLE_SCHEDULE);
  }
  Future<int> insertSchedule(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(TABLE_SCHEDULE, row);
  }
  Future<int> deleteSchedule(int id) async {
    Database db = await instance.database;
    return await db.delete(TABLE_SCHEDULE);
  }


 /* Future<int> rowCountScheduleNext() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $TABLE_SCHDLNEXT'));
  }
  Future<List<Map<String, dynamic>>> fetchScheduleNext() async {
    Database db = await instance.database;
    return await db.query(TABLE_SCHDLNEXT);
  }
  Future<int> insertScheduleNext(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(TABLE_SCHDLNEXT, row);
  }
  Future<int> deleteScheduleNext(int id) async {
    Database db = await instance.database;
    return await db.delete(TABLE_SCHDLNEXT);

  }
  Future<int> insertscnxt(Map<String, dynamic> row, table) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }




  Future<int> rowCountScheduleThird() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $TABLE_SCHDLTHRD'));
  }
  Future<List<Map<String, dynamic>>> fetchScheduleThird() async {
    Database db = await instance.database;
    return await db.query(TABLE_SCHDLTHRD);
  }
  Future<int> insertScheduleThird(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(TABLE_SCHDLTHRD, row);
  }
  Future<int> deleteScheduleThird(int id) async {
    Database db = await instance.database;
    return await db.delete(TABLE_SCHDLTHRD);

  }
  Future<int> insertscthrd(Map<String, dynamic> row, table) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  */
//****************************************AUCTION SCHEDULE END****************************************************************************

//***************VERSION CONTROL FUNCTIONS START*******************************************************************************

//***************VERSION CONTROL FUNCTIONS END*******************************************************************************





/*Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[TABLE_NAME_9];
    return await db.update(TABLE_NAME_9, row);
  }*/
//----------------------------------------Changes by Gurmeet ends-------------------------


}


