import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
static const String page_id = 'notification';
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Material (
   


   child :  Scaffold(
   appBar : AppBar(
title :  Text('الإشعارات') ,  

centerTitle :  true  ,

actions :[
  IconButton (  icon: Icon(Icons.home)  ,  onPressed :() {
   

  })


]
   )



   )

    );
  }
}