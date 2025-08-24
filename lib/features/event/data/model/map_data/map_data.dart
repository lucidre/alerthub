import 'dart:convert';

import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:collection/collection.dart';

class MapData {
  final String? message;
  final List<Event>? events;
  final List<Hospital>? hospitals;

  const MapData({this.message, this.events, this.hospitals});

  @override
  String toString() =>
      'Event(message: $message, data: $events, hospitals: $hospitals)';

  factory MapData.fromMap(Map<String, dynamic> data) => MapData(
        message: data['message'] as String?,
        events: (data['events'] as List<dynamic>?)
            ?.map((e) => Event.fromMap(e as Map<String, dynamic>))
            .toList(),
        hospitals: (data['hospitals'] as List<dynamic>?)
            ?.map((e) => Hospital.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': events?.map((e) => e.toMap()).toList(),
        'hospitals': hospitals?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MapData].
  factory MapData.fromJson(String data) {
    return MapData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MapData] to a JSON string.
  String toJson() => json.encode(toMap());

  MapData copyWith({
    String? message,
    List<Event>? events,
    List<Hospital>? hospitals,
  }) {
    return MapData(
      message: message ?? this.message,
      events: events ?? this.events,
      hospitals: hospitals ?? this.hospitals,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! MapData) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => message.hashCode ^ events.hashCode ^ hospitals.hashCode;
}
