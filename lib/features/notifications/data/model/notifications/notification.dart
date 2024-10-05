import 'dart:convert';

import 'package:collection/collection.dart';

class Notification {
  String? description;
  int? createdAt;

  Notification({this.description, this.createdAt});

  @override
  String toString() {
    return 'Notification(description: $description, createdAt: $createdAt)';
  }

  factory Notification.fromMap(Map<String, dynamic> data) => Notification(
        description: data['description'] as String?,
        createdAt: data['createdAt'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'description': description,
        'createdAt': createdAt,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Notification].
  factory Notification.fromJson(String data) {
    return Notification.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Notification] to a JSON string.
  String toJson() => json.encode(toMap());

  Notification copyWith({
    String? description,
    int? createdAt,
  }) {
    return Notification(
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Notification) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => description.hashCode ^ createdAt.hashCode;
}
