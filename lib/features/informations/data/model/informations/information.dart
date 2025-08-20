import 'dart:convert';

import 'package:collection/collection.dart';

class Information {
  List<String>? description;
  String? url;
  String? title;
  String? id;

  Information({
    this.description,
    this.url,
    this.title,
    this.id,
  });

  @override
  String toString() {
    return 'Information(description: $description, url: $url, title: $title, id: $id)';
  }

  factory Information.fromMap(Map<String, dynamic> data) => Information(
        url: data['url'] as String?,
        title: data['title'] as String?,
        id: data['id'] as String?,
        description: (data['description'] as List<dynamic>?)
            ?.map(
              (e) => e.toString(),
            )
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'url': url,
        'id': id,
        'description': description,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Information].
  factory Information.fromJson(String data) {
    return Information.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Information] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Information) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ url.hashCode ^ description.hashCode;
}
