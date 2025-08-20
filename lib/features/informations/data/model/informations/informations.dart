import 'dart:convert';

import 'information.dart';
import 'package:collection/collection.dart';

class Informations {
  String? message;
  List<Information>? data;

  Informations({this.message, this.data});

  @override
  String toString() => 'Informations(message: $message, informations: $data)';

  factory Informations.fromMap(Map<String, dynamic> data) => Informations(
        message: data['message'] as String?,
        data: (data['informations'] as List<dynamic>?)
            ?.map((e) => Information.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'informations': data?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Informations].
  factory Informations.fromJson(String data) {
    return Informations.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Informations] to a JSON string.
  String toJson() => json.encode(toMap());

  Informations copyWith({
    String? message,
    List<Information>? informations,
  }) {
    return Informations(
      message: message ?? this.message,
      data: informations ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Informations) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}
