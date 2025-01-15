class CrnAwaitingData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<CrnawaitData>? data;

  CrnAwaitingData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  CrnAwaitingData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CrnawaitData>[];
      json['data'].forEach((v) {
        data!.add(CrnawaitData.fromJson(v));
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

class CrnawaitData {
  String? warrepflag;
  String? qtyrecvdval;
  String? qtyreceived;
  String? trvalue;
  String? podate;
  String? pounitname;
  String? consname;
  String? subconscode;
  String? pounit;
  String? qtyaccepted;
  String? vrnumber;
  String? vrdate;
  String? ponumber;
  String? plno;
  String? itemdesc;
  String? firmaccountname;
  String? posr;
  String? trkey;
  String? crnkey;
  String? authdate;
  String? filepath;
  String? sendername;
  String? doccnt;
  String? co6no;
  String? co6date;
  String? co7no;
  String? co7date;
  String? passedamount;
  String? returnreason;
  String? billcnt;

  CrnawaitData(
      {this.warrepflag,
        this.qtyrecvdval,
        this.qtyreceived,
        this.trvalue,
        this.podate,
        this.pounitname,
        this.consname,
        this.subconscode,
        this.pounit,
        this.qtyaccepted,
        this.vrnumber,
        this.vrdate,
        this.ponumber,
        this.plno,
        this.itemdesc,
        this.firmaccountname,
        this.posr,
        this.trkey,
        this.crnkey,
        this.authdate,
        this.filepath,
        this.sendername,
        this.doccnt,
        this.co6no,
        this.co6date,
        this.co7no,
        this.co7date,
        this.passedamount,
        this.returnreason,
        this.billcnt});

  CrnawaitData.fromJson(Map<String, dynamic> json) {
    warrepflag = json['warrepflag'];
    qtyrecvdval = json['qtyrecvdval'];
    qtyreceived = json['qtyreceived'];
    trvalue = json['trvalue'];
    podate = json['podate'];
    pounitname = json['pounitname'];
    consname = json['consname'];
    subconscode = json['subconscode'];
    pounit = json['pounit'];
    qtyaccepted = json['qtyaccepted'];
    vrnumber = json['vrnumber'];
    vrdate = json['vrdate'];
    ponumber = json['ponumber'];
    plno = json['plno'];
    itemdesc = json['itemdesc'];
    firmaccountname = json['firmaccountname'];
    posr = json['posr'];
    trkey = json['trkey'];
    crnkey = json['crnkey'];
    authdate = json['authdate'];
    filepath = json['filepath'];
    sendername = json['sendername'];
    doccnt = json['doccnt'];
    co6no = json['co6no'];
    co6date = json['co6date'];
    co7no = json['co7no'];
    co7date = json['co7date'];
    passedamount = json['passedamount'];
    returnreason = json['returnreason'];
    billcnt = json['billcnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['warrepflag'] = this.warrepflag;
    data['qtyrecvdval'] = this.qtyrecvdval;
    data['qtyreceived'] = this.qtyreceived;
    data['trvalue'] = this.trvalue;
    data['podate'] = this.podate;
    data['pounitname'] = this.pounitname;
    data['consname'] = this.consname;
    data['subconscode'] = this.subconscode;
    data['pounit'] = this.pounit;
    data['qtyaccepted'] = this.qtyaccepted;
    data['vrnumber'] = this.vrnumber;
    data['vrdate'] = this.vrdate;
    data['ponumber'] = this.ponumber;
    data['plno'] = this.plno;
    data['itemdesc'] = this.itemdesc;
    data['firmaccountname'] = this.firmaccountname;
    data['posr'] = this.posr;
    data['trkey'] = this.trkey;
    data['crnkey'] = this.crnkey;
    data['authdate'] = this.authdate;
    data['filepath'] = this.filepath;
    data['sendername'] = this.sendername;
    data['doccnt'] = this.doccnt;
    data['co6no'] = this.co6no;
    data['co6date'] = this.co6date;
    data['co7no'] = this.co7no;
    data['co7date'] = this.co7date;
    data['passedamount'] = this.passedamount;
    data['returnreason'] = this.returnreason;
    data['billcnt'] = this.billcnt;
    return data;
  }
}