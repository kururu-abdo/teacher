import 'package:flutter/material.dart';

ThemeData basicTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
        headline: base.headline.copyWith(
          fontFamily: 'Roboto',
          fontSize: 22.0,
          color: Colors.black,
        ),
        title: base.title.copyWith(
            fontFamily: 'Merriweather', fontSize: 15.0, color: Colors.green),
        display1: base.headline.copyWith(
          fontFamily: 'Roboto',
          fontSize: 24.0,
          color: Colors.white,
        ),
        display2: base.headline.copyWith(
          fontFamily: 'Merriweather',
          fontSize: 22.0,
          color: Colors.grey,
        ),
        caption: base.caption.copyWith(
          color: Color(0xFFCCC5AF),
        ),
        body1: base.body1.copyWith(color: Color(0xFF807A6B)));
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
      textTheme: _basicTextTheme(base.textTheme),
      //textTheme: Typography().white,
      primaryColor: Color(0xFF0336FE),
      
      //primaryColor: Color(0xff4829b2),
      indicatorColor: Color(0xFF807A6B),
      scaffoldBackgroundColor: Color(0xFF0336FE),
      accentColor: Color(0xFFFFF8E1),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 20.0,
      ),
      cardColor: Colors.white,
      
      buttonColor: Colors.yellow,
      backgroundColor: Colors.white,
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: Color(0xffce107c),
        unselectedLabelColor: Colors.grey,
      ));
}
