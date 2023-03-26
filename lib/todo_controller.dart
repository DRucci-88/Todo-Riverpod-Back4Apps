import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parse_learning/todo_model.dart';
import 'package:parse_learning/todo_repository.dart';

final todoControllerProvider =
    StateNotifierProvider<TodoController, List<TodoModel>>((ref) {
  final todoRepository = ref.watch(todoRepositoryProvider);
  return TodoController(todoRepository: todoRepository);
});

/// Gak jadi di pake
final getTodosProvider = FutureProvider<List<TodoModel>>((ref) {
  return ref.watch(todoControllerProvider);
});

class TodoController extends StateNotifier<List<TodoModel>> {
  final TodoRepository todoRepository;

  TodoController({required this.todoRepository}) : super([]);

  Future<bool> addTodo(String text) async {
    debugPrint('todo - controller - addTodo');
    final res = await todoRepository.add(text);
    if (!res.success || res.results == null) {
      return false;
    }
    final todo = TodoModel.fromParseObject(res.results![0]);

    state = [...state, todo];

    return true;
  }

  Future<bool> getTodos() async {
    debugPrint('todo - controller - getTodos');
    final res = await todoRepository.get();
    if (res.isEmpty) {
      return false;
    }

    final List<TodoModel> todos =
        res.map((e) => TodoModel.fromParseObject(e)).toList();
    state = todos;
    return true;
  }

  Future<bool> updateTodo(String objectId, bool done) async {
    debugPrint('todo - controller - update');
    final res = await todoRepository.update(objectId, done);
    if (!res.success || res.results == null) {
      return false;
    }
    final idx = state.indexWhere((element) => element.objectId == objectId);
    final todos = state;
    todos[idx] = state[idx].copyWith(done: done);
    state = todos.toList();

    return true;
  }

  Future<bool> deleteTodo(String objectId) async {
    debugPrint('todo - controller - delete');
    final res = await todoRepository.delete(objectId);
    if (!res.success || res.results == null) {
      return false;
    }
    state = state.where((e) => e.objectId != objectId).toList();
    return true;
  }
}
