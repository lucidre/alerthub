import 'dart:convert';

import 'package:collection/collection.dart';

import 'notification.dart';

class Data {
  String? id;
  String? uid;
  List<Notification>? notifications;

  Data({this.id, this.uid, this.notifications});

  @override
  String toString() {
    return 'Data(id: $id, uid: $uid, notifications: $notifications)';
  }

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        id: data['id'] as String?,
        uid: data['uid'] as String?,
        notifications: (data['notifications'] as List<dynamic>?)
            ?.map((e) => Notification.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'uid': uid,
        'notifications': notifications?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory Data.fromJson(String data) {
    return Data.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());

  Data copyWith({
    String? id,
    String? uid,
    List<Notification>? notifications,
  }) {
    return Data(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Data) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => id.hashCode ^ uid.hashCode ^ notifications.hashCode;
}
