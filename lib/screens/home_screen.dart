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

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
// @override
// void initState() {
//   super.initState();

// }

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails

    }
  }

  @override
  void initState() {
    super.initState();
    BackendlessInit().init();
    FirebaseInit.initFirebase();
  // initializeFlutterFire();
FCMConfig.fcmConfig();
    // reg_device();
    // itens.add(new );

//  itens.add(new );

//  itens.add(new );

    initializeFlutterFire();
    fetch_teacher();
  }
subscribe(){
  FCMConfig.subscripeToTopic("teacher"+teacher.id.toString());
  
}
  Teacher teacher;
  fetch_teacher() async {
    setState(() {
      debugPrint(json.decode(getStorage.read('teacher')  ).toString());
      teacher = Teacher.fromJson(json.decode(getStorage.read('teacher')));
    });
    subscribe();
 
  }

  List<ScreenHiddenDrawer> itens = new List();

  reg_device() async {
    List<String> channels = new List<String>();
    channels.add("default");

    await Backendless.messaging
        .registerDevice(channels, DateTime.utc(2021, 3, 1), (message) {
      print(message);
    });
  }

  
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('subject');

//    CollectionReference users = FirebaseFirestore.instance.collection('subject');

    return SafeArea(
      child: HiddenDrawerMenu(
        backgroundColorMenu: Colors.blueGrey,
        backgroundColorAppBar: Colors.teal,

        // backgroundMenu: DecorationImage(image: NetworkImage('')),
        screens: [
          ScreenHiddenDrawer(
              new ItemHiddenMenu(
                name: "الصفحة الرئيسية",
                baseStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8), fontSize: 28.0),
                colorLineSelected: Colors.teal,
              ),
              Scaffold(
                
                
                floatingActionButton: SpeedDial(
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
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
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
                      onTap: () => Navigator.of(context).push(
                          HeroDialogRoute(builder: (_) => AddTodoPopupCard())),
                      onLongPress: () => print('FIRST CHILD LONG PRESS'),
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.brush),
                      backgroundColor: Colors.blue,
                      label: 'اضافة اعلان',
                      labelStyle: TextStyle(fontSize: 18.0),
                      onTap: () => print('SECOND CHILD'),
                      onLongPress: () => print('SECOND CHILD LONG PRESS'),
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.keyboard_voice),
                      backgroundColor: Colors.green,
                      label: 'تسجيل خروج',
                      labelStyle: TextStyle(fontSize: 18.0),
                      onTap: () => print('THIRD تسجيل خروجCHILD'),
                      onLongPress: () => print('THIRD CHILD LONG PRESS'),
                    ),
                  ],
                ),
                body: ListView(children: [
                  SizedBox(height: 20.0),
                  Text('موادي'),
                  StreamBuilder<QuerySnapshot>(
                    stream: users.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      return Container(
                        
                        height: 150.0,
                        // color: Colors.grey[900],
                        child: new ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => SubjectDetails(
                                        ClassSubject.fromJson(
                                            document.data()))));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(5, 5),
                                        blurRadius: 1.0,
                                        spreadRadius: 1.0)
                                  ],

                                ),
                                child: new Card(
                                  shadowColor: Colors.amber,
                                  color: Colors.grey,
                                  child: Column(children: [
                                    Text(document.data()['name']),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(document.data()['dept']['name'])
                                  ]),
                                ),
                              ),
                            );

                          }).toList(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height:200),
                  Text('last news')
                ]),
              )),
          ScreenHiddenDrawer(
              new ItemHiddenMenu(
                name: "معلوماتي",
                baseStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8), fontSize: 28.0),
                colorLineSelected: Colors.teal,
              ),
              MyPrpfole()),
          ScreenHiddenDrawer(
              new ItemHiddenMenu(
                name: "المواد",
                baseStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8), fontSize: 28.0),
                colorLineSelected: Colors.teal,
              ),
              MySubjects())
        ],
      ),
    );
  }
}

class Home  extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return _HomeState();
  }


}

class _HomeState extends State<Home>{
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
                title:  Text(
                  teacher.name,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              new ListTile(
                onTap: (){
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
                onTap: (){
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
                  onTap: (){
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
                onTap: (){
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
Future.delayed(Duration(seconds: 5) ,   (){
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
 FCMConfig.getToken().then((value) => debugPrint(value));


fetch_teacher();
 subscribe();
}
 subscribe(){
   var teacher = Teacher.fromJson(json.decode(getStorage.read('teacher')));
   FCMConfig.subscripeToTopic('teacher${teacher.id.toString()}');
 }

int tabIndex = 0;


  List<Widget> screens =[

Container(
  height: double.infinity,

  child: ListView(
    children: [
      SizedBox(height: 10,),
Container(
            height: 150,
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
              ),
              items: ['assets/images/slide1.webp', 'assets/images/slide2.webp', 'assets/images/slide3.webp',
                'assets/images/slide4.webp', 'assets/images/slide5.jpeg'
              ].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(i))
                        ),
                        
                        
                        );
                  },
                );
              }).toList(),
            ),
          ),
 SizedBox(height: 10,) ,

Container(
  height: 250,
 decoration: BoxDecoration(
                            color:Colors.blue[200].withOpacity(0.5)  ,
                            borderRadius: BorderRadius.only(
                             topLeft:Radius.circular(20.0),
                             topRight: Radius.circular(20.0),
                            ),
                          ),

child: GridView.count(crossAxisCount: 3 ,

children: [
     GestureDetector(
       onTap: (){
         Get.to(MyPrpfole());
       },
       child: Container(
         child: Column(

           children: [
                    Container(
                           
  height: 80,
  width: 80.0,

                            decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage('assets/images/profile.png'))
                                
                                
                                , shape: BoxShape.circle)
                                ) ,

                                Text('الملف الشخصي')


           ],
         ),
       ),
     ) ,
  //  GestureDetector(
  //    onTap: (){
  //      Get.to(Events());
  //    },
  //    child: Column(
  //                   children: [
  //                     Container(
  //                         height: 80,
  //                         width: 80.0,
  //                         decoration: BoxDecoration(
  //                            image: DecorationImage(image: AssetImage('assets/images/news.png')) ,
                             
                              
  //                              shape: BoxShape.circle)),
  //                     Text('الأخبار')
  //                   ],
  //                 ),
  //  ),
                   GestureDetector(
                     onTap: (){
                       Get.to(Chats());
                     },
                     child: Column(
                  children: [
                      Container(
                          height: 80,
                          width: 80.0,
                          decoration: BoxDecoration(
                             image: DecorationImage(
                                  image: AssetImage('assets/images/messages.png')),
                               shape: BoxShape.circle)),
                      Text('المحادثات')
                  ],
                ),
                   ),
     
  //  GestureDetector(
  //    onTap: (){
  //      Get.to(MySubjects());
  //    },
  //    child: Column(
  //                   children: [
  //                     Container(
  //                         height: 80,
  //                         width: 80.0,
  //                         decoration: BoxDecoration(
  //                            image: DecorationImage(
  //                                 image: AssetImage('assets/images/subject.png')),
                              
                              
  //                              shape: BoxShape.circle)),
  //                     Text('المواد')
  //                   ],
  //                 ),
  //  ),

GestureDetector(
  onTap: (){
    Get.to(WebSite());
  },
  child:   Column(
  
                    children: [
  
                      Container(
  
                          height: 80,
  
                          width: 80.0,
  
                          decoration: BoxDecoration(
  
                             image: DecorationImage(
  
                                  image: AssetImage('assets/images/website.png')), 
  
                              
  
                              
  
                              shape: BoxShape.circle)),
  
                      Text('صفحة الكلية')
  
                    ],
  
                  ),
),
],
),


)


    ],
  ),
) ,

MySubjects(),


    Container(
      height: double.infinity,
        child: Events(),
        

    ),





  ];






var _scaffoldKey =  GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
var subjectProvider =  Provider.of<SubjectProvider>(context);
var teacherProvider =  Provider.of<UserBloc>(context);


var rotate =  Provider.of<AnimContainer>(context );
var main_bloc  =   Provider.of<MainBloc>(context );


    return Scaffold(
      key: _scaffoldKey,
    
      appBar: AppBar(
      
      elevation: 0.0,
      
      title: Text('الاستاذ'),  actions: [

IconButton(onPressed: (){
 _bottomSheetMore(context);
}, icon: Icon(Icons.menu))


    ],),
    
    
    
  body: Padding(padding: EdgeInsets.all(8.0) ,
  
  child: ListView(

    children: [


       SizedBox(
              height: 5.0,
            ),
            Container(
              height: 150,
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
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          image: DecorationImage(
                              image: AssetImage(i), fit: BoxFit.cover),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ), 

SizedBox(height: 20,) ,

Container(width: double.infinity,
child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children:[
Text('موادي' ,   style:TextStyle(color:Colors.white ,   fontWeight:FontWeight.bold) ),
 

  ]
),
) ,

SizedBox(
              height: 20,
            ),
Container(
                height: MediaQuery.of(context).size.height/2,
                child: StreamBuilder<List<ClassSubject>>(
                  stream : subjectProvider.getMySubjects(teacherProvider.getUser()),
                  builder: (BuildContext context, AsyncSnapshot<List<ClassSubject>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(

                        child: CircularProgressIndicator(),
                      );
                    }
                    return 
                  GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10 ,
                  children: snapshot.data.map((subject) => 

OpenContainer(
                                  openBuilder: (_, closeContainer) =>
                                 SubjectDetails(subject)    ,
                                  onClosed: (res) => setState(() {
                                    
                                  }),
                                
                                  closedBuilder: (_, openContainer) =>
                                     


                                         Container(
                              height: 120,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 224, 226, 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                children: [
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(subject.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
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
                            )
                                ),


 





                  ).toList(),
                  
                  
                  ); 
                    
                  },
                ),
 )



     ],
  ),
  ),
    
    ) ;




  }

}

class DrawerItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
///////////////////