class RailwaylistData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<CrnSummaryRlwData>? data;

  RailwaylistData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  RailwaylistData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CrnSummaryRlwData>[];
      json['data'].forEach((v) {
        data!.add(new CrnSummaryRlwData.fromJson(v));
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

class CrnSummaryRlwData {
  String? intcode;
  String? value;

  CrnSummaryRlwData({this.intcode, this.value});

  CrnSummaryRlwData.fromJson(Map<String, dynamic> json) {
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