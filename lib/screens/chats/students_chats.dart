import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/main_bloc.dart';
import 'package:teacher_side/bloc/user_bloc.dart';
import 'package:teacher_side/main.dart';
import 'package:teacher_side/models/chat_user.dart';
import 'package:teacher_side/screens/chats/chat_page.dart';
import 'package:teacher_side/utils/fcm_config.dart';

class Chats extends StatefulWidget {
  Chats({Key key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    
var mainBloc = Provider.of<MainBloc>(context);
var userBloc = Provider.of<UserBloc>(context);


    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
  actions: [
IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Get.back();
                })    
  ],


        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){

          Get.back();
        }),
        
        title: Text('الماسنجر'),  
      
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(bottomRight: Radius.circular(20) ,  bottomLeft: 
      //   Radius.circular(20)
      //   )
      // ),
      elevation: 0.0,
      ),
      body: Padding(padding: EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<User>>(
        stream: mainBloc.getChatUsers(userBloc.getUser()),
        builder: (context, snapshot  ) {


          if (snapshot.connectionState==ConnectionState.waiting) {
            return Center(
child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            //TODOS:students chat with me
  itemCount: snapshot.data.length,
  shrinkWrap: true,
  padding: EdgeInsets.only(top: 16),
  physics: NeverScrollableScrollPhysics(),
  itemBuilder: (context, index){
   


          return Container(
            // color: Colors.grey,
            width: double.infinity,
            child: Card(
              elevation: 8.0,
              child: ListTile(
onTap: () async{
String myToken = await  FCMConfig.getToken();
  Get.to(
ChatPage(
  
  user: snapshot.data[index]
  
  ,  me:
  User(userBloc.getUser().id,  userBloc.getUser().name, 

'أستاذ' )


,

  ));
},


title: Text(snapshot.data[index].name),

              ),
            ),
          );
  },
);
        }
      ),
      
      ),

      ),
    );
  }
}