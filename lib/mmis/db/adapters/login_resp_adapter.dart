import 'package:flutter_app/mmis/db/db_models/userloginrespdb.dart';
import 'package:hive/hive.dart';

class LoginRespAdapter extends TypeAdapter<UserLoginrespDb> {

  @override
  final int typeId = 1;

  @override
  UserLoginrespDb read(BinaryReader reader){
    final cToken = reader.read();
    final sToken = reader.read();
    final mapId = reader.read();
    final emailId = reader.read();
    final mobile = reader.read();
    final userName = reader.read();
    final wkArea = reader.read();
    final userType = reader.read();
    final uValue = reader.read();
    final lastLogTime = reader.read();
    final ouName = reader.read();
    final orgZone = reader.read();
    final moduleAccess = reader.read();

    return UserLoginrespDb(cToken: cToken, sToken: sToken, mapId: mapId, emailId: emailId, mobile: mobile, userName: userName, wkArea: wkArea, userType: userType, uValue: uValue, lastLogTime: lastLogTime, ouName: ouName, orgZone: orgZone, moduleAccess: moduleAccess);
  }

  @override
  void write(BinaryWriter writer, UserLoginrespDb obj){
    writer.write(obj.cToken);
    writer.write(obj.sToken);
    writer.write(obj.mapId);
    writer.write(obj.emailId);
    writer.write(obj.mobile);
    writer.write(obj.userName);
    writer.write(obj.wkArea);
    writer.write(obj.userType);
    writer.write(obj.uValue);
    writer.write(obj.lastLogTime);
    writer.write(obj.ouName);
    writer.write(obj.orgZone);
    writer.write(obj.moduleAccess);
  }

  // @override
  // final int typeId = 1;
  //
  // @override
  // UserLoginrespDb read(BinaryReader reader) {
  //   final numOfFields = reader.readByte();
  //   final fields = <int, dynamic>{
  //     for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
  //   };
  //   return UserLoginrespDb(
  //       fields[0] as  String,
  //       fields[1] as  String,
  //       fields[2] as  String,
  //       fields[3] as  String,
  //       fields[4] as  String,
  //       fields[5] as  String,
  //       fields[6] as  String,
  //       fields[7] as  String,
  //       fields[8] as  String,
  //       fields[9] as  String,
  //       fields[10] as String,
  //       fields[11] as String,
  //       fields[12] as String,
  //   );
  // }
  //
  // @override
  // void write(BinaryWriter writer, UserLoginrespDb obj) {
  //   writer
  //     ..writeByte(0)
  //     ..write(obj.cToken)
  //     ..writeByte(1)
  //     ..write(obj.sToken)
  //     ..writeByte(2)
  //     ..write(obj.mapId)
  //     ..writeByte(3)
  //     ..write(obj.emailId)
  //     ..writeByte(4)
  //     ..write(obj.mobile)
  //     ..writeByte(5)
  //     ..write(obj.userName)
  //     ..writeByte(6)
  //     ..write(obj.wkArea)
  //     ..writeByte(7)
  //     ..write(obj.userType)
  //     ..writeByte(8)
  //     ..write(obj.uValue)
  //     ..writeByte(9)
  //     ..write(obj.lastLogTime)
  //     ..writeByte(10)
  //     ..write(obj.ouName)
  //     ..writeByte(11)
  //     ..write(obj.orgZone)
  //     ..writeByte(12)
  //     ..write(obj.moduleAccess);
  // }
  //
  // @override
  // int get hashCode => typeId.hashCode;
  //
  // @override
  // bool operator ==(Object other) => identical(this, other) || other is LoginRespAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}