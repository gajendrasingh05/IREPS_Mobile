class ConsAnalysis {
  String? _pacfirm;
  String? _stkunit;
  String? _depodetail;
  String? _issuecode;
  String? _rlyname;
  String? _issconsgdept;
  String? _ledgerno;
  String? _vs;
  String? _consumind;
  String? _ledgername;
  String? _ledgerfoliono;
  String? _ledgerfolioname;
  String? _ledgerfolioplno;
  String? _ledgerfolioshortdesc;
  String? _consumppercentage;
  String? _monthlycurrentconsumption;
  String? _monthlypreviousconsumption;

  String? get pacfirm => _pacfirm;
  String? get stkunit => _stkunit;
  String? get depodetail => _depodetail;
  String? get issuecode => _issuecode;
  String? get rlyname => _rlyname;
  String? get issconsgdept => _issconsgdept;
  String? get ledgerno => _ledgerno;
  String? get vs => _vs;
  String? get consumind => _consumind;
  String? get ledgername => _ledgername;
  String? get ledgerfoliono => _ledgerfoliono;
  String? get ledgerfolioname => _ledgerfolioname;
  String? get ledgerfolioplno => _ledgerfolioplno;
  String? get ledgerfolioshortdesc => _ledgerfolioshortdesc;
  String? get consumppercentage => _consumppercentage;
  String? get monthlycurrentconsumption => _monthlycurrentconsumption;
  String? get monthlypreviousconsumption => _monthlypreviousconsumption;

  ConsAnalysis({
      String? pacfirm, 
      String? stkunit, 
      String? depodetail, 
      String? issuecode, 
      String? rlyname, 
      String? issconsgdept, 
      String? ledgerno, 
      String? vs, 
      String? consumind, 
      String? ledgername, 
      String? ledgerfoliono, 
      String? ledgerfolioname, 
      String? ledgerfolioplno, 
      String? ledgerfolioshortdesc, 
      String? consumppercentage, 
      String? monthlycurrentconsumption, 
      String? monthlypreviousconsumption}){
    _pacfirm = pacfirm;
    _stkunit = stkunit;
    _depodetail = depodetail;
    _issuecode = issuecode;
    _rlyname = rlyname;
    _issconsgdept = issconsgdept;
    _ledgerno = ledgerno;
    _vs = vs;
    _consumind = consumind;
    _ledgername = ledgername;
    _ledgerfoliono = ledgerfoliono;
    _ledgerfolioname = ledgerfolioname;
    _ledgerfolioplno = ledgerfolioplno;
    _ledgerfolioshortdesc = ledgerfolioshortdesc;
    _consumppercentage = consumppercentage;
    _monthlycurrentconsumption = monthlycurrentconsumption;
    _monthlypreviousconsumption = monthlypreviousconsumption;
}

  ConsAnalysis.fromJson(dynamic json) {
    _pacfirm = json['pacfirm'];
    _stkunit = json['stkunit'];
    _depodetail = json['depodetail'];
    _issuecode = json['issuecode'];
    _rlyname = json['rlyname'];
    _issconsgdept = json['issconsgdept'];
    _ledgerno = json['ledgerno'];
    _vs = json['vs'];
    _consumind = json['consumind'];
    _ledgername = json['ledgername'];
    _ledgerfoliono = json['ledgerfoliono'];
    _ledgerfolioname = json['ledgerfolioname'];
    _ledgerfolioplno = json['ledgerfolioplno'];
    _ledgerfolioshortdesc = json['ledgerfolioshortdesc'];
    _consumppercentage = json['consumppercentage'];
    _monthlycurrentconsumption = json['monthlycurrentconsumption'];
    _monthlypreviousconsumption = json['monthlypreviousconsumption'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['pacfirm'] = _pacfirm;
    map['stkunit'] = _stkunit;
    map['depodetail'] = _depodetail;
    map['issuecode'] = _issuecode;
    map['rlyname'] = _rlyname;
    map['issconsgdept'] = _issconsgdept;
    map['ledgerno'] = _ledgerno;
    map['vs'] = _vs;
    map['consumind'] = _consumind;
    map['ledgername'] = _ledgername;
    map['ledgerfoliono'] = _ledgerfoliono;
    map['ledgerfolioname'] = _ledgerfolioname;
    map['ledgerfolioplno'] = _ledgerfolioplno;
    map['ledgerfolioshortdesc'] = _ledgerfolioshortdesc;
    map['consumppercentage'] = _consumppercentage;
    map['monthlycurrentconsumption'] = _monthlycurrentconsumption;
    map['monthlypreviousconsumption'] = _monthlypreviousconsumption;
    return map;
  }

}