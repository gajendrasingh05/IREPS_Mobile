class LoginResponse {
  String? _apiFor;
  String? _count;
  String? _status;
  String? _message;
  List<LoginrespData>? _data;

  LoginResponse(
      {String? apiFor,
        String? count,
        String? status,
        String? message,
        List<LoginrespData>? data}) {
    if (apiFor != null) {
      this._apiFor = apiFor;
    }
    if (count != null) {
      this._count = count;
    }
    if (status != null) {
      this._status = status;
    }
    if (message != null) {
      this._message = message;
    }
    if (data != null) {
      this._data = data;
    }
  }

  String? get apiFor => _apiFor;
  set apiFor(String? apiFor) => _apiFor = apiFor;
  String? get count => _count;
  set count(String? count) => _count = count;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get message => _message;
  set message(String? message) => _message = message;
  List<LoginrespData>? get data => _data;
  set data(List<LoginrespData>? data) => _data = data;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    _apiFor = json['api_for'];
    _count = json['count'];
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = <LoginrespData>[];
      json['data'].forEach((v) {
        _data!.add(new LoginrespData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_for'] = this._apiFor;
    data['count'] = this._count;
    data['status'] = this._status;
    data['message'] = this._message;
    if (this._data != null) {
      data['data'] = this._data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LoginrespData {
  String? _cToken;
  String? _sToken;
  String? _mapId;
  String? _emailId;
  String? _mobile;
  String? _userName;
  String? _wkArea;
  String? _userType;
  String? _uValue;
  String? _lastLogTime;
  String? _ouName;
  String? _orgZone;
  String? _moduleAccess;

  LoginrespData({
        String? cToken,
        String? sToken,
        String? mapId,
        String? emailId,
        String? mobile,
        String? userName,
        String? wkArea,
        String? userType,
        String? uValue,
        String? lastLogTime,
        String? ouName,
        String? orgZone,
        String? moduleAccess}) {
    if (cToken != null) {
      this._cToken = cToken;
    }
    if (sToken != null) {
      this._sToken = sToken;
    }
    if (mapId != null) {
      this._mapId = mapId;
    }
    if (emailId != null) {
      this._emailId = emailId;
    }
    if (mobile != null) {
      this._mobile = mobile;
    }
    if (userName != null) {
      this._userName = userName;
    }
    if (wkArea != null) {
      this._wkArea = wkArea;
    }
    if (userType != null) {
      this._userType = userType;
    }
    if (uValue != null) {
      this._uValue = uValue;
    }
    if (lastLogTime != null) {
      this._lastLogTime = lastLogTime;
    }
    if (ouName != null) {
      this._ouName = ouName;
    }
    if (orgZone != null) {
      this._orgZone = orgZone;
    }
    if (moduleAccess != null) {
      this._moduleAccess = moduleAccess;
    }
  }

  String? get cToken => _cToken;
  set cToken(String? cToken) => _cToken = cToken;
  String? get sToken => _sToken;
  set sToken(String? sToken) => _sToken = sToken;
  String? get mapId => _mapId;
  set mapId(String? mapId) => _mapId = mapId;
  String? get emailId => _emailId;
  set emailId(String? emailId) => _emailId = emailId;
  String? get mobile => _mobile;
  set mobile(String? mobile) => _mobile = mobile;
  String? get userName => _userName;
  set userName(String? userName) => _userName = userName;
  String? get wkArea => _wkArea;
  set wkArea(String? wkArea) => _wkArea = wkArea;
  String? get userType => _userType;
  set userType(String? userType) => _userType = userType;
  String? get uValue => _uValue;
  set uValue(String? uValue) => _uValue = uValue;
  String? get lastLogTime => _lastLogTime;
  set lastLogTime(String? lastLogTime) => _lastLogTime = lastLogTime;
  String? get ouName => _ouName;
  set ouName(String? ouName) => _ouName = ouName;
  String? get orgZone => _orgZone;
  set orgZone(String? orgZone) => _orgZone = orgZone;
  String? get moduleAccess => _moduleAccess;
  set moduleAccess(String? moduleAccess) => _moduleAccess = moduleAccess;


  LoginrespData.fromJson(Map<String, dynamic> json) {
    _cToken = json['c_token'];
    _sToken = json['s_token'];
    _mapId = json['map_id'];
    _emailId = json['email_id'];
    _mobile = json['mobile'];
    _userName = json['user_name'];
    _wkArea = json['wk_area'];
    _userType = json['user_type'];
    _uValue = json['u_value'];
    _lastLogTime = json['last_log_time'];
    _ouName = json['ou_name'];
    _orgZone = json['org_zone'];
    _moduleAccess = json['module_access'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['c_token'] = this._cToken;
    data['s_token'] = this._sToken;
    data['map_id'] = this._mapId;
    data['email_id'] = this._emailId;
    data['mobile'] = this._mobile;
    data['user_name'] = this._userName;
    data['wk_area'] = this._wkArea;
    data['user_type'] = this._userType;
    data['u_value'] = this._uValue;
    data['last_log_time'] = this._lastLogTime;
    data['ou_name'] = this._ouName;
    data['org_zone'] = this._orgZone;
    data['module_access'] = this._moduleAccess;
    return data;
  }
}