import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_preview/flutter_file_preview.dart';
import 'package:flutter_filereader/flutter_filereader.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:load/load.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/services_provider.dart';
import 'package:teacher_side/bloc/user_bloc.dart';
import 'package:teacher_side/models/dept.dart';
import 'package:teacher_side/models/level.dart';
import 'package:teacher_side/models/subject.dart';
import 'package:teacher_side/screens/login/login_view.dart';
import 'package:teacher_side/utils/backendless_init.dart';
import 'package:teacher_side/utils/constants.dart';
import 'package:teacher_side/utils/days.dart';
import 'package:teacher_side/utils/fcm_config.dart';
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

ClassSubject classSubject;

@override
void initState() { 
  super.initState();
  fetchSubjectData() ;
}

fetchSubjectData() async{
var data = await  FirebaseFirestore.instance.collection("subject")
   .where("id"  , isEqualTo:  widget.data['id'])
   .get();

if (data.docs.length>0) {
  
setState(() {
  classSubject = ClassSubject.fromJson(data.docs.first.data());
});


}

}



  @override
  Widget build(BuildContext context) {
    CollectionReference comments =
        FirebaseFirestore.instance.collection('comments');
    var teacherProvider = Provider.of<UserBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('lecture Q & A  '),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Container(
              width: double.infinity,
              height: 250.0,
              decoration: BoxDecoration(
                color: Colors.green[200].withOpacity(0.5),
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
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.data['files'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  var file = widget.data['files'][index];
                                  if (file.endsWith("jpg") ||
                                      file.endsWith("jpeg") ||
                                      file.endsWith("png")) {
                                    return Stack(children: [
                                      InkWell(
                                        onTap: () async {
                                          await FlutterFilePreview.openFile(
                                              file,
                                              title: widget.data['body']);
                                        },
                                        child: Container(
                                          height: 100,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    file,
                                                  ),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                            onPressed: () async {
                                              // LecureFiles.remove(e);

                                              var future =
                                                  await showCustomLoadingWidget(
                                                      Center(
                                                child: Material(
                                                  child: Container(
                                                    width: 250,
                                                    height: 80,
                                                    child: Center(
                                                        child: Text(
                                                            'جاري حذف الملف')),
                                                  ),
                                                ),
                                              ));
                                              await FirebaseFirestore.instance
                                                  .collection("lectures")
                                                  .doc(widget.data['id'])
                                                  .update({
                                                "files":
                                                    FieldValue.arrayRemove(file)
                                              });

                                              future.dismiss();
                                            },
                                            icon: Icon(
                                              Icons.highlight_off,
                                              color: Colors.red,
                                            )),
                                      ),
                                    ]);
                                  } else if (file.endsWith("pdf")) {
                                    return InkWell(            
                                      onTap: () async {
//     final _result =
//                                             await OpenFile.open(file);
// debugPrint(_result.message);
//                                    //     Get.to(OpenFile(url:  file   ));

                                        await FlutterFilePreview.openFile(file,
                                            title: widget.data['body']);
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 100,
                                            child: Container(
                                                height: 80,
                                                child: Center(
                                                  child: Text("PDF"),
                                                )
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
                                      ),
                                    );
                                  } else {
                                    return InkWell(
                                      onTap: () async {
                                        await FlutterFilePreview.openFile(file,
                                            title: widget.data['body']);
                                      },
                                      child: Stack(
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
                                      ),
                                    );
                                  }
                                },
                              ),
                            )
                          : Text('no document with this lecture'))
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Text('التعليقات...', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10.0),
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
                    debugPrint(snapshot.data.docs[index]
                        .data()['time']
                        .runtimeType
                        .toString());
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      color: Colors.green[200].withOpacity(0.5),

                          
                          ),
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
          maxLines: 3,
          decoration: InputDecoration(
              icon: IconButton(
                  icon: Icon(
                    Icons.comment,
                    color: Colors.blue,
                  ),
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
    var response = await http.post(
                      Uri.parse('https://fcm.googleapis.com/fcm/send'),
                      headers: <String, String>{
                        'Content-Type': 'application/json',
                        'Authorization': 'key=$serverToken',
                      },
                      body: jsonEncode(
                        <String, dynamic>{
                          'notification': <String, dynamic>{
                            'body': 'تم االتعليق    من قبل الاستاذ ',
                            'title': ':تم إضافة تعليق'
                          },
                          'priority': 'high',
                          'data': <String, dynamic>{
                            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                            'id': '1',
                            'status': 'done',
                            'screen': 'consults',
                           'data': {
                              "id": widget.data['id'].toString(),
                              "type": 'comment'
                            }
                          },
                          'to': '/topics/lecture${widget.data['id']}'
                        },
                      ),
                    );

                    controller.text = '';
                    print('comment');
                  }),
              hintText: 'تعليق...',
              hintStyle: TextStyle(color: Colors.black)),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //     onPressed: () {
      //       // add files to  lecture
      //     },
      //     label: Row(
      //       children: [Icon(Icons.add_a_photo_rounded), Text("اضافة ملفات")],
      //     )),
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

class AddMoreFilesToLecure extends StatefulWidget {
  final String title;
  final ClassSubject subject;
  const AddMoreFilesToLecure({Key key, this.subject, this.title}) : super(key: key);

  @override
  _AddFilesToLecureState createState() => _AddFilesToLecureState();
}

class _AddFilesToLecureState extends State<AddMoreFilesToLecure> {
  Department dept;
  TextEditingController titleController = new TextEditingController();
  List<File> LecureFiles = [];
  List FilesTouploads = [];
  DocumentSnapshot lecture_data;
  Level level;

  String lecture_id;

  String _path = '-';
  bool _pickFileInProgress = false;
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;
  bool _checkByMimeType = false;
  static const String SERVER_URL = "https://api.backendless.com";
  static const String APPLICATION_ID = "F698C529-1FF3-871A-FF6D-52A0154D3600";
  static const String ANDROID_API_KEY = "3BA6F57F-CA1D-43E5-AA56-AEBFDFD5982B";
  static const String IOS_API_KEY = "72521EEB-F3A3-40E4-A1C6-18A539269C0D";
  static const String JS_API_KEY = "5EB0896C-52DA-477C-AE1B-99AE73291C23";

  void initPressed() async {
    await Backendless.setUrl(SERVER_URL);

    await Backendless.initApp(
      applicationId: APPLICATION_ID,
      androidApiKey: ANDROID_API_KEY,
      iosApiKey: IOS_API_KEY,
      // jsApiKey: JS_KEY,
    );
  }

  @override
  void initState() {
    super.initState();
    BackendlessInit().init();
    initPressed();
    Backendless.initApp(
        applicationId: APPLICATION_ID,
        androidApiKey: ANDROID_API_KEY,
        iosApiKey: IOS_API_KEY);
  }

  @override
  Widget build(BuildContext context) {
    var serviceProvider = Provider.of<ServiceProvider>(context);

    return Scaffold(
      appBar: new AppBar(
        title: Text("إضافة ملفات "),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  children: LecureFiles.toSet().map((e) {
                    if (e.path.endsWith("jpg") ||
                        e.path.endsWith("jpeg") ||
                        e.path.endsWith("pnf")) {
                      return Stack(children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(
                                    File(e.path),
                                  ),
                                  fit: BoxFit.cover)),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  LecureFiles.remove(e);
                                });
                              },
                              icon: Icon(
                                Icons.highlight_off,
                                color: Colors.red,
                              )),
                        ),
                      ]);
                    } else if (e.path.endsWith("pdf")) {
                      return Stack(
                        children: [
                          Container(
                            height: 100,
                            child: PDFView(
                              filePath: e.path,
                              enableSwipe: true,
                              swipeHorizontal: true,
                              autoSpacing: false,
                              pageFling: false,
                              onRender: (_pages) {
                                setState(() {});
                              },
                              onError: (error) {
                                print(error.toString());
                              },
                              onPageError: (page, error) {
                                print('$page: ${error.toString()}');
                              },
                              onViewCreated:
                                  (PDFViewController pdfViewController) {
                                // _controller.complete(pdfViewController);
                              },
                              onPageChanged: (int page, int total) {
                                print('page change: $page/$total');
                              },
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    LecureFiles.remove(e);
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
                              filePath: e.path,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    LecureFiles.remove(e);
                                  });
                                },
                                icon: Icon(
                                  Icons.highlight_off,
                                  color: Colors.red,
                                )),
                          ),
                        ],
                      );
                    }
                  }).toList()),
            ),
            Spacer(),
            InkWell(
              onTap: () async {
                if (await serviceProvider.checkInternet()) {
                  LoadingDialog.show(context);

                  await UploadFilesToBackendless();
//

                  await Future.delayed(Duration(seconds: 2));

//send data to the firebase

                  FilesTouploads.forEach((element) async {
                    print('////////////////////////////////////////');
                    print(element);
                  });
                  CollectionReference lecture =
                      FirebaseFirestore.instance.collection('lectures');

                  var uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});
                  var data = await lecture.add({
                    'id': uuid.v1(),
                    'subject': widget.subject.toJson(),
                    'time': DateTime.now().millisecondsSinceEpoch,
                    'name': widget.title, // John Doe
                    'files': FilesTouploads, // Stokes and Sons
                    'subject_id': widget.subject.id
                  });
                  // .then((value) => print("lecures Added"))
                  // .catchError((error) => print("Failed to add user: $error"));

                  var firebase_data = await data.get();
                  setState(() {
                    lecture_data = firebase_data;
                    lecture_id = firebase_data.data()['id'];
                  });
                  FCMConfig.subscripeToTopic('lecture${lecture_id}');

                  var notification = await sendAndRetrieveMessage();
                  print('notification status');
                  print(notification);

                  LoadingDialog.hide(context);

                  Get.back();
                } else {
                  Fluttertoast.showToast(
                      msg: "تأكد من اتصال البيانات",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 255, 157, 46)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "تحديث المحاضرة",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _pickDocument();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _pickDocument() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: [
            'ppt',
            'pdf',
            'doc',
            "pptx",
            "png",
            "PNG",
            "gif",
            "jpg",
            "jpeg",
            "JPEG"
          ],
          allowMultiple: true);

      if (result != null) {
        LecureFiles = result.paths.map((path) => File(path)).toList();
      } else {
        LecureFiles = [];
      }
      // setState(() {
      //   LecureFiles.addAll(result.files);
      // });

    } catch (e) {
      print(e);
      // result = 'Error: $e';
    } finally {
      setState(() {
        // _pickFileInProgress = false;
      });
    }

    // setState(() {
    //   _path = result;
    // });

    debugPrint(_path);
  }

  Future<void> UploadFilesToBackendless() async {
    for (var file in LecureFiles) {
      var url = await Backendless.files.upload(File(file.path), 'lectures',
          overwrite: true, onProgressUpdate: (value) {});

      FilesTouploads.add(url);
    }

    // LecureFiles.forEach((file) async {
    //  print(file.path);

    // print(url);
    // });

    await Future.delayed(Duration(seconds: 2));
  }

  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    // await firebaseMessaging.requestNotificationPermissions(
    // );

    debugPrint('sending .......');

//https://gcm-http.googleapis.com/gcm/send
//https://fcm.googleapis.com/fcm/send
    var response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
// <String ,dynamic>{
//   "message":<String ,dynamic>{
//   "topic" :"general" ,
//  'to': await firebaseMessaging.getToken(),
//   "notification": <String ,dynamic>{
//         "body":"This is an FCM notification message!",
//         "title":"FCM Message"
//       },

//   'priority': 'high',

//   "data" : <dynamic ,dynamic>{
//          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//          'id': '1',
//          'status': 'done' ,
//          'screen' :'Lectures'
//       }
//   }
// }

        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'تم إضافة ملفات جديدة',
            'title': 'محاضرة${widget.subject.name}'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'screen': 'lecture_details',
            'lecture': lecture_data.data()
          },
          'to':
              '/topics/${widget.subject.department.dept_code}${widget.subject.level.id.toString()}'
        },
      ),
    );

    // final Completer<Map<String, dynamic>> completer =
    //    Completer<Map<String, dynamic>>();

    // firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     completer.complete(message);
    //   },
    // );

    // return completer.future;

    debugPrint(response.body);
  }
}
