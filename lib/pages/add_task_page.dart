import 'package:flutter/material.dart';
import 'package:todo_app/services/api_services.dart';

class AddTaskPage extends StatefulWidget {
  final bool updateTask;
  final String? titleText;
  final String? descText;
  final String? taskID;
  final int? priority;
  const AddTaskPage({
    super.key,
    this.updateTask = false,
    this.descText,
    this.titleText,
    this.taskID,
    this.priority,
  });

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int? selectedFilterPriority;

  @override
  void initState() {
    if (widget.updateTask) {
      titleController.text = "${widget.titleText}";
      descriptionController.text = "${widget.descText}";
      selectedFilterPriority = widget.priority;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ApiServices myServices = ApiServices();
    bool isLoading = false;
    FocusNode titleFocus = FocusNode();
    FocusNode descFocus = FocusNode();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined)),
        title: Text(
          widget.updateTask ? "Update Task" : "Add Task",
          style: TextStyle(color: Colors.green.shade600, fontSize: 24),
        ),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green.shade400),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                autofocus: true,
                focusNode: titleFocus,
                onSubmitted: (value) {
                  titleFocus.unfocus();
                  FocusScope.of(context).requestFocus(descFocus);
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Description',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green.shade400),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                focusNode: descFocus,
                onSubmitted: (value) => descFocus.unfocus(),
              ),
              Row(
                children: [
                  DropdownButton<int>(
                    hint: const Text("Select Task Priority",
                        style: TextStyle(color: Colors.black)),
                    value: selectedFilterPriority,
                    menuWidth: double.infinity,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.green.shade400,
                    ),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text("Low")),
                      DropdownMenuItem(value: 2, child: Text("Medium")),
                      DropdownMenuItem(value: 3, child: Text("High")),
                      DropdownMenuItem(value: 4, child: Text("Urgent")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedFilterPriority = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              isLoading
                  // ignore: dead_code
                  ? const CircularProgressIndicator()
                  : MaterialButton(
                      minWidth: double.infinity,
                      onPressed: () async {
                        if (titleController.text.isNotEmpty &&
                            descriptionController.text.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });
                          widget.updateTask
                              ? await myServices.updateTask(
                                  id: widget.taskID,
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  priority: selectedFilterPriority!,
                                  context: context)
                              : await myServices.addTask(
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  priority: selectedFilterPriority!,
                                  context: context);
                          setState(() {
                            titleController.clear();
                            descriptionController.clear();
                            isLoading = false;
                          });
                          if (context.mounted) {
                            Navigator.of(context).pop(true);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please fill all the fields",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      color: Colors.green.shade400,
                      textColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Text(
                        widget.updateTask ? "Update Task" : 'Add Task',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
