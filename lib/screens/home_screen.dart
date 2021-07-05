import 'dart:convert';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/animated_container.dart';
import 'package:teacher_side/bloc/main_bloc.dart';
import 'package:teacher_side/bloc/subjects_bloc.dart';
import 'package:teacher_side/bloc/user_bloc.dart';
import 'package:teacher_side/models/subject.dart';
import 'package:teacher_side/models/teacher.dart';
import 'package:teacher_side/screens/chats/students_chats.dart';
import 'package:teacher_side/screens/login/login_view.dart';
import 'package:teacher_side/screens/my_events.dart';
import 'package:teacher_side/screens/my_lectures.dart';
import 'package:teacher_side/screens/my_subjects.dart';
import 'package:teacher_side/screens/notifcatin_page.dart';
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
          margin: EdgeInsets.only(left: 5, right: 5),
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0))),
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
                    color: Colors.green.withOpacity(0.5),
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
                    color: Colors.green.withOpacity(0.5),
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
                    color: Colors.green.withOpacity(0.5),
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
                    color: Colors.green.withOpacity(0.5),
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

  bool isShow = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  Map SelectedDate;
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
                  Get.to(NotificationPage());
                },
                icon: Icon(Icons.notifications)),
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
            physics: BouncingScrollPhysics(),
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
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("الجدول"), Icon(Icons.calendar_today)]),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 100,
                child: ListView(
                  // This next line does the trick.
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  children: DAYS
                      .map(
                        (e) => InkWell(
                          onTap: () {
                            setState(() {
                              SelectedDate = e;
                              isShow = true;
                            });
                          },
                          child: Container(
                            width: 60.0,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                color: SelectedDate == e
                                    ? Colors.green
                                    : Colors.white),
                            child: Center(
                                child: Text(
                              e['name'],
                              style: TextStyle(
                                  color: SelectedDate == e
                                      ? Colors.white
                                      : Colors.black),
                            )),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 10),
              Visibility(
                  visible: isShow,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: FutureBuilder<List<Map>>(
                      future: subjectProvider.getMyTable2(
                          teacherProvider.getUser(), SelectedDate),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Map>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData && snapshot.data.length > 0) {
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: ListTile(
                                    title: Text(snapshot.data[index]["subject"]
                                        ['name']),
                                    subtitle: Row(
                                      children: [
                                        Text(snapshot.data[index]['from']),
                                        Text("---"),
                                        Text(snapshot.data[index]['to']),
                                      ],
                                    ),
                                    leading: Image.asset(
                                        'assets/images/subject.png'),
                                    trailing: Text(
                                      snapshot.data[index]['hall'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Center(
                            child: Text('لا توجد محاضرات في هذا اليوم '),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                margin: EdgeInsets.all(10.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10.0,
                      physics: BouncingScrollPhysics(),
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(MyLectures());
                          },
                          child: Column(
                            children: [
                              Container(
                                  height: 60.0.sp,
                                  width: 60.0.sp,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/teaching.png'),
                                          fit: BoxFit.cover),
                                      shape: BoxShape.rectangle)),
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
                                  height: 60.0.sp,
                                  width: 60.0.sp,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/calendar.png'),
                                          fit: BoxFit.cover),
                                      shape: BoxShape.rectangle)),
                              Text('الاعلانات',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(MySubjects());
                          },
                          child: Column(
                            children: [
                              Container(
                                  height: 60.0.sp,
                                  width: 60.0.sp,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/subject.png'),
                                          fit: BoxFit.cover),
                                      shape: BoxShape.rectangle)),
                              Text('المواد',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(WebSite());
                          },
                          child: Column(
                            children: [
                              Container(
                                  height: 60.0.sp,
                                  width: 60.0.sp,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/news.png'),
                                          fit: BoxFit.cover),
                                      shape: BoxShape.rectangle)),
                              Text('الموقع  الالكتروني',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(TimeTable());
                          },
                          child: Column(
                            children: [
                              Container(
                                  height: 60.0.sp,
                                  width: 60.0.sp,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/teaching.png'),
                                          fit: BoxFit.cover),
                                      shape: BoxShape.rectangle)),
                              Text('الجدول',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static List<String> getDaysOfWeek([String locale]) {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) => index)
        .map((value) => intl.DateFormat(intl.DateFormat.WEEKDAY, locale)
            .format(firstDayOfWeek.add(Duration(days: value))))
        .toList();
  }
}

class DrawerItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
///////////////////
