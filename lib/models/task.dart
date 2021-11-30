import 'dart:convert';

import 'package:http/http.dart' as http;

class Task {
  int? id;
  String? title;
  String? who;
  String? body;

  Task({this.id, this.title, this.who, this.body});

  @override
  String toString() => 'Todo { id: $id, title: $title, who: $who, body: $body }';

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['label'],
      who: json['who'],
      body: json['body'],
    );
  }

  static Future<List<Task>> getAllTasks() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.45:9000/tasks'), headers: {
      "Access-Control-Allow-Origin": "*",
      // Required for CORS support to work
      "Access-Control-Allow-Credentials": 'true',
      // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
          "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      return List<Task>.from(l.map((model) => Task.fromJson(model)));
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  static void addTask(Task task) async {
    print("Adding task: ${task}");
    final response = await http.post(
      Uri.parse('http://192.168.0.45:9000/tasks'),
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
            'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Content-Type": "application/json"
      },
      body: """
      {
        "who": "${task.who}",
        "label": "${task.title}",
        "body": "${task.body}"
      }
      """
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add task');
    }
  }

  static void updateTask(Task task) async {
    print("Updating task: ${task}");
    final response = await http.post(
        Uri.parse('http://192.168.0.45:9000/tasks/${task.id}'),
        headers: {
          "Access-Control-Allow-Origin": "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials":
          'true', // Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS",
          "Content-Type": "application/json"
        },
        body: """
      {
        "who": "${task.who}",
        "label": "${task.title}",
        "body": "${task.body}"
      }
      """
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task(${response.statusCode})');
    }
  }

  static void saveTask(Task task) async {
    print("Saving task: ${task}");
    if (task.who==null || task.who=="") {
      task.who = "Flutter Task App";
    }
    if (task.id == null) {
      addTask(task);
    } else {
      updateTask(task);
    }
  }
}
