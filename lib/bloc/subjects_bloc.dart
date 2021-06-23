import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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