import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String id;
  String comment_text;
Commentator commentator;
String object_id;
Timestamp time;
CommentModel.fromJson(Map<String , dynamic>  data){
  this.comment_text =  data["comment_text"];
  this.commentator =  Commentator.fromJson(data['commentator']);
  this.object_id =  data['object_id'];
  this.time =  data['time'];
}



Map<String, dynamic>  toJson()=>{

  "comment_text":  this.comment_text ,
  "commentator":  this.commentator.toJson() ,
  "object_id": this.object_id ,
  "time": this.time
};

}

class Commentator {

String id;
String name;
String role;
Commentator(this.id ,  this.name ,  this.role);

 Commentator.fromJson(Map<String, dynamic> data){
this.id = data['id'];
this.name= data['name'];
this.role =  data['role'];
 } 

Map<String, dynamic>  toJson()=>{
  "id":  this.id,
  "name":  this.name ,
  "role":  this.role
};


 @override
  bool operator ==(other) {
return  this.id ==other.id&&this.name==other.name&&this.role==other.role;

  }

}