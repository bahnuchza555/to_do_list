class TaskModel {
  String? id;
  String? title;
  String? description;
  DateTime? createdAt;
  String? status;

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.status,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "createdAt": createdAt?.toIso8601String(),
    "status": status,
  };
}