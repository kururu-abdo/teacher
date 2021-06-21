import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

_showSingleAnimationDialog(BuildContext context, Indicator indicator) {
  Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: false,
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: Text(indicator.toString().split('.').last),
            backgroundColor: Colors.pink,
          ),
          backgroundColor: Colors.teal,
          body: Padding(
            padding: const EdgeInsets.all(64),
            child: LoadingIndicator(
              indicatorType: indicator,
              color: Colors.white,
            ),
          ),
        );
      },
    ),
  );
}
