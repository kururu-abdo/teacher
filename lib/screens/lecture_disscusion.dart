import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_filereader/flutter_filereader.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/user_bloc.dart';
import 'package:teacher_side/utils/days.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class LectureDisscusion extends StatefulWidget {
  final Map data;
  LectureDisscusion(this.data);

  @override
  _LectureDisscusionState createState() => _LectureDisscusionState();
}

class _LectureDisscusionState extends State<LectureDisscusion> {
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference comments =
        FirebaseFirestore.instance.collection('comments');
    var teacherProvider = Provider.of<UserBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('lecture Q & A  '),
          centerTitle: true, elevation: 0.0,
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Container(
                width: double.infinity,
                height: 250.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text('${widget.data['name']}'),
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: widget.data['files'].length > 0
                            ? Container(
                                height: 100,
                                child: 
                                ListView.builder(
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
                                              onPressed: () async{
                                                  // LecureFiles.remove(e);

                                                  var future =await   showCustomLoadingWidget(

                                                    Center(child: Material(child: Container(
                                                      width: 250 ,
                                                      height: 80 ,
                                                      child: Center(child:  Text('جاري حذف الملف'))
                                                      ,),),)
                                                  );
                       await    FirebaseFirestore.instance.collection("lectures").doc(widget.data['id'])
                          .update({"files" :  FieldValue.arrayRemove(file)});

future.dismiss();


                                              
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
                                ),
                                )
                            : Text('no document with this lecture'))
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text('التعليقات...'    ,   style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height :  10.0) ,
            Container(
              height: MediaQuery.of(context).size.height * 2 / 3,
              child: FutureBuilder<QuerySnapshot>(
                future: comments
                    .where('object_id', isEqualTo: widget.data['id'])
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


                      debugPrint(snapshot.data.docs[index].data()['time'].runtimeType.toString());
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
            maxLines:   5,
            decoration: InputDecoration(
                icon: IconButton(
                    icon: Icon(Icons.comment ,   color: Colors.blue,),
                    onPressed: () async {
                      var uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});
                      await comments.add({
                        'id': uuid.v1(),
                        'object_id': widget.data['id'],
                        'comment_text': controller.text,
                        'time': Timestamp.now(),
                        'commentator': <dynamic, dynamic>{
                          'id': teacherProvider.getUser().id,
                          'name': teacherProvider.getUser().name,
                          'role': 'أستاذ'
                        }
                      });

                      controller.text = '';
                      print('comment');
                    }),
                hintText: 'تعليق...' ,   hintStyle: TextStyle(color: Colors.black)),
          ),
        ));
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
