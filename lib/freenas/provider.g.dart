// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

freeNasData _$freeNasDataFromJson(Map<String, dynamic> json) {
  return freeNasData(
      id: json['id'] as String,
      msg: json['msg'] as String,
      session: json['session'] as String,
      method: json['method'] as String,
      params: json['params'] as List,
      version: json['version'] as String,
      result: json['result']);
}

Map<String, dynamic> _$freeNasDataToJson(freeNasData instance) =>
    <String, dynamic>{
      'version': instance.version,
      'msg': instance.msg,
      'id': instance.id,
      'session': instance.session,
      'method': instance.method,
      'params': instance.params,
      'result': instance.result
    };
