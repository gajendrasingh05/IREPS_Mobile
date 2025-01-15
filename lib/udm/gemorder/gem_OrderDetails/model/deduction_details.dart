class DeductionDetails {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<DeductionDetailsData>? data;

  DeductionDetails(
      {this.apiFor, this.count, this.status, this.message, this.data});

  DeductionDetails.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DeductionDetailsData>[];
      json['data'].forEach((v) {
        data!.add(new DeductionDetailsData.fromJson(v));
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

class DeductionDetailsData {
  String? recovdesc;
  String? recovamt;

  DeductionDetailsData(
      {this.recovdesc,
        this.recovamt});


  DeductionDetailsData.fromJson(Map<String, dynamic> json) {
    recovdesc = json['recovdesc'];
    recovamt = json['recovamt'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recovdesc'] = this.recovdesc;
    data['recovamt'] = this.recovamt;
    return data;
  }
}