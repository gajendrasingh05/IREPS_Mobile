class StockDetailMaterialRejected {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<MaterialRejectedData>? data;

  StockDetailMaterialRejected(
      {this.apiFor, this.count, this.status, this.message, this.data});

  StockDetailMaterialRejected.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MaterialRejectedData>[];
      json['data'].forEach((v) {
        data!.add(new MaterialRejectedData.fromJson(v));
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

class MaterialRejectedData {
  String? poNo;
  String? dp;
  String? rejNo;
  String? rejdt;
  String? qty;
  String? unit;
  String? firm;
  String? islNo;
  String? rejectionDetail;
  String? rowId;

  MaterialRejectedData(
      {this.poNo,
        this.dp,
        this.rejNo,
        this.rejdt,
        this.qty,
        this.unit,
        this.firm,
        this.islNo,
        this.rejectionDetail,
        this.rowId});

  MaterialRejectedData.fromJson(Map<String, dynamic> json) {
    poNo = json['po_no'];
    dp = json['dp'];
    rejNo = json['rej_no'];
    rejdt = json['rejdt'];
    qty = json['qty'];
    unit = json['unit'];
    firm = json['firm'];
    islNo = json['isl_no'];
    rejectionDetail = json['rejection_detail'];
    rowId = json['row_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['po_no'] = this.poNo;
    data['dp'] = this.dp;
    data['rej_no'] = this.rejNo;
    data['rejdt'] = this.rejdt;
    data['qty'] = this.qty;
    data['unit'] = this.unit;
    data['firm'] = this.firm;
    data['isl_no'] = this.islNo;
    data['rejection_detail'] = this.rejectionDetail;
    data['row_id'] = this.rowId;
    return data;
  }
}