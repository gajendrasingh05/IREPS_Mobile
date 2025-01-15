class WarrantysummaryreportData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<WarrantySmryReportData>? data;

  WarrantysummaryreportData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  WarrantysummaryreportData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WarrantySmryReportData>[];
      json['data'].forEach((v) {
        data!.add(new WarrantySmryReportData.fromJson(v));
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

class WarrantySmryReportData {
  String? totalorigrecovery;
  String? totalbalrecovery;
  String? totalbalrejqty;
  String? totalorigrejqty;

  WarrantySmryReportData(
      {this.totalorigrecovery,
        this.totalbalrecovery,
        this.totalbalrejqty,
        this.totalorigrejqty});

  WarrantySmryReportData.fromJson(Map<String, dynamic> json) {
    totalorigrecovery = json['totalorigrecovery'];
    totalbalrecovery = json['totalbalrecovery'];
    totalbalrejqty = json['totalbalrejqty'];
    totalorigrejqty = json['totalorigrejqty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalorigrecovery'] = this.totalorigrecovery;
    data['totalbalrecovery'] = this.totalbalrecovery;
    data['totalbalrejqty'] = this.totalbalrejqty;
    data['totalorigrejqty'] = this.totalorigrejqty;
    return data;
  }
}