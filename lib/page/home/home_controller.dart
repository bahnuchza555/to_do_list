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
  List<TaskModel> tasks = [];
  bool isFirstLoad = true;
  bool nextPage = false;
  bool isLoadMore = false;
  int offset = 0;
  late ScrollController scrollController;
  List<DateTime> dateList = [];

  onDelete(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }

  loadData(String status, {bool? isReset, int limit = 20}) async {
    if (isReset == true) {
      tasks = [];
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
        temp.tasks?.sort((a, b) => a.id!.compareTo(b.id!));
        tasks.addAll(temp.tasks?.reversed ?? []);
        // tasks.reversed.forEach((element) {
        //   var date = DateFormat('dd MMM yyyy').format(element.createdAt!);
        //   dateList.add(DateTime.parse(date));
        // });
        // dateList.sort((a, b) => a.compareTo(b));
        offset += 1;
      }
    } catch (error) {
      log(error.toString());
    }
    notifyListeners();
  }
}
