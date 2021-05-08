import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/cubit/to_do_cubit.dart';
import 'package:flutter_todo_app/cubit/to_do_states.dart';
import 'package:flutter_todo_app/widgets/task_widget.dart';

class NewTasksScreen extends StatelessWidget {
  String imageAsset = "assets/images/empty-tasks.png";
  String title = "No Tasks";
  String subtitle = "Start creating your tasks";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ToDoCubit.get(context).newTasks.length == 0
            ? buildDefaultLayout(imageAsset, title, subtitle)
            : buildTasksListView(context,ToDoCubit.get(context).newTasks);
      },
    );
  }
}
