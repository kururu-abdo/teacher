import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ripple_effect/ripple_effect.dart';
import 'package:teacher_side/bloc/main_bloc.dart';
import 'package:teacher_side/models/lecture.dart';
import 'package:teacher_side/models/subject.dart';
import 'package:teacher_side/screens/add_event.dart';
import 'package:teacher_side/screens/add_subject.dart';
import 'package:teacher_side/screens/edit_lecture.dart';
import 'package:teacher_side/screens/event_details.dart';
import 'package:teacher_side/screens/lecture_disscusion.dart';
import 'package:teacher_side/utils/constants.dart';
import 'package:teacher_side/utils/fcm_config.dart';
import 'package:teacher_side/utils/ui/pop_up_card.dart';
import 'package:teacher_side/models/subject.dart';

class SubjectDetails extends StatefulWidget {
  final ClassSubject subject;
  SubjectDetails(this.subject);

  @override
  _SubjectDetailsState createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails> {
  final pageKey = RipplePage.createGlobalKey();
  final effectKey = RippleEffect.createGlobalKey();
  final effectKey2 = RippleEffect.createGlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('lectures');
    CollectionReference events =
        FirebaseFirestore.instance.collection('subject-events');
    return RipplePage(
      pageKey: pageKey,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text('المحاضرات'),
              centerTitle: true,
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.contacts), text: "المحاضرات"),
                  Tab(icon: Icon(Icons.camera_alt), text: "الإعلانات")
                ],
              ),
            ),
            body: TabBarView(children: [
              StreamBuilder<QuerySnapshot>(
                stream: users
                    .where('subject_id', isEqualTo: widget.subject.id)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  //   debugPrint(snapshot.data.docs.length.toString());

                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.hasData) {
                    return ListView(
                        children: snapshot.data.docs
                            .asMap()
                            .map((
                              i,
                              DocumentSnapshot document,
                            ) {
                              return MapEntry(
                                  i,
                                  Container(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    LectureDisscusion(
                                                        document.data())));
                                      },
                                      child: SwipeActionCell(
                                        key: ObjectKey(document.data()['id']),
                                        performsFirstActionWithFullSwipe: true,
                                        trailingActions: <SwipeAction>[
                                          SwipeAction(
                                              title: "حذف",
                                              onTap: (CompletionHandler
                                                  handler) async {
                                                await handler(true);

                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: Text('Delete'),
                                                          content: Text(
                                                              'Are you to delete lecture?'),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              color: Colors.red,
                                                              textColor:
                                                                  Colors.white,
                                                              child: Text(
                                                                  'cancel'),
                                                              onPressed: () {
                                                                setState(() {
                                                                  //  codeDialog = valueText;
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              },
                                                            ),
                                                            FlatButton(
                                                              color:
                                                                  Colors.green,
                                                              textColor:
                                                                  Colors.white,
                                                              child: Text('OK'),
                                                              onPressed:
                                                                  () async {
                                                                setState(() {});
                                                                CollectionReference
                                                                    lectures =
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'lectures');

                                                                var lecture =
                                                                    await lectures
                                                                        .where(
                                                                            'id',
                                                                            isEqualTo:
                                                                                document.data()['id'])
                                                                        .get();
                                                                var doc_id =
                                                                    lecture
                                                                        .docs
                                                                        .first
                                                                        .id;
                                                                await lectures
                                                                    .doc(doc_id)
                                                                    .delete();

                                                                // await updateAddress();
                                                                setState(() {
                                                                  //  codeDialog = valueText;
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ));
                                                setState(() {});
                                              },
                                              color: Colors.red),
                                          SwipeAction(
                                              title: "تعديل",
                                              onTap: (CompletionHandler
                                                  handler) async {
                                                await handler(true);
                                                Navigator.of(context).push(
                                                    HeroDialogRoute(
                                                        builder: (_) {
                                                  return EditLecture(
                                                      new Lecture(
                                                          document.data()['id'],
                                                          document
                                                              .data()['name'],
                                                          document
                                                              .data()['files'],
                                                          ClassSubject.fromJson(
                                                              document.data()[
                                                                  'subject']),
                                                          document
                                                              .data()['time']));
                                                }));

                                                // setState(() {

                                                // });
                                              },
                                              color: Colors.green)
                                        ],
                                        child: Card(
                                          margin: EdgeInsets.only(bottom: 8.0),
                                          elevation: 2.0,
                                          // color: Colors.yellow,
                                          child: new ListTile(
                                            leading: Container(
                                                height: 40,
                                                width: 40,
                                                child: Center(
                                                  child: Text(
                                                      (i + 1).toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.blueGrey,
                                                    shape: BoxShape.circle)),
                                            title: new Text(
                                              document.data()['name'],
                                              style: TextStyle(
                                                  color: Color(0xFF0336FE)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ));
                            })
                            .values
                            .toList());
                  }
                  return Text("loading.....");
                },
              ),

              //

              StreamBuilder<QuerySnapshot>(
                stream: events
                    .where('subject_id', isEqualTo: widget.subject.id)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('error');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Text('waiting...');
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => Material(
                                  child: EventDeitals(
                                      snapshot.data.docs[index].data()))));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: Dismissible(
                            background: Container(
                              color: Colors.red,
                              child: Icon(Icons.delete),
                            ),
                            onDismissed: (direction) async {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('Delete'),
                                        content:
                                            Text('Are you to delete lecture?'),
                                        actions: <Widget>[
                                          FlatButton(
                                            color: Colors.red,
                                            textColor: Colors.white,
                                            child: Text('cancel'),
                                            onPressed: () {
                                              setState(() {
                                                //  codeDialog = valueText;
                                                Navigator.pop(context);
                                              });
                                            },
                                          ),
                                          FlatButton(
                                            color: Colors.green,
                                            textColor: Colors.white,
                                            child: Text('OK'),
                                            onPressed: () async {
                                              setState(() {});
                                              CollectionReference events =
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'subject-events');

                                              var event = await events
                                                  .where('id',
                                                      isEqualTo: snapshot.data
                                                          .docs[index]['id'])
                                                  .get();
                                              var doc_id = event.docs.first.id;
                                              await events.doc(doc_id).delete();

                                              // await updateAddress();
                                              setState(() {
                                                //  codeDialog = valueText;
                                                Navigator.pop(context);
                                              });
                                            },
                                          ),
                                        ],
                                      ));
                            },
                            key: ObjectKey(snapshot.data.docs[index]['id']),
                            child: Card(
                              elevation: 2.0,
                              child: ListTile(
                                leading: Container(
                                  child: Center(
                                      child: Text((index + 1).toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      shape: BoxShape.circle),
                                ),
                                title: Text(
                                  snapshot.data.docs[index]['name'],
                                  style: TextStyle(color: Color(0xFF0336FE)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ]),
            floatingActionButton: RippleEffect(
              pageKey: pageKey,
              effectKey: effectKey,
              color: Colors.yellow,
              child: SpeedDial(

                  /// both default to 16
                  marginEnd: 18,
                  marginBottom: 20,
                  // animatedIcon: AnimatedIcons.menu_close,
                  // animatedIconTheme: IconThemeData(size: 22.0),
                  /// This is ignored if animatedIcon is non null
                  icon: Icons.add,
                  activeIcon: Icons.remove,
                  // iconTheme: IconThemeData(color: Colors.grey[50], size: 30),
                  /// The label of the main button.
                  // label: Text("Open Speed Dial"),
                  /// The active label of the main button, Defaults to label if not specified.
                  // activeLabel: Text("Close Speed Dial"),
                  /// Transition Builder between label and activeLabel, defaults to FadeTransition.
                  // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
                  /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
                  buttonSize: 56.0,
                  visible: true,

                  /// If true user is forced to close dial manually
                  /// by tapping main button and overlay is not rendered.
                  closeManually: false,

                  /// If true overlay will render no matter what.
                  renderOverlay: false,
                  curve: Curves.bounceIn,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.5,
                  onOpen: () => print('OPENING DIAL'),
                  onClose: () => print('DIAL CLOSED'),
                  tooltip: 'Speed Dial',
                  heroTag: 'speed-dial-hero-tag',
                  foregroundColor: Colors.black,
                  backgroundColor: Theme.of(context).accentColor,
                  elevation: 8.0,
                  shape: CircleBorder(),
                  // orientation: SpeedDialOrientation.Up,
                  // childMarginBottom: 2,
                  // childMarginTop: 2,
                  children: [
                    SpeedDialChild(
                      child: Icon(Icons.accessibility),
                      backgroundColor: Colors.red,
                      label: 'اضافة محاضرة',
                      labelStyle: TextStyle(fontSize: 18.0),
                      onTap: () => RippleEffect.start(
                          effectKey,
                          () => Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return NewLecture(widget.subject);
                              }))),

                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (_) {
                      //   return NewLecture(widget.subject);
                      // })

                      // ),
                      onLongPress: () => print('FIRST CHILD LONG PRESS'),
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.accessibility),
                      backgroundColor: Colors.red,
                      label: 'اضافة اعلان',
                      labelStyle: TextStyle(fontSize: 18.0),
                      onTap: () => RippleEffect.start(
                          effectKey,
                          () => Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return NewEvent(widget.subject.toJson());
                              }))),
                      onLongPress: () => print('FIRST CHILD LONG PRESS'),
                    ),
                  ]),
            )

            //    FloatingActionButton(child: Icon(Icons.add), onPressed: (){

            // Navigator.of(context).push(

            // HeroDialogRoute(builder: (_){

            //   return  NewLecture();
            // })

            // //   MaterialPageRoute(builder: (_){
            // // return  NewLecture();
            // // } ,
            // // )

            // );
            //   },),

            ),
      ),
    );
  }
}
