class CrcMyforwardedData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<MyforwardedCrcData>? data;

  CrcMyforwardedData({this.apiFor, this.count, this.status, this.message, this.data});

  CrcMyforwardedData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if(json['data'] != null) {
      data = <MyforwardedCrcData>[];
      json['data'].forEach((v) {
        data!.add(MyforwardedCrcData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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

class MyforwardedCrcData {
  String? crnversion;
  Null? warrepflag;
  String? qtyrecvdval;
  String? qtyreceived;
  String? trvalue;
  String? podate;
  String? pounitname;
  String? postname;
  String? filepath;
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
  String? doccnt;

  MyforwardedCrcData({
        this.crnversion,
        this.warrepflag,
        this.qtyrecvdval,
        this.qtyreceived,
        this.trvalue,
        this.podate,
        this.pounitname,
        this.postname,
        this.filepath,
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
        this.doccnt});

  MyforwardedCrcData.fromJson(Map<String, dynamic> json) {
    crnversion = json['crnversion'];
    warrepflag = json['warrepflag'];
    qtyrecvdval = json['qtyrecvdval'];
    qtyreceived = json['qtyreceived'];
    trvalue = json['trvalue'];
    podate = json['podate'];
    pounitname = json['pounitname'];
    postname = json['postname'];
    filepath = json['filepath'];
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
    doccnt = json['doccnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['crnversion'] = this.crnversion;
    data['warrepflag'] = this.warrepflag;
    data['qtyrecvdval'] = this.qtyrecvdval;
    data['qtyreceived'] = this.qtyreceived;
    data['trvalue'] = this.trvalue;
    data['podate'] = this.podate;
    data['pounitname'] = this.pounitname;
    data['postname'] = this.postname;
    data['filepath'] = this.filepath;
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
    data['doccnt'] = this.doccnt;
    return data;
  }
}