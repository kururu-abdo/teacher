import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:teacher_side/models/teacher.dart';
import 'package:teacher_side/utils/constants.dart';

class UserBloc {
Teacher teacher;


Teacher  getUser() {

var teacher =    Teacher.fromJson(json.decode(getStorage.read('teacher')));


return teacher;

}


Future<void>  updateTeacher(Teacher teacher) async{

await getStorage.write('teacher', json.encode(teacher.toJson()));

}




}
