import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacher_side/models/subject.dart';

class Lecture {

 String id;
  String name;


  int time;
  List Files ;
ClassSubject subject;

Lecture(this.id, this.name ,this.Files,this.subject ,  this.time);

Lecture.fromJson(Map<dynamic ,dynamic> data){
  this.id =  data['id'];
  this.name = data['name']??'';
  this.Files =data['Files']??[];
  this.time =data['time']??DateTime.now();
  this.subject= ClassSubject.fromJson(data['subject']);

}

Map<dynamic ,dynamic>  toJson(){

  return  {
  'id':  this.id ,
  'name': this.name ,
  
  'time': this.time ,
  'files': this.Files,
  'subject': this.subject.toJson() ,

  };
}




}