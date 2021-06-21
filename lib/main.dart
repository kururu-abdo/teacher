import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/animated_container.dart';
import 'package:teacher_side/bloc/main_bloc.dart';
import 'package:teacher_side/bloc/services_provider.dart';
import 'package:teacher_side/bloc/subjects_bloc.dart';
import 'package:teacher_side/bloc/user_bloc.dart';
import 'package:teacher_side/models/notification.dart';
import 'package:teacher_side/screens/chats/chat_page_notif.dart';
import 'package:teacher_side/screens/event_details_notif.dart';
import 'package:teacher_side/screens/lecture_details_notif.dart';
import 'package:teacher_side/screens/main_event_details.dart';
import 'package:teacher_side/screens/notifcatin_page.dart';
import 'package:teacher_side/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:teacher_side/utils/backendless_init.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:teacher_side/utils/fcm_config.dart';
import 'package:teacher_side/utils/local_datase.dart';
import 'package:teacher_side/utils/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  RemoteNotification notification = message.notification;
  flutterLocalNotificationsPlugin.show(
      notification?.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
            'channel', 'channelName', 'channelDescription'),

        // android:
        //  AndroidNotificationDetails(
        //   channel.id,
        //   channel.name,
        //   channel.description,
        //   // TODO add a proper drawable resource to android, for now using
        //   //      one that already exists in example app.
        //   icon: 'launch_background',
        // ),
        // null
      ));
  DBProvider.db.newNotification(LocalNotification(
      title: notification.title,
      object: json.encode(message.data),
      body: notification.body,
      time: DateTime.now().millisecondsSinceEpoch));

  Get.toNamed('/notification');
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FCMConfig();
  await GetStorage.init();
  await FlutterDownloader.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  BackendlessInit().init();
  runApp(MultiProvider(providers: [
    Provider<ServiceProvider>(create: (_) => ServiceProvider()),
    ChangeNotifierProvider(create: (_) => MainBloc()),
    Provider<UserBloc>(create: (_) => UserBloc()),
    Provider<SubjectProvider>(create: (_) => SubjectProvider()),
    ChangeNotifierProvider<AnimContainer>(create: (_) => AnimContainer())
  ], child: HomePage()));
}

Route routes(RouteSettings settings) {
  if (settings.name == "notification") {
    return MaterialPageRoute(
      builder: (_) => NotificationPage(),
    );
  } else if (settings.name == '/') {
    return MaterialPageRoute(
      builder: (_) => SplashScreen(),
    );
  } else if (settings.name == "/chat") {
    return MaterialPageRoute(
      builder: (_) => ChatPageNotif(),
    );
  } else if (settings.name == "/lecture") {
    return MaterialPageRoute(
      builder: (_) => LectureDetailsNotif(),
    );
  } else if (settings.name == "/event") {
    return MaterialPageRoute(
      builder: (_) => EventDeitalsNotif(),
    );
  } else {
    return MaterialPageRoute(
      builder: (_) => HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: new Locale("ar", ""),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('ar', ''), // Spanish, no country code
      ],
//themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      onGenerateRoute: routes,
// theme: basicTheme() ,
      theme: ThemeData.from(
          colorScheme: ColorScheme.light().copyWith(
        primary: Color(0xFF0336FE),
        primaryVariant: Color(0xFF5536FE),
        secondary: Color(0xFFffde03),
        secondaryVariant: Color(0xffc79400),
        background: Color(0xFF0336FE),
        onBackground: Colors.white,
        onError: Colors.black,
        onSurface: Colors.white,
        error: Colors.red,
        surface:  Colors.blue,
        onSecondary: Colors.black,
        onPrimary: Colors.white,
      )),

      home: ChangeNotifierProvider(
          create: (BuildContext context) {
            return MainBloc();
          },
          child: LoadingProvider(
              themeData: LoadingThemeData(
                loadingBackgroundColor: Colors.white,
                backgroundColor: Colors.black54,
              ),
              loadingWidgetBuilder: (ctx, data) {
                return Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Container(
                      child: CupertinoActivityIndicator(),
                      color: Colors.blue,
                    ),
                  ),
                );
              },
              child: SplashScreen())),
    );
  }
}