import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parse_learning/todo_controller.dart';

class TodoRiverpodApp extends ConsumerStatefulWidget {
  const TodoRiverpodApp({super.key});

  @override
  ConsumerState<TodoRiverpodApp> createState() => _TodoRiverpodAppState();
}

class _TodoRiverpodAppState extends ConsumerState<TodoRiverpodApp> {
  final _todoCtl = TextEditingController();

  @override
  void initState() {
    ref.read(todoControllerProvider.notifier).getTodos();
    super.initState();
  }

  @override
  void dispose() {
    _todoCtl.dispose();
    super.dispose();
  }

  void addTodo() {
    if (_todoCtl.text.trim().isNotEmpty) {
      ref.read(todoControllerProvider.notifier).addTodo(_todoCtl.text.trim());
      _todoCtl.clear();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Empty title"),
      duration: Duration(seconds: 1),
    ));
  }

  void updateTodo(String objectId, bool done) async {
    await ref.read(todoControllerProvider.notifier).updateTodo(objectId, done);
  }

  void deleteTodo(String objectId) async {
    await ref.read(todoControllerProvider.notifier).deleteTodo(objectId);
  }

  @override
  Widget build(BuildContext context) {
    final getTodos = ref.watch(todoControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Parse Todo List"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    autocorrect: true,
                    textCapitalization: TextCapitalization.sentences,
                    controller: _todoCtl,
                    decoration: const InputDecoration(
                        labelText: "New todo",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: addTodo,
                  child: const Text("ADD"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: getTodos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(getTodos[index].title),
                  leading: CircleAvatar(
                    backgroundColor:
                        getTodos[index].done ? Colors.green : Colors.blue,
                    foregroundColor: Colors.white,
                    child:
                        Icon(getTodos[index].done ? Icons.check : Icons.error),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                          value: getTodos[index].done,
                          onChanged: (value) async {
                            updateTodo(getTodos[index].objectId, value!);
                          }),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.blue,
                        ),
                        onPressed: () async {
                          deleteTodo(getTodos[index].objectId);
                          // const snackBar = SnackBar(
                          //   content: Text("Todo deleted!"),
                          //   duration: Duration(seconds: 2),
                          // );
                          // ScaffoldMessenger.of(context)
                          //   ..removeCurrentSnackBar()
                          //   ..showSnackBar(snackBar);
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          // Expanded(
          //   child: ref.watch(getTodosProvider).when(
          //     data: (data) {
          //       return ListView.builder(
          //         padding: const EdgeInsets.only(top: 10.0),
          //         itemCount: data.length,
          //         itemBuilder: (context, index) {
          //           return ListTile(
          //             title: Text(data[index].title),
          //             leading: CircleAvatar(
          //               backgroundColor:
          //                   data[index].done ? Colors.green : Colors.blue,
          //               foregroundColor: Colors.white,
          //               child:
          //                   Icon(data[index].done ? Icons.check : Icons.error),
          //             ),
          //             trailing: Row(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 Checkbox(
          //                     value: data[index].done,
          //                     onChanged: (value) async {
          //                       updateTodo(data[index].objectId, value!);
          //                     }),
          //                 IconButton(
          //                   icon: const Icon(
          //                     Icons.delete,
          //                     color: Colors.blue,
          //                   ),
          //                   onPressed: () async {
          //                     deleteTodo(data[index].objectId);
          //                     // const snackBar = SnackBar(
          //                     //   content: Text("Todo deleted!"),
          //                     //   duration: Duration(seconds: 2),
          //                     // );
          //                     // ScaffoldMessenger.of(context)
          //                     //   ..removeCurrentSnackBar()
          //                     //   ..showSnackBar(snackBar);
          //                   },
          //                 )
          //               ],
          //             ),
          //           );
          //         },
          //       );
          //     },
          //     error: (error, stackTrace) {
          //       return const Center(
          //         child: Text("Error..."),
          //       );
          //     },
          //     loading: () {
          //       return const Center(
          //         child: SizedBox(
          //             width: 100,
          //             height: 100,
          //             child: CircularProgressIndicator()),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
