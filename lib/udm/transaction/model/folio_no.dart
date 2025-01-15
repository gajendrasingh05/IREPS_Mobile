/// ledgerkey : "294609"
/// ledgerno : "002"
/// ledgername : "LHB C3"
/// ledgerfoliono : "0001"
/// ledgerfolioname : "02"
/// ledgerfolioplno : "33580066"
/// ledgerfolioshortdesc : "'BRAKE CALIPER UNIT WZ57 UP 10"

class FolioNo {
  String? _ledgerkey;
  String? _ledgerno;
  String? _ledgername;
  String? _ledgerfoliono;
  String? _ledgerfolioname;
  String? _ledgerfolioplno;
  String? _ledgerfolioshortdesc;

  String? get ledgerkey => _ledgerkey;
  String? get ledgerno => _ledgerno;
  String? get ledgername => _ledgername;
  String? get ledgerfoliono => _ledgerfoliono;
  String? get ledgerfolioname => _ledgerfolioname;
  String? get ledgerfolioplno => _ledgerfolioplno;
  String? get ledgerfolioshortdesc => _ledgerfolioshortdesc;

  FolioNo({
      String? ledgerkey, 
      String? ledgerno, 
      String? ledgername, 
      String? ledgerfoliono, 
      String? ledgerfolioname, 
      String? ledgerfolioplno, 
      String? ledgerfolioshortdesc}){
    _ledgerkey = ledgerkey;
    _ledgerno = ledgerno;
    _ledgername = ledgername;
    _ledgerfoliono = ledgerfoliono;
    _ledgerfolioname = ledgerfolioname;
    _ledgerfolioplno = ledgerfolioplno;
    _ledgerfolioshortdesc = ledgerfolioshortdesc;
}

  FolioNo.fromJson(dynamic json) {
    _ledgerkey = json['ledgerkey'];
    _ledgerno = json['ledgerno'];
    _ledgername = json['ledgername'];
    _ledgerfoliono = json['ledgerfoliono'];
    _ledgerfolioname = json['ledgerfolioname'];
    _ledgerfolioplno = json['ledgerfolioplno'];
    _ledgerfolioshortdesc = json['ledgerfolioshortdesc'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['ledgerkey'] = _ledgerkey;
    map['ledgerno'] = _ledgerno;
    map['ledgername'] = _ledgername;
    map['ledgerfoliono'] = _ledgerfoliono;
    map['ledgerfolioname'] = _ledgerfolioname;
    map['ledgerfolioplno'] = _ledgerfolioplno;
    map['ledgerfolioshortdesc'] = _ledgerfolioshortdesc;
    return map;
  }

}