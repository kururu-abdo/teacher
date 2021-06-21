import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/user_bloc.dart';
import 'package:teacher_side/utils/days.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
class LectureDetailsNotif extends StatefulWidget {

  static const id = '/lecture';
  @override
  _LectureDisscusionState createState() => _LectureDisscusionState();
}

class _LectureDisscusionState extends State<LectureDetailsNotif> {
TextEditingController controller = new TextEditingController();


  @override
  Widget build(BuildContext context) {

        final Map data = ModalRoute.of(context).settings.arguments;
         CollectionReference comments =
        FirebaseFirestore.instance.collection('comments');
    var teacherProvider = Provider.of<UserBloc>(context);

    return Scaffold(
    appBar: AppBar (title: Text('lecture Q & A  '),  centerTitle: true,),

   
   body: ListView(

children: [

  Padding(padding: EdgeInsets.only(top: 8.0) ,
  
  child: Container(
    width:double.infinity ,
    height: 250.0,

    decoration: BoxDecoration(
      color: Theme.of(context).accentColor,

    ),

    child: Stack(children: [
Align(
alignment: Alignment.topCenter,
child: Text('${data['name']}'),

) ,

Align(

  alignment: Alignment.bottomLeft ,
  child:data['files'].length>0? Container(
    height: 100  ,
    
    child:ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: data['files'].length,
      itemBuilder: (BuildContext context, int index) {
      return  Container(
        height: 80,
        width: 80,
      
        child: Card(
          
          child:Column(children: [
            Text('file ${index+1}') ,

            IconButton(icon: Icon(Icons.download_rounded), onPressed: (){

              
            })


          ],)
        ),
      );
     },
    ),
  ) :  Text('no document with this lecture')

)


    ],),
  ),
  
  ) ,

  SizedBox(height:10.0) ,
  Container(
    decoration: BoxDecoration(
      boxShadow:[BoxShadow(blurRadius: 2.0 ,  color:Colors.black38)]
    ),
    child: Text('التعليقات...')) ,
Container(
              height: MediaQuery.of(context).size.height * 2 / 3,
              child: FutureBuilder<QuerySnapshot>(
                future: comments
                    .where('object_id', isEqualTo: data['id'])
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            // borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            color: Colors.blue[300]),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(snapshot.data.docs[index]
                                  .data()['commentator']['name']),
                              subtitle: Text(snapshot.data.docs[index]
                                  .data()['commentator']['role']),
                            ),
                            Text(
                              snapshot.data.docs[index].data()['comment_text'],
                              maxLines: 20,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            // Text(snapshot.data.docs[index].data()['time'].toString()),
                            dateFormatWidget(
                                snapshot.data.docs[index].data()['time'])
                          ],
                        ),
                      );
                      return Text(snapshot.data.docs[index].data().toString());
                    },
                  );
                },
              ),
            ),



],





   ),

 bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
                icon: IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () async {
                      var uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});
                      await comments.add({
                        'id': uuid.v1(),
                        'object_id': data['id'],
                        'comment_text': controller.text,
                        'time': Timestamp.now(),
                        'commentator': <dynamic, dynamic>{
                          'id': teacherProvider.getUser().id,
                          'name': teacherProvider.getUser().name,
                          'role': 'أستاذ'
                        }
                      });





controller.text='';
                      print('comment');
                    }),
                hintText: 'comment...'),
          ),
        )


    );
  }


  

  Widget dateFormatWidget(Timestamp time) {
    DateTime date = time.toDate();
    var now = DateTime.now();
    var nowDay = now.weekday;
    var day = date.weekday;

    print(day);
    // print(Days.values[Days.values[day].index]);
    return Container(
      child: Text(getDayText(nowDay, day)),
    );
  }
String getDayText(int nowDay, int day) {
    if (nowDay == day) {
      return 'اليوم';
    } else if (nowDay - day == 1) {
      return 'الأمس';
    } else {
      return Days.values[day - 1].toString();
    }
  }
}