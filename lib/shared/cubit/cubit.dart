import 'package:flutter/material.dart';
import 'package:flutter_app/modules/archived_tasks/arvhived_tasks_screen.dart';
import 'package:flutter_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:flutter_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:flutter_app/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit(): super(AppInitialState());

  //عشان اكسيز ع اي حاجو هنا من برة
  static AppCubit get(context)=>BlocProvider.of(context);

  int currentIndex=0;
  List<Widget>screens=
  [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  void ChangeIndex(int index){
    currentIndex=index;
  emit(AppChangeBottomNavBarState());
  }

  Database database;
  List<Map> newtasks=[];
  List<Map> donetasks=[];
  List<Map> archivedtasks=[];
//عملت الكريت والget ف نفس الوقت
  void createDatabase ()
  {
     openDatabase(
        "todo.db",
        version: 1,
        onCreate: (database,version)
        {
          print("DataBase Created");
          database.execute("CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT, time TEXT,status TEXT)").then((value)
          {
            print("Table Created");}
          ).catchError((error){
            print('error when created table ${error.toStrinde}');
          });
        },
        onOpen:(database)
        {
          getDataFromDataBase(database);
          print("DataBase Opened");
        }
    ).then((value) {
      database=value;
      emit(AppCreateDatabaseState());
     }
    );
  }

   insertToDatabase (
      {
        @required String title,
        @required String time,
        @required String date,
      }) async
   {
     await database.transaction((txn)
    {
      txn.rawInsert('INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print("$value inserted successfully");
        emit(AppInsertDatabaseState());

//عشان اعمل انسيرت جديدة
        getDataFromDataBase(database);
      }).catchError((error){
        print('error when inserted new Record ${error.toStrinde}');
      });
      return null;
    });
  }

  void getDataFromDataBase(database)
  {
    newtasks=[];
    donetasks=[];
    archivedtasks=[];
    emit(AppGetDatabaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value)
     {

       value.forEach((element){
      if(element['status']=='new')
          newtasks.add(element);
      else if(element['status']=='done')
        donetasks.add(element);
      else
        archivedtasks.add(element);


       });

       emit(AppGetDatabaseState());
     });

  }

  void updateData({
    @required String status,
    @required int id,
  })
  async{
       database.rawUpdate(
    'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]
    ).then((value)
    {
      getDataFromDataBase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    @required int id,
  })
  {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value)
    {
      getDataFromDataBase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheetShown=false;
  IconData fabIcon= Icons.edit;

  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  })
{
  isBottomSheetShown=isShow;
  fabIcon=icon;
  emit(AppIChangeBottomSheetState());
  }
}