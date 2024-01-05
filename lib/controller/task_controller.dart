import 'package:get/get.dart';
import 'package:to_do_app_3/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  final taskList = <Task>[].obs;

  addTask({required Task task})
  {
    return DBHelper.insert(task);
  }

  Future<void> getTasks() async{
    final List<Map<String,dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }
  void deleteTasks(Task task) async{
    await DBHelper.delete(task);
    getTasks();
  }
  void deleteAllTasks() async
  {
    await DBHelper.deleteAll();
    getTasks();
  }

  void updateTasks(int id) async{
    await DBHelper.update(id);
    getTasks();
  }

}
