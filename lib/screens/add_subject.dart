import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_filereader/flutter_filereader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:load/load.dart';
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/services_provider.dart';
import 'package:teacher_side/models/dept.dart';
import 'package:teacher_side/models/level.dart';
import 'package:teacher_side/models/subject.dart';
import 'package:teacher_side/utils/backendless_init.dart';
import 'package:teacher_side/utils/constants.dart';
import 'package:teacher_side/utils/fcm_config.dart';
import 'package:teacher_side/utils/ui/custom_tween.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class NewLecture extends StatefulWidget {
  final ClassSubject subject;
  NewLecture(this.subject);

  @override
  _NewLectureState createState() => _NewLectureState();
}

class _NewLectureState extends State<NewLecture> {
  @override
  void initState() {
    super.initState();
  
      BackendlessInit().init();

  }

  final _formKey = GlobalKey<FormState>();
    TextEditingController titleController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("محاضرة جديدة"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            TextFormField(
              controller: titleController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'عنوان المحاضرة' ,
                 enabledBorder: UnderlineInputBorder(),
                 border: UnderlineInputBorder()
              
              ),
              
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'العنوان مطلوب';
                }
                return null;
              },
            ),
Spacer() ,
          
            MaterialButton(
                minWidth: 250,
                color: Colors.yellow,
                shape: RoundedRectangleBorder(

                  borderRadius :BorderRadius.all(Radius.circular(10.0))
                ),
                onPressed: () async {
if (_formKey.currentState.validate()) {
Get.to(()=>AddFilesToLecure(subject: widget.subject , title: titleController.text,))  ;
}



                },
                child: Text('متابعة '))

            // Add TextFormFields and ElevatedButton here.
          ])),
    );
  }
}

// FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
//   allowedFileExtensions: ['doc' ,'pdf' ,'ppt'],

//   allowedMimeTypes: ['application/*'],
//   invalidFileNameSymbols: ['/'],
// );

// final path = await FlutterDocumentPicker.openDocument(params: params);

//
class AddFilesToLecure extends StatefulWidget {
  final String title;
  final ClassSubject subject;
  const AddFilesToLecure({Key key ,this.subject ,  this.title}) : super(key: key);

  @override
  _AddFilesToLecureState createState() => _AddFilesToLecureState();
}

class _AddFilesToLecureState extends State<AddFilesToLecure> {

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

  void initPressed() async{
 await Backendless.setUrl(SERVER_URL);




  await   Backendless.initApp(
      
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
              height: MediaQuery.of(context).size.height/3,
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
                  }).toList()
           
           
              ),
            ),
Spacer() ,
        InkWell(
                onTap: () async{

              if (await serviceProvider.checkInternet()) {
                  var future = await showLoadingDialog();

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

                  Get.back();
                  future.dismiss();
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
                      color: Colors.yellow),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("نشر المحاضرة",textAlign: TextAlign.center,),
                  ),
                ),
              ) ,



            
          ],
        ),
      ),


      floatingActionButton: 
      new FloatingActionButton(onPressed: (){

_pickDocument();
      } , 
      
      child: Icon(Icons.add),
      
      ),
    );
  }
 _pickDocument() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['ppt', 'pdf', 'doc' , "pptx" ,  "png" ,"PNG" , "gif" ,  "jpg"   ,"jpeg" ,"JPEG"],

          allowMultiple: true);

          if (result != null) {
       LecureFiles = result.paths.map((path) => File(path)).toList();
      } else {
        LecureFiles =[];
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
          for (var file  in LecureFiles) {
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
            'body': 'تم إضافة محاضرة جديدة',
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





