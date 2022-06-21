import 'package:flutter/material.dart';
import 'package:flutter_app/modules/archived_tasks/arvhived_tasks_screen.dart';
import 'package:flutter_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:flutter_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:flutter_app/shared/components/components.dart';
import 'package:flutter_app/shared/components/constants.dart';
import 'package:flutter_app/shared/cubit/cubit.dart';
import 'package:flutter_app/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class HomeLayout extends StatelessWidget
{

  //عشان اعمل validation
  var scaffoldKay=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();


  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create:(BuildContext context)=>AppCubit()..createDatabase(),
        child:BlocConsumer<AppCubit,AppStates>(
          listener:(BuildContext context,AppStates state){
            if(state is AppInsertDatabaseState)
            {
              Navigator.pop(context);
            }

          } ,
          builder: (BuildContext context,AppStates state){
            return Scaffold(
              key:scaffoldKay,
              appBar: AppBar(
                title:
                Text('Todo App'),
              ),
              body:
               state is! AppGetDatabaseLoadingState? AppCubit.get(context).screens[AppCubit.get(context).currentIndex]: CircularProgressIndicator(),

              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                if (AppCubit.get(context).isBottomSheetShown) {
                  if (formKey.currentState.validate())
                 {
                 AppCubit.get(context).insertToDatabase(title: titleController.text, time: timeController.text, date: dateController.text);

                 }
            }else {
            scaffoldKay.currentState
                .showBottomSheet(
            (context) =>
             Container(
            color: Colors.grey[100],
            padding: EdgeInsets.all(20.0),
            child: Form(
            key: formKey,
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            defaultFormField(
            controller: titleController,
            type: TextInputType.text,
            validate: (String value) {
            if (value.isEmpty) {
            print('title must not be empty');
            }
            return null;
            },
            label: "task title",
            prefix: Icons.title,
            ),
            SizedBox(
            height: 15,
            ),
            defaultFormField
            (
            controller: timeController,
            type: TextInputType.datetime,
            onTap: () {
            showTimePicker(
            context: context, initialTime: TimeOfDay.now()
            ).then((value) {
            timeController.text = value.format(context);
            });
            },
            validate: (String value) {
            if (value.isEmpty) {
            print('time must not be empty');
            }
            return null;
            },
            label: "task Time",
            prefix: Icons.watch_later_outlined,
            ),
            SizedBox(
            height: 15,
            ),
            defaultFormField
            (
            controller: dateController,
            type: TextInputType.datetime,
            onTap:() {
            showDatePicker(context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.parse('2022-12-30'),
            ).then((value) {
            dateController.text =
            DateFormat.yMMMd().format(value);
            });
            },
            validate: (String value) {
            if (value.isEmpty) {
            print('Date must not be empty');
            }
            return null;
            },
            label: "task Date",
            prefix: Icons.calendar_today,
            ),
            ],
            ),
            ),
            ),
            ).closed.then((value)
            {
            AppCubit.get(context).changeBottomSheetState(
            isShow:false,
            icon: Icons.edit);
            });
            AppCubit.get(context).changeBottomSheetState(
            isShow:true,
            icon: Icons.add);

            }
            },
               child:Icon(
             AppCubit.get(context).fabIcon
            ),
           ),

              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: AppCubit.get(context).currentIndex,
                onTap: (index)
                {
                  AppCubit.get(context).ChangeIndex(index);

                },
                items:[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.done),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive),
                    label: 'Archive',
                  ),

                ],
              ),
            );
          },
        )
    );
  }

  //بتاخد متغير واحد اسمة openDatabase بحطة انا في Var


}