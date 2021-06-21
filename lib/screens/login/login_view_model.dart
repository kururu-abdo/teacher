import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacher_side/models/teacher.dart';
import 'package:teacher_side/utils/constants.dart';
import 'package:teacher_side/utils/firebase_init.dart';
class LoginFormBloc extends FormBloc<String, String> {
  final phone = TextFieldBloc(
    validators: [
   
    ],
  );

  final password = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final showSuccessResponse = BooleanFieldBloc();

  LoginFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        phone,
        password,
        showSuccessResponse,
      ],
    );
  }



  @override
  void onSubmitting() async {
    print(phone.value);
    print(password.value);
    print(showSuccessResponse.value);

//    await Future<void>.delayed(Duration(seconds: 1));

print('querying data');
QuerySnapshot data =await FirebaseFirestore.instance
  .collection('teacher')
  .where('phone', isEqualTo: phone.value.toString())
  .where('password'  , isEqualTo: password.value.toString())
  .get();



print('////////////////////');
print(data.docs);


  





    if (data.size>0) {
      Iterable I =  data.docs;
  //  Teacher teacher  = I.map((e) =>   Teacher.fromJson(I));
    
        await   getStorage.write('teacher', json.encode(data.docs.first.data()));
      emitSuccess();
    } else {
      emitFailure(failureResponse: 'خطأ في كلمة السر او في رقم الهاتف');
    }
  }

  @override 
  void reload(){
FirebaseInit.initFirebase();



  }

}

