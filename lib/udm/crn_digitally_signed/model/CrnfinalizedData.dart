class CrnfinalizedData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<CrnfinalzData>? data;

  CrnfinalizedData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  CrnfinalizedData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CrnfinalzData>[];
      json['data'].forEach((v) {
        data!.add(CrnfinalzData.fromJson(v));
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

class CrnfinalzData {
  String? delofficername;
  String? deldtls;
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
  String? crnstatus;
  String? dropcomment;
  String? sentdate;
  String? approvaldate;
  String? sendername;
  String? doccnt;

  CrnfinalzData(
      {this.delofficername,
        this.deldtls,
        this.warrepflag,
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
        this.crnstatus,
        this.dropcomment,
        this.sentdate,
        this.approvaldate,
        this.sendername,
        this.doccnt});

  CrnfinalzData.fromJson(Map<String, dynamic> json) {
    delofficername = json['delofficername'];
    deldtls = json['deldtls'];
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
    crnstatus = json['crnstatus'];
    dropcomment = json['dropcomment'];
    sentdate = json['sentdate'];
    approvaldate = json['approvaldate'];
    sendername = json['sendername'];
    doccnt = json['doccnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delofficername'] = this.delofficername;
    data['deldtls'] = this.deldtls;
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
    data['crnstatus'] = this.crnstatus;
    data['dropcomment'] = this.dropcomment;
    data['sentdate'] = this.sentdate;
    data['approvaldate'] = this.approvaldate;
    data['sendername'] = this.sendername;
    data['doccnt'] = this.doccnt;
    return data;
  }
}