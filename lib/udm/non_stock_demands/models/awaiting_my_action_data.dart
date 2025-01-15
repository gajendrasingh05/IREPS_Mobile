class AwaitingMyActionData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<AwaitingActionData>? data;

  AwaitingMyActionData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  AwaitingMyActionData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AwaitingActionData>[];
      json['data'].forEach((v) {
        data!.add(new AwaitingActionData.fromJson(v));
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

class AwaitingActionData {
  String? demandref;
  String? authSeq;
  String? approvalstatus;
  String? itemdescription;
  String? previouspost;
  String? initiatedwithpost;
  String? currentlywithpost;
  String? dmdkey;
  String? dmdno;
  String? dmddate;
  String? indentorname;
  String? createdtime;
  String? currentlywith;
  String? dmdstatus;
  String? dmdstatusval;
  String? demandestval;
  String? approvalvalue;
  String? username;
  String? useremail;

  AwaitingActionData(
      {this.demandref,
        this.authSeq,
        this.approvalstatus,
        this.itemdescription,
        this.previouspost,
        this.initiatedwithpost,
        this.currentlywithpost,
        this.dmdkey,
        this.dmdno,
        this.dmddate,
        this.indentorname,
        this.createdtime,
        this.currentlywith,
        this.dmdstatus,
        this.dmdstatusval,
        this.demandestval,
        this.approvalvalue,
        this.username,
        this.useremail});

  AwaitingActionData.fromJson(Map<String, dynamic> json) {
    demandref = json['demandref'];
    authSeq = json['auth_seq'];
    approvalstatus = json['approvalstatus'];
    itemdescription = json['itemdescription'];
    previouspost = json['previouspost'];
    initiatedwithpost = json['initiatedwithpost'];
    currentlywithpost = json['currentlywithpost'];
    dmdkey = json['dmdkey'];
    dmdno = json['dmdno'];
    dmddate = json['dmddate'];
    indentorname = json['indentorname'];
    createdtime = json['createdtime'];
    currentlywith = json['currentlywith'];
    dmdstatus = json['dmdstatus'];
    dmdstatusval = json['dmdstatusval'];
    demandestval = json['demandestval'];
    approvalvalue = json['approvalvalue'];
    username = json['username'];
    useremail = json['useremail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['demandref'] = this.demandref;
    data['auth_seq'] = this.authSeq;
    data['approvalstatus'] = this.approvalstatus;
    data['itemdescription'] = this.itemdescription;
    data['previouspost'] = this.previouspost;
    data['initiatedwithpost'] = this.initiatedwithpost;
    data['currentlywithpost'] = this.currentlywithpost;
    data['dmdkey'] = this.dmdkey;
    data['dmdno'] = this.dmdno;
    data['dmddate'] = this.dmddate;
    data['indentorname'] = this.indentorname;
    data['createdtime'] = this.createdtime;
    data['currentlywith'] = this.currentlywith;
    data['dmdstatus'] = this.dmdstatus;
    data['dmdstatusval'] = this.dmdstatusval;
    data['demandestval'] = this.demandestval;
    data['approvalvalue'] = this.approvalvalue;
    data['username'] = this.username;
    data['useremail'] = this.useremail;
    return data;
  }
}