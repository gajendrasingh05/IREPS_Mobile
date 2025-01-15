class StkprpsummaryrailwaylistData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<StockProposalSummryRlwData>? data;

  StkprpsummaryrailwaylistData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  StkprpsummaryrailwaylistData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StockProposalSummryRlwData>[];
      json['data'].forEach((v) {
        data!.add(new StockProposalSummryRlwData.fromJson(v));
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

class StockProposalSummryRlwData {
  String? intcode;
  String? value;

  StockProposalSummryRlwData({this.intcode, this.value});

  StockProposalSummryRlwData.fromJson(Map<String, dynamic> json) {
    intcode = json['intcode'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intcode'] = this.intcode;
    data['value'] = this.value;
    return data;
  }
}