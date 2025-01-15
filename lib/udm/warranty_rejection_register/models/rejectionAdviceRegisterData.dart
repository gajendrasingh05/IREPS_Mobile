class RejectionAdviceRegisterData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<RejAdcRegData>? data;

  RejectionAdviceRegisterData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  RejectionAdviceRegisterData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RejAdcRegData>[];
      json['data'].forEach((v) {
        data!.add(new RejAdcRegData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_for'] = this.apiFor;
    data['count'] = this.count;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RejAdcRegData {
  String? unifiedplno;
  String? recoveredamount;
  String? potype;
  String? depodetail;
  String? rlyname;
  String? rejadviceflag;
  String? recoverystatus;
  String? billpayoff;
  String? allocation;
  String? origrecovery;
  String? balrecovery;
  String? curstockinglocation;
  String? transkey;
  String? voucherno;
  String? voucherdate;
  String? transqty;
  String? qtyrejected;
  String? transrate;
  String? transvalue;
  String? ledgerkey;
  String? ledgerno;
  String? ledgerfoliono;
  String? ledgerfolioplno;
  String? itemdescription;
  String? dmtrno;
  String? dmtrdate;
  String? pounit;
  String? unitdes;
  String? qtyreceived;
  String? qtyaccepted;
  String? vendorname;
  String? pono;
  String? podate;
  String? balrejqty;
  String? balrejvalue;
  String? challanno;
  String? challandate;
  String? rejectionrej;
  String? acceptedqty;
  String? rejtranskey;
  String? totalreinspqty;
  String? returnedqty;
  String? suppliedqty;
  String? reinspflag;
  String? earlierdmtrno;
  String? earlierdmtrdate;
  String? rejadviceno;
  String? pdf_path;

  RejAdcRegData(
      {
        this.unifiedplno,
        this.recoveredamount,
        this.potype,
        this.depodetail,
        this.rlyname,
        this.rejadviceflag,
        this.recoverystatus,
        this.billpayoff,
        this.allocation,
        this.origrecovery,
        this.balrecovery,
        this.curstockinglocation,
        this.transkey,
        this.voucherno,
        this.voucherdate,
        this.transqty,
        this.qtyrejected,
        this.transrate,
        this.transvalue,
        this.ledgerkey,
        this.ledgerno,
        this.ledgerfoliono,
        this.ledgerfolioplno,
        this.itemdescription,
        this.dmtrno,
        this.dmtrdate,
        this.pounit,
        this.unitdes,
        this.qtyreceived,
        this.qtyaccepted,
        this.vendorname,
        this.pono,
        this.podate,
        this.balrejqty,
        this.balrejvalue,
        this.challanno,
        this.challandate,
        this.rejectionrej,
        this.acceptedqty,
        this.rejtranskey,
        this.totalreinspqty,
        this.returnedqty,
        this.suppliedqty,
        this.reinspflag,
        this.earlierdmtrno,
        this.earlierdmtrdate,
        this.rejadviceno,
        this.pdf_path
      });

  RejAdcRegData.fromJson(Map<String, dynamic> json) {
    unifiedplno = json['unifiedplno'];
    recoveredamount = json['recoveredamount'];
    potype = json['potype'];
    depodetail = json['depodetail'];
    rlyname = json['rlyname'];
    rejadviceflag = json['rejadviceflag'];
    recoverystatus = json['recoverystatus'];
    billpayoff = json['billpayoff'];
    allocation = json['allocation'];
    origrecovery = json['origrecovery'];
    balrecovery = json['balrecovery'];
    curstockinglocation = json['curstockinglocation'];
    transkey = json['transkey'];
    voucherno = json['voucherno'];
    voucherdate = json['voucherdate'];
    transqty = json['transqty'];
    qtyrejected = json['qtyrejected'];
    transrate = json['transrate'];
    transvalue = json['transvalue'];
    ledgerkey = json['ledgerkey'];
    ledgerno = json['ledgerno'];
    ledgerfoliono = json['ledgerfoliono'];
    ledgerfolioplno = json['ledgerfolioplno'];
    itemdescription = json['itemdescription'];
    dmtrno = json['dmtrno'];
    dmtrdate = json['dmtrdate'];
    pounit = json['pounit'];
    unitdes = json['unitdes'];
    qtyreceived = json['qtyreceived'];
    qtyaccepted = json['qtyaccepted'];
    vendorname = json['vendorname'];
    pono = json['pono'];
    podate = json['podate'];
    balrejqty = json['balrejqty'];
    balrejvalue = json['balrejvalue'];
    challanno = json['challanno'];
    challandate = json['challandate'];
    rejectionrej = json['rejectionrej'];
    acceptedqty = json['acceptedqty'];
    rejtranskey = json['rejtranskey'];
    totalreinspqty = json['totalreinspqty'];
    returnedqty = json['returnedqty'];
    suppliedqty = json['suppliedqty'];
    reinspflag = json['reinspflag'];
    earlierdmtrno = json['earlierdmtrno'];
    earlierdmtrdate = json['earlierdmtrdate'];
    rejadviceno = json['rejadviceno'];
    pdf_path = json['pdf_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unifiedplno'] = this.unifiedplno;
    data['recoveredamount'] = this.recoveredamount;
    data['potype'] = this.potype;
    data['depodetail'] = this.depodetail;
    data['rlyname'] = this.rlyname;
    data['rejadviceflag'] = this.rejadviceflag;
    data['recoverystatus'] = this.recoverystatus;
    data['billpayoff'] = this.billpayoff;
    data['allocation'] = this.allocation;
    data['origrecovery'] = this.origrecovery;
    data['balrecovery'] = this.balrecovery;
    data['curstockinglocation'] = this.curstockinglocation;
    data['transkey'] = this.transkey;
    data['voucherno'] = this.voucherno;
    data['voucherdate'] = this.voucherdate;
    data['transqty'] = this.transqty;
    data['qtyrejected'] = this.qtyrejected;
    data['transrate'] = this.transrate;
    data['transvalue'] = this.transvalue;
    data['ledgerkey'] = this.ledgerkey;
    data['ledgerno'] = this.ledgerno;
    data['ledgerfoliono'] = this.ledgerfoliono;
    data['ledgerfolioplno'] = this.ledgerfolioplno;
    data['itemdescription'] = this.itemdescription;
    data['dmtrno'] = this.dmtrno;
    data['dmtrdate'] = this.dmtrdate;
    data['pounit'] = this.pounit;
    data['unitdes'] = this.unitdes;
    data['qtyreceived'] = this.qtyreceived;
    data['qtyaccepted'] = this.qtyaccepted;
    data['vendorname'] = this.vendorname;
    data['pono'] = this.pono;
    data['podate'] = this.podate;
    data['balrejqty'] = this.balrejqty;
    data['balrejvalue'] = this.balrejvalue;
    data['challanno'] = this.challanno;
    data['challandate'] = this.challandate;
    data['rejectionrej'] = this.rejectionrej;
    data['acceptedqty'] = this.acceptedqty;
    data['rejtranskey'] = this.rejtranskey;
    data['totalreinspqty'] = this.totalreinspqty;
    data['returnedqty'] = this.returnedqty;
    data['suppliedqty'] = this.suppliedqty;
    data['reinspflag'] = this.reinspflag;
    data['earlierdmtrno'] = this.earlierdmtrno;
    data['earlierdmtrdate'] = this.earlierdmtrdate;
    data['rejadviceno'] = this.rejadviceno;
    data['pdf_path'] = this.pdf_path;
    return data;
  }
}