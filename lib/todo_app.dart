import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<StatefulWidget> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final _todoCtl = TextEditingController();

  final todoClassName = 'Todo';

  void addToDo() async {
    if (_todoCtl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Empty title"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    await saveTodo(_todoCtl.text);
    _todoCtl.clear();
    // setState(() {
    //   _todoCtl.clear();
    // });
  }

  Future<void> saveTodo(String title) async {
    final todo = ParseObject(todoClassName)
      ..set('title', title)
      ..set('done', false);
    final ParseResponse parseResponse = await todo.save();
    debugPrint(parseResponse.toString());
    debugPrint(parseResponse.results.toString());
    debugPrint(parseResponse.statusCode.toString());
    debugPrint(parseResponse.success.toString());

    // await Future.delayed(const Duration(seconds: 1), () {});
  }

  Future<List<ParseObject>> getTodo() async {
    final queryTodo = QueryBuilder(ParseObject(todoClassName));
    final ParseResponse apiResponse = await queryTodo.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    }
    // await Future.delayed(const Duration(seconds: 2), () {});
    return [];
  }

  Future<void> updateTodo(String id, bool done) async {
    final todo = ParseObject(todoClassName)
      ..objectId = id
      ..set('done', done);
    await todo.save();

    // await Future.delayed(const Duration(seconds: 1), () {});
  }

  Future<void> deleteTodo(String id) async {
    final todo = ParseObject(todoClassName)..objectId = id;
    await todo.delete();
    // await Future.delayed(const Duration(seconds: 1), () {});
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: addToDo,
                    child: const Text("ADD"),
                  ),
                ],
              )),
          Expanded(
            child: FutureBuilder<List<ParseObject>>(
              future: getTodo(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator()),
                    );
                  default:
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error..."),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("No Data..."),
                      );
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 10.0),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          //*************************************
                          //Get Parse Object Values
                          final varTodo = snapshot.data![index];
                          final varTitle = varTodo.get<String>('title')!;
                          final varDone = varTodo.get<bool>('done')!;
                          //*************************************

                          return ListTile(
                            title: Text(varTitle),
                            leading: CircleAvatar(
                              backgroundColor:
                                  varDone ? Colors.green : Colors.blue,
                              foregroundColor: Colors.white,
                              child: Icon(varDone ? Icons.check : Icons.error),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                    value: varDone,
                                    onChanged: (value) async {
                                      await updateTodo(
                                          varTodo.objectId!, value!);
                                      // setState(() {
                                      //   //Refresh UI
                                      // });
                                    }),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    await deleteTodo(varTodo.objectId!);
                                    // setState(() {
                                    //   const snackBar = SnackBar(
                                    //     content: Text("Todo deleted!"),
                                    //     duration: Duration(seconds: 2),
                                    //   );
                                    //   ScaffoldMessenger.of(context)
                                    //     ..removeCurrentSnackBar()
                                    //     ..showSnackBar(snackBar);
                                    // });
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
