import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/functions.dart';

class CountryModel implements DefaultModel {
  const CountryModel({
    required this.name,
    required this.flag,
    required this.code,
    required this.prefix,
    this.minLength,
    this.maxLength,
    this.lengthAreaCode,
    this.enableStartCeroValidation,
  });
  final String name;
  final String flag;
  final String code;
  final String prefix;
  final int? minLength;
  final int? maxLength;
  final int? lengthAreaCode;
  final bool? enableStartCeroValidation;

  @override
  Iterable get values => toJson().values;

  @override
  CountryModel copyWith({
    String? name,
    String? flag,
    String? code,
    String? prefix,
    int? minLength,
    int? maxLength,
    int? lengthAreaCode,
    bool? enableStartCeroValidation,
  }) =>
      CountryModel(
        name: name ?? this.name,
        flag: flag ?? this.flag,
        code: code ?? this.code,
        prefix: prefix ?? this.prefix,
        minLength: minLength ?? this.minLength,
        maxLength: maxLength ?? this.maxLength,
        lengthAreaCode: lengthAreaCode ?? this.lengthAreaCode,
        enableStartCeroValidation:
            enableStartCeroValidation ?? this.enableStartCeroValidation,
      );

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
        "flag": flag,
        "code": code,
        "prefix": prefix,
        "minLength": minLength,
        "maxLength": maxLength,
        "lengthAreaCode": lengthAreaCode,
        "enableStartCeroValidation": enableStartCeroValidation,
      };

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        name: json['name'],
        flag: json['flag'],
        code: json['code'],
        prefix: json['prefix'],
        minLength: json['minLength'],
        maxLength: json['maxLength'],
        lengthAreaCode: json['lengthAreaCode'],
        enableStartCeroValidation: json['enableStartCeroValidation'],
      );

  static List<CountryModel> buildListFrom(Iterable iterableList) =>
      iterableList.map((e) => CountryModel.fromJson(e)).toList();

  static Future<List<CountryModel>> getFromAsset(String assetPath) async =>
      CountryModel.buildListFrom(await getJsonFile(assetPath));
}
