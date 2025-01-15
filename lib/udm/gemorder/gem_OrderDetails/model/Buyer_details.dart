class BuyerDetails {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<BuyerDetailsData>? data;

  BuyerDetails(
      {this.apiFor, this.count, this.status, this.message, this.data});

  BuyerDetails.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BuyerDetailsData>[];
      json['data'].forEach((v) {
        data!.add(new BuyerDetailsData.fromJson(v));
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

class BuyerDetailsData {
  String? organisation;
  String? buyername;
  String? buyeraddress;
  String? buyermobile;


  BuyerDetailsData(
      {this.organisation,
        this.buyername,
        this.buyeraddress,
        this.buyermobile});


  BuyerDetailsData.fromJson(Map<String, dynamic> json) {
    organisation = json['organisation'];
    buyername = json['buyername'];
    buyeraddress = json['buyeraddress'];
    buyermobile = json['buyermobile'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['organisation'] = this.organisation;
    data['buyername'] = this.buyername;
    data['buyeraddress'] = this.buyeraddress;
    data['buyermobile'] = this.buyermobile;
    return data;
  }
}