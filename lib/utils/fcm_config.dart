import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:teacher_side/main.dart';
import 'package:teacher_side/models/notification.dart';
import 'package:teacher_side/screens/notifcatin_page.dart';
import 'package:teacher_side/utils/constants.dart';
import 'package:teacher_side/utils/local_datase.dart';


class FCMConfig {
  FCMConfig() {
    fcmConfig();
  }

  static fcmConfig() async {
    debugPrint('config notfication');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        debugPrint('config notfication');

        var result = await DBProvider.db.newNotification(LocalNotification(
            title: notification.title,
            body : notification.body,
            object: json.encode(message.data),
            time: DateTime.now().millisecondsSinceEpoch
            
            ));

Get.defaultDialog(title:'اخطار جديد'   ,  
content: Text("هنالك اخطار جديد"),

backgroundColor: Colors.yellow,
actions: [TextButton(onPressed: (){
  Get.to(NotificationPage());
}, 

child: Text('حسنا'  ))] ,    );


        // debugPrint('/////////////////////////////');
        // debugPrint(result.toString());
        // flutterLocalNotificationsPlugin.show(
        //     notification?.hashCode,
        //     notification.title,
        //     notification.body,
        //     NotificationDetails(
        //     android:    AndroidNotificationDetails(
        //             'channel', 'channelName', 'channelDescription'),
                
        //         // android:
        //         //  AndroidNotificationDetails(
        //         //   channel.id,
        //         //   channel.name,
        //         //   channel.description,
        //         //   // TODO add a proper drawable resource to android, for now using
        //         //   //      one that already exists in example app.
        //         //   icon: 'launch_background',
        //         // ),
        //         // null
        //         ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        debugPrint('config notfication');

        var result = DBProvider.db.newNotification(LocalNotification(
            title: notification.title,
            body: notification.body,
            object: json.encode(message.data),
            time: DateTime.now().millisecondsSinceEpoch));
      
      }

    
    });

// RemoteMessage initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();

// debugPrint(initialMessage?.data.toString());

//     if (initialMessage?.data['type'] != 'chat') {
//    Get.toNamed('notification');
//     }

  
  }

static unsubsribeToAll()  async{
      getStorage.read("topics", );
      List  topics =  json.decode( getStorage.read("topics", ));

      topics.forEach((element) {debugPrint(element);});

}

static subscripeToTopic(String topic){
  debugPrint('subcribe to topic  '+ topic);
    topics.add(topic);

    getStorage.write("topics", json.encode(topics));


 FirebaseMessaging.instance.subscribeToTopic(topic);
}
static unSubscripeToTopic(String topic) {
 FirebaseMessaging.instance.unsubscribeFromTopic("teacher"+topic);
}
static Future<String>  getToken() async{
  return await  FirebaseMessaging.instance.getToken();
}





}