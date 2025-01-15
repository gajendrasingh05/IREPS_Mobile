import 'dart:core';

class EndUserlistData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<EndUserlist>? data;

  EndUserlistData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  EndUserlistData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EndUserlist>[];
      json['data'].forEach((v) {
        data!.add(new EndUserlist.fromJson(v));
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

class EndUserlist {
  String? unifiedPlNo;
  String? ledgerNo;
  String? ledgerFolioNo;
  String? ledgerKey;
  String? ledgerName;
  String? ledgerFolioName;
  String? itemDesc;
  String? itemCode;
  String? rate;
  String? stkQty;
  String? stkVal;
  String? unitDes;

  EndUserlist(
      {
        this.unifiedPlNo,
        this.ledgerNo,
        this.ledgerFolioNo,
        this.ledgerKey,
        this.ledgerName,
        this.ledgerFolioName,
        this.itemDesc,
        this.itemCode,
        this.rate,
        this.stkQty,
        this.stkVal,
        this.unitDes});

  EndUserlist.fromJson(Map<String, dynamic> json) {
    unifiedPlNo = json['unifiedPlNo'];
    ledgerNo = json['ledgerNo'];
    ledgerFolioNo = json['ledgerFolioNo'];
    ledgerKey = json['ledgerKey'];
    ledgerName = json['ledgerName'];
    ledgerFolioName = json['ledgerFolioName'];
    itemDesc = json['itemDesc'];
    itemCode = json['itemCode'];
    rate = json['rate'];
    stkQty = json['stkQty'];
    stkVal = json['stkVal'];
    unitDes = json['unitDes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unifiedPlNo'] = this.unifiedPlNo;
    data['ledgerNo'] = this.ledgerNo;
    data['ledgerFolioNo'] = this.ledgerFolioNo;
    data['ledgerKey'] = this.ledgerKey;
    data['ledgerName'] = this.ledgerName;
    data['ledgerFolioName'] = this.ledgerFolioName;
    data['itemDesc'] = this.itemDesc;
    data['itemCode'] = this.itemCode;
    data['rate'] = this.rate;
    data['stkQty'] = this.stkQty;
    data['stkVal'] = this.stkVal;
    data['unitDes'] = this.unitDes;
    return data;
  }
}