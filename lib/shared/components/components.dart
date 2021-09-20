import 'package:flutter/material.dart';
import 'package:tasks_app/shared/cubit/cubit.dart';

Widget defaultFormField(
        {required TextEditingController controller,
        required String label,
        required IconData prefixIcon,
        required String? Function(String?)? validate,
        IconData? suffixIcon,
        bool isPassword = false,
        Function()? onTap,
        Function()? togglePassword}) =>
    TextFormField(
      obscureText: isPassword,
      controller: controller,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(
          onPressed: togglePassword,
          icon: Icon(suffixIcon),
        ),
      ),
      onChanged: (value) {},
      onFieldSubmitted: (value) {},
      validator: validate,
    );

Widget buildTask(
        {required model,
        required BuildContext context,
        required String status}) =>
    Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDataBase(id: model['id']);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              child: Text(model['time']),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model['title']),
                  Text(model['date']),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.archive),
              onPressed: () {
                AppCubit.get(context)
                    .updateDataBase(status: 'archive', id: model['id']);
              },
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDataBase(status: 'done', id: model['id']);
              },
              icon: Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );

Widget buildTasks({required tasks}) => tasks.length > 0
    ? ListView.separated(
        itemBuilder: (context, index) => buildTask(
          model: tasks[index],
          context: context,
          status: 'new',
        ),
        itemCount: tasks.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      )
    : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100,
            ),
            Text(
              'No tasks found',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
