import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/functions.dart';

class CountryModel implements DefaultModel {
  const CountryModel({
    required this.name,
    required this.flag,
    required this.code,
    required this.prefix,
    required this.length,
    required this.lengthAreaCode,
  });
  final String name;
  final String flag;
  final String code;
  final String prefix;
  final int? length;
  final int? lengthAreaCode;

  @override
  Iterable get values => toJson().values;

  @override
  CountryModel copyWith({
    String? name,
    String? flag,
    String? code,
    String? prefix,
    int? length,
    int? lengthAreaCode,
  }) =>
      CountryModel(
        name: name ?? this.name,
        flag: flag ?? this.flag,
        code: code ?? this.code,
        prefix: prefix ?? this.prefix,
        length: length ?? this.length,
        lengthAreaCode: lengthAreaCode ?? this.lengthAreaCode,
      );

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
        "flag": flag,
        "code": code,
        "prefix": prefix,
        "length": length,
        "lengthAreaCode": lengthAreaCode,
      };

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        name: json['name'],
        flag: json['flag'],
        code: json['code'],
        prefix: json['prefix'],
        length: json['length'],
        lengthAreaCode: json['lengthAreaCode'],
      );

  static List<CountryModel> buildListFrom(Iterable iterableList) =>
      iterableList.map((e) => CountryModel.fromJson(e)).toList();

  static Future<List<CountryModel>> getFromAsset(String assetPath) async =>
      CountryModel.buildListFrom(await getJsonFile(assetPath));
}
