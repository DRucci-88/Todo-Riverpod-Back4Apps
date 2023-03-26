import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

final todoRepositoryProvider = Provider((ref) {
  final todo = ParseObject(TodoRepository.todoClassName);
  return TodoRepository(todo: todo);
});

class TodoRepository {
  static const todoClassName = 'Todo';

  final ParseObject todo;

  TodoRepository({
    required this.todo,
  });

  Future<ParseResponse> add(String text) {
    todo.set('title', text);
    todo.set('done', true);
    return todo.save();
  }

  Future<List<ParseObject>> get() async {
    final queryTodo = QueryBuilder(todo);
    final ParseResponse apiResponse = await queryTodo.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    }
    return [];
  }

  Future<ParseResponse> update(String objectId, bool done) {
    todo
      ..objectId = objectId
      ..set('done', done);
    return todo.save();
  }

  Future<ParseResponse> delete(String objectId) {
    todo.objectId = objectId;
    return todo.delete();
  }
}
