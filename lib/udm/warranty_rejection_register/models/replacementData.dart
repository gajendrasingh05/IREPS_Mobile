class ReplacementData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<RepData>? data;

  ReplacementData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  ReplacementData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RepData>[];
      json['data'].forEach((v) {
        data!.add(new RepData.fromJson(v));
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

class RepData {
  String? crnflag;
  String? rlyname;
  String? dmtrno;
  String? dateofaccountal;
  String? qtyreplaced;
  String? unit;
  String? challanno;
  String? challandate;
  String? receiptdate;
  String? conscodename;
  String? userdepotname;
  String? postdesig;
  String? crnremark;
  String? pdfpath;
  String? crnapprovaldate;
  String? sentforappdt;

  RepData(
      {this.crnflag,
        this.rlyname,
        this.dmtrno,
        this.dateofaccountal,
        this.qtyreplaced,
        this.unit,
        this.challanno,
        this.challandate,
        this.receiptdate,
        this.conscodename,
        this.userdepotname,
        this.postdesig,
        this.crnremark,
        this.pdfpath,
        this.crnapprovaldate,
        this.sentforappdt});

  RepData.fromJson(Map<String, dynamic> json) {
    crnflag = json['crnflag'];
    rlyname = json['rlyname'];
    dmtrno = json['dmtrno'];
    dateofaccountal = json['dateofaccountal'];
    qtyreplaced = json['qtyreplaced'];
    unit = json['unit'];
    challanno = json['challanno'];
    challandate = json['challandate'];
    receiptdate = json['receiptdate'];
    conscodename = json['conscodename'];
    userdepotname = json['userdepotname'];
    postdesig = json['postdesig'];
    crnremark = json['crnremark'];
    pdfpath = json['pdfpath'];
    crnapprovaldate = json['crnapprovaldate'];
    sentforappdt = json['sentforappdt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['crnflag'] = this.crnflag;
    data['rlyname'] = this.rlyname;
    data['dmtrno'] = this.dmtrno;
    data['dateofaccountal'] = this.dateofaccountal;
    data['qtyreplaced'] = this.qtyreplaced;
    data['unit'] = this.unit;
    data['challanno'] = this.challanno;
    data['challandate'] = this.challandate;
    data['receiptdate'] = this.receiptdate;
    data['conscodename'] = this.conscodename;
    data['userdepotname'] = this.userdepotname;
    data['postdesig'] = this.postdesig;
    data['crnremark'] = this.crnremark;
    data['pdfpath'] = this.pdfpath;
    data['crnapprovaldate'] = this.crnapprovaldate;
    data['sentforappdt'] = this.sentforappdt;
    return data;
  }
}