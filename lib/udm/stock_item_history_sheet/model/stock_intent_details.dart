class StockIntentDetails {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<IntentData>? data;

  StockIntentDetails(
      {this.apiFor, this.count, this.status, this.message, this.data});

  StockIntentDetails.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <IntentData>[];
      json['data'].forEach((v) {
        data!.add(new IntentData.fromJson(v));
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

class IntentData {
  String? dp;
  String? poNo;
  String? podt;
  String? poqty;
  String? cvdqty;
  String? dueqty;
  String? dd;
  String? firm;
  String? unit;
  String? poSr;
  String? dmdNo;
  String? rate;
  String? poCat;
  String? cpstart;
  String? rowId;

  IntentData(
      {this.dp,
        this.poNo,
        this.podt,
        this.poqty,
        this.cvdqty,
        this.dueqty,
        this.dd,
        this.firm,
        this.unit,
        this.poSr,
        this.dmdNo,
        this.rate,
        this.poCat,
        this.cpstart,
        this.rowId});

  IntentData.fromJson(Map<String, dynamic> json) {
    dp = json['dp'];
    poNo = json['po_no'];
    podt = json['podt'];
    poqty = json['poqty'];
    cvdqty = json['cvdqty'];
    dueqty = json['dueqty'];
    dd = json['dd'];
    firm = json['firm'];
    unit = json['unit'];
    poSr = json['po_sr'];
    dmdNo = json['dmd_no'];
    rate = json['rate'];
    poCat = json['po_cat'];
    cpstart = json['cpstart'];
    rowId = json['row_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dp'] = this.dp;
    data['po_no'] = this.poNo;
    data['podt'] = this.podt;
    data['poqty'] = this.poqty;
    data['cvdqty'] = this.cvdqty;
    data['dueqty'] = this.dueqty;
    data['dd'] = this.dd;
    data['firm'] = this.firm;
    data['unit'] = this.unit;
    data['po_sr'] = this.poSr;
    data['dmd_no'] = this.dmdNo;
    data['rate'] = this.rate;
    data['po_cat'] = this.poCat;
    data['cpstart'] = this.cpstart;
    data['row_id'] = this.rowId;
    return data;
  }
}