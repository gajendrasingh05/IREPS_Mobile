class CrnSummarylinkData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<CrnsumrylinkData>? data;

  CrnSummarylinkData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  CrnSummarylinkData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CrnsumrylinkData>[];
      json['data'].forEach((v) {
        data!.add(new CrnsumrylinkData.fromJson(v));
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

class CrnsumrylinkData {
  String? reinspflag;
  String? rejind;
  String? warrepflag;
  String? railname;
  String? unittype;
  String? unitname;
  String? department;
  String? consdtls;
  String? pono;
  String? podate;
  String? posr;
  String? vrno;
  String? vrdate;
  String? itemdesc;
  String? receiptdate;
  String? challanno;
  String? challandate;
  String? qtyreceived;
  String? qtyaccepted;
  String? pounit;
  String? povalue;
  String? crnflag;
  String? trkey;
  String? vendorname;

  CrnsumrylinkData(
      {
        this.reinspflag,
        this.rejind,
        this.warrepflag,
        this.railname,
        this.unittype,
        this.unitname,
        this.department,
        this.consdtls,
        this.pono,
        this.podate,
        this.posr,
        this.vrno,
        this.vrdate,
        this.itemdesc,
        this.receiptdate,
        this.challanno,
        this.challandate,
        this.qtyreceived,
        this.qtyaccepted,
        this.pounit,
        this.povalue,
        this.crnflag,
        this.trkey,
        this.vendorname});

  CrnsumrylinkData.fromJson(Map<String, dynamic> json) {
    reinspflag = json['reinspflag'];
    rejind = json['rejind'];
    warrepflag = json['warrepflag'];
    railname = json['railname'];
    unittype = json['unittype'];
    unitname = json['unitname'];
    department = json['department'];
    consdtls = json['consdtls'];
    pono = json['pono'];
    podate = json['podate'];
    posr = json['posr'];
    vrno = json['vrno'];
    vrdate = json['vrdate'];
    itemdesc = json['itemdesc'];
    receiptdate = json['receiptdate'];
    challanno = json['challanno'];
    challandate = json['challandate'];
    qtyreceived = json['qtyreceived'];
    qtyaccepted = json['qtyaccepted'];
    pounit = json['pounit'];
    povalue = json['povalue'];
    crnflag = json['crnflag'];
    trkey = json['trkey'];
    vendorname = json['vendorname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reinspflag'] = this.reinspflag;
    data['rejind'] = this.rejind;
    data['warrepflag'] = this.warrepflag;
    data['railname'] = this.railname;
    data['unittype'] = this.unittype;
    data['unitname'] = this.unitname;
    data['department'] = this.department;
    data['consdtls'] = this.consdtls;
    data['pono'] = this.pono;
    data['podate'] = this.podate;
    data['posr'] = this.posr;
    data['vrno'] = this.vrno;
    data['vrdate'] = this.vrdate;
    data['itemdesc'] = this.itemdesc;
    data['receiptdate'] = this.receiptdate;
    data['challanno'] = this.challanno;
    data['challandate'] = this.challandate;
    data['qtyreceived'] = this.qtyreceived;
    data['qtyaccepted'] = this.qtyaccepted;
    data['pounit'] = this.pounit;
    data['povalue'] = this.povalue;
    data['crnflag'] = this.crnflag;
    data['trkey'] = this.trkey;
    data['vendorname'] = this.vendorname;
    return data;
  }
}