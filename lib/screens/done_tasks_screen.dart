import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/cubit/to_do_cubit.dart';
import 'package:flutter_todo_app/cubit/to_do_states.dart';
import 'package:flutter_todo_app/widgets/task_widget.dart';

class DoneTasksScreen extends StatelessWidget {
  String imageAsset = "assets/images/got-this.png";
  String title = "No Done Tasks";
  String subtitle = "Start getting some tasks done";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ToDoCubit.get(context).doneTasks.length == 0
            ? buildDefaultLayout(imageAsset, title, subtitle)
            : buildTasksListView(context,ToDoCubit.get(context).doneTasks);
      },
    );
  }
}
