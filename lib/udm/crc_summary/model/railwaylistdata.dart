class RailwaylistData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<CrcSummaryRlwData>? data;

  RailwaylistData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  RailwaylistData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CrcSummaryRlwData>[];
      json['data'].forEach((v) {
        data!.add(new CrcSummaryRlwData.fromJson(v));
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

class CrcSummaryRlwData {
  String? intcode;
  String? value;

  CrcSummaryRlwData({this.intcode, this.value});

  CrcSummaryRlwData.fromJson(Map<String, dynamic> json) {
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