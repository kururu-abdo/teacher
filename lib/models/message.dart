import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacher_side/models/chat_user.dart';

class Message{

String id;
String message;
Timestamp time;

User sender;
User receiver;

Message(this.id ,this.message , this.sender,this.receiver ,this.time );

Message.fromJson(Map<dynamic , dynamic> data){

this.id = data['id'];
this.message = data['message'];
this.time =  data['time'];
this.sender =  data['sender'];

this.receiver =  data['receiver'];

}
Map<dynamic , dynamic>   toJson(){
  return {
  'id': this.id ,
  'message':this.message ,
  'sender': this.sender ,
  'receiver':this.receiver ,
  'time': this.time
  };
}


}