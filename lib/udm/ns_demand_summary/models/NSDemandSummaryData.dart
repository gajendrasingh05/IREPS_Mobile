class NSDemandSummaryData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<NSDmdSummaryData>? data;

  NSDemandSummaryData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  NSDemandSummaryData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NSDmdSummaryData>[];
      json['data'].forEach((v) {
        data!.add(new NSDmdSummaryData.fromJson(v));
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

class NSDmdSummaryData {
  String? orgzone;
  String? orgzonecode;
  String? unitname;
  String? unitnamecode;
  String? unittypename;
  String? unittypecode;
  String? deptname;
  String? deptcode;
  String? ccode;
  String? consshortname;
  String? cname;
  String? indentorpost;
  String? indentorname;
  String? initiatedbydesig;
  String? total;
  String? draft;
  String? underfinanceconcurrence;
  String? underfinancevetting;
  String? underprocess;
  String? approved;
  String? returned;
  String? dropped;

  NSDmdSummaryData(
      {this.orgzone,
        this.orgzonecode,
        this.unitname,
        this.unitnamecode,
        this.unittypename,
        this.unittypecode,
        this.deptname,
        this.deptcode,
        this.ccode,
        this.consshortname,
        this.cname,
        this.indentorpost,
        this.indentorname,
        this.initiatedbydesig,
        this.total,
        this.draft,
        this.underfinanceconcurrence,
        this.underfinancevetting,
        this.underprocess,
        this.approved,
        this.returned,
        this.dropped});

  NSDmdSummaryData.fromJson(Map<String, dynamic> json) {
    orgzone = json['orgzone'];
    orgzonecode = json['orgzonecode'];
    unitname = json['unitname'];
    unitnamecode = json['unitnamecode'];
    unittypename = json['unittypename'];
    unittypecode = json['unittypecode'];
    deptname = json['deptname'];
    deptcode = json['deptcode'];
    ccode = json['ccode'];
    consshortname = json['consshortname'];
    cname = json['cname'];
    indentorpost = json['indentorpost'];
    indentorname = json['indentorname'];
    initiatedbydesig = json['initiatedbydesig'];
    total = json['total'];
    draft = json['draft'];
    underfinanceconcurrence = json['underfinanceconcurrence'];
    underfinancevetting = json['underfinancevetting'];
    underprocess = json['underprocess'];
    approved = json['approved'];
    returned = json['returned'];
    dropped = json['dropped'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orgzone'] = this.orgzone;
    data['orgzonecode'] = this.orgzonecode;
    data['unitname'] = this.unitname;
    data['unitnamecode'] = this.unitnamecode;
    data['unittypename'] = this.unittypename;
    data['unittypecode'] = this.unittypecode;
    data['deptname'] = this.deptname;
    data['deptcode'] = this.deptcode;
    data['ccode'] = this.ccode;
    data['consshortname'] = this.consshortname;
    data['cname'] = this.cname;
    data['indentorpost'] = this.indentorpost;
    data['indentorname'] = this.indentorname;
    data['initiatedbydesig'] = this.initiatedbydesig;
    data['total'] = this.total;
    data['draft'] = this.draft;
    data['underfinanceconcurrence'] = this.underfinanceconcurrence;
    data['underfinancevetting'] = this.underfinancevetting;
    data['underprocess'] = this.underprocess;
    data['approved'] = this.approved;
    data['returned'] = this.returned;
    data['dropped'] = this.dropped;
    return data;
  }
}