import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';

class ExampleModel implements DefaultModel<ExampleModel> {
  ExampleModel({
    required this.name,
    required this.value,
  });
  final String name;
  final int value;

  @override
  Iterable get values => toJson().values;

  @override
  ExampleModel copyWith({
    String? name,
    int? value,
  }) =>
      ExampleModel(
        name: name ?? this.name,
        value: value ?? this.value,
      );

  static List<ExampleModel> buildListFrom(List<dynamic> iterableList) =>
      iterableList.map((e) => ExampleModel.fromJson(e)).toList();

  static Set<ExampleModel> buildSetFrom(List<dynamic> iterableList) =>
      iterableList.toSet().map((e) => ExampleModel.fromJson(e)).toSet();

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };

  factory ExampleModel.fromJson(Map<String, dynamic> json) => ExampleModel(
        name: json["name"],
        value: json["value"],
      );

  @override
  String toString() => 'ExampleModel(name: $name, value: $value)';

  static ExampleModel? fromJsonNullable(Map<String, dynamic>? json) =>
      json != null ? ExampleModel.fromJson(json) : null;
}
