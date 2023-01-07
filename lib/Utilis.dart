import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
class ToastMessage{
   void toastMessage(String message){
     Fluttertoast.showToast(
         msg: message,
         backgroundColor: Colors.green,
         textColor: Colors.white,
         gravity: ToastGravity.BOTTOM,
     );
   }
}