import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class SongPage extends StatefulWidget {

  final String name,url,urllink;
  SongPage(this.name,this.url,this.urllink);

  @override
  _SongPageState createState() => _SongPageState(name,url,urllink);
}

class _SongPageState extends State<SongPage> with AutomaticKeepAliveClientMixin {


  @override
  bool get wantKeepAlive => true;

  static WebViewController _myController;// = new WebViewController();


  String name,url,urllink;
  Widget pauseOrPlay = Icon(Icons.play_arrow);
  _SongPageState(this.name,this.url,this.urllink);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
        //dispose();
      },
          child: Scaffold(
        appBar: AppBar(
          title: Text("song page"),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*0.4,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: url!=null?Image.network(url):Image.network("https://via.placeholder.com/150"),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.2,
              width: MediaQuery.of(context).size.width,
                child: Center(
                        child: Visibility(
                          maintainState: true,
                          visible: false,
                          child: WebView(
                            onWebViewCreated: (controller){
                              _myController = controller;
                            },
                            javascriptMode: JavascriptMode.unrestricted,
                            initialUrl: urllink,
                          ),
                        ),
                        
                    ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.1,
                      width: MediaQuery.of(context).size.width*0.2,
                      child: Container(
                        child: RaisedButton(
                          child: pauseOrPlay,
                          onPressed: (){
                            print(_myController.runtimeType.toString());
                            Future<String> pop = _myController.evaluateJavascript("document.getElementsByName('media')[0].paused;");
                            pop.then((onValue){
                              if(onValue=="true"){
                                _myController.evaluateJavascript("document.getElementsByName('media')[0].play();");
                                setState(() {
                                  pauseOrPlay = Icon(Icons.pause);
                                });
                              }
                              else{
                                _myController.evaluateJavascript("document.getElementsByName('media')[0].pause();");
                                setState(() {
                                  pauseOrPlay = Icon(Icons.play_arrow);
                                });
                              }
                            }) ;
                          },
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        child:Slider(
                          value: 0.5,
                          onChanged: (double){

                          },

                        ),
                      ),
                      Container(
                        child:Slider(
                          value: 0.1,
                          onChanged: (double){

                          },

                        ),
                      )
                    ],
                  )
                ],
              ),

              /*
              height: MediaQuery.of(context).size.height*0.05,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: RaisedButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: (){
                    _myController.evaluateJavascript("document.getElementsByName('media')[0].pause();");
                  },
                ),
              ),*/
            )
          ],
        ),
      ),
    );
  }

  


  @override 
  void dispose(){
    super.dispose();
  }
}