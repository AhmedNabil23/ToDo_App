import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/shared/cubit/cubit.dart';

Widget defaultButton({
 double width =double.infinity,
 Color background=Colors.blue,
 double radius =0,
 @required Function function,
 @required String text,
})=>  Container(
  width: double.infinity,

  height: 50,
  child: MaterialButton(

    onPressed:function,
    child:
    Text(
      text.toUpperCase(),
      style:TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: background,
  ),
);

Widget defaultFormField({
  @required TextEditingController controller,
   TextInputType type,
  @required Function validate,
   Function onTap,

  @required String label,
  @required IconData prefix,
  bool isPassword=false,
  IconData suffix,
  Function suffixPressed,
})=>  TextFormField(
  controller: controller,
  keyboardType: type,
  onTap:onTap,

  validator: validate,

  decoration: InputDecoration(
    labelText:label,
    prefixIcon: Icon(
        prefix
    ),
    suffixIcon: suffix !=null? IconButton(
      onPressed:suffixPressed ,
      icon: Icon(
            suffix,
        ),
    ):null,
    border: OutlineInputBorder(),
  ),


  obscureText: isPassword,

  );

//ليست الtasks
Widget buildTaskItem(Map model,context)=>Dismissible(
  key:Key(model['id'].toString()),
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(

          radius: 40.0,

          child: Text('${model['time']}'),

        ),

        SizedBox( width: 20.0,),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(

                '${model['title']}',

                style: TextStyle(

                  fontSize: 18.0,

                  fontWeight: FontWeight.bold,

                ),

              ),

              Text(

                '${model['date']}',

                style: TextStyle(

                  color: Colors.grey,

                ),

              ),

            ],

          ),

        ),

        SizedBox( width: 20.0,),

        IconButton(

         icon: Icon(

          Icons.check_box,

        color:Colors.green[400],

        ),

          onPressed: ()

          {

            AppCubit.get(context).updateData(status: 'done', id: model['id']);

          }),

        IconButton(

            icon: Icon(

              Icons.archive,

              color:Colors.grey,

            ),

            onPressed: ()

            {

              AppCubit.get(context).updateData(status: 'archived', id: model['id']);

            }),



      ],

    ),

  ),
  onDismissed:(direction)
  {
    AppCubit.get(context).deleteData(id: model['id']);
  },
);

Widget tasksBuilder ({
  @required List<Map> tasks,
})=>ConditionalBuilder(
  condition: tasks.length>0,
  builder: (context) => ListView.separated(
      itemBuilder: (context,index)=>buildTaskItem(tasks[index],context),
      separatorBuilder:  (context,index)=>Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey[300],
      ),
      itemCount: tasks.length),
  fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center ,
        children: [
          Icon(
            Icons.menu,
            size: 100,
            color: Colors.grey,
          ),
          Text('No Tasks Yet,Please Add Some Tasks',
            style: TextStyle(
              fontSize:16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),),
        ],)),
);


