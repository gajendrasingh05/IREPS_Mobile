class StockLast_Five_Years_Orders {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<OrderPlacedData>? data;

  StockLast_Five_Years_Orders(
      {this.apiFor, this.count, this.status, this.message, this.data});

  StockLast_Five_Years_Orders.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OrderPlacedData>[];
      json['data'].forEach((v) {
        data!.add(new OrderPlacedData.fromJson(v));
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

class OrderPlacedData {
  String? poSr;
  String? dp;
  String? poNo;
  String? podt;
  String? pocat;
  String? poqty;
  String? supqty;
  String? rejqty;
  String? odd;
  String? edd;
  String? ods;
  String? firm;
  String? unit;
  String? dmdNo;
  String? rate;
  String? pokey;
  String? aiRate;
  String? podt1;
  String? cancqty;
  String? status;
  String? purType;
  String? poSlot;
  String? pdfLink;
  String? rowId;

  OrderPlacedData(
      {this.poSr,
        this.dp,
        this.poNo,
        this.podt,
        this.pocat,
        this.poqty,
        this.supqty,
        this.rejqty,
        this.odd,
        this.edd,
        this.ods,
        this.firm,
        this.unit,
        this.dmdNo,
        this.rate,
        this.pokey,
        this.aiRate,
        this.podt1,
        this.cancqty,
        this.status,
        this.purType,
        this.poSlot,
        this.pdfLink,
        this.rowId});

  OrderPlacedData.fromJson(Map<String, dynamic> json) {
    poSr = json['po_sr'];
    dp = json['dp'];
    poNo = json['po_no'];
    podt = json['podt'];
    pocat = json['pocat'];
    poqty = json['poqty'];
    supqty = json['supqty'];
    rejqty = json['rejqty'];
    odd = json['odd'];
    edd = json['edd'];
    ods = json['ods'];
    firm = json['firm'];
    unit = json['unit'];
    dmdNo = json['dmd_no'];
    rate = json['rate'];
    pokey = json['pokey'];
    aiRate = json['ai_rate'];
    podt1 = json['podt1'];
    cancqty = json['cancqty'];
    status = json['status'];
    purType = json['pur_type'];
    poSlot = json['po_slot'];
    pdfLink = json['pdf_link'];
    rowId = json['row_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['po_sr'] = this.poSr;
    data['dp'] = this.dp;
    data['po_no'] = this.poNo;
    data['podt'] = this.podt;
    data['pocat'] = this.pocat;
    data['poqty'] = this.poqty;
    data['supqty'] = this.supqty;
    data['rejqty'] = this.rejqty;
    data['odd'] = this.odd;
    data['edd'] = this.edd;
    data['ods'] = this.ods;
    data['firm'] = this.firm;
    data['unit'] = this.unit;
    data['dmd_no'] = this.dmdNo;
    data['rate'] = this.rate;
    data['pokey'] = this.pokey;
    data['ai_rate'] = this.aiRate;
    data['podt1'] = this.podt1;
    data['cancqty'] = this.cancqty;
    data['status'] = this.status;
    data['pur_type'] = this.purType;
    data['po_slot'] = this.poSlot;
    data['pdf_link'] = this.pdfLink;
    data['row_id'] = this.rowId;
    return data;
  }
}