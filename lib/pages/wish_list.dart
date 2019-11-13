import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:music_player/pages/credit.dart';
import 'package:music_player/pages/intro_page.dart';
import 'package:music_player/pages/song_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_player/main.dart';
import 'dart:convert';
import 'song_page.dart';

import 'package:music_player/pages/song_page.dart';

class WishList extends StatefulWidget {
  final String name,password;
  WishList(this.name,this.password);
  @override
  _WishListState createState() => _WishListState(this.name,password);
}

class _WishListState extends State<WishList> {
  final String name,password;
  _WishListState(this.name,this.password);
  Map data;
  List userData;
  List<String> selectedSongs = ["Dummy Data",];
  Future getData() async {
    http.Response response = await http.get('http://starlord.hackerearth.com/studio');
    setState(() {
      userData = json.decode(response.body);
    });
  }
  Future getSelectedSongs() async {
    Firestore.instance
        .collection('users')
        .document(name)
        .get()
        .then((DocumentSnapshot ds) {
          Users abc = new Users.fromSnapshot(ds);
          setState(() {
            selectedSongs = List.from(abc.songs);
          });
      }).catchError((error){
      });
  }
  


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SongList(name, password)));
      },
          child: Scaffold(
        backgroundColor: Color.fromRGBO(150, 66, 86, 1.0),
        appBar: AppBar(
          title: Text("Wish List"),
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
                    Navigator.push(context,MaterialPageRoute(builder: (context) => SongList(name,password)),);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 4,6, 4),
                  child: Icon(Icons.list,color: Color.fromRGBO(220,150, 180,1)),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Credit() ));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 4,6, 4),
                  child: Icon(Icons.person,color: Color.fromRGBO(90,50, 60,1)),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
                  prefs.then((onValue){
                    onValue.setString('name',null);
                    onValue.setString('password',null);
                    Navigator.push(context,MaterialPageRoute(builder: (context) => IntroPage()),);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 4, 12, 4),
                  child: Icon(Icons.eject,color: Color.fromRGBO(90,50, 60,1)),
                ),
              )
          ],
        ),
        body: ListView.builder(
                    itemCount: userData == null ? 0 : userData.length ,
                    itemBuilder: (BuildContext context,int index){
                      if(selectedSongs.contains(userData[index]['song'])){
                      print("in loop");
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: songcard(userData[index ]['song'],userData[index]['artists'],userData[index]['cover_image'],userData[index]['url'])
                        ),
                      );
                      }
                      else{
                        return new Container();
                      }
                    },
                  ),

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

  @override
  void initState() {
    super.initState();
    getData();
    getSelectedSongs();
  }

}