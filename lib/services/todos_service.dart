import 'dart:convert';
import 'dart:io';

import 'package:flutter_todo_demo/models/api_status.dart';
import 'package:http/http.dart' as http;

class TodosService {
  static const String host = 'http://localhost:3000/todos';

  // Get all ongoing todos
  static Future<Object> getOngoingTodos() async {
    try {
      var urlPath = '$host/getOngoing';
      var url = Uri.parse(urlPath);

      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return Success(resBodyJSON: jsonEncode(data['result']));
      }

      // In case of failure
      return Failure(code: 403, errorResponse: '403 Forbidden Access');
    } on HttpException {
      return Failure(code: 101, errorResponse: 'No Internet Access');
    } on FormatException {
      return Failure(code: 102, errorResponse: 'Invalid Format');
    } catch (exception) {
      return Failure(code: 103, errorResponse: exception.toString());
    }
  }

  // Get completed todos (history)
  static Future<Object> getCompletedTodos() async {
    try {
      var urlPath = '$host/getCompleted';
      var url = Uri.parse(urlPath);

      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return Success(resBodyJSON: jsonEncode(data['result']));
      }

      // In case of failure
      return Failure(code: 403, errorResponse: '403 Forbidden Access');
    } on HttpException {
      return Failure(code: 101, errorResponse: 'No Internet Access');
    } on FormatException {
      return Failure(code: 102, errorResponse: 'Invalid Format');
    } catch (exception) {
      return Failure(code: 103, errorResponse: exception.toString());
    }
  }

  // Get todos of the day
  static Future<Object> getTodosOfTheDay() async {
    try {
      var url = Uri.parse('$host/todosOfTheDay');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return Success(resBodyJSON: jsonEncode(data['result']));
      }

      // In case of failure
      return Failure(code: 403, errorResponse: '403 Forbidden Access');
    } on HttpException {
      return Failure(code: 101, errorResponse: 'No Internet Access');
    } on FormatException {
      return Failure(code: 102, errorResponse: 'Invalid Format');
    } catch (exception) {
      return Failure(code: 103, errorResponse: exception.toString());
    }
  }

  // Complete todos
  static Future<Object> completeTodoById(String todoId) async {
    try {
      var url = Uri.parse('$host/$todoId/complete');
      var response = await http.put(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return Success(resBodyJSON: jsonEncode(data['result']));
      }

      // In case of failure
      return Failure(code: 403, errorResponse: '403 Forbidden Access');
    } on HttpException {
      return Failure(code: 101, errorResponse: 'No Internet Access');
    } on FormatException {
      return Failure(code: 102, errorResponse: 'Invalid Format');
    } catch (exception) {
      return Failure(code: 103, errorResponse: exception.toString());
    }
  }

  // Remove todos
  static Future<Object> removeTodosById(String todoId) async {
    try {
      var url = Uri.parse('$host/$todoId');
      var response = await http.delete(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return Success(resBodyJSON: jsonEncode(data['result']));
      }

      // In case of failure
      return Failure(code: 403, errorResponse: '403 Forbidden Access');
    } on HttpException {
      return Failure(code: 101, errorResponse: 'No Internet Access');
    } on FormatException {
      return Failure(code: 102, errorResponse: 'Invalid Format');
    } catch (exception) {
      return Failure(code: 103, errorResponse: exception.toString());
    }
  }

  // Update todo by id
  static Future<Object> updateTodoById(
      String todoToUpdateJson, String todoId) async {
    try {
      var url = Uri.parse('$host/$todoId');
      var response = await http.put(url,
          body: todoToUpdateJson,
          headers: {'Content-type': 'application/json'});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return Success(resBodyJSON: jsonEncode(data['result']));
      }

      // In case of failure
      return Failure(code: 403, errorResponse: '403 Forbidden Access');
    } on HttpException {
      return Failure(code: 101, errorResponse: 'No Internet Access');
    } on FormatException {
      return Failure(code: 102, errorResponse: 'Invalid Format');
    } catch (exception) {
      return Failure(code: 103, errorResponse: exception.toString());
    }
  }

  // Create new todo
  static Future<Object> createTodo(String todoToCreateJson) async {
    try {
      var url = Uri.parse(host);
      var response = await http.post(url,
          body: todoToCreateJson,
          headers: {'Content-type': 'application/json'});

      if (response.statusCode == 201) {
        Map<String, dynamic> data = json.decode(response.body);
        return Success(resBodyJSON: jsonEncode(data['result']));
      }

      // In case of failure
      return Failure(code: 403, errorResponse: '403 Forbidden Access');
    } on HttpException {
      return Failure(code: 101, errorResponse: 'No Internet Access');
    } on FormatException {
      return Failure(code: 102, errorResponse: 'Invalid Format');
    } catch (exception) {
      return Failure(code: 103, errorResponse: exception.toString());
    }
  }
}
