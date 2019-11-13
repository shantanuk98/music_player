import 'package:flutter/material.dart';
import 'package:music_player/pages/song_list.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:media_notification/media_notification.dart';
import 'payment_page.dart';

class SongPage extends StatefulWidget {

  final String name,artists,password,url,urllink;
  SongPage(this.name,this.artists,this.password,this.url,this.urllink);

  @override
  _SongPageState createState() => _SongPageState(name,artists,password,url,urllink);
}

class _SongPageState extends State<SongPage> with AutomaticKeepAliveClientMixin {


  @override
  bool get wantKeepAlive => true;

  static WebViewController _myController;// = new WebViewController();
  String name,artists,password,url,urllink;
  Widget pauseOrPlay = Icon(Icons.play_arrow);
  _SongPageState(this.name,this.artists,this.password,this.url,this.urllink);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> SongList(name, password)));
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
                  Container(
                    height: MediaQuery.of(context).size.height*0.14,
                    width: MediaQuery.of(context).size.width*0.54,  
                    child: Column(
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
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*0.1,
                      width: MediaQuery.of(context).size.width*0.2,
                    child: RaisedButton(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.attach_money),
                      ),
                      onPressed: (){
                        _myController.evaluateJavascript("document.getElementsByName('media')[0].pause()");
                        //dispose();
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentPage(name,artists,url)));
                      },
                    ),
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

  String status = 'hidden';

  Future<void> hide() async {
    try {
      await MediaNotification.hide();
      setState(() => status = 'hidden');
  } on PlatformException {

    }
  }

  Future<void> show(title, author) async {
    try {
      await MediaNotification.show(title: title, author: author);
      setState(() => status = 'play');
    } on PlatformException {

    }
  }

  @override
  void initState() {
    super.initState();

    MediaNotification.setListener('pause', () {
      setState(() => status = 'pause');
      Future<String> pop = _myController.evaluateJavascript("document.getElementsByName('media')[0].paused;");
                            pop.then((onValue){
                              if(onValue=="false"){
                                _myController.evaluateJavascript("document.getElementsByName('media')[0].pause();");
                                setState(() {
                                  pauseOrPlay = Icon(Icons.play_arrow);
                                });
                              }
                            });
    });

    MediaNotification.setListener('play', () {
      setState(() => status = 'play');
      Future<String> pop = _myController.evaluateJavascript("document.getElementsByName('media')[0].paused;");
                            pop.then((onValue){
                              if(onValue=="true"){
                                _myController.evaluateJavascript("document.getElementsByName('media')[0].play();");
                                setState(() {
                                  pauseOrPlay = Icon(Icons.pause);
                                });
                              }
                            });
    });
    
    MediaNotification.setListener('next', () {
      
    });

    MediaNotification.setListener('prev', () {
      
    });

    MediaNotification.setListener('select', () {
      
    });

    show(name, name);
  }


  @override 
  void dispose(){
    super.dispose();
  }
}