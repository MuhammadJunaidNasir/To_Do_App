import 'dart:async';

import 'package:flutter/material.dart';
import 'package:to_do_app/to_do_tasks_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

   @override
  void initState() {

     Timer(const Duration(seconds: 5), () {
       Navigator.push(context, 
       MaterialPageRoute(builder: (context)=> const TasksScreen()));
     });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
           const Center(
            child: CircleAvatar(
              radius: 60.0,
              backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQg3sUUiFVylv0UbnQqzHsNCmcoi2OLNVg9pw&usqp=CAU'),
            ),
          ),
           const SizedBox(height: 10,),
           Padding(
             padding: const EdgeInsets.only(left: 120.0),
             child: Row(
                children: const [
                  Text(' To Do App',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
               ],
             ),
           ),
        ],
      )
    );
  }
}
