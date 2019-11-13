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
        body: Container(
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
      
    );
  }
}