class StockDetails {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<AvailableStockData>? data;

  StockDetails({this.apiFor, this.count, this.status, this.message, this.data});

  StockDetails.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AvailableStockData>[];
      json['data'].forEach((v) {
        data!.add(new AvailableStockData.fromJson(v));
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

class AvailableStockData {
  String? zoneName;
  String? totalStock;
  String? totalValue;
  String? rowId;

  AvailableStockData({this.zoneName, this.totalStock, this.totalValue, this.rowId});

  AvailableStockData.fromJson(Map<String, dynamic> json) {
    zoneName = json['zone_name'];
    totalStock = json['total_stock'];
    totalValue = json['total_value'];
    rowId = json['row_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zone_name'] = this.zoneName;
    data['total_stock'] = this.totalStock;
    data['total_value'] = this.totalValue;
    data['row_id'] = this.rowId;
    return data;
  }
}