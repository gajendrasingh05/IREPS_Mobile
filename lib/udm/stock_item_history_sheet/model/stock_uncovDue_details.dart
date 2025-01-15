class StockUncovDuesDetails {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<UncoverDueData>? data;

  StockUncovDuesDetails(
      {this.apiFor, this.count, this.status, this.message, this.data});

  StockUncovDuesDetails.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UncoverDueData>[];
      json['data'].forEach((v) {
        data!.add(new UncoverDueData.fromJson(v));
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

class UncoverDueData {
  String? dp;
  String? forSort;
  String? dpnm;
  String? dmdNo;
  String? demdt;
  String? qty;
  String? unit;
  String? tenno;
  String? duedate;
  String? rem;
  String? dmdtype;
  String? sec;
  String? estno;
  String? dqty;
  String? rowId;

  UncoverDueData(
      {this.dp,
        this.forSort,
        this.dpnm,
        this.dmdNo,
        this.demdt,
        this.qty,
        this.unit,
        this.tenno,
        this.duedate,
        this.rem,
        this.dmdtype,
        this.sec,
        this.estno,
        this.dqty,
        this.rowId});

  UncoverDueData.fromJson(Map<String, dynamic> json) {
    dp = json['dp'];
    forSort = json['for_sort'];
    dpnm = json['dpnm'];
    dmdNo = json['dmd_no'];
    demdt = json['demdt'];
    qty = json['qty'];
    unit = json['unit'];
    tenno = json['tenno'];
    duedate = json['duedate'];
    rem = json['rem'];
    dmdtype = json['dmdtype'];
    sec = json['sec'];
    estno = json['estno'];
    dqty = json['dqty'];
    rowId = json['row_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dp'] = this.dp;
    data['for_sort'] = this.forSort;
    data['dpnm'] = this.dpnm;
    data['dmd_no'] = this.dmdNo;
    data['demdt'] = this.demdt;
    data['qty'] = this.qty;
    data['unit'] = this.unit;
    data['tenno'] = this.tenno;
    data['duedate'] = this.duedate;
    data['rem'] = this.rem;
    data['dmdtype'] = this.dmdtype;
    data['sec'] = this.sec;
    data['estno'] = this.estno;
    data['dqty'] = this.dqty;
    data['row_id'] = this.rowId;
    return data;
  }
}