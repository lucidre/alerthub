import 'dart:convert';

import 'package:alerthub/common_libs.dart';
import 'package:collection/collection.dart';

class EventModel {
  String? id;
  String? name;
  String? description;
  String? creatorId;
  String? location;
  double? lat;
  double? long;
  List<String>? images;
  EventPriority? priority;
  int? upVote;
  int? downVote;
  String? availiablity;
  int? createdAt;
  int? updatedAt;

  EventModel({
    this.id,
    this.name,
    this.description,
    this.creatorId,
    this.location,
    this.lat,
    this.long,
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
    return 'Event(id: $id, name: $name, description: $description, creatorId: $creatorId, location: $location, lat: $lat, long: $long, images: $images, priority: $priority, upVote: $upVote, downVote: $downVote, availiablity: $availiablity, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory EventModel.fromMap(Map<String, dynamic> data) => EventModel(
        id: data['id'] as String?,
        name: data['name'] as String?,
        description: data['description'] as String?,
        creatorId: data['creator_id'] as String?,
        location: data['location'] as String?,
        lat: (data['lat'] as num?)?.toDouble(),
        long: (data['long'] as num?)?.toDouble(),
        images: (data['images'] as List<dynamic>?)?.map((e) {
          return e.toString();
        }).toList(),
        priority: data['priority'] != null
            ? priorityFromName(data['priority'])
            : null,
        upVote: data['up_vote'] as int?,
        downVote: data['down_vote'] as int?,
        availiablity: data['availiablity'] as String?,
        createdAt: data['created_at'] as int?,
        updatedAt: data['updated_at'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'creator_id': creatorId,
        'location': location,
        'lat': lat,
        'long': long,
        'images': images,
        'priority': priority?.name,
        'up_vote': upVote,
        'down_vote': downVote,
        'availiablity': availiablity,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [EventModel].
  factory EventModel.fromJson(String data) {
    return EventModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [EventModel] to a JSON string.
  String toJson() => json.encode(toMap());

  EventModel copyWith({
    String? id,
    String? name,
    String? description,
    String? creatorId,
    String? location,
    double? lat,
    double? long,
    List<String>? images,
    EventPriority? priority,
    int? upVote,
    int? downVote,
    String? availiablity,
    int? createdAt,
    int? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      location: location ?? this.location,
      lat: lat ?? this.lat,
      long: long ?? this.long,
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
    if (other is! EventModel) return false;
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
      long.hashCode ^
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
