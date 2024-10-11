import 'package:flutter/material.dart';
import 'package:todo_app/models/project_model.dart';
import 'package:todo_app/pages/project_page.dart';
import '../models/task_model.dart';
import '../services/api_services.dart';
import 'add_task_page.dart';
import 'task_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TaskModel> tasks = [];
  List<TaskModel> filteredTasks = [];
  int? selectedFilterPriority;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    ApiServices apiServices = ApiServices();
    tasks = await apiServices.getTasks();
    filteredTasks = tasks;
    setState(() {});
  }

  void sortTasksByPriority() {
    if (selectedFilterPriority != null) {
      filteredTasks = tasks
          .where((task) => task.priority == selectedFilterPriority)
          .toList();
    } else {
      filteredTasks = tasks;
    }

    filteredTasks.sort((a, b) => (a.priority ?? 0).compareTo(b.priority ?? 0));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ApiServices myServices = ApiServices();

    String capitalize({required String text}) {
      return "${text[0].toUpperCase()}${text.substring(1)}";
    }

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                  'Projects',
                  style: TextStyle(
                      color: Colors.green.shade600,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FutureBuilder(
                future: myServices.getProjects(),
                builder: (context, AsyncSnapshot<List<ProjectModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.green,
                    ));
                  } else if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!.map((project) {
                        return ListTile(
                          title: Text(
                            "${project.name}",
                            style: const TextStyle(fontSize: 18),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProjectPage(
                                    title: project.name, id: project.id)));
                          },
                        );
                      }).toList(),
                    );
                  } else {
                    return const Center(
                      child: Text("No Projects available"),
                    );
                  }
                }),
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          'My TODOs',
          style: TextStyle(color: Colors.green.shade400, fontSize: 34),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_outlined,
              color: Colors.black,
              size: 28,
            ),
            onPressed: () async {
              final bool shouldRefresh = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddTaskPage()));
              if (shouldRefresh) {
                loadTasks();
              }
            },
            style:
                IconButton.styleFrom(backgroundColor: Colors.yellow.shade400),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  DropdownButton<int>(
                    hint: const Text("Filter by Priority"),
                    value: selectedFilterPriority,
                    underline: Container(
                      height: 2,
                      color: Colors.green.shade400,
                    ),
                    menuWidth: double.infinity,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text("Low")),
                      DropdownMenuItem(value: 2, child: Text("Medium")),
                      DropdownMenuItem(value: 3, child: Text("High")),
                      DropdownMenuItem(value: 4, child: Text("Urgent")),
                      DropdownMenuItem(value: null, child: Text("Show All")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedFilterPriority = value;
                        sortTasksByPriority();
                      });
                    },
                  ),
                ],
              ),
            ),
            tasks.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.green.shade400,
                  ))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return Stack(
                          children: [
                            InkWell(
                              onTap: () async {
                                final bool shouldRefresh = await Navigator.of(
                                        context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => TaskDetailsPage(
                                              titleText: task.content,
                                              descText: task.description,
                                              taskID: task.id,
                                              priority: task.priority,
                                            )));
                                if (shouldRefresh) {
                                  loadTasks();
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        "Priority ${task.priority}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                      width: double.infinity,
                                    ),
                                    Text(
                                      capitalize(
                                          text: task.content ?? 'No title'),
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
                                      task.description ?? 'No description',
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
                                child:
                                    PopupMenuButton(onSelected: (value) async {
                                  if (value == 'edit') {
                                    bool shouldRefresh = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddTaskPage(
                                                  updateTask: true,
                                                  taskID: task.id,
                                                  titleText: task.content,
                                                  descText: task.description,
                                                  priority: task.priority,
                                                )));
                                    if (shouldRefresh) {
                                      loadTasks();
                                    }
                                  } else if (value == 'delete') {
                                    await myServices.deleteTask(
                                        id: task.id, context: context);
                                    loadTasks();
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
                  ),
          ],
        ),
      ),
    );
  }
}
