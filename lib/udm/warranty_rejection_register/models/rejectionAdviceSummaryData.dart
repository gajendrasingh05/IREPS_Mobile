class RejectionAdviceSummaryData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<RejAdcSummaryData>? data;

  RejectionAdviceSummaryData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  RejectionAdviceSummaryData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RejAdcSummaryData>[];
      json['data'].forEach((v) {
        data!.add(new RejAdcSummaryData.fromJson(v));
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

class RejAdcSummaryData {
  String? totalorigrecovery;
  String? totalbalrecovery;
  String? totalbalrejqty;
  String? totalorigrejqty;

  RejAdcSummaryData(
      {this.totalorigrecovery,
        this.totalbalrecovery,
        this.totalbalrejqty,
        this.totalorigrejqty});

  RejAdcSummaryData.fromJson(Map<String, dynamic> json) {
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