import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/main_bloc.dart';
import 'package:teacher_side/screens/home_screen.dart';
import 'package:teacher_side/screens/login/login_view.dart';
import 'package:teacher_side/utils/constants.dart';
import 'package:teacher_side/utils/fcm_config.dart';
import 'package:teacher_side/utils/firebase_init.dart';

class SplashScreen extends StatefulWidget {
//  SplashScreen({Key key}) : super(key: key);

  @override
  createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    FirebaseInit.initFirebase();
   
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTimer();
  }

  startTimer() async {
    Timer(Duration(seconds: 4), () async {
      await navigateTo();
    });
  }

  navigateTo() async {
    var isLogged = getStorage.read('isLogged') ?? false;

    if (isLogged) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
              create: (BuildContext context) => MainBloc(),
              child: Material(
                  child: Localizations(delegates: [
                DefaultWidgetsLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ], locale: new Locale("ar", ""), child: Home())))));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => Material(child: LoginForm())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
          padding: EdgeInsets.only(bottom: 30.0),
          child: new Image.asset(
            'assets/images/logo.jpg',
            height: 80.0,
            width: 80.0,
          )),
    )

        //  Stack(
        //   fit: StackFit.expand,
        //   children: <Widget>[
        //     new Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       mainAxisSize: MainAxisSize.min,
        //       children: <Widget>[

        //         Padding(padding: EdgeInsets.only(bottom: 30.0),child:new Image.asset('assets/images/splash.jpg',height: 25.0,fit: BoxFit.scaleDown,))

        //     ],),

        //   ],
        // ),
        );
  }
}
