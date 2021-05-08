import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/to_do_observer.dart';

import 'home_layout.dart';



void main() {

  Bloc.observer = ToDoObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: HomeLayout(),
    );
  }
}
