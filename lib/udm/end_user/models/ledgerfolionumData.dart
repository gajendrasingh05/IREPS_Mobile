class LedgerfolioNumberData{
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<LedgerfolioNumData>? data;

  LedgerfolioNumberData({this.apiFor, this.count, this.status, this.message, this.data});

  LedgerfolioNumberData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LedgerfolioNumData>[];
      json['data'].forEach((v) {
        data!.add(new LedgerfolioNumData.fromJson(v));
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

class LedgerfolioNumData {
  String? intcode;
  String? value;

  LedgerfolioNumData({this.intcode, this.value});

  LedgerfolioNumData.fromJson(Map<String, dynamic> json) {
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