class GemBillDetails {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<GemBillDetailsData>? data;

  GemBillDetails(
      {this.apiFor, this.count, this.status, this.message, this.data});

  GemBillDetails.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GemBillDetailsData>[];
      json['data'].forEach((v) {
        data!.add(new GemBillDetailsData.fromJson(v));
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

class GemBillDetailsData {
  String? consigneename;
  String? invoiceno;
  String? invoicedate;
  String? billno;
  String? billdate;
  String? billamount;
  String? au_code;
  String? au_desc;
  String? co6number;
  String? co6date;
  String? co7number;
  String? co7date;
  String? passedamount;
  String? bookdate;
  String? returndate;
  String? returnreason;
  String? invoicefile;
  String? crcdate;
  String? deductedamount;
  String? receiptno;


  GemBillDetailsData(
      {this.consigneename,
        this.invoiceno,
        this.invoicedate,
        this.billno,
        this.billdate,
        this.billamount,
        this.au_code,
        this.au_desc,
        this.co6number,
        this.co6date,
        this.co7number,
        this.co7date,
        this.passedamount,
        this.bookdate,
        this.returndate,
        this.returnreason,
        this.invoicefile,
        this.crcdate,
        this.deductedamount,
        this.receiptno,
      });


  GemBillDetailsData.fromJson(Map<String, dynamic> json) {
    consigneename = json['consigneename'];
    invoiceno = json['invoiceno'];
    invoicedate = json['invoicedate'];
    billno = json['billno'];
    billdate = json['billdate'];
    billamount = json['billamount'];
    au_code = json['au_code'];
    au_desc = json['au_desc'];
    co6number = json['co6number'];
    co6date = json['co6date'];
    co7number = json['co7number'];
    co7date = json['co7date'];
    passedamount = json['passedamount'];
    bookdate = json['bookdate'];
    returndate = json['returndate'];
    returnreason = json['returnreason'];
    invoicefile = json['invoicefile'];
    crcdate = json['crcdate'];
    deductedamount = json['deductedamount'];
    receiptno = json['receiptno'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consigneename'] = this.consigneename;
    data['invoiceno'] = this.invoiceno;
    data['invoicedate'] = this.invoicedate;
    data['billno'] = this.billno;
    data['billdate'] = this.billdate;
    data['billamount'] = this.billamount;
    data['au_code'] = this.au_code;
    data['au_desc'] = this.au_desc;
    data['co6number'] = this.co6number;
    data['co6date'] = this.co6date;
    data['co7number'] = this.co7number;
    data['co7date'] = this.co7date;
    data['passedamount'] = this.passedamount;
    data['bookdate'] = this.bookdate;
    data['returndate'] = this.returndate;
    data['returnreason'] = this.returnreason;
    data['invoicefile'] = this.invoicefile;
    data['crcdate'] = this.crcdate;
    data['deductedamount'] = this.deductedamount;
    data['receiptno'] = this.receiptno;
    return data;
  }
}