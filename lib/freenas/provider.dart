import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'provider.g.dart';
// flutter packages pub run build_runner build

@JsonSerializable(nullable: true)
class freeNasData {
  String version;
  String msg;
  String id;
  String session;
  String method;
  List<dynamic> params;
  dynamic result;

  freeNasData({
    this.id,
    this.msg,
    this.session,
    this.method,
    this.params,
    this.version,
    this.result
  });

  factory freeNasData.fromJson(Map<String, dynamic> json) => _$freeNasDataFromJson(json);
  Map<String, dynamic> toJson() => _$freeNasDataToJson(this);
}

freeNasData jsonDecodeFunc(String data) {
  Map freeNasDataMap = jsonDecode(data);
  return freeNasData.fromJson(freeNasDataMap);
}


typedef freeNasData decodeFunc(String s);
typedef void messageHandler(freeNasData message);