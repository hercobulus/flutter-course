  import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/models/todo.dart';

const todoListKey = 'todo_list';

class TodoRepository {

  late SharedPreferences sharedPreferences;

  void saveTodoList(List<Todo> todos){
    final jsonString = json.encode(todos);
    sharedPreferences.setString(todoListKey, jsonString);
  }

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String todoString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List jsonDecoded = json.decode(todoString) as List;

    final List<Todo> todos = jsonDecoded.map((e) => Todo.fromJson(e)).toList();
    return todos;
  }

}