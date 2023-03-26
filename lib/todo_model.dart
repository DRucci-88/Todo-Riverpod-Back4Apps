import 'dart:convert';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TodoModel {
  final String objectId;
  final String title;
  final bool done;

  const TodoModel({
    required this.objectId,
    required this.title,
    required this.done,
  });

  factory TodoModel.fromParseObject(ParseObject parseObject) {
    return TodoModel(
      objectId: parseObject.get<String>('objectId')!,
      title: parseObject.get<String>('title')!,
      done: parseObject.get<bool>('done')!,
    );
  }

  TodoModel copyWith({
    String? objectId,
    String? title,
    bool? done,
  }) {
    return TodoModel(
      objectId: objectId ?? this.objectId,
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'done': done,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      objectId: map['objectId'] as String,
      title: map['title'] as String,
      done: map['done'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TodoModel(title: $title, done: $done)';

  @override
  bool operator ==(covariant TodoModel other) {
    if (identical(this, other)) return true;

    return other.title == title && other.done == done;
  }

  @override
  int get hashCode => title.hashCode ^ done.hashCode;
}
