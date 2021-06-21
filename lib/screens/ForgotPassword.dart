import 'package:flutter/material.dart';
import 'package:teacher_side/screens/login/login_view.dart';
class ForgotPassword extends StatelessWidget {
  static String id = 'forgot-password';
TextEditingController _phoneNumberController = new TextEditingController();
var formKey =  GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.lightBlueAccent,
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ' Your Phone',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  validator: (txt)=>txt.length>0? null:'the number is required' ,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    icon: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    errorStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                RaisedButton(
                  child: Text('Send Phone'),
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      debugPrint('verify');
                      // await verifyPhone();
                    }
                  },
                ),
                FlatButton(
                  child: Text('Sign In'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Material(child: LoginForm())));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

// Future<void>  verifyPhone() async{
//   await FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber:'+249 0998541587',
//       // '+249'+_phoneNumberController.text.trim(),
//       verificationCompleted: (PhoneAuthCredential credential) {
//         print('complete');
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         print(e.message);
//       },
//       codeSent: (String verificationId, int resendToken) {
//         print('code sent');
//             String smsCode='xxxx';
//             PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
//             verificationId: verificationId, smsCode: smsCode);

//       },
//       codeAutoRetrievalTimeout: (String verificationId) {},
//     );
// }


  
}
