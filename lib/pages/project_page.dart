import 'package:flutter/material.dart';
import 'package:todo_app/services/api_services.dart';

import '../models/task_model.dart';
import 'add_task_page.dart';
import 'task_details_page.dart';

class ProjectPage extends StatefulWidget {
  final String? title, id;

  const ProjectPage({super.key, this.title, this.id});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  ApiServices myServices = ApiServices();

  String capitalize({required String text}) {
    return "${text[0].toUpperCase()}${text.substring(1)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined)),
        title: Text(
          "${widget.title}",
          style: TextStyle(color: Colors.green.shade600, fontSize: 24),
        ),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            FutureBuilder(
                future: myServices.getTasksByProject(id: widget.id),
                builder: (context, AsyncSnapshot<List<TaskModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.green.shade400,
                    ));
                  }
                  // ignore: unrelated_type_equality_checks
                  else if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              InkWell(
                                onTap: () async {
                                  final bool shouldRefresh = await Navigator.of(
                                          context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => TaskDetailsPage(
                                                titleText: snapshot
                                                    .data?[index].content,
                                                descText: snapshot
                                                    .data?[index].description,
                                                taskID:
                                                    snapshot.data?[index].id,
                                              )));
                                  if (shouldRefresh) {
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.all(14),
                                  margin: const EdgeInsets.all(7),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        capitalize(
                                            text:
                                                "${snapshot.data?[index].content}"),
                                        style: TextStyle(
                                          color: Colors.green.shade600,
                                          fontSize: 20,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 6,
                                        width: double.infinity,
                                      ),
                                      Text(
                                        "${snapshot.data?[index].description}",
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  alignment: const Alignment(0.9, -0.9),
                                  child: PopupMenuButton(
                                      onSelected: (value) async {
                                    if (value == 'edit') {
                                      bool shouldRefresh = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddTaskPage(
                                                    updateTask: true,
                                                    taskID: snapshot
                                                        .data?[index].id,
                                                    titleText: snapshot
                                                        .data?[index].content,
                                                    descText: snapshot
                                                        .data?[index]
                                                        .description,
                                                  )));
                                      if (shouldRefresh) {
                                        setState(() {});
                                      }
                                    } else if (value == 'delete') {
                                      await myServices.deleteTask(
                                          id: snapshot.data?[index].id,
                                          context: context);
                                      setState(() {});
                                    }
                                  }, itemBuilder: (context) {
                                    return [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ];
                                  })),
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                        child:
                            Text("No Tasks available, try adding something"));
                  }
                }),
          ],
        ),
      ),
    );
  }
}
