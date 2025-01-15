/// unitname : "Numbers"
/// totalqty : "513"
/// totalval : "4150.17"

class ItemSummary {
  String? _unitname;
  String? _totalqty;
  String? _totalval;

  String? get unitname => _unitname;
  String? get totalqty => _totalqty;
  String? get totalval => _totalval;

  ItemSummary({
      String? unitname,
      String? totalqty,
      String? totalval}){
    _unitname = unitname;
    _totalqty = totalqty;
    _totalval = totalval;
}

  ItemSummary.fromJson(dynamic json) {
    _unitname = json['unitname'];
    _totalqty = json['totalqty'];
    _totalval = json['totalval'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['unitname'] = _unitname;
    map['totalqty'] = _totalqty;
    map['totalval'] = _totalval;
    return map;
  }

}