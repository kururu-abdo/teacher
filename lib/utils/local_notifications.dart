
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:student_side/util/constants.dart';

// class LocalNotifications {
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//   final  AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   'This channel is used for important notifications.', // description
//   importance: Importance.max,
// );
//   init() async{



// await flutterLocalNotificationsPlugin
//   .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//   ?.createNotificationChannel(channel);
//   }



// show(Map<dynamic ,dynamic > data) async{
//  await flutterLocalNotificationsPlugin.show(
//         1,
//         data['title'],
//         data['body'],
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             channel.description,
         
//             // other properties...
//           ),
//         ));
// }

// }