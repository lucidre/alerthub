import 'dart:convert';
import 'dart:ui';

import 'package:alerthub/constants/style.dart';
import 'package:collection/collection.dart';

class Event {
  final String? id;
  final String? name;
  final String? description;
  final String? creatorId;
  final String? location;
  final double? lat;
  final double? lng;
  final List<String>? images;
  final EventPriority? priority;
  final int? upVote;
  final int? downVote;
  final String? availiablity;
  final int? createdAt;
  final int? updatedAt;

  const Event({
    this.id,
    this.name,
    this.description,
    this.creatorId,
    this.location,
    this.lat,
    this.lng,
    this.images,
    this.priority,
    this.upVote,
    this.downVote,
    this.availiablity,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'Datum(id: $id, name: $name, description: $description, creatorId: $creatorId, location: $location, lat: $lat, lng: $lng, images: $images, priority: $priority, upVote: $upVote, downVote: $downVote, availiablity: $availiablity, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory Event.fromMap(Map<String, dynamic> data) => Event(
        id: data['id'] as String?,
        name: data['name'] as String?,
        description: data['description'] as String?,
        creatorId: data['creatorId'] as String?,
        location: data['location'] as String?,
        lat: (data['lat'] as num?)?.toDouble(),
        lng: (data['lng'] as num?)?.toDouble(),
        images: (data['images'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        priority: data['priority'] == null
            ? null
            : priorityFromName(data['priority']),
        upVote: data['upVote'] as int?,
        downVote: data['downVote'] as int?,
        availiablity: data['availiablity'] as String?,
        createdAt: data['createdAt'] as int?,
        updatedAt: data['updatedAt'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'creatorId': creatorId,
        'location': location,
        'lat': lat,
        'lng': lng,
        'images': images,
        'priority': priority?.name,
        'upVote': upVote,
        'downVote': downVote,
        'availiablity': availiablity,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Event].
  factory Event.fromJson(String data) {
    return Event.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Event] to a JSON string.
  String toJson() => json.encode(toMap());

  Event copyWith({
    String? id,
    String? name,
    String? description,
    String? creatorId,
    String? location,
    double? lat,
    double? lng,
    List<String>? images,
    EventPriority? priority,
    int? upVote,
    int? downVote,
    String? availiablity,
    int? createdAt,
    int? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      location: location ?? this.location,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      images: images ?? this.images,
      priority: priority ?? this.priority,
      upVote: upVote ?? this.upVote,
      downVote: downVote ?? this.downVote,
      availiablity: availiablity ?? this.availiablity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Event) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      creatorId.hashCode ^
      location.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      images.hashCode ^
      priority.hashCode ^
      upVote.hashCode ^
      downVote.hashCode ^
      availiablity.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

enum EventPriority {
  high,
  medium,
  low,
}

EventPriority priorityFromName(String name) {
  if (name == 'high') {
    return EventPriority.high;
  } else if (name == 'medium') {
    return EventPriority.medium;
  } else {
    return EventPriority.low;
  }
}

extension EventExtension on EventPriority {
  String get displayName {
    if (this == EventPriority.high) {
      return 'High';
    } else if (this == EventPriority.medium) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }

  String get description {
    if (this == EventPriority.high) {
      return 'This is a high-priority event that significantly impacts users and the surrounding environment. Please be cautious and consider finding alternatives, as this event could cause major disruptions or critical issues affecting your daily activities.';
    } else if (this == EventPriority.medium) {
      return 'This event has a moderate impact on users and the environment. While it may cause some inconvenience, it is not immediately critical. Please stay informed and plan accordingly to minimize any potential disruptions to your daily routine.';
    } else {
      return 'This is a low-priority event with minimal impact on users and the environment. It is a minor occurrence that should not significantly affect your daily life. You can address it at your convenience without major concerns.';
    }
  }

  Color get color {
    if (this == EventPriority.high) {
      return destructive600;
    } else if (this == EventPriority.medium) {
      return warning600;
    } else {
      return primary600;
    }
  }

  Color get color2 {
    if (this == EventPriority.high) {
      return destructive500;
    } else if (this == EventPriority.medium) {
      return warning500;
    } else {
      return primary400;
    }
  }

  Color get color3 {
    if (this == EventPriority.high) {
      return destructive100;
    } else if (this == EventPriority.medium) {
      return warning100;
    } else {
      return primary100;
    }
  }

  Color get color4 {
    if (this == EventPriority.high) {
      return destructive300;
    } else if (this == EventPriority.medium) {
      return warning400;
    } else {
      return primary400;
    }
  }
}
