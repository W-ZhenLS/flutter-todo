import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo_demo/models/todoToCreate_model.dart';
import 'package:flutter_todo_demo/models/todo_model.dart';
import 'package:flutter_todo_demo/services/todos_service.dart';

import '../models/api_status.dart';
import '../models/todoToUpdate_model.dart';

class TodosViewModel extends ChangeNotifier {
  bool _isLoading = false;
  TodoToCreateModel _todoToCreate = TodoToCreateModel();
  TodoToUpdateModel _todoToUpdate = TodoToUpdateModel();
  List<TodosModel> _ongoingTodosList = [];
  List<TodosModel> _todosOfTheDay = [];
  List<TodosModel> _completedTodos = [];

  // Getter
  bool get isLoading => _isLoading;
  TodoToCreateModel get todoToCreate => _todoToCreate;
  TodoToUpdateModel get todoToUpdate => _todoToUpdate;
  List<TodosModel> get todoList => _ongoingTodosList;
  List<TodosModel> get todosOfTheDay => _todosOfTheDay;
  List<TodosModel> get completedTodos => _completedTodos;

  // Setter
  setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  setTodoToCreate(TodoToCreateModel todoToCreate) {
    _todoToCreate = todoToCreate;
  }

  setTodoToUpdate(TodoToUpdateModel todoToUpdate) {
    _todoToUpdate = todoToUpdate;
  }

  setTodoList(List<TodosModel> todosList) {
    _ongoingTodosList = todosList;
  }

  setTodosOfTheDay(List<TodosModel> todosOfTheDay) {
    _todosOfTheDay = todosOfTheDay;
  }

  setCompletedTodos(List<TodosModel> completedTodos) {
    _completedTodos = completedTodos;
  }

  // Constructor
  TodosViewModel() {
    getOngoingTodos();
    getTodosOfTheDay();
    getCompletedTodos();
  }

  // Get ongoing todos
  getOngoingTodos() async {
    setIsLoading(true);

    var response = await TodosService.getOngoingTodos();

    if (response is Success) {
      List ongoingTodosListObj = json.decode(response.resBodyJSON);
      List<TodosModel> ongoingTodos = [];

      for (var i = 0; i < ongoingTodosListObj.length; i++) {
        TodosModel todos =
            todoModelFromJson(jsonEncode(ongoingTodosListObj[i]));
        ongoingTodos.add(todos);
      }
      setTodoList(ongoingTodos);
    }

    setIsLoading(false);
  }

  // Get completed todos (history)
  getCompletedTodos() async {
    setIsLoading(true);

    var response = await TodosService.getCompletedTodos();

    if (response is Success) {
      List completedTodosListObj = json.decode(response.resBodyJSON);
      List<TodosModel> completedTodos = [];

      for (var i = 0; i < completedTodosListObj.length; i++) {
        TodosModel todos = todoModelFromJson(jsonEncode(completedTodosListObj[i]));
        completedTodos.add(todos);        
      }
      setCompletedTodos(completedTodos);
    }

    setIsLoading(false);
  }

  // Get todos of the day
  getTodosOfTheDay() async {
    setIsLoading(true);

    var response = await TodosService.getTodosOfTheDay();

    if (response is Success) {
      List todosListObj = json.decode(response.resBodyJSON);
      List<TodosModel> todosOfTheDay = [];

      for (var i = 0; i < todosListObj.length; i++) {
        TodosModel todos = todoModelFromJson(jsonEncode(todosListObj[i]));
        todosOfTheDay.add(todos);
      }
      setTodosOfTheDay(todosOfTheDay);
    }

    setIsLoading(false);
  }

  // Complete todos
  completeTodoById(String todoId) async {
    setIsLoading(true);

    var response = await TodosService.completeTodoById(todoId);
    if (response is Success) {
      setIsLoading(false);
      return true;
    }

    setIsLoading(false);
    return false;
  }

  // Remove todos
  removeTodoById(String todoId) async {
    setIsLoading(true);

    var response = await TodosService.removeTodosById(todoId);
    if (response is Success) {
      setIsLoading(false);
      return true;
    }
    setIsLoading(false);
    return false;
  }

  // Update todos
  updateTodoById(String todoId) async {
    setIsLoading(true);
    var todoToUpdateJson = todoToUpdateModelToJson(_todoToUpdate);
    var response = await TodosService.updateTodoById(todoToUpdateJson, todoId);

    if (response is Success) {
      setIsLoading(false);
      return true;
    }
    setIsLoading(false);
    return false;
  }

  // Create todo
  createTodo() async {
    setIsLoading(true);
    var todoToCreateJson = todoToCreateModelToJson(_todoToCreate);
    var response = await TodosService.createTodo(todoToCreateJson);

    if (response is Success) {
      setIsLoading(false);
      return true;
    }
    setIsLoading(false);
    return false;
  }
}
