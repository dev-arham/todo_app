class ProjectModel {
  String? id;
  String? name;

  ProjectModel({this.id, this.name});

  ProjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}