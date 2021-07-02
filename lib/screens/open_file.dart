import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OpenFile extends StatelessWidget {
  final  String  url ;

  const OpenFile({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
      SafeArea(
            child:   Container(height: double.infinity,
            
            child: WebViewContainer(url),
            )
    
    );
  }

  Widget _urlButton(BuildContext context, String url) {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: WebViewContainer(url)
        
        );
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }
}


class WebViewContainer extends StatefulWidget {
  final url;

  WebViewContainer(this.url);

  @override
  createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  final String  _url;
  final _key = UniqueKey();

  _WebViewContainerState(this._url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _url));
          
        
  }
}
