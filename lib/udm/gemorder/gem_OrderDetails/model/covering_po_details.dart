class CoveringPODetails {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<CoveringPODetailsData>? data;

  CoveringPODetails(
      {this.apiFor, this.count, this.status, this.message, this.data});

  CoveringPODetails.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CoveringPODetailsData>[];
      json['data'].forEach((v) {
        data!.add(new CoveringPODetailsData.fromJson(v));
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

class CoveringPODetailsData {
  String? pono;
  String? podate;
  String? vendorname;
  String? povalue;
  String? payauthname;


  CoveringPODetailsData(
      {this.pono,
        this.podate,
        this.vendorname,
        this.povalue,
        this.payauthname});


  CoveringPODetailsData.fromJson(Map<String, dynamic> json) {
    pono = json['pono'];
    podate = json['podate'];
    vendorname = json['vendorname'];
    povalue = json['povalue'];
    payauthname = json['payauthname'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pono'] = this.pono;
    data['podate'] = this.podate;
    data['vendorname'] = this.vendorname;
    data['povalue'] = this.povalue;
    data['payauthname'] = this.payauthname;
    return data;
  }
}