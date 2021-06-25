import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/main_bloc.dart';
import 'package:teacher_side/bloc/subjects_bloc.dart';
import 'package:teacher_side/bloc/user_bloc.dart';
import 'package:teacher_side/models/event.dart';
import 'package:teacher_side/models/lecture.dart';
import 'package:teacher_side/models/subject.dart';
import 'package:teacher_side/screens/lecture_comments.dart';
import 'package:teacher_side/screens/lecture_disscusion.dart';

class MyLectures extends StatefulWidget {
  const MyLectures({Key key}) : super(key: key);

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyLectures> {
  @override
  Widget build(BuildContext context) {
    var subjectProvider = Provider.of<SubjectProvider>(context);
    var teacherProvider = Provider.of<UserBloc>(context);
    var main_provider = Provider.of<MainBloc>(context);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: new AppBar(
              title: Text(" المحاضرات "),
              centerTitle: true,
            ),
            body: Padding(
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder<List<Lecture>>(
                future: subjectProvider.geLectures(teacherProvider.getUser()),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Lecture>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return ListView(
                    children: snapshot.data.map((event) {
                      return Bounce(
                        duration: Duration(milliseconds: 200),
  onPressed: (){ 
  
  Get.to(LectureComments(event.id));
   },

                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Card(
                            
                            elevation: 3.0,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(event.name,
                                        style:
                                            TextStyle(fontWeight: FontWeight.bold)),
                          
                          
                                    Text(
                                        dateData(event.time))
                                  ],
                                )
                              ,
                          
                              Text(event.subject.name) ,
                          
                                                      Text(event.subject.department.name+"   "+event.subject.level.name),
                          
                            
                            
                            
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            )));
  }

  Future<ClassSubject> getSubjectName(String subject_id) async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('subject')
        .where('id', isEqualTo: subject_id)
        .get();

    if (data.docs.length > 0) {
      return ClassSubject.fromJson(data.docs.first.data());
    }
  }

  String dateData(int t) {
    var date = new DateTime.fromMillisecondsSinceEpoch(t);

    return "${date.day}-${date.month}-${date.year}";
  }
}
