import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_test/model/task_model.dart';
import 'package:to_do_test/service/api_service.dart';

class HomeController extends ChangeNotifier {
  HomeController(this.context) {
    scrollController = ScrollController();
    loadData('TODO');
  }

  final BuildContext context;
  Map<String, List<TaskModel>>? tasks = {};
  bool isLoadMore = false;
  int offset = 0;
  late ScrollController scrollController;

  onDelete(String key, String taskId) {
    if (tasks?.containsKey(key) == true) {
      tasks?[key]?.removeWhere((element) => element.id == taskId);
      if (tasks?[key]?.isEmpty == true) {
        tasks?.remove(key);
      }
    } else {
      print('is not contains key');
    }
    notifyListeners();
  }

  loadData(String status, {bool? isReset, int limit = 20}) async {
    if (isReset == true) {
      tasks = {};
      offset = 0;
      notifyListeners();
    }
    try {
      var temp = await ApiService.getTasks(
          offset: offset,
          limit: limit,
          sortBy: 'createdAt',
          isAsc: true,
          status: status);

      if (temp.tasks?.isNotEmpty == true) {
        print(temp.tasks?.length);
        temp.tasks?.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

        removeDuplicateTasks(temp.tasks!);

        var newTasks = groupTasksByCreatedAt(temp.tasks!);
        tasks?.addAll(newTasks);

        offset += 1;
      }
    } catch (error) {
      log(error.toString());
    }
    notifyListeners();
  }

  void removeDuplicateTasks(List<TaskModel> tasks) {
    tasks.toSet().toList();
  }

  Map<String, List<TaskModel>> groupTasksByCreatedAt(List<TaskModel> tasks) {
    Map<String, List<TaskModel>> groupedTasks = {};
    for (var task in tasks) {
      var dateFormat = DateFormat('dd MMM yyyy').format(task.createdAt!);
      if (!groupedTasks.containsKey(dateFormat)) {
        groupedTasks[dateFormat] = [];
      }
      groupedTasks[dateFormat]?.add(task);
    }
    return groupedTasks;
  }
}
