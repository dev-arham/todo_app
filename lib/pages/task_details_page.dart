import 'package:flutter/material.dart';
import 'package:todo_app/services/api_services.dart';

import 'add_task_page.dart';

class TaskDetailsPage extends StatelessWidget {
  final String? titleText;
  final String? descText;
  final String? taskID;
  final int? priority;
  const TaskDetailsPage(
      {super.key, this.descText, this.titleText, this.taskID, this.priority});

  @override
  Widget build(BuildContext context) {
    ApiServices myServices = ApiServices();

    String capitalize({required String text}) {
      return "${text[0].toUpperCase()}${text.substring(1)}";
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined)),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddTaskPage(
                            updateTask: true,
                            taskID: taskID,
                            titleText: titleText,
                            descText: descText,
                            priority: priority,
                          )));
            },
            icon: const Icon(
              Icons.edit_note_outlined,
              color: Colors.black,
              size: 30,
            ),
            style:
                IconButton.styleFrom(backgroundColor: Colors.yellow.shade400),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () async {
              await myServices.deleteTask(id: taskID, context: context);
              if (context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
            icon: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.black,
              size: 30,
            ),
            style: IconButton.styleFrom(backgroundColor: Colors.red.shade400),
          ),
        ],
        toolbarHeight: 80,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              capitalize(text: "$titleText"),
              style: TextStyle(color: Colors.green.shade400, fontSize: 50),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10)),
              child: Text(
                "Priority $priority",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "$descText",
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
      )),
    );
  }
}
