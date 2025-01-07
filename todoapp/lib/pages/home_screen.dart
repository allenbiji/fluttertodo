import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';
import '../services/api_service.dart';
import '../widgets/todo_item.dart';
import 'add_todo_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _token;
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchTodos();
  }

  Future<void> _loadTokenAndFetchTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    if (storedToken == null) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return;
    }
    setState(() {
      _token = storedToken;
    });
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    if (_token == null) return;
    try {
      final responseList = await ApiService.fetchTodos(_token!);
      setState(() {
        todos = responseList.map<Todo>((item) => Todo.fromJson(item)).toList();
      });
    } catch (e) {
      print('Error fetching todos: $e');
    }
  }

  void addTodo(String title) async {
    if (_token == null) return;
    try {
      final newTodoMap = await ApiService.createTodo(_token!, title);
      setState(() {
        todos.insert(0, Todo.fromJson(newTodoMap));
      });
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  void toggleTodoCompletion(String id) async {
    final index = todos.indexWhere((t) => t.id == id);
    if (index == -1 || _token == null) return;
    final currentTodo = todos[index];
    final updated = currentTodo.toggleCompletion();
    try {
      final updatedTodoMap =
          await ApiService.updateTodo(_token!, id, updated.isCompleted);
      setState(() {
        todos[index] = Todo.fromJson(updatedTodoMap);
      });
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  void deleteTodo(String id) async {
    if (_token == null) return;
    try {
      await ApiService.deleteTodo(_token!, id);
      setState(() {
        todos.removeWhere((t) => t.id == id);
      });
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchTodos,
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return TodoItem(
              todo: todos[index],
              onToggle: toggleTodoCompletion,
              onDelete: deleteTodo,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddTodoScreen(onAdd: addTodo),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
