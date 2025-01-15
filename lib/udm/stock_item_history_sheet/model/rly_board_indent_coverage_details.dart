class RlyBoardIndentCoverageDetails {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<RlyIntentCoverageData>? data;

  RlyBoardIndentCoverageDetails(
      {this.apiFor, this.count, this.status, this.message, this.data});

  RlyBoardIndentCoverageDetails.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RlyIntentCoverageData>[];
      json['data'].forEach((v) {
        data!.add(new RlyIntentCoverageData.fromJson(v));
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

class RlyIntentCoverageData {
  String? dp;
  String? poNo;
  String? podt;
  String? pocat;
  String? poqty;
  String? dueqty;
  String? dd;
  String? ods;
  String? firm;
  String? unit;
  String? poSr;
  String? dmdNo;
  String? rate;
  String? insp;
  String? shortname;
  String? pokey;
  String? aiRate;
  String? podt1;
  String? whost;
  String? pdf_link;
  String? rowId;

  RlyIntentCoverageData(
      {this.dp,
        this.poNo,
        this.podt,
        this.pocat,
        this.poqty,
        this.dueqty,
        this.dd,
        this.ods,
        this.firm,
        this.unit,
        this.poSr,
        this.dmdNo,
        this.rate,
        this.insp,
        this.shortname,
        this.pokey,
        this.aiRate,
        this.podt1,
        this.whost,
        this.pdf_link,
        this.rowId});

  RlyIntentCoverageData.fromJson(Map<String, dynamic> json) {
    dp = json['dp'];
    poNo = json['po_no'];
    podt = json['podt'];
    pocat = json['pocat'];
    poqty = json['poqty'];
    dueqty = json['dueqty'];
    dd = json['dd'];
    ods = json['ods'];
    firm = json['firm'];
    unit = json['unit'];
    poSr = json['po_sr'];
    dmdNo = json['dmd_no'];
    rate = json['rate'];
    insp = json['insp'];
    shortname = json['shortname'];
    pokey = json['pokey'];
    aiRate = json['ai_rate'];
    podt1 = json['podt1'];
    whost = json['whost'];
    pdf_link = json['pdf_link'];
    rowId = json['row_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dp'] = this.dp;
    data['po_no'] = this.poNo;
    data['podt'] = this.podt;
    data['pocat'] = this.pocat;
    data['poqty'] = this.poqty;
    data['dueqty'] = this.dueqty;
    data['dd'] = this.dd;
    data['ods'] = this.ods;
    data['firm'] = this.firm;
    data['unit'] = this.unit;
    data['po_sr'] = this.poSr;
    data['dmd_no'] = this.dmdNo;
    data['rate'] = this.rate;
    data['insp'] = this.insp;
    data['shortname'] = this.shortname;
    data['pokey'] = this.pokey;
    data['ai_rate'] = this.aiRate;
    data['podt1'] = this.podt1;
    data['whost'] = this.whost;
    data['pdf_link'] = this.pdf_link;
    data['row_id'] = this.rowId;
    return data;
  }
}