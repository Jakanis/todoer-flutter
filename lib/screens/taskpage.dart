import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';

class TaskPage extends StatefulWidget {
  Task task;

  TaskPage({required this.task, Key? key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState(task);
}

class _TaskPageState extends State<TaskPage> {
  Task task;
  String? body;
  String? title;

  _TaskPageState(this.task);

  void permitSave() {
    bool update = false;
    if (body != null && body!=task.body) {
      task.body=body;
      update=true;
    }
    if (title != null && body!=task.title) {
      task.title=title;
      update=true;
    }
    if (update) {
      setState(() {
        Task.saveTask(task);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          permitSave();
          return Future.value(true);
        },
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(18),
                      child: GestureDetector(
                        onTap: () {
                          permitSave();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: task.title,
                        decoration: InputDecoration(
                          hintText: 'Enter task title',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                        onChanged: (val) => title = val,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: task.body,
                    decoration: InputDecoration(
                      hintText: 'Enter task body',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (val) => body = val,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
