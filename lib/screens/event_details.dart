import 'dart:convert';
import 'dart:ui';
import 'package:flutter_filereader/flutter_filereader.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teacher_side/models/teacher.dart';
import 'package:teacher_side/utils/constants.dart';
import 'package:teacher_side/utils/days.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
class EventDeitals extends StatefulWidget {

  final Map  data;
  EventDeitals(this.data);

  @override
  _LectureDisscusionState createState() => _LectureDisscusionState();
}

class _LectureDisscusionState extends State<EventDeitals> {
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

    debugPrint(widget.data['id']);

}


  @override
  Widget build(BuildContext context) {
     CollectionReference comments = FirebaseFirestore.instance.collection('comments');
    return Scaffold(
      resizeToAvoidBottomInset: false,
    appBar: AppBar (title: Text('details '),  
    
    elevation: 0.0,
    centerTitle: true,),

   
   body: ListView(

children: [

  Padding(padding: EdgeInsets.only(top: 8.0) ,
  
  child: Container(
    width:double.infinity ,
    height: 200.0,

    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,

    ),

    child: Stack(children: [
Align(
alignment: Alignment.topCenter,
child: Text('${widget.data['name']}'),

) ,

Align(

  alignment: Alignment.bottomLeft ,
  child: widget.data['files'].length>0? 
  
  
  
  Container(
    height: 100  ,
    
    child:ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.data['files'].length,
      itemBuilder: (BuildContext context, int index) {

         var file =   widget.data['files'][index];
                                  if (file.endsWith("jpg") ||
                                        file.endsWith("jpeg") ||
                                        file.endsWith("png")) {
                                      return Stack(children: [
                                        Container(
                                          height: 100,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    file,
                                                  ),
                                                  fit: BoxFit.cover)),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  // LecureFiles.remove(e);
                                                });
                                              },
                                              icon: Icon(
                                                Icons.highlight_off,
                                                color: Colors.red,
                                              )),
                                        ),
                                      ]);
                                    } else if (file.endsWith("pdf")) {
                                      return Stack(
                                        children: [
                                          Container(
                                            height: 100,
                                            child: 
                                    Container(height: 80,child: Center(child: Text("PDF"),) 
                                            // PDFView(
                                            //   filePath: file,
                                            //   enableSwipe: true,
                                            //   swipeHorizontal: true,
                                            //   autoSpacing: false,
                                            //   pageFling: false,
                                            //   onRender: (_pages) {
                                            //     setState(() {});
                                            //   },
                                            //   onError: (error) {
                                            //     print(error.toString());
                                            //   },
                                            //   onPageError: (page, error) {
                                            //     print(
                                            //         '$page: ${error.toString()}');
                                            //   },
                                            //   onViewCreated: (PDFViewController
                                            //       pdfViewController) {
                                            //     // _controller.complete(pdfViewController);
                                            //   },
                                            //   onPageChanged:
                                            //       (int page, int total) {
                                            //     print(
                                            //         'page change: $page/$total');
                                            //   },
                                            // ),
                                          ),),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    // LecureFiles.remove(e);
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.highlight_off,
                                                  color: Colors.red,
                                                )),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Stack(
                                        children: [
                                          Container(
                                            height: 100,
                                            child: FileReaderView(
                                              filePath: file,
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    // LecureFiles.remove(e);
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.highlight_off,
                                                  color: Colors.red,
                                                )),
                                          ),
                                        ],
                                      );}
                                 },


//         debugPrint(widget.data['files'][index]);
  
//         return



// GestureDetector(
//   onTap: (){


//     Navigator.push(context, MaterialPageRoute(builder: (_){
//   return Material(child: Hero(tag:  index.toString(), child: Container(

// decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(
//                                                                 "${widget.data['files'][index]}"))),

//   )),);
//     }));
//   },
//   child: Image.network("${widget.data['files'][index]}"));



  //     Container(
  //       width:100,
  // height: 100,
  //       child: Image.network(widget.data['files'][index]));
    
      
   
    //   Container(
    //     height: 80,
    //     width: 80,
      
    //     child: Card(
          
    //       child:Column(children: [
    //         Text('file ${index+1}') ,

    //         IconButton(icon: Icon(Icons.download_rounded), onPressed: (){

              
    //         })


    //       ],)
    //     ),
    //   );
    //  },
    ),
  ) :  Text('no document with this lecture')

)


    ],),
  ),
  
  ) ,

  SizedBox(height:10.0) ,
  Text('التعليقات...' ,  style: 
  
  
  
  
  
  
  
  
  
  TextStyle(color: Colors.white),) ,
Container(
  height: MediaQuery.of(context).size.height*2/3,
  child: FutureBuilder<QuerySnapshot>(
    future: comments.where('object_id' ,isEqualTo: widget.data['id']).get(),

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
    maxLines: 3,
     decoration: InputDecoration(
       
     icon: IconButton(icon: Icon(Icons.comment ,  color: Colors.white,), onPressed: () async{
var uuid = Uuid(
    options: {'grng': UuidUtil.cryptoRNG}
);
   await comments.add({
     'id':uuid.v1(),
      'object_id': widget.data['id'],
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
       hintText: 'تعليق...'  ,  hintStyle: TextStyle(color: Colors.white)
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

Widget dateFormatWidget(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    // var now = DateTime.now();
    // var nowDay = now.weekday;
    // var day = date.weekday;

    var format = new DateFormat('d MMM, hh:mm a');
    // var date = new DateTime.fromMillisecondsSinceEpoch(t);
    var formattedDate = DateFormat.yMMMd().format(date); // Apr 8, 2020

    var now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var formattedToday = DateFormat.yMMMd().format(today);

    final yesterday = DateTime(now.year, now.month, now.day - 1);
    var formattedYesterDay = DateFormat.yMMMd().format(yesterday);

    String time = '';

    if (formattedDate == formattedToday) {
      time = "اليوم";
    } else if (formattedDate == formattedYesterDay) {
      time = "الأمس";
    } else {
      time = formattedDate;
    }

    return Container(
      child: Text(time),
    );
    // print(day);
    // print(Days.values[Days.values[day].index]   );
    // return Container(
    //   child: Text(getDayText(nowDay, day)),
    // );
  }
  }



