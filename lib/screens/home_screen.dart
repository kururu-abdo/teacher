import 'dart:convert';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animations/animations.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:teacher_side/bloc/animated_container.dart';
import 'package:teacher_side/bloc/main_bloc.dart';
import 'package:teacher_side/bloc/subjects_bloc.dart';
import 'package:teacher_side/bloc/user_bloc.dart';
import 'package:teacher_side/models/subject.dart';
import 'package:teacher_side/models/teacher.dart';
import 'package:teacher_side/screens/chats/chat_page.dart';
import 'package:teacher_side/screens/chats/students_chats.dart';
import 'package:teacher_side/screens/events.dart';
import 'package:teacher_side/screens/login/login_view.dart';
import 'package:teacher_side/screens/my_events.dart';
import 'package:teacher_side/screens/my_lectures.dart';
import 'package:teacher_side/screens/my_subjects.dart';
import 'package:teacher_side/screens/profile.dart';
import 'package:teacher_side/screens/subject_details.dart';
import 'package:teacher_side/screens/time_table.dart';
import 'package:teacher_side/screens/website.dart';
import 'package:teacher_side/screens/welcome_screen.dart';
import 'package:teacher_side/utils/backendless_init.dart';
import 'package:teacher_side/utils/constants.dart';
import 'package:teacher_side/utils/fcm_config.dart';
import 'package:teacher_side/utils/firebase_init.dart';
import 'package:teacher_side/utils/ui/custom_tween.dart';
import 'package:teacher_side/utils/ui/pop_card.dart';
import 'package:teacher_side/utils/ui/pop_up_card.dart';
import 'package:flutter/scheduler.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final globalScaffoldKey = GlobalKey<ScaffoldState>();

  Teacher teacher;
  fetch_teacher() async {
    setState(() {
      debugPrint(json.decode(getStorage.read('teacher')).toString());
      teacher = Teacher.fromJson(json.decode(getStorage.read('teacher')));
    });

    print(teacher.name);
  }

  void _bottomSheetMore(context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return new Container(
          padding: EdgeInsets.only(
            left: 5.0,
            right: 5.0,
            top: 5.0,
            bottom: 5.0,
          ),
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0))),
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                title: Text(
                  teacher.name,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              new ListTile(
                onTap: () {
                  Get.to(WebSite());
                },
                leading: new Container(
                  width: 4.0,
                  child: Icon(
                    Icons.web,
                    color: Colors.blue,
                    size: 24.0,
                  ),
                ),
                title: const Text(
                  'صفحة الكلية',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              new ListTile(
                onTap: () {
                  Get.to(Chats());
                },
                leading: new Container(
                  width: 4.0,
                  child: Icon(
                    Icons.chat,
                    color: Colors.blue,
                    size: 24.0,
                  ),
                ),
                title: const Text(
                  'الرسائل',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              new ListTile(
                onTap: () {
                  Get.to(TimeTable());
                },
                leading: new Container(
                  width: 4.0,
                  child: Icon(
                    Icons.schedule,
                    color: Colors.blue,
                    size: 24.0,
                  ),
                ),
                title: const Text(
                  'الجدول',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              new ListTile(
                onTap: () {
                  Get.to(MyPrpfole());
                },
                leading: new Container(
                  width: 4.0,
                  child: Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: 24.0,
                  ),
                ),
                title: const Text(
                  'الملف الشخصي',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              new Divider(
                height: 10.0,
              ),
              new ListTile(
                title: const Text(
                  'تسجيل خروج',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () async {
//var future = await   showLoadingDialog();
                  LoadingDialog.show(context);
                  Future.delayed(Duration(seconds: 5), () {
                    LoadingDialog.hide(context);
                    FCMConfig.subscripeToTopic(teacher.id);
                    getStorage.write('isLogged', false);

                    Get.to(SplashScreen());
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    FCMConfig.fcmConfig();

    fetch_teacher();
    subscribe();
  }

  subscribe() {
    var teacher = Teacher.fromJson(json.decode(getStorage.read('teacher')));
    FCMConfig.subscripeToTopic('teacher${teacher.id.toString()}');
  }

 
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var subjectProvider = Provider.of<SubjectProvider>(context);
    var teacherProvider = Provider.of<UserBloc>(context);

    var rotate = Provider.of<AnimContainer>(context);
    var main_bloc = Provider.of<MainBloc>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          title: Text('الاستاذ'),
          actions: [
            IconButton(
                onPressed: () {
                  _bottomSheetMore(context);
                },
                icon: Icon(Icons.menu))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView(
            physics :  BouncingScrollPhysics() ,
            children: [
              SizedBox(
                height: 5.0,
              ),
              Container(
                height: 200,
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 4),
                  ),
                  items: [
                    'assets/images/slide1.webp',
                    'assets/images/slide2.webp',
                    'assets/images/slide3.webp',
                    'assets/images/slide4.webp',
                    'assets/images/slide5.jpeg'
                  ].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            image: DecorationImage(
                                image: AssetImage(i), fit: BoxFit.cover),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                InkWell(
                  onTap: () {

                    Get.to(MyLectures());
                  },
                  child: Column(
                    children: [
                      Container(
                          height: 80,
                          width: 80.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/teaching.png')),
                              shape: BoxShape.circle)),
                      Text('المحاضرات',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(MyEvents());
                  },
                  child: Column(
                    children: [
                      Container(
                          height: 80,
                          width: 80.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/calendar.png')),
                              shape: BoxShape.circle)),
                      Text('الاعلانات',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ]),
              SizedBox(
                height: 10,
              ),
              Text("الجدول", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                  height: 100,
                  child: Column(
                    children: [
                      StreamBuilder<List<Map>>(
                          stream: subjectProvider
                              .getMyTableOneSubject(teacherProvider.getUser()),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Map>> snapshot) {
                            if (!snapshot.hasData) {
                              return
                              
                              
                               Container(
                                 height: 50,
                                 width: 200,
                                 decoration: BoxDecoration(
                                   color: Colors.red.withOpacity(0.4)
                                 ),
                                 child: Center(child: Text("ليس لديك محاضرات")));
                            }

                            return Container(
                              height: 60,
                              child: ListView(
                                  children: snapshot.data
                                      .map((subject) => Card(
                                            elevation: 8.0,
                                            color: Color.fromRGBO(
                                                255, 224, 226, 1.0),
                                            child: ListTile(
                                              title: Text(
                                                  subject["subject"]['name']),
                                              subtitle: Text(subject["subject"]
                                                      ["level"]["name"] +
                                                  "  " +
                                                  subject["subject"]
                                                      ["department"]["name"]),
                                              trailing: Text(subject["day"]
                                                      ["name"] +
                                                  " " +
                                                  subject["from"]),
                                            ),
                                          ))
                                      .toList()),
                            );
                          }),
                      Container(
                        height: 40,
                        child: Center(
                            child: IconButton(
                                onPressed: () {
                                  Get.to(TimeTable());
                                },
                                icon: Icon(Icons.expand_more_rounded,
                                    color: Colors.blueAccent, size: 40))),
                      ),
                    ],
                  )),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('موادي',
                          style: TextStyle(fontWeight: FontWeight.bold)),

                          
                      Container(
                        child: Center(
                            child: IconButton(
                                onPressed: () {
                                  Get.to(Material(child: MySubjects()));
                                },
                                icon: Icon(Icons.expand_more_rounded,
                                    color: Colors.blueAccent, size: 40))),
                      ),
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: StreamBuilder<List<ClassSubject>>(
                  stream:
                      subjectProvider.getMySubjects2(teacherProvider.getUser()),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ClassSubject>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text("ليس لديك مواد بعد!"),
                      );
                    }

                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: snapshot.data
                          .map(
                            (subject) => OpenContainer(
                                openBuilder: (_, closeContainer) =>
                                    SubjectDetails(subject),
                                onClosed: (res) => setState(() {}),
                                closedBuilder: (_, openContainer) => Container(
                                      height: 120,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(
                                              255, 224, 226, 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Column(
                                        children: [
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(subject.name,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          // Align(
                                          //     alignment: Alignment.centerRight,
                                          //     child: Text(subject.)),
                                          SizedBox(
                                            height: 15.0,
                                          ),
                                          Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Image.asset(
                                                  'assets/images/diary.png',
                                                  width: 50,
                                                  height: 60)),
                                        ],
                                      ),
                                    )),
                          )
                          .toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
///////////////////
