import 'dart:convert';


import 'package:cloud_firestore/cloud_firestore.dart';

// model for  event

class Event{
  String id;
  String title;

  String body;
  Timestamp time;
  List Files ;




Event(this.id, this.title ,this.body ,this.Files);

Event.fromJson(Map<dynamic ,dynamic> data){
  this.id =  data['id'];
  this.title = data['title']??'';
  this.body =data['body']??'';
  this.time =data['time']??'';
  this.Files= data['files'];
  
}

Map<dynamic ,dynamic>  toJson(){

  return  {
  'id':  this.id ,
  'title': this.title ,
  'body':this.body ,
  'time': this.time ,
  'files': this.Files,


  };
}


}