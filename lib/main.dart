import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pages/intro_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(primaryColor: Color.fromRGBO(150, 66, 86, 1.0)),
      home:IntroPage(),
    );
  }
}

class Users {
 final String name;
 final String password;
 final List<String> songs;
 final DocumentReference reference;


 Users.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['name'] != null),
       assert(map['password'] != null),
       this.name = map['name'],
       this.password = map['password'],
       this.songs = List.from(map['songs'].map((i)=>i.toString()));

 Users.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$name:$password>";
}