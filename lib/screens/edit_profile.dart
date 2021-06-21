import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/services_provider.dart';
import 'package:teacher_side/bloc/user_bloc.dart';
import 'package:teacher_side/main.dart';
import 'package:teacher_side/models/semester.dart';

class EditProfile extends StatefulWidget {


  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
TextEditingController phoneController=  new TextEditingController();
TextEditingController addressController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();

List<Semester> semesters = [];
  Semester semester;
var _formKey = GlobalKey<FormState>();
  fetch_semeters() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('semester')
        //.where('teacher' , isEqualTo: teacher.toJson())

        .get();

    setState(() {
      semesters = data.docs.map((e) => Semester.fromJson(e.data())).toList();
    });
  }


@override
void initState() { 
  super.initState();
  fetch_semeters();
}

  @override
  Widget build(BuildContext context) {
   
var teacherProvider = Provider.of<UserBloc>(context);
    var serviceProvider = Provider.of<ServiceProvider>(context);

return Scaffold(
  resizeToAvoidBottomInset: false,
    appBar: AppBar(
        actions: [
         

          IconButton(icon: Icon(FontAwesomeIcons.user), onPressed: () {
             Get.back();
          }) ,

             
        ],
      elevation: 0.0,
        centerTitle: true,
        title: Text(' تعديل الملف الشخصي '),
      ),

      body: Padding(padding: EdgeInsets.all(10.0) ,  
      child:  Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[300],
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(children: [
                      Text('السمستر'),
                      Container(),
                      new DropdownButton<Semester>(
                        value: semester,
                        items: semesters.map((sem) {
                          return DropdownMenuItem<Semester>(
                            value: sem,
                            child: Text(sem.name ?? '' ,  ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            semester = newValue;
                          });
                        },
                      )
                    ])),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.phone),

 
                   labelStyle: TextStyle(color: Color(0xFFd8dfff)),
                  hintStyle: TextStyle(color: Color(0xFFd8dfff)),
                    border: UnderlineInputBorder(),
                                        contentPadding: EdgeInsets.all(15.0),
                  labelText: 'التلفون',
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  icon: const Icon(FontAwesomeIcons.addressCard),
                

                   labelStyle: TextStyle(color: Color(0xFFd8dfff)),
                  hintStyle: TextStyle(color: Color(0xFFd8dfff)),
                  border: UnderlineInputBorder(),
                  contentPadding: EdgeInsets.all(15.0),
                  labelText: 'العنوان',
                ),
              ),

SizedBox(height: 10.0) ,

 TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.security),
                  labelStyle: TextStyle(color: Color(0xFFd8dfff)),
                  hintStyle: TextStyle(color: Color(0xFFd8dfff)),
                  border: UnderlineInputBorder(),
                  contentPadding: EdgeInsets.all(15.0),
                  labelText: 'كلمة السر',
                ),
              ),


Spacer() ,

              Center(
                child: new Container(
                  width: 250,

                  height: 60,
                    // padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                    child: new RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: const Text('تحديث'),
                      onPressed: () async{


if(await serviceProvider.checkInternet()){
  var future = await showLoadingDialog();
var teacher = teacherProvider.getUser();

teacher.semester =  this.semester!=null?this.semester: teacher.semester; 

teacher.phone = phoneController.text.length>0 
                              ? phoneController.text
                              : teacher.phone ;
teacher.address = addressController.text.length > 0
                              ? addressController.text
                              : teacher.address;

teacher.password =   passwordController.text.length>0? passwordController.text:teacher.password;
  CollectionReference teachers =
                              FirebaseFirestore.instance.collection('teacher');
                            // .where('id' , isEqualTo:teacher.id)
                            // .get()
                            // ;
               QuerySnapshot current_teacer =     await      teachers
                         .where('id' , isEqualTo: teacher.id)
                           .get();
                           print(teacher.id);
print(current_teacer.docs.toString());

var doc_id=    current_teacer.docs.first.id;

                            if (phoneController.text.length>0) {

                teachers

                 .doc(doc_id)

    .update({'phone': teacher.phone ,
    'semester' :  teacher.semester.toJson() ,
    'address' : teacher.address ,
    "password" :  teacher.password
    
    
    });


await teacherProvider.updateTeacher(teacher);
 Fluttertoast.showToast(
                                  msg: "تحديث البيانات بنجاح ^_^",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);

future.dismiss();
}else{

   Fluttertoast.showToast(
                              msg: "تأكد من أتصالك بالانترنت ^_^",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
}







                      }
                      })
                    ),
              ),
            ],
          ),
        ) ,),


);

  }
}