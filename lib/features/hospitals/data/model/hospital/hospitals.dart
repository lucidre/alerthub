import 'dart:convert';

import 'package:collection/collection.dart';

import 'hospital.dart';

class Hospitals {
  final String? message;
  final List<Hospital>? data;

  const Hospitals({this.message, this.data});

  @override
  String toString() => 'Event(message: $message, data: $data)';

  factory Hospitals.fromMap(Map<String, dynamic> data) => Hospitals(
        message: data['message'] as String?,
        data: (data['data'] as List<dynamic>?)
            ?.map((e) => Hospital.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': data?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Hospitals].
  factory Hospitals.fromJson(String data) {
    return Hospitals.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Hospitals] to a JSON string.
  String toJson() => json.encode(toMap());

  Hospitals copyWith({
    String? message,
    List<Hospital>? data,
  }) {
    return Hospitals(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Hospitals) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}
