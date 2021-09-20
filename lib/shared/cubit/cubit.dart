import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks_app/modules/archive_tasks/archive_tasks_screen.dart';
import 'package:tasks_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:tasks_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:tasks_app/shared/cubit/statless.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentScreen = 0;
  Database? database;
  List<Widget> list_screens = [
    NewTasksScreen(),
    DoneTaskScreen(),
    ArchiveTasksScreen(),
  ];
  List<String> list_titles = [
    'Tasks',
    'Done',
    'Archives',
  ];
  List<Map> tasks_archived = [];
  List<Map> tasks_done = [];
  List<Map> tasks_new = [];

  bool isBottomSheet = false;

  void changeIndex(int index) {
    currentScreen = index;
    emit(AppChangeNavBottomBar());
  }

  void createDataBase() async {
    database = await openDatabase('todo.db', version: 1,
        onCreate: (Database database, int version) async {
      print('table created');

      await database
          .execute(
              'create table tasks(id integer primary key, title text, time text, date text, status text);')
          .then((value) => print("tabel created"))
          .catchError((error) {
        print('error create table');
      });
    }, onOpen: (Database database) {
      getDataBase(database);
    });
  }

  void insertDataBase(
      {required String title,
      required String time,
      required String date}) async {
    await database!.transaction((txn) async {
      int value = await txn.rawInsert(
          "insert into tasks(title, time, date, status) values('$title', '$time','$date', 'new')");
      print(value);
      emit(AppInsertToDatabase());
    }).then((value) {
      getDataBase(database);
      emit(AppGetDatabase());
    });
  }

  void updateDataBase({required String status, required int id}) async {
    database!.rawUpdate("update tasks set status=? where id=?", [status, id]);
    emit(AppUpdateDatabase());
    getDataBase(database);
    emit(AppGetDatabase());
  }

  void getDataBase(database) async {
    tasks_archived = [];
    tasks_new = [];
    tasks_done = [];
    List tasks = await database!.rawQuery("select * from tasks");
    tasks.forEach((element) {
      if (element['status'] == 'new')
        tasks_new.add(element);
      else if (element['status'] == 'done')
        tasks_done.add(element);
      else
        tasks_archived.add(element);
    });
  }

  void changeBottomSheetState({required bool isBottomSheet}) {
    this.isBottomSheet = isBottomSheet;
    emit(AppChangeBottomSheetState());
  }

  void deleteDataBase({required int id}) async {
    await database!
        .rawDelete("delete from tasks where id=?", [id]).then((value) {
      getDataBase(database);
      emit(AppDeleteDatabase());
    });
  }
}
