import 'package:flutter/material.dart';
import 'package:flutter_todo_app/cubit/to_do_cubit.dart';


Widget buildTaskItem(BuildContext context, Map item) {
  return Dismissible(
    key: Key(item.toString()),
    onDismissed: (direction){
      ToDoCubit.get(context).deleteData(id:item['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text("${item['time']}"),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${item['title']}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${item['date']}",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          IconButton(icon: Image.asset("assets/icons/todo-done.jpg",), onPressed: (){
            ToDoCubit.get(context).updateData(id: item["id"],state:'done');
          }),
          IconButton(icon: Icon(Icons.archive,color: Colors.red.shade200,), onPressed: (){
            ToDoCubit.get(context).updateData(id: item["id"],state:'archived');
          }),
        ],
      ),
    ),
  );
}



Widget buildSeparator() {
  return Container(
    height: 1,
    width: double.infinity,
    color: Colors.grey[300],
  );
}


Widget buildLoading() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

Widget buildDefaultLayout(String imageAsset,String title,String subtitle){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imageAsset),
        SizedBox(height: 8,),
        Column(children: [
          Text(title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          Text(subtitle,style: TextStyle(fontSize: 12),),
        ],)
      ],
    ),
  );
}


Widget buildTasksListView(BuildContext context,List<Map> tasksList){
  return ListView.separated(
      itemBuilder: (context, index) => buildTaskItem(
          context, tasksList[index]),
      separatorBuilder: (context, index) => buildSeparator(),
      itemCount: tasksList.length);
}