import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacher_side/utils/constants.dart';
import 'package:teacher_side/utils/firebase_init.dart';
class AddSubjectFormBloc extends FormBloc<String, String> {
  final phone = TextFieldBloc(
    validators: [
   
    ],
  );

  final password = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

 final select1 = SelectFieldBloc(
    items: ['Option 1', 'Option 2'],
  );

  final select2 = SelectFieldBloc(
    items: ['Option 1', 'Option 2'],
  );

//subject

    final select3 = SelectFieldBloc(
    items: ['Option 1', 'Option 2'],
  );


  
  AddSubjectFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        phone,
        password,
        
      ],
    );
  }



  @override
  void onSubmitting() async {
    print(phone.value);
    print(password.value);

//    await Future<void>.delayed(Duration(seconds: 1));


QuerySnapshot data =await FirebaseFirestore.instance
  .collection('teacher')
  .where('phone', isEqualTo: phone.value.toString())
  .where('password'  , isEqualTo: password.value)
  .get();



print('////////////////////');
print(data.docs);


  





    if (data.size>0) {
      Iterable I =  data.docs;
  //  Teacher teacher  = I.map((e) =>   Teacher.fromJson(I));
    
        await   getStorage.write('teacher', json.encode(data.docs.first.data()));
      emitSuccess();
    } else {
      emitFailure(failureResponse: 'This is an awesome error!');
    }
  }

  @override 
  void reload(){
FirebaseInit.initFirebase();



  }


}

