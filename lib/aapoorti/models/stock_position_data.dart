class StockPositionData {
  String? nAME;
  String? iD;
  int? aCCID;

  StockPositionData({this.nAME, this.iD, this.aCCID});

  StockPositionData.fromJson(Map<String, dynamic> json) {
    nAME = json['NAME'];
    iD = json['ID'];
    aCCID = json['ACCID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NAME'] = this.nAME;
    data['ID'] = this.iD;
    data['ACCID'] = this.aCCID;
    return data;
  }
}