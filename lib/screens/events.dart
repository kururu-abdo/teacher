import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:teacher_side/bloc/main_bloc.dart';
import 'package:teacher_side/models/event.dart';
import 'package:teacher_side/screens/main_event_details.dart';
class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
   @override
  Widget build(BuildContext context) {
   


    var main_bloc = Provider.of<MainBloc>(context);
    return 
     Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<List<Event>>(
          stream: main_bloc.getEvents(), 
          builder:
              (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          if (!snapshot.hasData) {
              return Center(
                child: Text('no events yet'),
              );
            }
            return ListView(
              children: snapshot.data
              
                  .map((event) =>   Card(
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.grey[500].withOpacity(0.5)
                            ),
                            child: ListTile(
leading: ImageIcon(AssetImage('assets/images/news.png')),

                              onTap: () {
                           Get.to(MainEventDetails(   event));
                              },
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              title: Text(
                                event.title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                  )
                  .toList(),
            );
          },
        ),
      );


  }
}