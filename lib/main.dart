import 'package:flutter/material.dart';
import 'package:parse_learning/my_home_page.dart';
import 'package:parse_learning/todo_app.dart';
import 'package:parse_learning/todo_riverpod_app.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = '9byfRQirTEdsBSRxjvEz7771CZAwH5tvROSKgci7';
  const keyClientKey = 'sYGxu5fWpiWsX8jA56oZYbqYJRJEbaJFS7iTJ8LS';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
    debug: true,
  );

  // ParseObject firstObject = ParseObject('FirstClass')
  //   ..set('message', 'Hey first message. Parse is now connected');
  // // firstObject.f
  // await firstObject.save();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoRiverpodApp(),
      // home: const TodoApp(),
      // home: const MyHomePage(),
    );
  }
}
