import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/models/project_model.dart';
import 'package:todo_app/models/task_model.dart';
import 'api_key.dart';

class ApiServices {
  Future<List<TaskModel>> getTasks() async {
    List<TaskModel> tasks = [];
    final url = Uri.parse("https://api.todoist.com/rest/v2/tasks");
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $myAPIKey"
    });
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (var element in responseBody) {
        tasks.add(TaskModel.fromJson(element));
      }
      return tasks;
    } else {
      throw Exception("Failed to load tasks");
    }
  }

  addTask(
      {required String title,
      required String description,
      required int priority,
      required BuildContext context}) async {
    var body = jsonEncode({
      "content": title,
      "description": description,
      "priority": priority,
    });
    final url = Uri.parse("https://api.todoist.com/rest/v2/tasks");
    final response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $myAPIKey",
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Task added successfully",
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Unable to add task",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  updateTask(
      {required String? id,
      required String title,
      required String description,
      required int priority,
      required BuildContext context}) async {
    var body = jsonEncode({
      "content": title,
      "description": description,
      "priority": priority,
    });
    final url = Uri.parse("https://api.todoist.com/rest/v2/tasks/$id");
    final response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $myAPIKey",
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Task updated successfully",
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Unable to update task",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  deleteTask({required String? id, required BuildContext context}) async {
    var url = Uri.parse("https://api.todoist.com/rest/v2/tasks/$id");
    var response =
        await http.delete(url, headers: {"Authorization": "Bearer $myAPIKey"});
    if (response.statusCode == 204) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Task deleted successfully",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Unable to delete task",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.yellow,
          ),
        );
      }
    }
  }

  Future<List<ProjectModel>> getProjects() async {
    List<ProjectModel> tasks = [];
    final url = Uri.parse("https://api.todoist.com/rest/v2/projects");
    final response =
        await http.get(url, headers: {"Authorization": "Bearer $myAPIKey"});
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (var element in responseBody) {
        tasks.add(ProjectModel.fromJson(element));
      }
      return tasks;
    } else {
      throw Exception("Failed to load tasks");
    }
  }

  Future<List<TaskModel>> getTasksByProject({required String? id}) async {
    List<TaskModel> tasks = [];
    final url =
        Uri.parse("https://api.todoist.com/rest/v2/tasks?project_id=$id");
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $myAPIKey"
    });
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (var element in responseBody) {
        tasks.add(TaskModel.fromJson(element));
      }
      return tasks;
    } else {
      throw Exception("Failed to load tasks");
    }
  }
}
