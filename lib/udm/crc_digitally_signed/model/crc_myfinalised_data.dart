class CrcMyfinalisedData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<MyfinalisedCrcData>? data;

  CrcMyfinalisedData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  CrcMyfinalisedData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MyfinalisedCrcData>[];
      json['data'].forEach((v) {
        data!.add(new MyfinalisedCrcData.fromJson(v));
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

class MyfinalisedCrcData {
  String? crnversion;
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
  String? authdate;
  String? postname;
  String? filepath;
  String? crnstatus;
  String? dropcomment;
  String? approvername;
  String? approvaldate;
  String? doccnt;

  MyfinalisedCrcData(
      {this.crnversion,
        this.delofficername,
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
        this.authdate,
        this.postname,
        this.filepath,
        this.crnstatus,
        this.dropcomment,
        this.approvername,
        this.approvaldate,
        this.doccnt});

  MyfinalisedCrcData.fromJson(Map<String, dynamic> json) {
    crnversion = json['crnversion'];
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
    authdate = json['authdate'];
    postname = json['postname'];
    filepath = json['filepath'];
    crnstatus = json['crnstatus'];
    dropcomment = json['dropcomment'];
    approvername = json['approvername'];
    approvaldate = json['approvaldate'];
    doccnt = json['doccnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['crnversion'] = this.crnversion;
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
    data['authdate'] = this.authdate;
    data['postname'] = this.postname;
    data['filepath'] = this.filepath;
    data['crnstatus'] = this.crnstatus;
    data['dropcomment'] = this.dropcomment;
    data['approvername'] = this.approvername;
    data['approvaldate'] = this.approvaldate;
    data['doccnt'] = this.doccnt;
    return data;
  }
}