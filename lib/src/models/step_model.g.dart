// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StepModel _$StepModelFromJson(Map<String, dynamic> json) => StepModel(
      (json['steps'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Map<String, int>.from(e as Map)),
      ),
      json['lastUpdate'] as String,
      json['username'] as String,
    );

Map<String, dynamic> _$StepModelToJson(StepModel instance) => <String, dynamic>{
      'steps': instance.steps,
      'lastUpdate': instance.lastUpdate,
      'username': instance.username,
    };
