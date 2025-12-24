import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoProvider extends ChangeNotifier {
  final List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  TodoProvider() {
    loadTodos();
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todoString = prefs.getString('todos');

    if (todoString != null) {
      final List decoded = jsonDecode(todoString);
      _todos.clear();
      _todos.addAll(
        decoded.map((e) => Todo.fromJson(e)).toList(),
      );
      notifyListeners();
    }
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String todoString =
        jsonEncode(_todos.map((e) => e.toJson()).toList());
    await prefs.setString('todos', todoString);
  }

  void addTodo(String title) {
    _todos.add(Todo(title: title));
    saveTodos();
    notifyListeners();
  }

  void toggleTodo(int index) {
    _todos[index].isDone = !_todos[index].isDone;
    saveTodos();
    notifyListeners();
  }

  void removeTodo(int index) {
    _todos.removeAt(index);
    saveTodos();
    notifyListeners();
  }
}
