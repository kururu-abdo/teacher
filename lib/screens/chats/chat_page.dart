import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:teacher_side/main.dart';
import 'package:teacher_side/models/chat_user.dart' as chat_user;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:teacher_side/models/chat_user.dart';
import 'package:teacher_side/models/message.dart';
import 'package:teacher_side/models/teacher.dart';
import 'package:teacher_side/utils/constants.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class ChatPage extends StatefulWidget {
  final User user;
  final User me;
  const ChatPage({Key key, this.user, this.me}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChatPage> {
  TextEditingController _controller = new TextEditingController();

  ScrollController _scrollController = ScrollController();
double _sigmaX = 4; // from 0-10
  double _sigmaY = 4; // from 0-10
  double _opacity = 0.6; // from 0-1.0
  bool showBlur = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference chats =
        FirebaseFirestore.instance.collection('messages');

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  icon: Icon(FontAwesomeIcons.facebookMessenger),
                  onPressed: () {
                    Get.back();
                  })
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )),
            centerTitle: true,
            title: Text(widget.user.name),
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('chat_id',
                      isEqualTo: widget.user.name + widget.me.name)
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data.docs.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return Align(
                          alignment: chat_user.User.fromJson(snapshot
                                      .data.docs[index]
                                      .data()['receiver']) ==
                                  chat_user.User.fromJson(widget.me.toJson())
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                color: chat_user.User.fromJson(snapshot
                                            .data.docs[index]
                                            .data()['receiver']) ==
                                        chat_user.User.fromJson(
                                            widget.me.toJson())
                                    ? Colors.grey
                                    : Colors.purple,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            margin: EdgeInsets.all(10.0),
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                                snapshot.data.docs[index].data()['message']),
                          ));
                    },
                  );
                }
              }),
          bottomNavigationBar: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  icon: IconButton(
                      icon: Icon(Icons.message, color: Colors.blueAccent),
                      onPressed: () async {
                        var uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});
                        await chats.add({
                          'chat_id': widget.user.name + widget.me.name,
                          'id': uuid.v1(),
                          'message': _controller.text,
                          'time': Timestamp.now(),
                          'sender': widget.me.toJson(),
                          'receiver': widget.user.toJson()
                        });
                        _controller.text = '';
                        print('comment');

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
                                'body':
                                    'أستاذ   ارسل لك رسالة ${widget.me.name}',
                                'title': ':رسالة جديدة'
                              },
                              'priority': 'high',
                              'data': <String, dynamic>{
                                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                'id': '1',
                                'status': 'done',
                                'screen': 'chat',
                                'data': <dynamic, dynamic>{
                                  'sender': widget.me.toJson(),
                                  'receiver': widget.user.toJson()
                                }
                              },
                              'to': '/topics/${widget.user.id.toString()}'
                            },
                          ),
                        );

                        LoadingIndicator(
                          indicatorType: Indicator.ballPulse,
                          color: Colors.white,
                        );

                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut);

                        //      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500));
                      }),
                  hintText: 'message...',
                  hintStyle: TextStyle(color: Colors.black)),
            ),
          )),
    );
  }
}
