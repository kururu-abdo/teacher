import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teacher_side/models/teacher.dart';
import 'package:teacher_side/utils/constants.dart';
import 'package:teacher_side/utils/days.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
class EventDeitalsNotif extends StatefulWidget {

  static const id= '/event';

  @override
  _LectureDisscusionState createState() => _LectureDisscusionState();
}

class _LectureDisscusionState extends State<EventDeitalsNotif> {
TextEditingController _controller =  new TextEditingController();




@override
void initState() { 
  super.initState();
  get_teacher();
}
Teacher teacher;
get_teacher(){
  setState(() {
      teacher =  Teacher.fromJson(json.decode(getStorage.read('teacher')));
    });

   

}


  @override
  Widget build(BuildContext context) {
final Map data = ModalRoute.of(context).settings.arguments;
     CollectionReference comments = FirebaseFirestore.instance.collection('comments');
    return Scaffold(
      resizeToAvoidBottomInset: false,
    appBar: AppBar (title: Text('details '),  centerTitle: true,),

   
   body: ListView(

children: [

  Padding(padding: EdgeInsets.only(top: 8.0) ,
  
  child: Container(
    width:double.infinity ,
    height: 200.0,

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
  child: data['files'].length>0? 
  
  
  
  Container(
    height: 100  ,
    
    child:ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: data['files'].length,
      itemBuilder: (BuildContext context, int index) {
        debugPrint(data['files'][index]);
      return 
      Container(
        width:100,
  height: 100,
        child: Image.network(data['files'][index]));
     
      
      Container(
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
  height: MediaQuery.of(context).size.height*2/3,
  child: FutureBuilder<QuerySnapshot>(
    future: comments.where('object_id' ,isEqualTo: data['id']).get(),

    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
       if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
   
      return  ListView.builder(
        itemCount: snapshot.data.docs.length,
        itemBuilder: (BuildContext context, int index) {

          return
          Container(
            
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
                          ) ,
                            Text(
                            snapshot.data.docs[index].data()['comment_text']
                              , maxLines: 20,) ,
                              SizedBox(height: 10.0,) ,
                              // Text(snapshot.data.docs[index].data()['time'].toString()),
                              dateFormatWidget( snapshot.data.docs[index].data()['time'])

              ],
            ),
          )
         ;
        return     Text(snapshot.data.docs[index].data().toString());
       },
      );
    },
  ),


) ,





],





   ),
// floatingActionButton: Container(
//   height: 40,

  
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.all(Radius.circular(20)),
//     color: Colors.teal
//   ),
//   child: Text('add comment')

// ,
// ),
 bottomNavigationBar: Padding(padding: MediaQuery.of(context).viewInsets,
   child:TextField(
    controller: _controller,
     decoration: InputDecoration(
       
     icon: IconButton(icon: Icon(Icons.comment), onPressed: () async{
var uuid = Uuid(
    options: {'grng': UuidUtil.cryptoRNG}
);
   await comments.add({
     'id':uuid.v1(),
      'object_id': data['id'],
       'comment_text':  _controller.text ,
       'time': Timestamp.now() ,
       'commentator':  <dynamic ,dynamic>{
         'id':teacher.id,
         'name':teacher.name ,
         'role':'أستاذ'
       }


   });
     _controller.text='';
        print('comment');
      }),   
       hintText: 'comment...'
     ),
     
   ), 
  )
    );
  }



        DateTime convertTimeStampToDateTime(int timeStamp) {
     var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
     return dateToTimeStamp;
   }

  String convertTimeStampToHumanDate(int timeStamp) {
    var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return DateFormat('dd/MM/yyyy').format(dateToTimeStamp);
  }

   String convertTimeStampToHumanHour(int timeStamp) {
     var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
     return DateFormat('HH:mm').format(dateToTimeStamp);
   }



  Widget dateFormatWidget(Timestamp time){
   DateTime date =  time.toDate();  
   var now =DateTime.now();
     var nowDay =   now.weekday;
     var day = date.weekday;

  print(day);
 // print(Days.values[Days.values[day].index]);
return Container( child: Text(getDayText(nowDay, day)),   );
  }
  
String getDayText(int nowDay, int day) {
if (nowDay==day) {
  return 'اليوم';
} else if(nowDay-day==1) {
   return 'الأمس';
}else{
  return Days.values[day-1].toString();
}


}
  }



