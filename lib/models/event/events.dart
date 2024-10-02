import 'dart:convert';

import 'package:collection/collection.dart';

import 'event.dart';

class Events {
  final String? message;
  final List<Event>? data;

  const Events({this.message, this.data});

  @override
  String toString() => 'Event(message: $message, data: $data)';

  factory Events.fromMap(Map<String, dynamic> data) => Events(
        message: data['message'] as String?,
        data: (data['data'] as List<dynamic>?)
            ?.map((e) => Event.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': data?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Events].
  factory Events.fromJson(String data) {
    return Events.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Events] to a JSON string.
  String toJson() => json.encode(toMap());

  Events copyWith({
    String? message,
    List<Event>? data,
  }) {
    return Events(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Events) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}
