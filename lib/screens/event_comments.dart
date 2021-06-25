import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/comment_bloc.dart';
import 'package:teacher_side/bloc/user_bloc.dart';
import 'package:teacher_side/models/chat_user.dart';
import 'package:teacher_side/models/comment_model.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class CommentsListKeyPrefix {
  static final String singleComment = "Comment";
  static final String commentUser = "Comment User";
  static final String commentText = "Comment Text";
  static final String commentDivider = "Comment Divider";
}

class EventComments extends StatefulWidget {
  String object_id;
  EventComments(this.object_id);

  @override
  _LectureCommentsState createState() => _LectureCommentsState();
}

class _LectureCommentsState extends State<EventComments> {
  List<CommentModel> comments = [];
TextEditingController _controller =  new TextEditingController();
  @override
  void initState() {
    super.initState();
    CommentBloc.getObjectComments(widget.object_id).then((value) {
      setState(() {
        comments = value;
      });
    });
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
      body:
      
      Padding(
        padding: const EdgeInsets.only(top: 8.0),



        child: ExpansionTile(
          leading: Icon(Icons.comment),
          trailing: Text(comments.length.toString()),
          title: Text("التعليقات"),
          children: List<Widget>.generate(
            comments.length,
            (int index) => _SingleComment(
              key: ValueKey("${CommentsListKeyPrefix.singleComment} $index"),
              index: index,
              commeents: comments,
            ),
          ),
        ),
      ),

floatingActionButton: FloatingActionButton(onPressed: () async{

  await _displayTextInputDialog( context);
},

child: Text("تعليق"),
),
    );
  }


  Future<void> _displayTextInputDialog(BuildContext context) async {
     CollectionReference commentsRef =
        FirebaseFirestore.instance.collection('comments');
    var userBloc = Provider.of<UserBloc>(context ,listen: false);
    var me =
        Commentator(userBloc.getUser().id, userBloc.getUser().name, 'أستاذ');
   return showDialog(
       context: context,
       builder: (context) {
         return AlertDialog(
           title: Text('اضف تعليق'),
          
           content: TextField(
             
             controller:_controller,
             decoration: InputDecoration(
               errorText: "قم بكتابة نص التعليق",
               hintText: "التعليق..."),
           ),

       actions: [
          FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () async{
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

         );}
         );

       
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