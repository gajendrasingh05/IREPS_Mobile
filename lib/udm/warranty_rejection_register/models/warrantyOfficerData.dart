class WarrantyOfficerData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<OfiicerData>? data;

  WarrantyOfficerData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  WarrantyOfficerData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OfiicerData>[];
      json['data'].forEach((v) {
        data!.add(new OfiicerData.fromJson(v));
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

class OfiicerData {
  String? userMail;

  OfiicerData({this.userMail});

  OfiicerData.fromJson(Map<String, dynamic> json) {
    userMail = json['userMail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userMail'] = this.userMail;
    return data;
  }
}