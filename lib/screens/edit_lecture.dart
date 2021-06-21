import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/services_provider.dart';
import 'package:teacher_side/models/dept.dart';
import 'package:teacher_side/models/lecture.dart';
import 'package:teacher_side/models/level.dart';
import 'package:teacher_side/models/subject.dart';
import 'package:teacher_side/utils/backendless_init.dart';
import 'package:teacher_side/utils/constants.dart';
import 'package:teacher_side/utils/ui/custom_tween.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';


class EditLecture extends StatefulWidget {
 final Lecture lecture;
EditLecture(this.lecture);

  @override
  _NewLectureState createState() => _NewLectureState();
}

class _NewLectureState extends State<EditLecture> {


@override
void initState() { 
  super.initState();
  BackendlessInit().init();


}
    final _formKey = GlobalKey<FormState>();
Department dept;
TextEditingController titleController = new TextEditingController();
List LecureFiles =[];
List FilesTouploads =[];
DocumentSnapshot lecture_data;
Level level;

String lecture_id;

String _path = '-';
  bool _pickFileInProgress = false;
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;
  bool _checkByMimeType = false;
  @override
  Widget build(BuildContext context) {
            var serviceProvider = Provider.of<ServiceProvider>(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: '',
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child:  Material(
            // color: Colors.white24,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                      child: Card(
child:  Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
TextFormField(
  controller: titleController,
  decoration: InputDecoration(
    
  
    labelText: 'عنوان المحاضرة'
          
  ),
  // The validator receives the text that the user has entered.
  validator: (value) {
    if (value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  },
),

            Row(

              children:[
Text('اضافة ملفات') ,




IconButton(icon: Icon(Icons.file_copy),

onPressed: () async{
_pickDocument();


},) ,
//LecureFiles

Text('ملفات  ${LecureFiles.length}')




              ]
            ) ,

            MaterialButton(
              minWidth: double.infinity,
              onPressed: ()async{
//await upload files then send data to firebase
if(await serviceProvider.checkInternet()){
  
await UploadFilesToBackendless();
//

await Future.delayed(Duration(seconds: 2));

//send data to the firebase

FilesTouploads.forEach((element)  async{

print('////////////////////////////////////////');
print(element);

});
  CollectionReference lecture =
                                              await FirebaseFirestore.instance
                                                  .collection('lecures');

                                          var selectedSubject = await lecture
                                              .where('id', isEqualTo: widget.lecture.id)
                                              .get();
                                          var doc_id =
                                              selectedSubject.docs.first.id;




var updatedLecture = widget.lecture;
updatedLecture.name =  titleController.text.length>0?titleController.text:updatedLecture.name;


                                          updatedLecture.Files =
                                          FilesTouploads.length > 0
                                                  ? FilesTouploads
                                                  :      updatedLecture.Files;



var data =await lecture.doc(doc_id)
          .update({
          
           
       
            'name': updatedLecture.name, // John Doe
            'files':  updatedLecture
                                                .Files, // Stokes and Sons
            
          });
          // .then((value) => print("lecures Added"))
          // .catchError((error) => print("Failed to add user: $error"));


// var notification = await sendAndRetrieveMessage();
// print('notification status');
// print(notification);

Get.back();


}else{
  
}
              } ,  child:Text('upload lecture'))
          
              // Add TextFormFields and ElevatedButton here.
        ]
     )
    ) ,
        
      )
      )
      )

          )
          )
          )
      );
    
  }


  _pickDocument() async {
        try {
    FilePickerResult result = await FilePicker.platform.pickFiles(
          // type: FileType.custom,
          // allowedExtensions: ['ppt', 'pdf', 'doc' ],
          
         allowMultiple: true      );
setState(() {
  LecureFiles =   result.files;
});

print('///////////////////////////////////');
 PlatformFile file = result.files.first;
print(file.extension);
var first_file =File(LecureFiles[0].path);
      
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




Future<void> UploadFilesToBackendless()  async{


LecureFiles.forEach((file)  async{ 
  // PlatformFile()

//await here
var url = await Backendless.files.upload(File(file.path), 'lectures'  ,  overwrite:true  ,onProgressUpdate:(value){}


);

 setState(() {
  FilesTouploads.add(url);
 });
//print(url);




 });



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
         'body': 'there are new lecture added for you ,   check it now!',
         'title': 'new lecure Added'
       },
     
       'priority': 'high',
       'data': <String, dynamic>{
         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
         'id': '1',
         'status': 'done' ,
         'screen' :'lecture_details',
         'lecture': lecture_data.data()
       },
       'to': '/topics/general'

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

// FlutterDocumentPickerParams params = FlutterDocumentPickerParams(      
//   allowedFileExtensions: ['doc' ,'pdf' ,'ppt'],

//   allowedMimeTypes: ['application/*'],
//   invalidFileNameSymbols: ['/'],
// );

// final path = await FlutterDocumentPicker.openDocument(params: params);

//