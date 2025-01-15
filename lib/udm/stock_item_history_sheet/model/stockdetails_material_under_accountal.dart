class StockDetailsMaterialUnderAccountal {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<UnderAccountalData>? data;

  StockDetailsMaterialUnderAccountal(
      {this.apiFor, this.count, this.status, this.message, this.data});

  StockDetailsMaterialUnderAccountal.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UnderAccountalData>[];
      json['data'].forEach((v) {
        data!.add(new UnderAccountalData.fromJson(v));
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

class UnderAccountalData {
  String? poNo;
  String? dp;
  String? drrNo;
  String? drrdt;
  String? qty;
  String? unit;
  String? rnStatus;
  String? pkgrecd;
  String? firm;
  String? recpt;
  String? rowId;

  UnderAccountalData(
      {this.poNo,
        this.dp,
        this.drrNo,
        this.drrdt,
        this.qty,
        this.unit,
        this.rnStatus,
        this.pkgrecd,
        this.firm,
        this.recpt,
        this.rowId});

  UnderAccountalData.fromJson(Map<String, dynamic> json) {
    poNo = json['po_no'];
    dp = json['dp'];
    drrNo = json['drr_no'];
    drrdt = json['drrdt'];
    qty = json['qty'];
    unit = json['unit'];
    rnStatus = json['rn_status'];
    pkgrecd = json['pkgrecd'];
    firm = json['firm'];
    recpt = json['recpt'];
    rowId = json['row_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['po_no'] = this.poNo;
    data['dp'] = this.dp;
    data['drr_no'] = this.drrNo;
    data['drrdt'] = this.drrdt;
    data['qty'] = this.qty;
    data['unit'] = this.unit;
    data['rn_status'] = this.rnStatus;
    data['pkgrecd'] = this.pkgrecd;
    data['firm'] = this.firm;
    data['recpt'] = this.recpt;
    data['row_id'] = this.rowId;
    return data;
  }
}