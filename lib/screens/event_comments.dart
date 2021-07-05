import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_show_more/flutter_show_more.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/comment_bloc.dart';
import 'package:teacher_side/bloc/user_bloc.dart';
import 'package:teacher_side/models/chat_user.dart';
import 'package:teacher_side/models/comment_model.dart';
import 'package:teacher_side/models/event.dart';
import 'package:teacher_side/utils/days.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class CommentsListKeyPrefix {
  static final String singleComment = "Comment";
  static final String commentUser = "Comment User";
  static final String commentText = "Comment Text";
  static final String commentDivider = "Comment Divider";
}

class EventComments extends StatefulWidget {
  final String object_id;
  EventComments(this.object_id);

  @override
  _LectureCommentsState createState() => _LectureCommentsState();
}

class _LectureCommentsState extends State<EventComments> {
  List<CommentModel> comments = [];
  TextEditingController _controller = new TextEditingController();
  @override
  void initState() {
    super.initState();
    CommentBloc.getObjectComments(widget.object_id).then((value) {
      setState(() {
        comments = value;
      });
    });
  }

  Event event;

  fetchEvent() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('lecture-events')
        .where('id', isEqualTo: widget.object_id)
        .get();

    if (data.docs.isNotEmpty) {
      setState(() {
        event = Event.fromJson(data.docs.first.data());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference commentsRef =
        FirebaseFirestore.instance.collection('comments');

    var userBloc = Provider.of<UserBloc>(context);
    var me =
        Commentator(userBloc.getUser().id, userBloc.getUser().name, 'أستاذ');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("التعليقات"),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Card(
                elevation: 16.0,
                child: Container(
                    height: 80,
                    child:
                        Center(child: Text(event != null ? event.title : ""))),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 2 / 3,
                child: FutureBuilder<QuerySnapshot>(
                  future: commentsRef
                      .where('object_id', isEqualTo: widget.object_id)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        debugPrint(snapshot.data.docs[index]
                            .data()['time']
                            .runtimeType
                            .toString());
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            color: Colors.green[200].withOpacity(0.5),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(snapshot.data.docs[index]
                                    .data()['commentator']['name']),
                                subtitle: Text(snapshot.data.docs[index]
                                    .data()['commentator']['role']),
                              ),
                              ShowMoreText(
                                snapshot.data.docs[index]
                                    .data()['comment_text'],
                                maxLength: 100,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                                showMoreText: 'عرض اكثر',
                                showMoreStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).accentColor,
                                ),
                                shouldShowLessText: true,
                                showLessText: 'عرض اقل',
                              ),

                              SizedBox(
                                height: 10.0,
                              ),
                              // Text(snapshot.data.docs[index].data()['time'].toString()),
                              dateFormatWidget(
                                  snapshot.data.docs[index].data()['time'])
                            ],
                          ),
                        );
                        return Text(
                            snapshot.data.docs[index].data().toString());
                      },
                    );
                  },
                ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _displayTextInputDialog(context);
        },
        child: Text("تعليق"),
      ),
    );
  }

  String getDayText(int nowDay, int day) {
    if (nowDay == day) {
      return 'اليوم';
    } else if (nowDay - day == 1) {
      return 'الأمس';
    } else {
      return Days.values[day - 1].toString();
    }
  }

  Widget dateFormatWidget(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    // var now = DateTime.now();
    // var nowDay = now.weekday;
    // var day = date.weekday;

    var format = new DateFormat('d MMM, hh:mm a');
    // var date = new DateTime.fromMillisecondsSinceEpoch(t);
    var formattedDate = DateFormat.yMMMd().format(date); // Apr 8, 2020

    var now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var formattedToday = DateFormat.yMMMd().format(today);

    final yesterday = DateTime(now.year, now.month, now.day - 1);
    var formattedYesterDay = DateFormat.yMMMd().format(yesterday);

    String time = '';

    if (formattedDate == formattedToday) {
      time = "اليوم";
    } else if (formattedDate == formattedYesterDay) {
      time = "الأمس";
    } else {
      time = formattedDate;
    }

    return Container(
      child: Text(time),
    );
    // print(day);
    // print(Days.values[Days.values[day].index]   );
    // return Container(
    //   child: Text(getDayText(nowDay, day)),
    // );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    CollectionReference commentsRef =
        FirebaseFirestore.instance.collection('comments');
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var me =
        Commentator(userBloc.getUser().id, userBloc.getUser().name, 'أستاذ');
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('اضف تعليق'),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  errorText: "قم بكتابة نص التعليق", hintText: "التعليق..."),
            ),
            actions: [
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () async {
                  var uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});
                  await commentsRef.add({
                    'id': uuid.v1(),
                    'object_id': widget.object_id,
                    'comment_text': _controller.text,
                    'time': Timestamp.now(),
                    'commentator': me.toJson()
                  });
                  _controller.text = '';
                  setState(() {});
                  Get.back();
                },
              ),
            ],
          );
        });
  }
}

class _SingleComment extends StatelessWidget {
  final int index;
  List<CommentModel> commeents;
  _SingleComment({Key key, @required this.index, this.commeents})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CommentModel commentData = commeents[index];
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserDetailsWithFollow(
            key: ValueKey("${CommentsListKeyPrefix.commentUser} $index"),
            userData: commentData.commentator,
          ),
          Text(
            commentData.comment_text,
            key: ValueKey("${CommentsListKeyPrefix.commentText} $index"),
            textAlign: TextAlign.left,
          ),
          Divider(
            key: ValueKey("${CommentsListKeyPrefix.commentDivider} $index"),
            color: Colors.black45,
          ),
        ],
      ),
    );
  }
}

class UserDetailsWithFollowKeys {
  static final ValueKey userDetails = ValueKey("UserDetails");
  static final ValueKey follow = ValueKey("follow");
}

class UserDetailsWithFollow extends StatelessWidget {
  final Commentator userData;

  const UserDetailsWithFollow({Key key, @required this.userData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context);
    var me =
        Commentator(userBloc.getUser().id, userBloc.getUser().name, 'أستاذ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: UserDetails(
            key: UserDetailsWithFollowKeys.userDetails,
            userData: userData,
          ),
        ),
        Visibility(
          visible: me != userData,
          child: Expanded(
            flex: 1,
            child: Container(
              key: UserDetailsWithFollowKeys.follow,
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.message),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class UserDetails extends StatelessWidget {
  final Commentator userData;

  const UserDetails({Key key, @required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context);
    var me =
        Commentator(userBloc.getUser().id, userBloc.getUser().name, 'أستاذ');
    return Container(
      child: Row(children: <Widget>[
        me != userData
            ? Text(
                userData.name + "  " + userData.role,
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            : Text("أنا", style: TextStyle(fontWeight: FontWeight.bold)),
      ]),
    );
  }
}
