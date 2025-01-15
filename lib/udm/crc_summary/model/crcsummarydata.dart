class CrcSummaryData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<CrcSmryData>? data;

  CrcSummaryData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  CrcSummaryData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CrcSmryData>[];
      json['data'].forEach((v) {
        data!.add(new CrcSmryData.fromJson(v));
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

class CrcSmryData {
  String? railname;
  String? unittype;
  String? unitname;
  String? department;
  String? conscode;
  String? consignee;
  String? subconscode;
  String? subconsname;
  String? openbal;
  String? billreceived;
  String? billpassed;
  String? totalpending;
  String? pendsevendays;
  String? pendfifteendays;
  String? pendthirtydays;
  String? pendmorethirty;

  CrcSmryData(
      {this.railname,
        this.unittype,
        this.unitname,
        this.department,
        this.conscode,
        this.consignee,
        this.subconscode,
        this.subconsname,
        this.openbal,
        this.billreceived,
        this.billpassed,
        this.totalpending,
        this.pendsevendays,
        this.pendfifteendays,
        this.pendthirtydays,
        this.pendmorethirty});

  CrcSmryData.fromJson(Map<String, dynamic> json) {
    railname = json['railname'];
    unittype = json['unittype'];
    unitname = json['unitname'];
    department = json['department'];
    conscode = json['conscode'];
    consignee = json['consignee'];
    subconscode = json['subconscode'];
    subconsname = json['subconsname'];
    openbal = json['openbal'];
    billreceived = json['billreceived'];
    billpassed = json['billpassed'];
    totalpending = json['totalpending'];
    pendsevendays = json['pendsevendays'];
    pendfifteendays = json['pendfifteendays'];
    pendthirtydays = json['pendthirtydays'];
    pendmorethirty = json['pendmorethirty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['railname'] = this.railname;
    data['unittype'] = this.unittype;
    data['unitname'] = this.unitname;
    data['department'] = this.department;
    data['conscode'] = this.conscode;
    data['consignee'] = this.consignee;
    data['subconscode'] = this.subconscode;
    data['subconsname'] = this.subconsname;
    data['openbal'] = this.openbal;
    data['billreceived'] = this.billreceived;
    data['billpassed'] = this.billpassed;
    data['totalpending'] = this.totalpending;
    data['pendsevendays'] = this.pendsevendays;
    data['pendfifteendays'] = this.pendfifteendays;
    data['pendthirtydays'] = this.pendthirtydays;
    data['pendmorethirty'] = this.pendmorethirty;
    return data;
  }
}