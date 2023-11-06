import 'package:dio/dio.dart';
import 'package:to_do_test/model/tasks_model.dart';

class ApiService {
  static Dio dioClient = Dio();

  static initDioClient() async {
    var _dio = Dio();
    _dio.options.connectTimeout = Duration(seconds: 30000);
    _dio.options.receiveTimeout = Duration(seconds: 30000);
    _dio.options.responseType = ResponseType.json;
    _dio.interceptors.clear();

    dioClient = _dio;
  }

  static Future<TasksModel> getTasks(
      {int? offset,
      int? limit,
      String? sortBy,
      bool? isAsc,
      String? status}) async {
    final serviceRes = await dioClient.get(
        'https://todo-list-api-mfchjooefq-as.a.run.app/todo-list?offset=$offset&limit=$limit&sortBy=$sortBy&isAsc=$isAsc&status=$status');

    if (serviceRes.statusCode == 200) {
      var result = TasksModel.fromJson(serviceRes.data);
      return result;
    } else {
      throw Exception('Failed to load service');
    }
  }
}
