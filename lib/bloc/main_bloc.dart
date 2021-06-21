import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:teacher_side/models/chat_user.dart';
import 'package:teacher_side/models/event.dart';
import 'package:teacher_side/models/semester.dart';
import 'package:teacher_side/models/subject.dart';
import 'package:teacher_side/models/teacher.dart';
import 'package:teacher_side/utils/constants.dart';
import 'package:teacher_side/utils/fcm_config.dart';

class MainBloc  extends ChangeNotifier {
MainBloc(){
  // fetch_subjects();
  fetch_events();
}

PublishSubject<List<ClassSubject>> subject_stream =  PublishSubject<List<ClassSubject>>();



Stream<List<ClassSubject>> get  subs=> subject_stream.stream;
Sink<List<ClassSubject>>  get subs_sink => subject_stream.sink;

   
PublishSubject<List>  events = new PublishSubject<List>();

Stream<List> get  evnts=> events.stream;
Sink<List>  get evnts_sink => events.sink;


List notifications  =[];

List getNotifictions () {
  List  lists =  json.decode(getStorage.read('notifications'))??[];


print(lists.length);
  return lists;
}

Future updateNotfications(Map<dynamic ,dynamic> data) async {
 List  lists =  json.decode(getStorage.read('notifications'))??[];
  lists.add(data);

  await getStorage.write('notifications', json.encode(lists));
//List lists =  json.encode(value)

}


 Stream<List<Event>> getEvents() async* {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('events')
        .where('dept', isEqualTo: null)
         .where('level', isEqualTo: null)
        .get();
    List<Event> evnt =
        data.docs.map((e) => Event.fromJson(e.data())).toList();

    evnt.forEach((element) {
      print(element.title);
    });

    yield evnt;
  }


Stream<List<ClassSubject>> fetch_subjects2(Teacher teacher , Semester semester) async*{
  QuerySnapshot data =await FirebaseFirestore.instance
  .collection('subject')
  // .where('teacher' , isEqualTo: teacher.toJson())
  .where('semester' , isEqualTo: Semester(1, 'السمستر الأول').toJson())
  
   .get();
    


try {

  
      List<ClassSubject> subjects =
          data.docs.map((e) => ClassSubject.fromJson(e.data())).toList();

      subjects.forEach((element) {
        print('/////////');
        print(element.name);
      });
     yield subjects;
      // subs_sink.add(subjects);
      // subject_stream.add(subjects);
      // subject_stream.sink.add(subjects);
    } catch (e) {
      print('an error occured    ${e}');
    }
 
}

fetch_subjects() async{
  QuerySnapshot data =await FirebaseFirestore.instance
  .collection('subject')
 
  .get();
  print(data.docs.first.data());
try {
  List<ClassSubject>  subjects =data.docs.map((e) =>  ClassSubject.fromJson(e.data()) ).toList();

subjects.forEach((element) {print(element.name);});

  subs_sink.add(subjects);
  subject_stream.add(subjects);
  subject_stream.sink.add(subjects);
} catch (e) {

  print('an error occured    ${e}');
}
 
 // notifyListeners();
}





fetch_events() async{
  QuerySnapshot data =await FirebaseFirestore.instance
  .collection('subject-events')
 
  .get();
  print(data.docs.first.data());
try {
//  List  subjects =data.docs.map((e) =>  ClassSubject.fromJson(e.data()) ).toList();


evnts_sink.add(data.docs);
  events.add(data.docs);
 events.sink.add(data.docs);
} catch (e) {

  print('an error occured    ${e}');
}
 
 // notifyListeners();
}



 Stream<List<User>> getChatUsers (Teacher teacher)async*{
try {
  
 var token = await  FCMConfig.getToken();
 QuerySnapshot data = await FirebaseFirestore.instance
          .collection('messages')
         .where('receiver', isEqualTo: <dynamic, dynamic>{
        'id': teacher.id,
        'name': teacher.name,
        'role': 'أستاذ' ,
    
      })
      
      .get();

      List<User>  users = [];
      List list = data.docs;



     users =  list.map((chat) => User.fromJson(chat['sender'])).toList();
var uniques = new LinkedHashMap<String, User>();

     for (var s in users) {
        uniques[s.id] = s;
      }
       users=[];
      for (var key in uniques.values) {
      
       users.add(key);
      }

//print(unique.length);
yield users;
for (var user in users) {
  print(user.toJson());
}
} catch (e) {

  print(e);
}


}



}