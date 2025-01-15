class RailwaylistData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<WRRRlwData>? data;

  RailwaylistData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  RailwaylistData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WRRRlwData>[];
      json['data'].forEach((v) {
        data!.add(new WRRRlwData.fromJson(v));
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

class WRRRlwData {
  String? intcode;
  String? value;

  WRRRlwData({this.intcode, this.value});

  WRRRlwData.fromJson(Map<String, dynamic> json) {
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