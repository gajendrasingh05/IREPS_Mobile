class WithdrawnData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<WithdrawData>? data;

  WithdrawnData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  WithdrawnData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WithdrawData>[];
      json['data'].forEach((v) {
        data!.add(new WithdrawData.fromJson(v));
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

class WithdrawData {
  String? userDepotName;
  String? rejAdvNo;
  String? partyDetail;
  String? poNo;
  String? poDate;
  String? qtyAccepted;
  String? unit;
  String? voucherNo;

  WithdrawData(
      {this.userDepotName,
        this.rejAdvNo,
        this.partyDetail,
        this.poNo,
        this.poDate,
        this.qtyAccepted,
        this.unit,
        this.voucherNo});

  WithdrawData.fromJson(Map<String, dynamic> json) {
    userDepotName = json['userDepotName'];
    rejAdvNo = json['rejAdvNo'];
    partyDetail = json['partyDetail'];
    poNo = json['poNo'];
    poDate = json['poDate'];
    qtyAccepted = json['qtyAccepted'];
    unit = json['unit'];
    voucherNo = json['voucherNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userDepotName'] = this.userDepotName;
    data['rejAdvNo'] = this.rejAdvNo;
    data['partyDetail'] = this.partyDetail;
    data['poNo'] = this.poNo;
    data['poDate'] = this.poDate;
    data['qtyAccepted'] = this.qtyAccepted;
    data['unit'] = this.unit;
    data['voucherNo'] = this.voucherNo;
    return data;
  }
}