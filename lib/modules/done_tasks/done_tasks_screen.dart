import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/shared/components/components.dart';
import 'package:tasks_app/shared/cubit/cubit.dart';
import 'package:tasks_app/shared/cubit/statless.dart';

class DoneTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, states) {},
        builder: (context, state) {
          List<Map> tasks = AppCubit.get(context).tasks_done;
          return buildTasks(tasks: tasks);
        });
  }
}
