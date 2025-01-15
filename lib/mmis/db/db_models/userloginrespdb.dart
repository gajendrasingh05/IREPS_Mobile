import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class UserLoginrespDb extends HiveObject {
  @HiveField(0)
  late String cToken;
  @HiveField(1)
  late String sToken;
  @HiveField(2)
  late String mapId;
  @HiveField(3)
  late String emailId;
  @HiveField(4)
  late String? mobile;
  @HiveField(5)
  late String userName;
  @HiveField(6)
  late String wkArea;
  @HiveField(7)
  late String userType;
  @HiveField(8)
  late String uValue;
  @HiveField(9)
  late String lastLogTime;
  @HiveField(10)
  late String ouName;
  @HiveField(11)
  late String orgZone;
  @HiveField(12)
  late String moduleAccess;

  UserLoginrespDb({required this.cToken, required this.sToken, required this.mapId, required this.emailId, required this.mobile, required this.userName,
     required this.wkArea, required this.userType, required this.uValue, required this.lastLogTime, required this.ouName, required this.orgZone, required this.moduleAccess});

  factory UserLoginrespDb.fromJson(Map<String, dynamic> json){
    return UserLoginrespDb(cToken: json['cToken'], sToken: json['sToken'], mapId: json['mapId'], emailId: json['emailId'], mobile: json['mobile'], userName: json['userName'],
                              wkArea: json['wkArea'], userType: json['userType'], uValue: json[''], lastLogTime: json['lastLogTime'], ouName: json['lastLogTime'], orgZone: json['orgZone'], moduleAccess: json['moduleAccess']);
  }

  Map<String, dynamic> toJson(){
    return {
      'cToken': cToken,
      'sToken' : sToken,
      'mapId' : mapId,
      'emailId' : emailId,
      'mobile' : mobile,
      'userName' : userName,
      'wkArea' : wkArea,
      'userType' : userType,
      'uValue' : uValue,
      'lastLogTime' : lastLogTime,
      'ouName' : ouName,
      'orgZone' : orgZone,
      'moduleAccess' : moduleAccess
    };
  }
}