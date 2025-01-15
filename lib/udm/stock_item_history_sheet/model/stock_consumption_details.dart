class StockConsumptionDetails {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<ConsumptionDetailData>? data;

  StockConsumptionDetails(
      {this.apiFor, this.count, this.status, this.message, this.data});

  StockConsumptionDetails.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ConsumptionDetailData>[];
      json['data'].forEach((v) {
        data!.add(new ConsumptionDetailData.fromJson(v));
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

class ConsumptionDetailData {
  String? dp;
  String? dpSname;
  String? cat;
  String? wd;
  String? wdLvlPlstatus;
  String? mainDp;
  String? udes;
  String? stock;
  String? bar;
  String? pdRate;
  String? aacNext;
  String? issueYr3;
  String? issueYr2;
  String? issueYr1;
  String? issueYr0;
  String? lidt;
  String? lrdt;
  String? nri;
  String? sparestock;
  String? cc58IssueYR0;
  String? cc58IssueYR1;
  String? cc58IssueYR2;
  String? cc58IssueYR3;
  String? month1;
  String? rowId;
  String? aac;

  ConsumptionDetailData(
      {this.dp,
        this.dpSname,
        this.cat,
        this.wd,
        this.wdLvlPlstatus,
        this.mainDp,
        this.udes,
        this.stock,
        this.bar,
        this.pdRate,
        this.aacNext,
        this.issueYr3,
        this.issueYr2,
        this.issueYr1,
        this.issueYr0,
        this.lidt,
        this.lrdt,
        this.nri,
        this.sparestock,
        this.cc58IssueYR0,
        this.cc58IssueYR1,
        this.cc58IssueYR2,
        this.cc58IssueYR3,
        this.month1,
        this.rowId,
        this.aac});

  ConsumptionDetailData.fromJson(Map<String, dynamic> json) {
    dp = json['dp'];
    dpSname = json['dp_sname'];
    cat = json['cat'];
    wd = json['wd'];
    wdLvlPlstatus = json['wd_lvl_plstatus'];
    mainDp = json['main_dp'];
    udes = json['udes'];
    stock = json['stock'];
    bar = json['bar'];
    pdRate = json['pd_rate'];
    aacNext = json['aac_next'];
    issueYr3 = json['issue_yr3'];
    issueYr2 = json['issue_yr2'];
    issueYr1 = json['issue_yr1'];
    issueYr0 = json['issue_yr0'];
    lidt = json['lidt'];
    lrdt = json['lrdt'];
    nri = json['nri'];
    sparestock = json['sparestock'];
    cc58IssueYR0 = json['cc58IssueYR0'];
    cc58IssueYR1 = json['cc58IssueYR1'];
    cc58IssueYR2 = json['cc58IssueYR2'];
    cc58IssueYR3 = json['cc58IssueYR3'];
    month1 = json['month1'];
    rowId = json['row_id'];
    aac = json['aac'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dp'] = this.dp;
    data['dp_sname'] = this.dpSname;
    data['cat'] = this.cat;
    data['wd'] = this.wd;
    data['wd_lvl_plstatus'] = this.wdLvlPlstatus;
    data['main_dp'] = this.mainDp;
    data['udes'] = this.udes;
    data['stock'] = this.stock;
    data['bar'] = this.bar;
    data['pd_rate'] = this.pdRate;
    data['aac_next'] = this.aacNext;
    data['issue_yr3'] = this.issueYr3;
    data['issue_yr2'] = this.issueYr2;
    data['issue_yr1'] = this.issueYr1;
    data['issue_yr0'] = this.issueYr0;
    data['lidt'] = this.lidt;
    data['lrdt'] = this.lrdt;
    data['nri'] = this.nri;
    data['sparestock'] = this.sparestock;
    data['cc58IssueYR0'] = this.cc58IssueYR0;
    data['cc58IssueYR1'] = this.cc58IssueYR1;
    data['cc58IssueYR2'] = this.cc58IssueYR2;
    data['cc58IssueYR3'] = this.cc58IssueYR3;
    data['month1'] = this.month1;
    data['row_id'] = this.rowId;
    data['aac'] = this.aac;
    return data;
  }
}