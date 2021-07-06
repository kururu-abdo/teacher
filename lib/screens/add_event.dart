import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_filereader/flutter_filereader.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:load/load.dart';
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/services_provider.dart';
import 'package:teacher_side/models/dept.dart';
import 'package:teacher_side/models/level.dart';
import 'package:teacher_side/screens/login/login_view.dart';
import 'package:teacher_side/utils/backendless_init.dart';
import 'package:teacher_side/utils/constants.dart';
import 'package:teacher_side/utils/ui/custom_tween.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class NewEvent extends StatefulWidget {
  final Map data;
  NewEvent(this.data);

  @override
  _NewLectureState createState() => _NewLectureState();
}

class _NewLectureState extends State<NewEvent> {
  String event_id;
  DocumentSnapshot event_data;
  @override
  void initState() {
    super.initState();
    BackendlessInit().init();
  }

  final _formKey = GlobalKey<FormState>();
  Department dept;
  TextEditingController titleController = new TextEditingController();
  List LecureFiles = [];
  List FilesTouploads = [];

  Level level;

  String _path = '-';
  bool _pickFileInProgress = false;
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;
  bool _checkByMimeType = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(" إضافة خبر"),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                SizedBox(height: 10,) ,
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2 ,  color: Colors.black)
                  ),
                  child: TextFormField(
                    controller: titleController,

                    maxLines: 10,

                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      labelText: 'الخبر...',
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                    ),

                    // The validator receives the text that the user has entered.

                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }

                      return null;
                    },
                  ),
                ),
Spacer() ,


Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                        Get.to(() => AddFiles(
                                data: widget.data,
                                title: titleController.text,
                              ));

                        }
                      },
                      child: Container(
                        width: 100.0.sp,
                        height: 40.0.sp,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: Center(
                            child: Text(
                          "متابعة",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: 100.0.sp,
                        height: 40.0.sp,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: Center(child: Text("إلغاء")),
                      ),
                    )
                  ],
                ),
                    

                

                // Add TextFormFields and ElevatedButton here.
              ])),
        ));
  }

  }

// FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
//   allowedFileExtensions: ['doc' ,'pdf' ,'ppt'],

//   allowedMimeTypes: ['application/*'],
//   invalidFileNameSymbols: ['/'],
// );

// final path = await FlutterDocumentPicker.openDocument(params: params);

//

class AddFiles extends StatefulWidget {
  final String title;
final Map data;
  AddFiles({Key key,  this.data , this.title}) : super(key: key);

  @override
  _AddFilesState createState() => _AddFilesState();
}

class _AddFilesState extends State<AddFiles> {


   String event_id;
  DocumentSnapshot event_data;
  @override
  void initState() {
    super.initState();
    BackendlessInit().init();


     Backendless.initApp(
        applicationId: APPLICATION_ID,
        androidApiKey: ANDROID_API_KEY,
        iosApiKey: IOS_API_KEY);
  }


  static const String SERVER_URL = "https://api.backendless.com";
  static const String APPLICATION_ID = "F698C529-1FF3-871A-FF6D-52A0154D3600";
  static const String ANDROID_API_KEY = "3BA6F57F-CA1D-43E5-AA56-AEBFDFD5982B";
  static const String IOS_API_KEY = "72521EEB-F3A3-40E4-A1C6-18A539269C0D";
  static const String JS_API_KEY = "5EB0896C-52DA-477C-AE1B-99AE73291C23";

  final _formKey = GlobalKey<FormState>();
  Department dept;
  TextEditingController titleController = new TextEditingController();
  List LecureFiles = [];
  List FilesTouploads = [];

  Level level;

  String _path = '-';
  bool _pickFileInProgress = false;
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;
  bool _checkByMimeType = false;
  @override
  Widget build(BuildContext context) {
        var service_provider = Provider.of<ServiceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("إضافة ملفات"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
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

Spacer()
,

             MaterialButton(
                minWidth: 250,
                color: Colors.yellow,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                onPressed: () async {
                       if (await service_provider.checkInternet()) {
                  LoadingDialog.show(context);
                    //await upload files then send data to firebase

                    await UploadFilesToBackendless();

                    //

                    await Future.delayed(Duration(seconds: 2));

                    //send data to the firebase

                    FilesTouploads.forEach((element) async {
                      print('////////////////////////////////////////');

                      print(element);
                    });

                    CollectionReference lecture =
                        FirebaseFirestore.instance.collection('subject-events');

                    var uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});

                    var data = await lecture.add({
                      'id': uuid.v1(),
                      "teacher_id" :  widget.data["teacher_id"] ,

                      'date': DateTime.now(),

                      'name': '${titleController.text}', // John Doe

                      'files': FilesTouploads, // Stokes and Sons

                      'subject_id': widget.data['id']
                    });

                    var firebase_data = await data.get();

                    setState(() {
                      event_data = firebase_data;
                    });

                    print(event_data.data().toString());

                    debugPrint('event' + event_data.data()['id']);

                    // .then((value) => print("lecures Added"))

                    // .catchError((error) => print("Failed to add user: $error"));

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
                child: Text('نشر الاعلان ')), 
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
        allowedExtensions: ['png', 'jpg'],
      );
      setState(() {
        LecureFiles = result.files;
      });

      print('///////////////////////////////////');
      PlatformFile file = result.files.first;
      print(file.extension);
      var first_file = File(LecureFiles[0].path);

      print(first_file.lastAccessed());
// Backendless.files.upload(File file, String path, {bool overwrite, void onProgressUpdate(int progress)});

      // String result;
      // try {
      //   setState(() {
      //     _path = '-';
      //     _pickFileInProgress = true;
      //   });

      //   FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
      //     // allowedFileExtensions: ['pdf' ,'PDF' ,'Pdf'],
      //     allowedMimeTypes: ['application/*'],
      //     invalidFileNameSymbols: ['/'],

      //   );

      //   result = await FlutterDocumentPicker.openDocument(params: params);

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
            'body': 'الاستاذ عندو ليكم  خبر جديد',
            'title': 'اعلات'
          },
          'topic': 'topics/general',
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'screen': 'event_details',
           "id": event_data.data()['id'] , "type":'event'
          },
          'to':
              '/topics/${widget.data['dept']['name']}${widget.data['level']['name']}'
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
