import 'dart:core';

class VoucherlistData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<Voucherlist>? data;

  VoucherlistData({this.apiFor, this.count, this.status, this.message, this.data});

  VoucherlistData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Voucherlist>[];
      json['data'].forEach((v) {
        data!.add(new Voucherlist.fromJson(v));
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

class Voucherlist {
  String? locTransKey;
  String? cardCode;
  String? workOrderdetails;
  String? transUnitRate;
  String? curExpiryDate;
  String? trKey;
  String? vendName;
  String? orgZone;
  String? orgUnitType;
  String? consCode;
  String? subConsCode;
  String? voucherNo;
  String? voucherDate;
  String? transQty;
  String? transUnit;
  String? issQty;
  String? balQty;
  String? loc;
  String? makeBrand;
  String? prodSrNo;
  String? stockQty;
  String? rate;
  String? obStkMaster;
  String? obValStkMaster;
  String? ledgerKey;
  String? stkNs;
  String? trQtyIss;
  String? manuFacturingDate;

  Voucherlist({
    this.locTransKey,
    this.cardCode,
    this.workOrderdetails,
    this.transUnitRate,
    this.curExpiryDate,
    this.trKey,
    this.vendName,
    this.orgZone,
    this.orgUnitType,
    this.consCode,
    this.subConsCode,
    this.voucherNo,
    this.voucherDate,
    this.transQty,
    this.transUnit,
    this.issQty,
    this.balQty,
    this.loc,
    this.makeBrand,
    this.prodSrNo,
    this.stockQty,
    this.rate,
    this.obStkMaster,
    this.obValStkMaster,
    this.ledgerKey,
    this.stkNs,
    this.trQtyIss,
    this.manuFacturingDate

  });

  Voucherlist.fromJson(Map<String, dynamic> json) {
    locTransKey = json['locTransKey'];
    cardCode = json['cardCode'];
    workOrderdetails = json['workOrderdetails'];
    transUnitRate = json['transUnitRate'];
    curExpiryDate = json['curExpiryDate'];
    trKey = json['trKey'];
    vendName = json['vendName'];
    orgZone = json['orgZone'];
    orgUnitType = json['orgUnitType'];
    consCode = json['consCode'];
    subConsCode = json['subConsCode'];
    voucherNo = json['voucherNo'];
    voucherDate = json['voucherDate'];
    transQty = json['transQty'];
    transUnit = json['transUnit'];
    issQty = json['issQty'];
    balQty = json['balQty'];
    loc = json['loc'];
    makeBrand = json['makeBrand'];
    prodSrNo = json['prodSrNo'];
    stockQty = json['stockQty'];
    rate = json['rate'];
    obStkMaster = json['obStkMaster'];
    obValStkMaster = json['obValStkMaster'];
    ledgerKey = json['ledgerKey'];
    stkNs = json['stkNs'];
    trQtyIss = json['trQtyIss'];
    manuFacturingDate = json['manuFacturingDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locTransKey'] = this.locTransKey;
    data['cardCode'] = this.cardCode;
    data['workOrderdetails'] = this.workOrderdetails;
    data['transUnitRate'] = this.transUnitRate;
    data['curExpiryDate'] = this.curExpiryDate;
    data['trKey'] = this.trKey;
    data['vendName'] = this.vendName;
    data['orgZone'] = this.orgZone;
    data['orgUnitType'] = this.orgUnitType;
    data['consCode'] = this.consCode;
    data['subConsCode'] = this.subConsCode;
    data['voucherNo'] = this.voucherNo;
    data['voucherDate'] = this.voucherDate;
    data['transQty'] = this.transQty;
    data['transUnit'] = this.transUnit;
    data['issQty'] = this.issQty;
    data['balQty'] = this.balQty;
    data['loc'] = this.loc;
    data['makeBrand'] = this.makeBrand;
    data['prodSrNo'] = this.prodSrNo;
    data['stockQty'] = this.stockQty;
    data['rate'] = this.rate;
    data['obStkMaster'] = this.obStkMaster;
    data['obValStkMaster'] = this.obValStkMaster;
    data['ledgerKey'] = this.ledgerKey;
    data['stkNs'] = this.stkNs;
    data['trQtyIss'] = this.trQtyIss;
    data['manuFacturingDate'] = this.manuFacturingDate;

    return data;
  }
}