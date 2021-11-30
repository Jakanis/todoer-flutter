import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/screens/taskpage.dart';
import 'package:todo_app/widgets/taskcard.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pullRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            color: Colors.white30,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingWidget(),
                    Expanded(
                      child: FutureBuilder<List<Task>>(
                        future: Task.getAllTasks(),
                        builder: (context, content) {
                          if (content.hasData) {
                            return RefreshIndicator(
                              onRefresh: () => _pullRefresh(),
                              child: ListView.builder(
                                itemCount: content.data!.length,
                                itemBuilder: (context, index) {
                                  Task task = content.data![index];
                                  return TaskCardWidget(
                                      task: Task(
                                    id: task.id,
                                    title: task.title,
                                    who: task.who,
                                    body: task.body,
                                  ));
                                },
                              ),
                            );
                          } else if (content.hasError) {
                            return Text('${content.error}');
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskPage(task: Task())),
            );
          },
          tooltip: 'Add task',
          child: const Icon(Icons.add),
        ));
  }
}

class HeadingWidget extends StatelessWidget {
  const HeadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Row(
        children: [
          Image(
            image: AssetImage('assets/images/Icon-192.png'),
            width: 50,
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              "THE TASKER APP",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.lightBlue),
            ),
          )
        ],
      ),
    );
  }
}
