import 'package:flutter/material.dart';
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

class _SongPageState extends State<SongPage>{

  double songSlider=0.0,volumeSlider=0.0;
  String songDuration="0.00";
  Timer timer;
  static WebViewController _myController;// = new WebViewController();
  String name,artists,password,url,urllink;
  Widget pauseOrPlay = Icon(Icons.play_arrow);
  _SongPageState(this.name,this.artists,this.password,this.url,this.urllink);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        _myController.evaluateJavascript("document.getElementsByName('media')[0].pause();");
        Navigator.pop(context);
      },
          child: Scaffold(
        appBar: AppBar(
          title: Text("song page"),
        ),
        body: Container(
          color: Color.fromRGBO(150, 66, 86, 1.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Color.fromRGBO(200, 75, 96, .9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(200, 75, 96, .9),borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    height: MediaQuery.of(context).size.height*0.4,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: url!=null?Image.network(url):Image.network("https://via.placeholder.com/150"),
                      ),
                    ),
                  ),
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
                child: Column(
                  children: <Widget>[
                    Text(name,style: TextStyle(color: Colors.white)),
                    Text(artists,style: TextStyle(color: Colors.white70))
                  ],
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
                          child: Container(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.14,
                      width: MediaQuery.of(context).size.width*0.53,  
                      child: Column(
                        children: <Widget>[
                          Container(
                            child:Row(
                                children:<Widget>[ 
                                  Text(((double.parse(songDuration)*songSlider)).toStringAsFixed(2),style: TextStyle(color: Colors.white))
                                  ,
                                Container(
                                  height: MediaQuery.of(context).size.height*0.14,
                                  width: MediaQuery.of(context).size.width*0.37,
                                  child: Slider(
                                    activeColor: Colors.white,
                                    inactiveColor: Colors.white24,
                                  value: songSlider,
                                  onChanged: (double d){
                                    int d1=(d*1000).toInt();
                                    d=d1/1000;
                                    String jscom = "document.getElementsByName('media')[0].currentTime = $d*document.getElementsByName('media')[0].duration";
                                    print(jscom);
                                    _myController.evaluateJavascript(jscom);
                                    setState(() {
                                      songSlider=d;
                                    });
                                  },
                              ),
                                ),
                                Text(songDuration,style: TextStyle(color: Colors.white))
                              ]
                            ),
                          ),/*
                          Container(
                            child:Slider(
                              value: 0.0,
                              onChanged: (double){
                                _myController.evaluateJavascript("document.getElementsByName('media')[0].");

                              },

                            ),
                          )*/
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.1,
                        width: MediaQuery.of(context).size.width*0.2,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
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

    timer = Timer.periodic(Duration(seconds: 1), (Timer t){
      if(_myController!=null){
        Future<String> doub = _myController.evaluateJavascript("document.getElementsByName('media')[0].currentTime");
        doub.then((onValue){
          Future<String> doub1 = _myController.evaluateJavascript("document.getElementsByName('media')[0].duration");
          doub1.then((onValue1){
            songDuration = (double.parse(onValue1)/60).toStringAsFixed(2);
              setState(() {
                songSlider = double.parse(onValue)/double.parse(onValue1);
              });
            });
        });
      }
    });
    


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