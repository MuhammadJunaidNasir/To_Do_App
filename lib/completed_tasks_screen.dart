import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Utilis.dart';
class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({Key? key}) : super(key: key);

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  final completedRef= FirebaseDatabase.instance.ref('CompletedTasks');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Tasks'),
        backgroundColor: Colors.deepPurple,
        actions: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0,bottom: 5),
              child: Container(
                height: 10,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(child: Text('Clear All',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),
                ),
              ),
            ),
            onTap: (){
              completedRef.remove().then((value){
                ToastMessage().toastMessage('All tasks has been removed');
              });
            },
          ),
          const SizedBox(width: 10,),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi5TDQV2RxqFS4gOOxGdxPetnaGKOzezLUcw&usqp=CAU'),
          fit: BoxFit.fitHeight,
          ),
        ),
        child: Column(
          children: [

            Expanded(
              child: FirebaseAnimatedList(
                  query: completedRef,
                  itemBuilder: (context,snapshot,animation,index){
                    return Card(
                      color: Colors.purpleAccent,
                      child: ListTile(
                        leading: const Icon(Icons.done_outline_outlined),
                        title: Text(snapshot.child('Task').value.toString(),style: const TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text(snapshot.child('Date').value.toString(),style: const TextStyle(color: Colors.brown),),
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
}
