class TaskModel {
  String? id;
  String? content;
  String? description;
  bool? isCompleted;
  int? priority;

  TaskModel(
      {this.id,
      this.content,
      this.description,
      this.isCompleted,
      this.priority});

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    description = json['description'];
    isCompleted = json['is_completed'];
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['content'] = content;
    data['description'] = description;
    data['is_completed'] = isCompleted;
    return data;
  }
}

class CompletedTaskModel {
  List<Items>? items;

  CompletedTaskModel({this.items});

  CompletedTaskModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }
}

class Items {
  String? content;
  String? taskId;

  Items({this.content, this.taskId});

  Items.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    taskId = json['task_id'];
  }
}
