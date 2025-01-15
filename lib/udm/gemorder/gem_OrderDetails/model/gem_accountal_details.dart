class GemAccountalDetails {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<GemAccountalDetailsData>? data;

  GemAccountalDetails(
      {this.apiFor, this.count, this.status, this.message, this.data});

  GemAccountalDetails.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GemAccountalDetailsData>[];
      json['data'].forEach((v) {
        data!.add(new GemAccountalDetailsData.fromJson(v));
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

class GemAccountalDetailsData {
  String? srno;
  String? userdepotname;
  String? qtydispatched;
  String? qtyreceived;
  String? qtyaccepted;
  String? qtyrejected;
  String? itemcode;
  String? itemdes;
  String? dmtrno;
  String? receiptdate;
  String? doctype;
  String? rono;
  String? rodate;
  String? storedepot;
  String? sourcetype;
  String? rcpdate;
  String? unitgem;
  String? finyear;
  String? conscode;
  String? rnoteno;
  String? rnotedate;



  GemAccountalDetailsData(
      {this.srno,
        this.userdepotname,
        this.qtydispatched,
        this.qtyreceived,
        this.qtyaccepted,
        this.qtyrejected,
        this.itemcode,
        this.itemdes,
        this.dmtrno,
        this.receiptdate,
        this.doctype,
        this.rono,
        this.rodate,
        this.storedepot,
        this.sourcetype,
        this.rcpdate,
        this.unitgem,
        this.finyear,
        this.conscode,
        this.rnoteno,
        this.rnotedate});


  GemAccountalDetailsData.fromJson(Map<String, dynamic> json) {
    srno = json['srno'];
    userdepotname = json['userdepotname'];
    qtydispatched = json['qtydispatched'];
    qtyreceived = json['qtyreceived'];
    qtyaccepted = json['qtyaccepted'];
    qtyrejected = json['qtyrejected'];
    itemcode = json['itemcode'];
    itemdes = json['itemdes'];
    dmtrno = json['dmtrno'];
    receiptdate = json['receiptdate'];
    doctype = json['doctype'];
    rono = json['rono'];
    rodate = json['rodate'];
    storedepot = json['storedepot'];
    sourcetype = json['sourcetype'];
    rcpdate = json['rcpdate'];
    unitgem = json['unitgem'];
    finyear = json['finyear'];
    conscode = json['conscode'];
    rnoteno = json['rnoteno'];
    rnotedate = json['rnotedate'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['srno'] = this.srno;
    data['userdepotname'] = this.userdepotname;
    data['qtydispatched'] = this.qtydispatched;
    data['qtyreceived'] = this.qtyreceived;
    data['qtyaccepted'] = this.qtyaccepted;
    data['qtyrejected'] = this.qtyrejected;
    data['itemcode'] = this.itemcode;
    data['itemdes'] = this.itemdes;
    data['dmtrno'] = this.dmtrno;
    data['receiptdate'] = this.receiptdate;
    data['doctype'] = this.doctype;
    data['rono'] = this.rono;
    data['rodate'] = this.rodate;
    data['storedepot'] = this.storedepot;
    data['sourcetype'] = this.sourcetype;
    data['rcpdate'] = this.rcpdate;
    data['unitgem'] = this.unitgem;
    data['finyear'] = this.finyear;
    data['conscode'] = this.conscode;
    data['rnoteno'] = this.rnoteno;
    data['rnotedate'] = this.rnotedate;
    return data;
  }
}