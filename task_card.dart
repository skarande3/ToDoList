import "package:flutter/material.dart";
import "main.dart";

class TaskCard extends StatefulWidget{
  //Required details
  //1. to do description
  //2. Target date
  //3. Target Time
  String toDoDescription;
  String targetDate ;
  String title;
  final VoidCallback? updateScreen;
  //final VoidCallback? deleteTask;
  int taskIndex = 0;
  List<TaskCard> list = [];

  TaskCard({required this.taskIndex, required this.toDoDescription, required this.targetDate, required this.title, required this.updateScreen});
  @override
  State<StatefulWidget> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>{
  get taskList => null;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      shadowColor: Colors.black,
      elevation: 20,
      child: Stack(
        children: [Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
          ),
          alignment: Alignment.center,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(widget.title),
              Text(widget.toDoDescription),
              Text(widget.targetDate.toString())
            ],
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          child: ElevatedButton(onPressed: (){
            //widget.list.remove(widget);
            //_MyAppState.
            taskList.remove(widget.taskIndex);

          }, child: Text("-"),)
        )
        ]
      ),
    );
  }


}