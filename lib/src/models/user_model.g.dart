// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      json['name'] as String,
      json['pic'] as String,
      (json['pendingReq'] as List<dynamic>).map((e) => e as String).toList(),
      (json['pendingInv'] as List<dynamic>).map((e) => e as String).toList(),
      (json['friends'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'name': instance.name,
      'pic': instance.pic,
      'pendingReq': instance.pendingReq,
      'pendingInv': instance.pendingInv,
      'friends': instance.friends,
    };
