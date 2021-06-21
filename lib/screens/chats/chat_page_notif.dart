import 'dart:async';
import 'package:teacher_side/utils/chat_page_args.dart';

import '';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:teacher_side/main.dart';
import 'package:teacher_side/models/chat_user.dart' as chat_user;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:teacher_side/models/chat_user.dart';
import 'package:teacher_side/models/message.dart';
import 'package:teacher_side/models/teacher.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class ChatPageNotif extends StatefulWidget {

  const ChatPageNotif({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChatPageNotif> {
  TextEditingController _controller = new TextEditingController();
  
  ScrollController _scrollController = ScrollController();
 

  
  @override
  Widget build(BuildContext context) {
    
final ChatPageArgs users =
        ModalRoute.of(context).settings.arguments as ChatPageArgs;
  

    CollectionReference chats =
        FirebaseFirestore.instance.collection('messages');

    return SafeArea(
      child:  Scaffold(
            appBar: AppBar(
actions: [
  IconButton(icon: Icon(FontAwesomeIcons.facebookMessenger), onPressed: (){
    Get.back();
  })
],


                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )),
              centerTitle: true,
              title: Text(users.user.name),
            ),
            body: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('messages')
                   
                .where(
                  'chat_id', isEqualTo: users.user.name+users.me.name
                  )
               
                .orderBy('time' ,descending: false)
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
                            alignment:  
                            
                            
                        chat_user.User.fromJson(snapshot
                                        .data.docs[index]
                                        .data()['receiver']) ==
                                    chat_user.User.fromJson(users.me.toJson())
                                ?Alignment.topRight:Alignment.topLeft,
                            child: Container(
                         
                              decoration: BoxDecoration(
                                color: chat_user.User.fromJson(snapshot
                                              .data.docs[index]
                                              .data()['receiver']) ==
                                         chat_user.User.fromJson(
                                              users.me.toJson())
                                      ? Colors.grey
                                      : Colors.purple,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
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
                        icon: Icon(Icons.message),
                        onPressed: () async {
                          var uuid =
                              Uuid(options: {'grng': UuidUtil.cryptoRNG});
                          await chats.add({
                            'chat_id': users.user.name+users.me.name,
                            'id': uuid.v1(),
                            'message': _controller.text,
                            'time': Timestamp.now(),
                            'sender': users.me.toJson(),
                            'receiver': users.user.toJson()
                          });
                          _controller.text = '';
                          print('comment');









      _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut);


                    //      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500));
                        }),
                    hintText: 'message...'),
              ),
            )),

    );
  }
}
