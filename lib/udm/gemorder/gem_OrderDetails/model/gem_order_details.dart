class GemOrderDetails {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<GemOrderDetailsData>? data;

  GemOrderDetails(
      {this.apiFor, this.count, this.status, this.message, this.data});

  GemOrderDetails.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GemOrderDetailsData>[];
      json['data'].forEach((v) {
        data!.add(new GemOrderDetailsData.fromJson(v));
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

class GemOrderDetailsData {
  String? gemorderid;
  String? contracturl;
  String? vendordetails;
  String? orderamount;
  String? aucode;
  String? accountingunit;
  String? pokey;
  String? paymentmode;
  String? prop_key;
  String? vendorcode;
  String? orderdate;
  String? vendorpan;
  String? vendorgstn;
  String? numberofitem;


  GemOrderDetailsData(
      {this.gemorderid,
        this.contracturl,
        this.vendordetails,
        this.orderamount,
        this.aucode,
        this.accountingunit,
        this.pokey,
        this.paymentmode,
        this.prop_key,
        this.vendorcode,
        this.orderdate,
        this.vendorpan,
        this.vendorgstn,
        this.numberofitem});


  GemOrderDetailsData.fromJson(Map<String, dynamic> json) {
    gemorderid = json['gemorderid'];
    contracturl = json['contracturl'];
    vendordetails = json['vendordetails'];
    orderamount = json['orderamount'];
    aucode = json['aucode'];
    accountingunit = json['accountingunit'];
    pokey = json['pokey'];
    paymentmode = json['paymentmode'];
    prop_key = json['prop_key'];
    vendorcode = json['vendorcode'];
    orderdate = json['orderdate'];
    vendorpan = json['vendorpan'];
    vendorgstn = json['vendorgstn'];
    numberofitem = json['numberofitem'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gemorderid'] = this.gemorderid;
    data['contracturl'] = this.contracturl;
    data['vendordetails'] = this.vendordetails;
    data['orderamount'] = this.orderamount;
    data['aucode'] = this.aucode;
    data['accountingunit'] = this.accountingunit;
    data['pokey'] = this.pokey;
    data['paymentmode'] = this.paymentmode;
    data['prop_key'] = this.prop_key;
    data['vendorcode'] = this.vendorcode;
    data['orderdate'] = this.orderdate;
    data['vendorpan'] = this.vendorpan;
    data['vendorgstn'] = this.vendorgstn;
    data['numberofitem'] = this.numberofitem;
    return data;
  }
}