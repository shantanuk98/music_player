import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:music_player/pages/credit.dart';
import 'package:music_player/pages/intro_page.dart';
import 'package:music_player/pages/wish_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_player/main.dart';
import 'dart:convert';
import 'song_page.dart';

import 'package:music_player/pages/song_page.dart';

class SongList extends StatefulWidget {
  final String name,password;
  SongList(this.name,this.password);
  @override
  _SongListState createState() => _SongListState(this.name,password);
}

class _SongListState extends State<SongList> {
  final String name,password;
  _SongListState(this.name,this.password);
  Map data;
  List userData;
  List<String> selectedSongs = ["Dummy Data",];
  void getData() async {
    http.Response response = await http.get('http://starlord.hackerearth.com/studio');
    setState(() {
      userData = json.decode(response.body);
    });
  }
  void getSelectedSongs() async {
    Firestore.instance
        .collection('users')
        .document(name)
        .get()
        .then((DocumentSnapshot ds) {
          print("grt selcted song bef abc");
          Users abc = new Users.fromSnapshot(ds);
          print("get sel song after abc");
          setState(() {
            selectedSongs = List.from(abc.songs);
            print(selectedSongs);
          });
      }).catchError((error){
        print(error.toString());
      });
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: draw(),
      backgroundColor: Color.fromRGBO(150, 66, 86, 1.0),
      appBar: AppBar(
        title: Text("Songs"),
        
        actions: <Widget>[
            GestureDetector(
              onTap: (){
                
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 4,6, 4),
                child: Icon(Icons.search,color: Color.fromRGBO(220,150, 180,1)),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>WishList(name, password)));
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 4,6, 4),
                child: Icon(Icons.favorite,color: Color.fromRGBO(220,150, 180,1)),
              ),
            ),
            
            
        ],
      ),
      body: ListView.builder(
                  itemCount: userData == null ? 0 : userData.length ,
                  itemBuilder: (BuildContext context,int index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: songcard(userData[index ]['song'],userData[index]['artists'],userData[index]['cover_image'],userData[index]['url'])
                      ),
                    );
                  },
                ),

    );
  }

  Widget songcard(String song , String artists ,String url,String urllink ){
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context) => SongPage(song,artists,password,url,urllink)),);
      },
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Material(
            elevation: 10.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(200, 75, 96, .9),borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: ListTile(
                  //leading: Icon(Icons.arrow_forward),
                  title: Text(song,style: TextStyle(color: Colors.white)),
                  subtitle: Text(artists,style: TextStyle(color: Color.fromRGBO(230, 170, 200, 1))),
                  trailing: Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              (selectedSongs.contains(song))?selectedSongs.remove(song):selectedSongs.add(song);
                              Firestore.instance.collection('users')
                              .document(name)
                              .setData({'name':name,'password': password ,'songs':List.from(selectedSongs) })
                              .catchError((onError){
                                print("error while updating selected songs");
                              });
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: (selectedSongs.contains(song))? Icon(Icons.favorite,color: Color.fromRGBO(220,150, 180,1)):Icon(Icons.favorite_border,color: Color.fromRGBO(220,150, 180,1)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Icons.cloud_download,color: Color.fromRGBO(90,50, 60,1)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ),
    );
  }

  Widget draw(){
    return Drawer(
      child: Container(
        color: Color.fromRGBO(150, 66, 86, 1.0),
        child: ListView(
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Container(
              //color: Colors.white,
              height: MediaQuery.of(context).size.height*0.03,
              width: MediaQuery.of(context).size.width*1 ,
            ),
            Container(
              color: Colors.green,
              height: MediaQuery.of(context).size.height*0.25,   //photo
              width: MediaQuery.of(context).size.width*1,
              child: Center(
                child: Text(name),
              ),
            ),
            Container(
              //color: Colors.white,
              height: MediaQuery.of(context).size.height*0.03,
              width: MediaQuery.of(context).size.width*1 ,
            ),
            Container(
              color: Colors.blue,
              height: MediaQuery.of(context).size.height*0.1,     // name
              width: MediaQuery.of(context).size.width*1 ,
              child: Center(
                child: Text(name,style: TextStyle(
                  fontStyle: FontStyle.italic, 
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w300,
                  fontSize: 30 
                 ),),
              ),
            ),
            Container(
              //color: Colors.white,
              height: MediaQuery.of(context).size.height*0.03,
              width: MediaQuery.of(context).size.width*1 ,
            ),
            Container(
              color: Colors.blue,
              height: MediaQuery.of(context).size.height*0.1,   //credit
              width: MediaQuery.of(context).size.width*1 ,
              child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Credit() ));
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 4,6, 4),
                  child:Text("Credit") 
                  //Icon(Icons.person,color: Color.fromRGBO(90,50, 60,1)),
                ),
              ),
            ),
            ),
            Container(
              //color: Colors.white,
              height: MediaQuery.of(context).size.height*0.03,
              width: MediaQuery.of(context).size.width*1 ,
            ),
            Container(
              color: Colors.blue,
              height: MediaQuery.of(context).size.height*0.1,      //logout
              width: MediaQuery.of(context).size.width*1 ,
              child: GestureDetector(
              onTap: (){
                Future<SharedPreferences> prefs = SharedPreferences.getInstance();
                prefs.then((onValue){
                  onValue.setString('name',null);
                  onValue.setString('password',null);
                  Navigator.push(context,MaterialPageRoute(builder: (context) => IntroPage()),);
                });
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 4, 12, 4),
                  child: Text("Logout")//Icon(Icons.eject,color: Color.fromRGBO(90,50, 60,1)),
                ),
              ),
            )
            ),
            Container(
              //color: Colors.white,
              height: MediaQuery.of(context).size.height*0.03,
              width: MediaQuery.of(context).size.width*1 ,
            ),
            Container(
              color: Colors.blue,
              height: MediaQuery.of(context).size.height*0.1,
              width: MediaQuery.of(context).size.width*1 ,
              child: Center(
                child: Text("hello"),
              ),
            ),
            

          ]
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
    getSelectedSongs();
  }

}