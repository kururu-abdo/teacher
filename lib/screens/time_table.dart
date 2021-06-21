import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/subjects_bloc.dart';
import 'package:teacher_side/bloc/user_bloc.dart';
import 'package:teacher_side/utils/constants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
class TimeTable extends StatefulWidget {
  const TimeTable({ Key key }) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {

 

  @override
  Widget build(BuildContext context) {
     List<Widget> _getCards() {
      List<Widget> crds = List<Widget>();
      for (var i = 0; i < DAYS.length; i++) {
        crds.add(
AnimationConfiguration.staggeredList(
          position: i,
          duration: const Duration(milliseconds: 800),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: Container(
            child: Card(
              // color: widget.bodyForegroundColor,
              child: InkWell(
             
                onTap: () {
                    debugPrint('goo');
                  Get.to(() => TimeDetails(day: DAYS[i]));
                },
                child: Container(
                  width: 300,
                  height: 70,
                  child: Center(
                    child: Text(
                      DAYS[i]['name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        // color: widget.textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            margin: EdgeInsets.only(
              top: 5.0,
              bottom: 5.0,
            ),
          ),
            ),
          ),
        )



          
        );
      }
      return crds;
    }
     var teacherProvider = Provider.of<UserBloc>(context);
return Scaffold(
  appBar: AppBar(title: Text("اختر اليوم"),
  centerTitle: true ,
  
  
  elevation: 0.0,),
   body: Container(
        child: GridView.count(crossAxisCount: 2,
          children: _getCards(),
        ),
        margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
      ),


);
  }
}
class TimeDetails extends StatefulWidget {
  Map day;
   TimeDetails({ Key , key  ,  this.day }) : super(key: key);

  @override
  _TimeDetailsState createState() => _TimeDetailsState();
}

class _TimeDetailsState extends State<TimeDetails> {
  @override
  Widget build(BuildContext context) {
      var subcet_provider =SubjectProvider();
   var teacherProvider = Provider.of<UserBloc>(context);
    return Directionality(
textDirection: TextDirection.rtl,
      child: Scaffold(
       appBar: AppBar(title: Text(widget.day['name']),
       elevation: 0,
       
       
         centerTitle: true,),
    body: Padding(padding: EdgeInsets.all(10.0) ,
    
    
    child:   StreamBuilder<List<Map>>(
      stream: subcet_provider.getMyTable(teacherProvider.getUser(), widget.day),
      
      builder: (BuildContext context, AsyncSnapshot<List<Map>>  snapshot) {
       if ( snapshot.connectionState == ConnectionState.done  ) {
     


     if (snapshot.data.length<=0) {
         return Center(
                    child: Column(
                      children: [
                        Image.asset("assets/images/not_found.png"),
                        SizedBox(
                          height: 10,
                        ),
                        Text('لا توجد محاضرات لهذا اليوم')
                      ],
                    ),
                  );
     }

       return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.data[index]['subject']['name']),
                        subtitle: Text(snapshot.data[index]['subject']['level']
                                ['name'] +
                            " " +
                            snapshot.data[index]['subject']['department']
                                ['name']),
                        trailing: Text(snapshot.data[index]['hall'] +
                            snapshot.data[index]['from']),
                      ),
                    );
                  },
                );
       }
 else    if (snapshot.connectionState==ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator(),);
    }
    
   return Center(
                child: CircularProgressIndicator(),
              ); 
     
      },
    ),  ),
      ),
    );
  }
}