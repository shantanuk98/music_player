import 'package:flutter/material.dart';
import 'package:music_player/pages/signup_page.dart';
import 'package:music_player/pages/song_list.dart';
import 'signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:media_notification/media_notification.dart';
import 'package:flutter/services.dart';
import 'song_page.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      backgroundColor: Color.fromRGBO(150, 66, 86, 1.0),
            body: GestureDetector(
              onTap: (){
                Future<SharedPreferences> prefs = SharedPreferences.getInstance();
                prefs.then((onValue){
                  if(onValue.getString('name') != null){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => SongList(onValue.getString('name'),onValue.getString('password'))));
                  }
                  else{
                    Navigator.push(context,MaterialPageRoute(builder: (context) => SongList(onValue.getString('name'),onValue.getString('passwored'))));
                  }
                }).catchError((onError){
                  print("error on intro page");
                    Navigator.push(context,MaterialPageRoute(builder: (context) => SignupPage()));
                });
              },
              child: Center(
                child: Image.asset('assets/images/img.png')
              ),
            ),
    );
  }

  //@override 
  void initState() {
    super.initState();
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((onValue){
      if(onValue.getString('name') != null){
        Future.delayed(Duration(seconds: 3),(){Navigator.push(context,MaterialPageRoute(builder: (context) => SongList(onValue.getString('name'),onValue.getString('password'))),);});
      }
      else{
        Future.delayed(Duration(seconds: 3),(){Navigator.push(context,MaterialPageRoute(builder: (context) => SignupPage()),);});
      }
    }).catchError((onError){
      print("error on intro page");
      Future.delayed(Duration(seconds: 3),(){Navigator.push(context,MaterialPageRoute(builder: (context) => SignupPage()),);});
    });
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
      Future<String> pop = SongPage._myController.evaluateJavascript("document.getElementsByName('media')[0].paused;");
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


}