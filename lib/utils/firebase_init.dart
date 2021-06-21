import 'package:firebase_core/firebase_core.dart';

class FirebaseInit{

  static Future initFirebase() async{
     try {
      // Wait for Firebase to initialize and set `_initialized` state to true
    var app=  await Firebase.initializeApp( 
            name: 'teacher',
    options: const FirebaseOptions(
        appId: '1:655856558903:android:57a0fee0598ec0df4030b2',
        apiKey: 'AIzaSyBmRbOhtSSnelDInVPURVSU41SVf4RL1DM',
        messagingSenderId: '655856558903',
        projectId: 'students-452e5',
        databaseURL: 'https://students-452e5-default-rtdb.firebaseio.com'
    )
    
    );
      print('done');
     return app;
    } catch(e) {
 print(e.toString());     
    }
  }
}