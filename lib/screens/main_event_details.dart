import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:teacher_side/models/event.dart';
class MainEventDetails extends StatefulWidget {
final  Event  data;
MainEventDetails(this.data);


  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<MainEventDetails> {
  List<String>  files =[];
  @override
  void initState() { 
    super.initState();


fill_array();
  }
fill_array(){
  for (var i = 0; i < widget.data.Files.length; i++) {
    files.add(widget.data.Files[i]);
  }
}
    ScrollController _scrollController = ScrollController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
     resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue[200].withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        toolbarHeight: 80,
        title: Text('التفاصيل'),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(

          children: [
Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(blurRadius: 2.0, color: Colors.white)
                  ]),
                  child: Text('االموضوع.')),
              SizedBox(
                height: 10.0,
              ),

  Container(
width: double.infinity,
height: 100,
child: SingleChildScrollView(
  child: Text(widget.data.body != null?widget.data.body :''
  
  ,
  maxLines: 20,

  style: TextStyle(color: Colors.white),
  ),
),

  ) ,




 Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(blurRadius: 2.0, color: Colors.white)
                  ]),
                  child: Text('الملفات...')),
                 SizedBox(height: 10.0,),
         Center(
                child: Container(
                  height: MediaQuery.of(context).size.height-120,
                    decoration: BoxDecoration(),
                    child: files.length > 0
                        ? GridView.count(
                            crossAxisCount: 2,
                            children: files.map((file) {
                              print(file);

                              return Container(
                                margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue.withOpacity(0.5),
                                ),
                                child: Column(
                                  children: [

                                 
                                    IconButton(
                                        icon: Icon(FontAwesomeIcons.download,),
                                        onPressed: () {
                                          _requestDownload(file);
                                        }),
                                    Text('ملف ' ,   style: TextStyle(color: Colors.white) )
                                  ],
                                ),
                              );

                              return Stack(
                                children: [
                                  Container(
                                    color: Colors.green[300],
                                    height: 200,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          right: 5,
                                          child: IconButton(
                                              icon: Icon(
                                                  Icons.download_done_rounded),
                                              onPressed: () {
                                                _requestDownload(file);
                                              }),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text('ملف '),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          )
                        : Text('no files in this event')),
              ),
          ],
        ),
      )
 

    );
  }
    void _requestDownload(String link) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

       
    final taskId = await FlutterDownloader.enqueue(
      url: link,
      
   
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, 
          savedDir: appDocPath, // click on notification to open downloaded file (for Android)
    );
  }
}