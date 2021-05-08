import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/cubit/to_do_cubit.dart';
import 'package:flutter_todo_app/cubit/to_do_states.dart';
import 'package:flutter_todo_app/validation.dart';
import 'package:intl/intl.dart';

class HomeLayout extends StatelessWidget {
  ToDoCubit toDoCubit;
  List<Map> tasks = [];

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController timeEditingController = TextEditingController();
  TextEditingController dateEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ToDoCubit>(
      create: (BuildContext context) =>
      ToDoCubit()
        ..createDatabase(),
      child: BlocConsumer<ToDoCubit, ToDoStates>(
        listener: (BuildContext context, ToDoStates state) {},
        builder: (BuildContext context, ToDoStates state) {
          toDoCubit = ToDoCubit.get(context);
          toDoCubit.context = context;
          return Scaffold(
            //toDoCubit.screen[toDoCubit.currentIndex]
            key: scaffoldKey,
            appBar: buildAppBar(),
            body: toDoCubit.screen[toDoCubit.currentIndex],
            floatingActionButton: buildFloatingActionButton(),
            bottomNavigationBar: buildBottomNavigationBar(),
          );
        },
      ),
    );
  }

/////////////////////////////Widgets/////////////////////////////

  //Done
  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.edit),
      onPressed: fabButtonAction,
    );
  }

  //Done
  Widget buildBottomSheetForm() {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              )),
          padding: EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitleTextFormField(),
              SizedBox(height: 8),
              buildTimeTextFormField(),
              SizedBox(height: 8),
              buildDateTextFormField(),
            ],
          ),
        ),
      ),
    );
  }

  //Done
  Widget buildDateTextFormField() {
    return TextFormField(
      controller: dateEditingController,
      readOnly: true,
      showCursor: true,
      validator: Validation.dateValidation,
      onTap: getDate,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Task Date",
        prefixIcon: Icon(Icons.date_range),
      ),
    );
  }

  //Done
  Widget buildTimeTextFormField() {
    return TextFormField(
      controller: timeEditingController,
      validator: Validation.timeValidation,
      readOnly: true,
      showCursor: true,
      onTap: getTime,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Task Time",
        prefixIcon: Icon(Icons.schedule_outlined),
      ),
    );
  }

  //Done
  Widget buildTitleTextFormField() {
    return TextFormField(
      controller: titleEditingController,
      keyboardType: TextInputType.text,
      validator: Validation.titleValidation,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          labelText: "Task Title", prefixIcon: Icon(Icons.title)),
    );
  }

  //Done
  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      title: Text(
        "${toDoCubit.titles[toDoCubit.currentIndex]}",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  //Done
  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: toDoCubit.currentIndex,
      onTap: toDoCubit.changeIndex,
      items: [
        buildBottomNavigationBarItem(
          icon: Icons.menu,
          label: "Tasks",
        ),
        buildBottomNavigationBarItem(
          icon: Icons.check_circle_outline,
          label: "Done",
        ),
        buildBottomNavigationBarItem(
          icon: Icons.archive_outlined,
          label: "Archived",
        ),
      ],
    );
  }

  //Done
  BottomNavigationBarItem buildBottomNavigationBarItem(
      {IconData icon, String label}) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }

/////////////////////////////Widgets/////////////////////////////

/////////////////////////////Methods/////////////////////////////

  //Done
  void getTime() async {
    timeEditingController.text = (await showTimePicker(
        context: toDoCubit.context, initialTime: TimeOfDay.now()))
        .format(toDoCubit.context);
  }

  //Done
  void getDate() async {
    dateEditingController.text = DateFormat.yMMMd().format(await showDatePicker(
        context: toDoCubit.context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.parse("2021-12-31")));
  }

  //Done
  void showBottomSheet() {
    scaffoldKey.currentState
        .showBottomSheet(
          (context) => buildBottomSheetForm(),
      elevation: 10,
    )
        .closed
        .then((value) {
      toDoCubit.changeBottomSheetState(isShown: false);
    });
    toDoCubit.changeBottomSheetState(isShown: true);
  }

  //Done
  void closeBottomSheet() {
    Navigator.of(toDoCubit.context).pop();
    toDoCubit.changeBottomSheetState(isShown: false);
  }

  //Done
  void fabButtonAction() {
    if (toDoCubit.isBottomSheetShown) {
      if (formKey.currentState.validate()) {
        toDoCubit.insert(
            title: titleEditingController.text,
            time: timeEditingController.text,
            date: dateEditingController.text);
        titleEditingController.clear();
        timeEditingController.clear();
        dateEditingController.clear();
        closeBottomSheet();
      }
    } else {
      showBottomSheet();
    }
  }

/////////////////////////////Methods/////////////////////////////
}
