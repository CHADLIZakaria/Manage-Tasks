import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tasks_app/shared/components/components.dart';
import 'package:tasks_app/shared/cubit/cubit.dart';
import 'package:tasks_app/shared/cubit/statless.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  TextEditingController titleEditingController = TextEditingController();
  TextEditingController dateEditingController = TextEditingController();
  TextEditingController timeEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertToDatabase) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            body: cubit.list_screens[cubit.currentScreen],
            appBar: AppBar(
              title: Text('${cubit.list_titles[cubit.currentScreen]}'),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentScreen,
              onTap: (value) {
                cubit.changeIndex(value);
              },
              items: [
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
                  label: 'Archives',
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (!cubit.isBottomSheet) {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  label: 'Enter Task title',
                                  controller: titleEditingController,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Task title should be not empty';
                                    }
                                    return null;
                                  },
                                  prefixIcon: Icons.task,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                  label: 'Enter Task date',
                                  controller: dateEditingController,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Task date should be not empty';
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    DateTime? myDate = await showDatePicker(
                                      context: context,
                                      lastDate: DateTime.now()
                                          .add(Duration(hours: 24 * 30)),
                                      firstDate: DateTime.now(),
                                      initialDate: DateTime.now(),
                                    );
                                    dateEditingController.text =
                                        DateFormat('yyyy-MM-dd')
                                            .format(myDate!)
                                            .toString();
                                  },
                                  prefixIcon: Icons.calendar_today,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                  label: 'Enter Task time',
                                  controller: timeEditingController,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Task date should be not empty';
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    TimeOfDay? myDate = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    timeEditingController.text =
                                        myDate!.format(context).toString();
                                  },
                                  prefixIcon: Icons.watch_later_outlined,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(isBottomSheet: false);
                  });
                  cubit.changeBottomSheetState(isBottomSheet: true);
                } else {
                  if (formKey.currentState!.validate()) {
                    cubit.insertDataBase(
                        title: titleEditingController.text,
                        date: dateEditingController.text,
                        time: timeEditingController.text);
                  }
                  cubit.changeBottomSheetState(isBottomSheet: true);
                }
              },
              child: cubit.isBottomSheet ? Icon(Icons.edit) : Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
