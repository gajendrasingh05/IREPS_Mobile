class ChallanStatus {
  String? _contractNO;
  String? _status;
  String? _firmNAME;
  String? _loadingDATE;
  String? _type;
  String? _contractDATE;
  String? _trainNO;
  String? _value;
  String? _grossPAYMENTAMOUNT;
  String? _licenseFEEAMOUNT;

  ChallanStatus(
      {String? contractNO,
      String? status,
      String? firmNAME,
      String? loadingDATE,
      String? type,
      String? contractDATE,
      String? trainNO,
      String? value,
      String? grossPAYMENTAMOUNT,
      String? licenseFEEAMOUNT}) {
    if (contractNO != null) {
      this._contractNO = contractNO;
    }
    if (status != null) {
      this._status = status;
    }
    if (firmNAME != null) {
      this._firmNAME = firmNAME;
    }
    if (loadingDATE != null) {
      this._loadingDATE = loadingDATE;
    }
    if (type != null) {
      this._type = type;
    }
    if (contractDATE != null) {
      this._contractDATE = contractDATE;
    }
    if (trainNO != null) {
      this._trainNO = trainNO;
    }
    if (value != null) {
      this._value = value;
    }
    if (grossPAYMENTAMOUNT != null) {
      this._grossPAYMENTAMOUNT = grossPAYMENTAMOUNT;
    }
    if (licenseFEEAMOUNT != null) {
      this._licenseFEEAMOUNT = licenseFEEAMOUNT;
    }
  }

  String get contractNO => _contractNO!;
  set contractNO(String contractNO) => _contractNO = contractNO;
  String get status => _status!;
  set status(String status) => _status = status;
  String get firmNAME => _firmNAME!;
  set firmNAME(String firmNAME) => _firmNAME = firmNAME;
  String get loadingDATE => _loadingDATE!;
  set loadingDATE(String loadingDATE) => _loadingDATE = loadingDATE;
  String get type => _type!;
  set type(String type) => _type = type;
  String get contractDATE => _contractDATE!;
  set contractDATE(String contractDATE) => _contractDATE = contractDATE;
  String get trainNO => _trainNO!;
  set trainNO(String trainNO) => _trainNO = trainNO;
  String get value => _value!;
  set value(String value) => _value = value;
  String get grossPAYMENTAMOUNT => _grossPAYMENTAMOUNT!;
  set grossPAYMENTAMOUNT(String grossPAYMENTAMOUNT) =>
      _grossPAYMENTAMOUNT = grossPAYMENTAMOUNT;
  String get licenseFEEAMOUNT => _licenseFEEAMOUNT!;
  set licenseFEEAMOUNT(String licenseFEEAMOUNT) =>
      _licenseFEEAMOUNT = licenseFEEAMOUNT;

  ChallanStatus.fromJson(Map<String, dynamic> json) {
    _contractNO = json['contract_NO'];
    _status = json['status'];
    _firmNAME = json['firm_NAME'];
    _loadingDATE = json['loading_DATE'];
    _type = json['type'];
    _contractDATE = json['contract_DATE'];
    _trainNO = json['train_NO'];
    _value = json['value'];
    _grossPAYMENTAMOUNT = json['gross_PAYMENT_AMOUNT'];
    _licenseFEEAMOUNT = json['license_FEE_AMOUNT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contract_NO'] = this._contractNO;
    data['status'] = this._status;
    data['firm_NAME'] = this._firmNAME;
    data['loading_DATE'] = this._loadingDATE;
    data['type'] = this._type;
    data['contract_DATE'] = this._contractDATE;
    data['train_NO'] = this._trainNO;
    data['value'] = this._value;
    data['gross_PAYMENT_AMOUNT'] = this._grossPAYMENTAMOUNT;
    data['license_FEE_AMOUNT'] = this._licenseFEEAMOUNT;
    return data;
  }
}
