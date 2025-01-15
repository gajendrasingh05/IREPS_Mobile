class PopupFunc {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<PopupFuncData>? data;

  PopupFunc(
      {this.apiFor, this.count, this.status, this.message, this.data});

  PopupFunc.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PopupFuncData>[];
      json['data'].forEach((v) {
        data!.add(new PopupFuncData.fromJson(v));
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

class PopupFuncData {
   String? compsource;
   String? comprly;
   String? conscoderejdatasendor;
   String? compconsignee;
   String? comp_address;
   String? claimrly;
   String? claimrlycode;
   String? claimconscode;
   String? claimconsignee;
   String? claimaddress;
   String? rejrefno;
   String? rejdate;
   String? plno;
   String? itemdesc;
   String? qty;
   String? vendorname;
   String? transstatus;
   String? vrno;
   String? vrdate;
   String? claimamount;
   String? transtrkey;


  PopupFuncData(
      { this.compsource,
        this.comprly,
        this.conscoderejdatasendor,
        this.compconsignee,
        this.comp_address,
        this.claimrly,
        this.claimrlycode,
        this.claimconscode,
        this.claimconsignee,
        this.claimaddress,
        this.rejrefno,
        this.rejdate,
        this.plno,
        this.itemdesc,
        this.qty,
        this.vendorname,
        this. transstatus,
        this. vrno,
        this.vrdate,
        this.claimamount,
        this.transtrkey});


  PopupFuncData.fromJson(Map<String, dynamic> json) {
    compsource = json['compsource'];
    comprly = json['comprly'];
    conscoderejdatasendor = json['conscoderejdatasendor'];
    compconsignee = json['compconsignee'];
    comp_address = json['comp_address'];
    claimrly = json['claimrly'];
    claimrlycode = json['claimrlycode'];
    claimconscode = json['claimconscode'];
    claimconsignee = json['claimconsignee'];
    claimaddress = json['claimaddress'];
    rejrefno = json['rejrefno'];
    rejdate = json['rejdate'];
    plno = json['plno'];
    itemdesc = json['itemdesc'];
    qty = json['qty'];
    vendorname = json['vendorname'];
    transstatus = json['transstatus'];
    vrno = json['vrno'];
    vrdate = json['vrdate'];
    claimamount = json['claimamount'];
    transtrkey = json['transtrkey'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['compsource'] = this.compsource;
    data['comprly'] = this.comprly;
    data['conscoderejdatasendor'] = this.conscoderejdatasendor;
    data['compconsignee'] = this.compconsignee;
    data['comp_address'] = this.comp_address;
    data['claimrly'] = this.claimrly;
    data['claimrlycode'] = this.claimrlycode;
    data['claimconscode'] = this.claimconscode;
    data['claimconsignee'] = this.claimconsignee;
    data['claimaddress'] = this.claimaddress;
    data['rejrefno'] = this.rejrefno;
    data['rejdate'] = this.rejdate;
    data['plno'] = this.plno;
    data['itemdesc'] = this.itemdesc;
    data['qty'] = this.qty;
    data['vendorname'] = this.vendorname;
    data['transstatus'] = this. transstatus;
    data['vrno'] = this. vrno;
    data['vrdate'] = this.vrdate;
    data['claimamount'] = this.claimamount;
    data['transtrkey'] = this.transtrkey;
    return data;
  }
}