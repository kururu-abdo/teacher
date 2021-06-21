import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/main_bloc.dart';
import 'package:teacher_side/bloc/subjects_bloc.dart';
import 'package:teacher_side/bloc/user_bloc.dart';
import 'package:teacher_side/models/semester.dart';
import 'package:teacher_side/models/subject.dart';
import 'package:teacher_side/screens/subject_details.dart';

class MySubjects extends StatefulWidget {
// final Teacher teacher;

//   MySubjects(this.teacher);

  @override
  _MySubjectsState createState() => _MySubjectsState();
}

class _MySubjectsState extends State<MySubjects> {

@override
void initState() { 
  super.initState();
  
  //fetch_semesters();
}

List<Semester> semesters =[];
Semester semester;

fetch_semesters() async{
var future = await showLoadingDialog();

 FirebaseFirestore firestore = FirebaseFirestore.instance;


var level=    firestore.collection('semester');



var fetchedSemester =  await level.get();

Iterable I = fetchedSemester.docs;

setState(() {
  
  semesters =   I.map((e) => Semester.fromJson(e.data()) ).toList();
  
});


  future.dismiss();
}


  @override
  Widget build(BuildContext context) {
    var subjectProvider =  Provider.of<SubjectProvider>(context);
    var teacherProvider =  Provider.of<UserBloc>(context);

    return SafeArea(
      child: Container(

         height: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blue[200]
            
            ),
      child: ListView(children: [

SizedBox(height:50.0),
StreamBuilder<List<ClassSubject>>(
  stream: subjectProvider.getMySubjects(teacherProvider.getUser()) ,
 
  builder: (BuildContext context, AsyncSnapshot<List<ClassSubject>> snapshot){
     if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
      return Container(
        height: MediaQuery.of(context).size.height-150,
        child: ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
           
          return   Container(
            margin: EdgeInsets.all(5.0),

              decoration:BoxDecoration(
  color: Colors.grey[500].withOpacity(0.5),
                      borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(20.0),
                                right: Radius.circular(20.0),
                              ),
  ),
             width: double.infinity,
            child:ListTile(

              leading: Icon(FontAwesomeIcons.bookOpen),
              onTap:(){
  Get.to(()=>SubjectDetails(snapshot.data[index]));


              },
              subtitle:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                Text(snapshot.data[index].department.name),
                   Text(snapshot.data[index].level.name),
              ]),
              title: Text(snapshot.data[index].name ,
                
                style: TextStyle(fontSize: 20.0 ,  fontWeight: FontWeight.bold),))
          );
         },
        )
      );
  },
),



      ],),          
      ),
    );
  



    // ListTile(title: Text("ListTile"),
    //      subtitle: Text("Sample Subtitle. \nSubtitle line 3"),
    //      trailing: Icon(Icons.home),
    //      leading: Icon(Icons.add_box),
    //      isThreeLine: true,
    //      onLongPress: (){
    //         print("User has long pressed on the Tile");
    //      },
//)
  }
}