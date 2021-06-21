import 'package:teacher_side/models/dept.dart';
import 'package:teacher_side/models/level.dart';
import 'package:teacher_side/models/semester.dart';
import 'package:teacher_side/models/teacher.dart';


class ClassSubject {

  String  id;
  String name;
  Department department;
  Level level;
 String teacher_id;
  Semester semester;


ClassSubject(this.id  ,this.name  , this.department ,this.level ,this.teacher_id , this.semester);

ClassSubject.fromJson(Map <dynamic ,dynamic >  data){

this.id = data['id'];
this.name = data['name'];
this.department= Department.fromJson( data['dept'])    ;
this.level = Level.fromJson( data['level']);
this.teacher_id = data['teacher_id'];
this.semester =  Semester.fromJson(data['semester']);



}



Map <dynamic ,dynamic >  toJson(){
  return  {
'id': this.id,
'name' : this.name ,
'dept' : this.department.toJson()  ,
'level' : this.level.toJson(),
'teacher_id' : this.teacher_id ,
'semester' : this.semester.toJson()


  };
}

  
}