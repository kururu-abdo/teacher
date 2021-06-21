import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:teacher_side/models/teacher.dart';
import 'package:teacher_side/utils/constants.dart';

class HomeBloc extends Bloc{

  HomeBloc(initialState) : super(initialState){
fetch_teacher().then();
  }

  Teacher teacher;


fetch_teacher() async{


        teacher =  Teacher.fromJson(  json.decode(getStorage.read('teacher')));
}
  

  @override
  Stream mapEventToState(event) {
    
    throw UnimplementedError();
  }

}