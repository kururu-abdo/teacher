import 'dart:convert';


import 'package:cloud_firestore/cloud_firestore.dart';

// model for  event

class Event{
  String id;
  String title;

  String body;
  String time;
  List Files ;
Timestamp date;
String subject_id;
String teacher_id;

Event(this.id, this.title ,this.body ,this.Files  ,  this.date ,  this.teacher_id ,  this.subject_id);

Event.fromJson(Map<dynamic ,dynamic> data){
  this.id =  data['id'];
  this.title = data['title']??'';
  this.body =data['body']??'';
  this.time =data['time']??'';
  this.Files= data['files'];

  this.date =   data['date'];
  this.teacher_id =  data['teacher_id'];
    this.subject_id = data['subject_id'];

}

Map<dynamic ,dynamic>  toJson(){

  return  {
  'id':  this.id ,
  'title': this.title ,
  'body':this.body ,
  'time': this.time ,
  'files': this.Files,
  'date' :  this.date ,
  'teacher_id':  this.teacher_id,
   "subject_id" :this.subject_id

  };
}


}