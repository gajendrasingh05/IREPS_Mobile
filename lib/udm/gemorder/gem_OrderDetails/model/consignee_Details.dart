class ConsigneeDetails {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<ConsigneeDetailsData>? data;

  ConsigneeDetails(
      {this.apiFor, this.count, this.status, this.message, this.data});

  ConsigneeDetails.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ConsigneeDetailsData>[];
      json['data'].forEach((v) {
        data!.add(new ConsigneeDetailsData.fromJson(v));
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

class ConsigneeDetailsData {
  String? slno;
  String? prodsn;
  String? consigneename;
  String? consaddress;
  String? consmobile;
  String? itemdescription;
  String? qty;
  String? unit;


  ConsigneeDetailsData(
      {this.slno,
        this.prodsn,
        this.consigneename,
        this.consaddress,
        this.consmobile,
        this.itemdescription,
        this.qty,
        this.unit});


  ConsigneeDetailsData.fromJson(Map<String, dynamic> json) {
    slno = json['slno'];
    prodsn = json['prodsn'];
    consigneename = json['consigneename'];
    consaddress = json['consaddress'];
    consmobile = json['consmobile'];
    itemdescription = json['itemdescription'];
    qty = json['qty'];
    unit = json['unit'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slno'] = this.slno;
    data['prodsn'] = this.prodsn;
    data['consigneename'] = this.consigneename;
    data['consaddress'] = this.consaddress;
    data['consmobile'] = this.consmobile;
    data['itemdescription'] = this.itemdescription;
    data['qty'] = this.qty;
    data['unit'] = this.unit;
    return data;
  }
}