class UnitInitiatingProposalData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<UnitinitPrpData>? data;

  UnitInitiatingProposalData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  UnitInitiatingProposalData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UnitinitPrpData>[];
      json['data'].forEach((v) {
        data!.add(new UnitinitPrpData.fromJson(v));
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

class UnitinitPrpData {
  String? intCode;
  String? value;

  UnitinitPrpData({this.intCode, this.value});

  UnitinitPrpData.fromJson(Map<String, dynamic> json) {
    intCode = json['intCode'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intCode'] = this.intCode;
    data['value'] = this.value;
    return data;
  }
}