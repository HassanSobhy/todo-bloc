import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import 'to_do_states.dart';
import '../screens/archived_tasks_screen.dart';
import '../screens/done_tasks_screen.dart';
import '../screens/new_tasks_screen.dart';


class ToDoCubit extends Cubit<ToDoStates> {
  ToDoCubit() : super(ToDoStateInitial());

  BuildContext context;

  //Get Object From ToDoCubit
  static ToDoCubit get(BuildContext context) => BlocProvider.of<ToDoCubit>(context);

  bool _isBottomSheetShown = false;

  bool get isBottomSheetShown{
    return _isBottomSheetShown;
  }



  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  int _currentIndex = 0;
  Database _database;

  int get currentIndex{
    return _currentIndex;
  }

  List<Widget> _screen = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<Widget> get screen{
    return _screen;
  }

  List<String> _titles = [
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];

  List<String> get titles{
    return _titles;
  }

  void changeIndex(int index){
    _currentIndex = index;
    emit(ToDoChangeBottomNavBarState());
  }

  //Done
  void createDatabase() async {
    _database = await openDatabase(
      "todo.db",
      version: 1,
      onCreate: (database, version) async {
        print("Database Created");
        await database.execute(
            "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, state TEXT)");
        print("Table Created");
        emit(ToDoCreateDatabaseState());
      },
      onOpen: (database) {
        getDataFromDataBase(database);
        print("Database Opened");
      },
    );
  }

  //Done
  Future<int> insertDatabase({String title, String time, String date}) async {
    return await _database.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO tasks(title, date, time, state) VALUES("${title}","${date}","${time}","new")');
    });
  }

  //Done
  void insert({String title,String time,String date}) async {
    await insertDatabase(
      title: title,
      time: time,
      date: date,
    );
    emit(ToDoInsertToDatabaseState());
    getDataFromDataBase(_database);
  }

  //Done
  void getDataFromDataBase(Database database) async {
    //emit(ToDoLoadingState());
    List<Map> tempTasks = await database.rawQuery('SELECT * FROM tasks');
    newTasks = tempTasks.where((element) => element['state']=='new').toList();
    doneTasks = tempTasks.where((element) => element['state']=='done').toList();
    archivedTasks = tempTasks.where((element) => element['state']=='archived').toList();
    emit(ToDoGetDataFromDataBaseState());
  }

  void updateData({int id , String state}) async{
    await _database.rawUpdate(
        'UPDATE tasks SET state = ? WHERE id = ?',
        ['${state}', id]);
    emit(ToDoUpdateDataBaseState());
    getDataFromDataBase(_database);
  }

  void deleteData({int id}) async{
    await _database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
    emit(ToDoDleteDataBaseState());
    getDataFromDataBase(_database);
  }
  void changeBottomSheetState({bool isShown}){
    _isBottomSheetShown = isShown;
    emit(ToDoChangeBottomSheetState());
  }
}
