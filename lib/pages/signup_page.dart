import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_player/main.dart';
import 'song_list.dart';

class SignupPage extends StatefulWidget {

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  
  String name,password;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(220,150, 180,1),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height*0.5,
          width: MediaQuery.of(context).size.width*0.6,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: TextField(
                    onChanged: (text){
                      this.name = text;
                    },
                    decoration: InputDecoration(
                      labelText: "Name",
                      border:OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0))
                      )
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: TextField(
                    onChanged: (password){
                      this.password = password;
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      border:OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0))
                      )
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: RaisedButton(
                    child: Text("Login"),
                    onPressed: (){
                      print("login pressed");
                      exist(this.name, this.password);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: RaisedButton(
                    child: Text("Signup"),
                    onPressed: (){
                      print("signun pressed");
                      signup(this.name, this.password);
                    }
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void signup(String name,String password){
    Firestore.instance.collection('users')
    .document(name)
    .setData({ 'name':name, 'password': password,'songs':["Dummy Data",] })
    .then((value){
      Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      prefs.then((onValue){
        onValue.setString('name',name);
        onValue.setString('password', password);
        Navigator.push(context,MaterialPageRoute(builder: (context) => SongList(name,password)),);
      });
    }).catchError((onError){
      print("error occured while signup");
    });
  }
  void exist(String name, String password) {
        Firestore.instance
        .collection('users')
        .document(name)
        .get()
        .then((DocumentSnapshot ds) {
          Users abc = new Users.fromSnapshot(ds);
          print(abc.name);
          if(abc.password == password){
            Future<SharedPreferences> prefs = SharedPreferences.getInstance();
            prefs.then((onValue){
              onValue.setString('name',name);
              onValue.setString('password', password);
              Navigator.push(context,MaterialPageRoute(builder: (context) => SongList(name,password)),);
            });          
          }
          else{
            print("wrong password");
          }
        }).catchError((error){
      });
  }
}