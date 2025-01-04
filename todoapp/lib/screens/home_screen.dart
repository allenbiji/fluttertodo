import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';
import 'add_todo_screen.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({key? key}) : super(key: key)

  @override
  State<HomeScreen> createState() => _HomeScreenState(); 
}

class _HomeScreenState extends State<HomeScreen>{
  List<Todo> todos = [];

  void addtodo(String name){
    setState(() {
      todos.add(Todo(
        id: DateTime.now().toString(),
        name: name,
      ));
    });
  }

  void todoToggleCompletion(String id){
    setState(() {
      todos.map((todo) {
        return todo.id == id ? todo.toggleCompletion() : todo;
      }).toList();
    });
  }

  void removeTodo(String id){
    setState(() {
      todos.removeWhere((todo) => todo.id == id);
    });
  }

  
}