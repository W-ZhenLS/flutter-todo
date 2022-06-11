import 'package:flutter/material.dart';
import 'package:flutter_todo_demo/view_models/todos_view_model.dart';
import 'package:flutter_todo_demo/views/todos_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodosViewModel())
      ],
      child: MaterialApp(
        title: 'Todo Web App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.brown
        ),
        routes: {
          '/': (context) => const TodosView()
        },
      ),
    );
  }
}