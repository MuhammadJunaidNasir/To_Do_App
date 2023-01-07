import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:to_do_app/Utilis.dart';
import 'package:to_do_app/completed_tasks_screen.dart';


class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {

  List<String> tasksList= <String>['Pending Tasks','Completed Tasks'];
  String currentValue= 'Pending Tasks';
  bool check=false;
  final taskController= TextEditingController();
  final dateController= TextEditingController();
  final pendingRef= FirebaseDatabase.instance.ref('PendingTasks');
  final completedRef= FirebaseDatabase.instance.ref('CompletedTasks');
  DateTime currentDate= DateTime.now();
  String? selectedDate;

       void pickDate(context)async{
        DateTime? selectedDate= await showDatePicker(
           context: context,
           initialDate: currentDate,
           firstDate: DateTime(2023),
           lastDate: DateTime(2024),
         );
        if(selectedDate==null){
          return ToastMessage().toastMessage('You have not picked any date');
        }
        else{
          setState(() {
            currentDate=selectedDate;
          });
        }
       }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do App'),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        actions:  [
            const Padding(
             padding: EdgeInsets.only(right: 80.0),
             child: CircleAvatar(
               radius: 18,
               backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvHBRDNCY-7RQ9u9vcXtuVyuuXxxZcjv9T5w&usqp=CAU'),
             ),
           ),
            TextButton(
                onPressed: (){
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context)=> const CompletedTasksScreen()));
                },
                child: Row(children: const [
                   Text('Completed Tasks',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                  Icon(Icons.navigate_next_outlined,color: Colors.white,),
                ],),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.add,color: Colors.white,),
          onPressed: (){
                 addTask();
          }
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi5TDQV2RxqFS4gOOxGdxPetnaGKOzezLUcw&usqp=CAU'),
                fit: BoxFit.fitHeight,
            ),
        ),
        child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 5.0,right: 300),
                child: InkWell(
                  child: Container(
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(child: Text('Clear All',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                    ),
                    ),
                  ),
                  onTap: (){
                     pendingRef.remove().then((value){
                       ToastMessage().toastMessage('All tasks has been removed');
                     });
                  },
                ),
              ),

              const Divider(
                color: Colors.deepPurple,
                thickness: 1,
              ),
              Expanded(
                child: FirebaseAnimatedList(
                    query: pendingRef,
                    itemBuilder: (context,snapshot,animation,index){
                      final task= snapshot.child('Task').value.toString();
                      final date= snapshot.child('Date').value.toString();
                      return Card(
                        color: Colors.purpleAccent,
                        child: ListTile(
                          leading: const Icon(Icons.task),
                          title: Text(snapshot.child('Task').value.toString(),style: const TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(snapshot.child('Date').value.toString(),style: const TextStyle(color: Colors.brown),),
                          trailing:  PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder: (context)=>[
                              PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Update'),
                                  onTap: (){
                                    Navigator.pop(context);
                                    updateTask(task);
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child:ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                  onTap: (){
                                    Navigator.pop(context);
                                    pendingRef.child(snapshot.child('Task').value.toString()).remove().then((value){
                                      ToastMessage().toastMessage('Task has been deleted');
                                    });
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                value: 3,
                                child:ListTile(
                                  leading: Icon(Icons.done_outline),
                                  title: Text('Completed'),
                                  onTap: (){
                                    Navigator.pop(context);
                                    pendingRef.child(snapshot.child('Task').value.toString()).remove();
                                    completedRef.child(task).set({
                                      'Task': task,
                                      'Date': date,
                                    }).then((value){
                                      ToastMessage().toastMessage('Task has been added to completed list');
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                ),

              ),
            ],
          ),
      ),
    );
  }
   Future<void> updateTask(String task)async{
      return showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text('Update Task'),
              content: Container(
                height: 150,
                width: 100,
                child: Column(
                  children: [
                    TextFormField(
                      controller: taskController,
                      decoration: const InputDecoration(
                          hintText: 'Enter Updated Task'
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Picked Date: ${currentDate.month}/${currentDate.day}'),
                    ),
                    const SizedBox(height: 10,),
                    ElevatedButton(
                        onPressed: (){
                          pickDate(context);
                        },
                        child: const Text('Select Due Date')),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: (){
                          Navigator.pop(context);
                          pendingRef.child(task).update({
                            'Task': taskController.text.toString(),
                            'Date': currentDate.day.toString()+'/'+currentDate.month.toString(),
                          }).then((value){
                            ToastMessage().toastMessage('Task Updated Successfully!');
                            taskController.clear();
                            currentDate=DateTime.now();
                          }).onError((error, stackTrace){
                            ToastMessage().toastMessage(error.toString());
                          });
                    },
                    child: const Text('Update')),
              ],
            );
          }
      );
   }
   Future<void> addTask()async{
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Add New Task',style: TextStyle(color: Colors.deepPurple),),
            content: Container(
              height: 200,
              width: 300,
              child: Column(
                children: [
                  TextFormField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      hintText: 'Add Task Name',
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Picked Date: ${currentDate.month}/${currentDate.day}'),
                  ),
                  const SizedBox(height: 10,),

                  ElevatedButton(
                      onPressed: (){
                         pickDate(context);
                      },
                      child: const Text('Select Due Date')),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    pendingRef.child(taskController.text.toString()).set({
                      'Task': taskController.text.toString(),
                      'Date': currentDate.day.toString()+'/'+currentDate.month.toString(),
                    }).then((value){
                      ToastMessage().toastMessage('Task Added Successfully!');
                      taskController.clear();
                      currentDate=DateTime.now();
                    }).onError((error, stackTrace){
                      ToastMessage().toastMessage(error.toString());
                    });
                  },
                  child: const Text('ADD',style: TextStyle(color: Colors.deepPurple),)),
            ],
          );
        }
    );
  }
}
