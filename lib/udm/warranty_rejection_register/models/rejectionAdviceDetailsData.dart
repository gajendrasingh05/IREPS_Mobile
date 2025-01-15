class RejectionAdviceDetailsData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<RejectionAdviceData>? rejectionAdviceData;

  RejectionAdviceDetailsData(
      {this.apiFor, this.count, this.status, this.message, this.rejectionAdviceData});

  RejectionAdviceDetailsData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      rejectionAdviceData = <RejectionAdviceData>[];
      json['data'].forEach((v) {
        rejectionAdviceData!.add(new RejectionAdviceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_for'] = this.apiFor;
    data['count'] = this.count;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.rejectionAdviceData != null) {
      data['data'] = this.rejectionAdviceData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RejectionAdviceData {
  String? firmacctid;
  String? inspvcode;
  String? depotlodging;
  String? consigneereporting;
  String? assetdtlswarr;
  String? firtranskey;
  String? recoveredamt;
  String? withheldamount;
  String? inspvalue;
  String? warrantyno;
  String? warrantyperiod;
  String? remarkswarranty;
  String? icno;
  String? icdate;
  String? approvingagency;
  String? mfrname;
  String? inspectorname;
  String? inspectordesig;
  String? mobileno;
  String? usertype;
  String? username;
  String? warddetails;
  String? rejectionind;
  String? vrdate;
  String? trqty;
  String? trunitrate;
  String? trrejvalue;
  String? vrno;
  String? pono;
  String? podate;
  String? posr;
  String? trdate;
  String? challanno;
  String? challandate;
  String? billno;
  String? billdate;
  String? plno;
  String? recovind;
  String? poagency;
  String? itemdesc;
  String? makebrand;
  String? conscode;
  String? billpayoff;
  String? billpassoff;
  String? productsrno;
  String? dispatchdtls;
  String? qtyreceived;
  String? qtyrejected;
  String? rejreason;
  String? remarks;
  String? orirecovery;
  String? checkreinsp;
  String? trvalue;
  String? alloc;
  String? pounitrate;
  String? pounit;
  String? rlyname;
  String? regvrrefno;
  String? regvrrefdate;
  String? vrrefno;
  String? vrrefdate;
  String? subconcname;
  String? consigneepostdesig;
  String? departmentname;
  String? vendorname;
  String? rejconsigneeissuename;
  String? consigneeissuename;
  String? rejectionrailwayname;
  String? rejconscode;
  String? deliveryterm;

  RejectionAdviceData(
      {this.firmacctid,
        this.inspvcode,
        this.depotlodging,
        this.consigneereporting,
        this.assetdtlswarr,
        this.firtranskey,
        this.recoveredamt,
        this.withheldamount,
        this.inspvalue,
        this.warrantyno,
        this.warrantyperiod,
        this.remarkswarranty,
        this.icno,
        this.icdate,
        this.approvingagency,
        this.mfrname,
        this.inspectorname,
        this.inspectordesig,
        this.mobileno,
        this.usertype,
        this.username,
        this.warddetails,
        this.rejectionind,
        this.vrdate,
        this.trqty,
        this.trunitrate,
        this.trrejvalue,
        this.vrno,
        this.pono,
        this.podate,
        this.posr,
        this.trdate,
        this.challanno,
        this.challandate,
        this.billno,
        this.billdate,
        this.plno,
        this.recovind,
        this.poagency,
        this.itemdesc,
        this.makebrand,
        this.conscode,
        this.billpayoff,
        this.billpassoff,
        this.productsrno,
        this.dispatchdtls,
        this.qtyreceived,
        this.qtyrejected,
        this.rejreason,
        this.remarks,
        this.orirecovery,
        this.checkreinsp,
        this.trvalue,
        this.alloc,
        this.pounitrate,
        this.pounit,
        this.rlyname,
        this.regvrrefno,
        this.regvrrefdate,
        this.vrrefno,
        this.vrrefdate,
        this.subconcname,
        this.consigneepostdesig,
        this.departmentname,
        this.vendorname,
        this.rejconsigneeissuename,
        this.consigneeissuename,
        this.rejectionrailwayname,
        this.rejconscode,
        this.deliveryterm});

  RejectionAdviceData.fromJson(Map<String, dynamic> json) {
    firmacctid = json['firmacctid'];
    inspvcode = json['inspvcode'];
    depotlodging = json['depotlodging'];
    consigneereporting = json['consigneereporting'];
    assetdtlswarr = json['assetdtlswarr'];
    firtranskey = json['firtranskey'];
    recoveredamt = json['recoveredamt'];
    withheldamount = json['withheldamount'];
    inspvalue = json['inspvalue'];
    warrantyno = json['warrantyno'];
    warrantyperiod = json['warrantyperiod'];
    remarkswarranty = json['remarkswarranty'];
    icno = json['icno'];
    icdate = json['icdate'];
    approvingagency = json['approvingagency'];
    mfrname = json['mfrname'];
    inspectorname = json['inspectorname'];
    inspectordesig = json['inspectordesig'];
    mobileno = json['mobileno'];
    usertype = json['usertype'];
    username = json['username'];
    warddetails = json['warddetails'];
    rejectionind = json['rejectionind'];
    vrdate = json['vrdate'];
    trqty = json['trqty'];
    trunitrate = json['trunitrate'];
    trrejvalue = json['trrejvalue'];
    vrno = json['vrno'];
    pono = json['pono'];
    podate = json['podate'];
    posr = json['posr'];
    trdate = json['trdate'];
    challanno = json['challanno'];
    challandate = json['challandate'];
    billno = json['billno'];
    billdate = json['billdate'];
    plno = json['plno'];
    recovind = json['recovind'];
    poagency = json['poagency'];
    itemdesc = json['itemdesc'];
    makebrand = json['makebrand'];
    conscode = json['conscode'];
    billpayoff = json['billpayoff'];
    billpassoff = json['billpassoff'];
    productsrno = json['productsrno'];
    dispatchdtls = json['dispatchdtls'];
    qtyreceived = json['qtyreceived'];
    qtyrejected = json['qtyrejected'];
    rejreason = json['rejreason'];
    remarks = json['remarks'];
    orirecovery = json['orirecovery'];
    checkreinsp = json['checkreinsp'];
    trvalue = json['trvalue'];
    alloc = json['alloc'];
    pounitrate = json['pounitrate'];
    pounit = json['pounit'];
    rlyname = json['rlyname'];
    regvrrefno = json['regvrrefno'];
    regvrrefdate = json['regvrrefdate'];
    vrrefno = json['vrrefno'];
    vrrefdate = json['vrrefdate'];
    subconcname = json['subconcname'];
    consigneepostdesig = json['consigneepostdesig'];
    departmentname = json['departmentname'];
    vendorname = json['vendorname'];
    rejconsigneeissuename = json['rejconsigneeissuename'];
    consigneeissuename = json['consigneeissuename'];
    rejectionrailwayname = json['rejectionrailwayname'];
    rejconscode = json['rejconscode'];
    deliveryterm = json['deliveryterm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firmacctid'] = this.firmacctid;
    data['inspvcode'] = this.inspvcode;
    data['depotlodging'] = this.depotlodging;
    data['consigneereporting'] = this.consigneereporting;
    data['assetdtlswarr'] = this.assetdtlswarr;
    data['firtranskey'] = this.firtranskey;
    data['recoveredamt'] = this.recoveredamt;
    data['withheldamount'] = this.withheldamount;
    data['inspvalue'] = this.inspvalue;
    data['warrantyno'] = this.warrantyno;
    data['warrantyperiod'] = this.warrantyperiod;
    data['remarkswarranty'] = this.remarkswarranty;
    data['icno'] = this.icno;
    data['icdate'] = this.icdate;
    data['approvingagency'] = this.approvingagency;
    data['mfrname'] = this.mfrname;
    data['inspectorname'] = this.inspectorname;
    data['inspectordesig'] = this.inspectordesig;
    data['mobileno'] = this.mobileno;
    data['usertype'] = this.usertype;
    data['username'] = this.username;
    data['warddetails'] = this.warddetails;
    data['rejectionind'] = this.rejectionind;
    data['vrdate'] = this.vrdate;
    data['trqty'] = this.trqty;
    data['trunitrate'] = this.trunitrate;
    data['trrejvalue'] = this.trrejvalue;
    data['vrno'] = this.vrno;
    data['pono'] = this.pono;
    data['podate'] = this.podate;
    data['posr'] = this.posr;
    data['trdate'] = this.trdate;
    data['challanno'] = this.challanno;
    data['challandate'] = this.challandate;
    data['billno'] = this.billno;
    data['billdate'] = this.billdate;
    data['plno'] = this.plno;
    data['recovind'] = this.recovind;
    data['poagency'] = this.poagency;
    data['itemdesc'] = this.itemdesc;
    data['makebrand'] = this.makebrand;
    data['conscode'] = this.conscode;
    data['billpayoff'] = this.billpayoff;
    data['billpassoff'] = this.billpassoff;
    data['productsrno'] = this.productsrno;
    data['dispatchdtls'] = this.dispatchdtls;
    data['qtyreceived'] = this.qtyreceived;
    data['qtyrejected'] = this.qtyrejected;
    data['rejreason'] = this.rejreason;
    data['remarks'] = this.remarks;
    data['orirecovery'] = this.orirecovery;
    data['checkreinsp'] = this.checkreinsp;
    data['trvalue'] = this.trvalue;
    data['alloc'] = this.alloc;
    data['pounitrate'] = this.pounitrate;
    data['pounit'] = this.pounit;
    data['rlyname'] = this.rlyname;
    data['regvrrefno'] = this.regvrrefno;
    data['regvrrefdate'] = this.regvrrefdate;
    data['vrrefno'] = this.vrrefno;
    data['vrrefdate'] = this.vrrefdate;
    data['subconcname'] = this.subconcname;
    data['consigneepostdesig'] = this.consigneepostdesig;
    data['departmentname'] = this.departmentname;
    data['vendorname'] = this.vendorname;
    data['rejconsigneeissuename'] = this.rejconsigneeissuename;
    data['consigneeissuename'] = this.consigneeissuename;
    data['rejectionrailwayname'] = this.rejectionrailwayname;
    data['rejconscode'] = this.rejconscode;
    data['deliveryterm'] = this.deliveryterm;
    return data;
  }
}