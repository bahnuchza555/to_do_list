import 'dart:convert';

import 'package:to_do_test/model/task_model.dart';

// Tasks tasksFromJson(String str) => Tasks.fromJson(json.decode(str));
//
// String tasksToJson(Tasks data) => json.encode(data.toJson());

class TasksModel {
  List<TaskModel>? tasks;
  int? pageNumber;
  int? totalPages;

  TasksModel({
    this.tasks,
    this.pageNumber,
    this.totalPages,
  });

  factory TasksModel.fromJson(Map<String, dynamic> json) => TasksModel(
        tasks: json["tasks"] == null
            ? []
            : List<TaskModel>.from(
                json["tasks"]!.map((x) => TaskModel.fromJson(x))),
        pageNumber: json["pageNumber"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "tasks": tasks == null
            ? []
            : List<dynamic>.from(tasks!.map((x) => x.toJson())),
        "pageNumber": pageNumber,
        "totalPages": totalPages,
      };
}
