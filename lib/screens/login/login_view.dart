import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:teacher_side/screens/ForgotPassword.dart';
import 'package:teacher_side/screens/home_screen.dart';
import 'package:teacher_side/screens/login/bezier_conatainer.dart';
import 'package:teacher_side/screens/login/login_animation.dart';
import 'package:teacher_side/screens/login/login_view_model.dart';
import 'package:teacher_side/utils/constants.dart';
import 'package:teacher_side/utils/firebase_init.dart';
import 'package:teacher_side/utils/ui/pop_up_card.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>  {
  @override
  void initState() {
   
    FirebaseInit.initFirebase();
  }

 
    Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: new Text('Are you sure?'),
              actions: <Widget>[
                new TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                new TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, "/home"),
                  child: new Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
        final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => LoginFormBloc(),
      child: Builder(
        builder: (context) {
          final loginFormBloc = context.read<LoginFormBloc>();

          return SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: 
                  
                  Container(
                    height: height,
                    child: Stack(
                      children:[
                        Positioned(
                          top: -height * .15,
                          right: -MediaQuery.of(context).size.width * .4,
                          child: BezierContainer()), 
                         Column(children: [
                        SizedBox(
                          height: 200.0,
                        ),
                        
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(
                            child: FormBlocListener<LoginFormBloc, String, String>(
                          onSubmitting: (context, state) {
                            LoadingDialog.show(context);
                          },

                          onSuccess: (context, state) async {
                            LoadingDialog.hide(context);
                    
                            await getStorage.write('isLogged', true);
                    
                            Navigator.of(context).pushReplacement(
                                //  HeroDialogRoute(builder: (BuildContext context) { return Center(child: SizedBox(
                                //    height: 200,
                                //    width: 200,
                                //                   child: Card(
                    
                                //      child: Text('success'),),
                                //  )); })
                    
                                MaterialPageRoute(builder: (_) => Home()));
                          },
                          onFailure: (context, state) {
                            LoadingDialog.hide(context);
                    
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text(state.failureResponse)));
                          },
                          child: SingleChildScrollView(
                            physics: ClampingScrollPhysics(),
                            // login form
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  width: 250,
                                  child: TextFieldBlocBuilder(
                                    textFieldBloc: loginFormBloc.phone,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'الهانف',
                                        
                                        labelStyle:  TextStyle(color: Color(0xFFd8dfff)) ,
                                                                           hintStyle:
                                            TextStyle(color: Color(0xFFd8dfff)),
     
                                        prefixIcon: Icon(Icons.phone ,  color: Color(0xffd8dfff)),
                                        // filled: true,
                                        // fillColor: Colors.yellow[200],
                                        border: UnderlineInputBorder(),
                                        contentPadding: EdgeInsets.all(15.0)),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                SizedBox(
                                  width: 250,
                                  child: TextFieldBlocBuilder(
                                    textFieldBloc: loginFormBloc.password,
                                    suffixButton: SuffixButton.obscureText,
                                    
                                    decoration: InputDecoration(
                                        labelText: 'كلمة السر',
                                          labelStyle:
                                            TextStyle(color: Color(0xFFd8dfff)),
                                        hintStyle: TextStyle(color: Color(0xFF959fd1)),
                                        prefixIcon: Icon(Icons.lock ,   color: Color(0xffd8dfff),),
                                        border: UnderlineInputBorder(),
                                        contentPadding: EdgeInsets.all(15.0)),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Center(
                                  child: GestureDetector(
                                    child: Text(
                                      'هل نسيت كلمة السر؟',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () async {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => ForgotPassword()));
                                    },
                                  ),
                                ),
                         
                         InkWell(
                                  onTap: loginFormBloc.submit,
                                  child: Container(
                                    width: 250,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xFFffcf00)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          "تسجيل دخول",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                )        
                              ],
                            ),
                          ),
                        ))
                      ]),
                    
                    
                    
                      ]
                    ),
                  ),
                )),
          );


          return SafeArea(
              child: Stack(children: [
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/splash2.jpg'),
                      fit: BoxFit.cover)),
            ),
            Center(
                child: FormBlocListener<LoginFormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSuccess: (context, state) async {
                LoadingDialog.hide(context);

                await getStorage.write('isLogged', true);

                Navigator.of(context).pushReplacement(
                    //  HeroDialogRoute(builder: (BuildContext context) { return Center(child: SizedBox(
                    //    height: 200,
                    //    width: 200,
                    //                   child: Card(

                    //      child: Text('success'),),
                    //  )); })

                    MaterialPageRoute(builder: (_) => Home()));
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);

                // Scaffold.of(context).showSnackBar(
                //     SnackBar(content: Text(state.failureResponse)));
              },
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                // login form
                child: Column(
                  children: <Widget>[
                    TextFieldBlocBuilder(
                      textFieldBloc: loginFormBloc.phone,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'الهانف',
                          prefixIcon: Icon(Icons.phone),
                          filled: true,
                          fillColor: Colors.grey,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(15.0)),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: loginFormBloc.password,
                      suffixButton: SuffixButton.obscureText,
                      decoration: InputDecoration(
                          labelText: 'كلمة السر',
                          prefixIcon: Icon(Icons.lock),
                          filled: true,
                          fillColor: Colors.grey,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(15.0)),
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: GestureDetector(
                        child: Text(
                          'هل نسيت كلمة السر؟',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
                        },
                      ),
                    ),
                    Container(
                      width: 200.0,
                      child: MaterialButton(
                        color: Colors.green,
                        onPressed: loginFormBloc.submit,
                        child: Text('تسجيل دخول'),
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ]));

          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text('تسجيل الدخول'),
              centerTitle: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
            ),
            body: FormBlocListener<LoginFormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSuccess: (context, state) async {
                LoadingDialog.hide(context);

                await getStorage.write('isLogged', true);

                Navigator.of(context).pushReplacement(
                    //  HeroDialogRoute(builder: (BuildContext context) { return Center(child: SizedBox(
                    //    height: 200,
                    //    width: 200,
                    //                   child: Card(

                    //      child: Text('success'),),
                    //  )); })

                    MaterialPageRoute(builder: (_) => Home()));
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);

                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text(state.failureResponse)));
              },
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    TextFieldBlocBuilder(
                      textFieldBloc: loginFormBloc.phone,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'الهانف',
                          prefixIcon: Icon(Icons.phone),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(15.0)),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: loginFormBloc.password,
                      suffixButton: SuffixButton.obscureText,
                      decoration: InputDecoration(
                          labelText: 'كلمة السر',
                          prefixIcon: Icon(Icons.lock),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(15.0)),
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: GestureDetector(
                        child: Text('هل نسيت كلمة السر؟'),
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
                        },
                      ),
                    ),
                    Container(
                      width: 200.0,
                      child: MaterialButton(
                        color: Colors.green,
                        onPressed: loginFormBloc.submit,
                        child: Text('تسجيل دخول'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: true,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  SuccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.tag_faces, size: 100),
            SizedBox(height: 10),
            Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            RaisedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginForm())),
              icon: Icon(Icons.replay),
              label: Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      //emailField
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _emailController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
    );

    final passwordField = TextFormField(
      //passwordField
      autofocus: false,
      controller: _passwordController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
    );

    final loginButton = Material(
      // loginButton
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.teal,
      child: MaterialButton(
        minWidth: double.infinity,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: null,
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Color(0xffF3F3F3),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: Text(
                        "Your Logo Here",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      )),
                      SizedBox(height: 25.0),
                      emailField,
                      SizedBox(height: 25.0),
                      passwordField,
                      SizedBox(
                        height: 20.0,
                      ),
                      Divider(color: Colors.black),
                      SizedBox(
                        height: 20.0,
                      ),
                      loginButton,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// class Login extends StatefulWidget {
//   @override
//   _LoginState createState() => _LoginState();
// }

// enum LoginStatus { notSignIn, signIn }

// class _LoginState extends State {
//   LoginStatus _loginStatus = LoginStatus.notSignIn;
//   String email, password;
//   final _key = new GlobalKey();

//   bool _secureText = true;

//   showHide() {
//     setState(() {
//       _secureText = !_secureText;
//     });
//   }

//   check() {
//     final form = _key.currentState;
//     if (form.validate()) {
//       form.save();
//       login();
//     }
//   }

//   login() async {
//     final response = await http
//         .post("http://yourwebsite.com/flutter_app/api_verification.php", body: {
//       "flag": 1.toString(),
//       "email": email,
//       "password": password,
//       "fcm_token": "test_fcm_token"
//     });

//     final data = jsonDecode(response.body);
//     int value = data['value'];
//     String message = data['message'];
//     String emailAPI = data['email'];
//     String nameAPI = data['name'];
//     String id = data['id'];

//     if (value == 1) {
//       setState(() {
//         _loginStatus = LoginStatus.signIn;
//         savePref(value, emailAPI, nameAPI, id);
//       });
//       print(message);
//       loginToast(message);
//     } else {
//       print("fail");
//       print(message);
//       loginToast(message);
//     }
//   }