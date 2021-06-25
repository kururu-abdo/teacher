import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_side/models/event.dart';
import 'package:teacher_side/models/lecture.dart';
import 'package:teacher_side/models/subject.dart';
import 'package:teacher_side/models/teacher.dart';

class SubjectProvider   {



  Stream<List<ClassSubject>> getMySubjects(Teacher teacher)async*{
  debugPrint(teacher.toJson().toString());


try {
   QuerySnapshot data = await FirebaseFirestore.instance
          .collection('subject')
          .where('teacher_id', isEqualTo: teacher.id.toString())
          .where('semester', isEqualTo: teacher.semester.toJson())
          .get();

          
  data.docs.map((e) => print(e.data()));
      List<ClassSubject> subjects =
        data.docs.map((e) => ClassSubject.fromJson(e.data())).toList();


      yield subjects;
} catch (e) {
  print(e);
}


  }

 Future<List<Event>> getMyEvents(Teacher teacher) async {
     List<Event> events =[];
    try {
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection('subject-events')
          .where('teacher_id', isEqualTo: teacher.id.toString())
          .orderBy("date" )
          .get();
if (data.docs.length>0) {
     debugPrint("kdjfldsjhflsdahfglkashogsodgo");
   debugPrint(data.docs.first.data().toString());
    
    events=        data.docs.map((e) => Event.fromJson(e.data())).toList();

       
}
 return events;

    } catch (e) {
      print(e);
    }
  }


Future<List<Lecture>> geLectures(Teacher teacher) async {
    List<Lecture> events = [];
    try {
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection('lectures')
          .where('subject.teacher_id', isEqualTo: teacher.id.toString())
         
          .get();
      if (data.docs.length > 0) {
        debugPrint("kdjfldsjhflsdahfglkashogsodgo");
        debugPrint(data.docs.first.data().toString());

        events = data.docs.map((e) => Lecture.fromJson(e.data())).toList();
      }
      return events;
    } catch (e) {
      print(e);
    }
  }




 Stream<List<ClassSubject>> getMySubjects2(Teacher teacher) async* {
    debugPrint(teacher.toJson().toString());

    try {
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection('subject')
          .where('teacher_id', isEqualTo: teacher.id.toString())
          .where('semester', isEqualTo: teacher.semester.toJson())
          .limit(2)
          .get();

      data.docs.map((e) => print(e.data()));
      List<ClassSubject> subjects =
          data.docs.map((e) => ClassSubject.fromJson(e.data())).toList();

      yield subjects;
    } catch (e) {
      print(e);
    }
  }


  Stream<List<Map>> getMyTable(Teacher teacher ,  Map day) async* {
    debugPrint(teacher.toJson().toString());

    try {
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection('table')
         .where('subject.teacher_id', isEqualTo: teacher.id.toString())
          .where('subject.semester', isEqualTo: teacher.semester.toJson())
          .where('day', isEqualTo: day)
          .get();
     List<Map> subjects=[];    
for (var item in data.docs) {
  subjects.add(item.data());
}
      yield subjects;

      subjects.forEach((element) {debugPrint(element.toString());});
    } catch (e) {
      print(e);
    }
  }

Stream<List<Map>> getMyTableOneSubject(Teacher teacher ) async* {
    debugPrint(teacher.toJson().toString());

    try {
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection('table')
         .where('subject.teacher_id', isEqualTo: teacher.id.toString())
          .where('subject.semester', isEqualTo: teacher.semester.toJson())
          .limit(1)
          .get();
     List<Map> subjects=[];    
for (var item in data.docs) {
  subjects.add(item.data());
}
      yield subjects;

      subjects.forEach((element) {debugPrint(element.toString());});
    } catch (e) {
      print(e);
    }
  }



  
}