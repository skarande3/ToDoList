import 'dart:convert'; //nessessary import

import 'package:flutter/material.dart';//Theme of the app, all widgets are from this file.
import 'package:shared_preferences/shared_preferences.dart';

//In dart there are 2 types of widgets StatefulWidget & StatelessWidget. We use StatelessWidget here as it doesn't involve user interaction.
class IntroPage extends StatelessWidget { //for the introduction page,
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {     // Delay for 3 seconds
      Navigator.of(context).pushReplacementNamed('/app'); //responsible for transferring to the main page

    });

    //Scaffold is the fundamental structure for implementing material design visual layouts.
    // It has an appbar which gives the header like look at the top. Rest of content goes to body of scaffold.
    return Scaffold(
      backgroundColor: Colors.indigo[200],
      body: Center(
        child: Text(
          '*Welcome to Shravan\'s To-Do app*',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

void main() { // instructs the app to run.
  runApp( MaterialApp( //Father of all widgets, need this in almost all cases as the main widget.
   // home: MyApp(),
    initialRoute: '/intro', // Set the initial route to the IntroPage
  routes: {
    '/intro': (context) => IntroPage(), // Define the IntroPage route
    '/app': (context) => MyApp(), // Define the MyApp route
  },
  ));
}

//In dart there are 2 types of widgets StatefulWidget & StatelessWidget. We use StatefulWidget because it is
// mutable and can be rebuilt multiple times during its lifetime. Changes during user interactions.
class MyApp extends StatefulWidget{
  //static int a = 10;
 // static int taskIndex = 0;
  @override  // This annotation indicates that the following method is intended to override the createState method from the StatefulWidget class
  State<MyApp> createState() => _MyAppState();  //The createState method is overridden to create an instance of the associated
// state class, which is _MyAppState. State<MyApp> specifies that the state class (_MyAppState) is associated with the MyApp
// widget.
}

class _MyAppState extends State<MyApp> {
  List<Card> taskList=[];    //Listview.builder uses this list to display the tasks on the screen
  List<Card> masterList = []; //this is the main list that contains all tasks, even the deleted ones. There is a potential A
  //used the master list to ensure the deleting of tasks was done correctly.


  //was trying to add local storage but didn't work :(
  Future<List<Card>> getList()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();//this is used for local storage capabilities.
    String? jsonString = prefs.getString("list");
    if(jsonString != null){
      List<Card> decodedList = jsonDecode(jsonString);
      //List<String> myList = decodedList.cast<String>();
      return decodedList;
    }else{
      return [];
    }
  }

  //was trying to add local storage feature but it didn't work :(
  Future<bool> saveList()async{
    taskList = await getList();
    masterList = await getList();
    return true;
  }

  //controllers are used for fetching and changing text field values,
  // TextEditingController is a class that is used to control and manage the text entered by the user into a text field.
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  int taskIndex = 0;
  @override //syntax reqd.
  Widget build(BuildContext context) {

    print("build method called"); //debugging

    return Scaffold(
        appBar: AppBar(title: Text("TaskHarbor: Navigate Your Time with Ease!")),
        body: Padding( //this is used to align object properly
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            children: [
              Container(
                height: 250,
                child:
              Column(
              children: [
              TextField(
              controller: titleController, //allows to interact with and retrieve the text entered by the user.
                decoration: InputDecoration(
                    labelText: "Enter title here"
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    labelText: "Enter your task's description here"
                ),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Enter Date" //label text of field
                ),
                readOnly: true, //does not allow direct user input.
                onTap: ()async{
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //Sets the initial date of the date picker to the current date and time.
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2030));
                  print("firstlast"); //debugging
                  if(pickedDate!=null) {
                    print("picked");
                    setState(() {
                      dateController.text = pickedDate.toString().substring(0,10); //extracts the first 10 characters
                     // (the date portion) from the string representation of the selected date (pickedDate
                    });
                  }else{
                    print("Something's wrong");

                  }

                },
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(onPressed: (){

                    if (titleController.text.isEmpty &&
                        descriptionController.text.isEmpty &&
                        dateController.text.isEmpty) {

                      return;
                    }
                    final int task = taskIndex;
                    void deleteTask(){
                      bool a = taskList.remove(masterList[task]); //remove an element from taskList using the index obtained from masterList
                      print("did the remove happen: "+a.toString()); //check's if it happened
                      setState(() {
                        print((task).toString()+" this is the index that has been removed"); // prints the index it removed.
                      });
                    }
                    Card card = Card(
                      color: Colors.grey, //Sets the background color of the card to grey.
                      shadowColor: Colors.black, //adds shadow
                      elevation: 20,
                      child: Stack(
                          children: [Container( //Inside the Stack, the first child is a Container widget.
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            alignment: Alignment.center,
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(titleController.text),
                                Text(descriptionController.text),
                                Text(dateController.text)    //Displays the text from the controllers
                              ],
                            ),
                          ),
                            Container(
                                alignment: Alignment.topRight,
                                child: ElevatedButton(onPressed: (){
                                  deleteTask();
                                  //taskIndex--;
                                }, child: Text("-"),) //The remove task button
                            )
                          ]
                      ),
                    );

                    taskList.add(card);
                    masterList.add(card);
                    print(masterList.length);

                    print("${taskList.length} this is the length of tasklist after adding an item");
                    setState(() {
                      taskIndex++;
                      print(taskIndex.toString()+ ": task index");
                      descriptionController.text = "";
                      titleController.text = "";
                      dateController.text = "";
                      print("setting state");
                    });
                  }, child: Text("Add")))
                ],
              )

    ),
          Expanded( //used to ensure that its child takes up all available remaining space in the vertical direction
            child: Container(
              height: 450,
              child: ListView.builder( // creates a scrollable list view on-demand based on the length of the taskList
                itemCount: taskList.length,
                  itemBuilder: (context, index){
                  print("building the listview");
                return taskList[index];
              }),
            ),
          ),
            ],
          )

            ,
          ),
        );


  }


}