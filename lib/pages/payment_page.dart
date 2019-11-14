import 'package:flutter/material.dart';
import 'package:music_player/pages/payment_methods.dart';

class PaymentPage extends StatefulWidget {

  final String song,url,artists;
  PaymentPage(this.song,this.artists,this.url);

  @override
  _PaymentPageState createState() => _PaymentPageState(song,artists,url);
}

class _PaymentPageState extends State<PaymentPage> {

  final String song,artists,url;
  _PaymentPageState(this.song,this.artists,this.url);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold( 
        appBar: AppBar(
          title: Text("Checkout"),
        ),
        body: 
        
        Container(
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
                height: MediaQuery.of(context).size.height*0.01,
                    width: MediaQuery.of(context).size.width,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Text(song,style: TextStyle(color: Colors.white)),
                    Text(artists,style: TextStyle(color: Colors.white70))
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.01,
                    width: MediaQuery.of(context).size.width,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(child: Center(child: Text("Amount Payable :",style: TextStyle(color: Colors.white)))),
                    Expanded(child: Center(child: Text("\$${song.length}",style: TextStyle(color: Colors.white))))
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.02,
                    width: MediaQuery.of(context).size.width,
              ),
              Container(
                child: HomePage(),
              )
            ],
          ),
        ),
      ));
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        /*
        
        Container(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height*0.3,
                width: MediaQuery.of(context).size.width,
                child: Center(child: Image.network(url)),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.1,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Text(song),
                    Text(artists)
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height*0.1,
                      width: MediaQuery.of(context).size.width*0.7,
                      child: Text("Amount Payable"),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.1,
                      width: MediaQuery.of(context).size.width*0.3,
                      child: Center(
                        child: Text("\$${song.length}"),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: HomePage(),
              )
            ],
          ),
        ),
       ),
      
    );*/
  }
}