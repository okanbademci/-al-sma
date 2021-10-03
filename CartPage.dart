import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz/paket.dart';

import 'model.dart';

class cartPage extends StatefulWidget {
  List<int> cart = [];
  int soruindex;

  cartPage({Key? key, required this.cart, required this.soruindex})
      : super(key: key);

  @override
  _cartPageState createState() => _cartPageState();
}

class _cartPageState extends State<cartPage> {
  late List<dynamic> data;


  @override
  void initState() {
    super.initState();
    _loadData().then((value) {
      setState(() {
        data = value;
      });
    });
    print("*******");
    _loadDataToTravelList().then((value) => print("****" + value[0].title));
  }

  Future<List<dynamic>> _loadData() async {
    String jsonString = await rootBundle.loadString('assets/data.json');
    return json.decode(jsonString).toList();
  }

  Future<List<Travel>> _loadDataToTravelList() async {
    String jsonString = await rootBundle.loadString('assets/data.json');
    List<dynamic> jsonResponse = json.decode(jsonString).toList();
    return jsonResponse.map((v) => Travel.fromJson(v)).toList();
  }




  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("deneme"),
      ),
      body: ListView.builder(

          itemCount: widget.cart.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                QuizView(
                  image: Container(
                    width: 150,
                    height: 150,
                  ),
                  showCorrect: true,
                  tagBackgroundColor: Colors.white,
                  tagColor: Colors.black,
                  questionTag: "LOGO QUİZ",
                  answerColor: Colors.black,
                  answerBackgroundColor: Colors.white,
                  questionColor: Colors.white,
                  backgroundColor: Colors.blueGrey,
                  width: 300,
                  height: 600,
                  question: "",
                  dosruCevap: "${data[(widget.cart[index])-1]["date"]}",
                  yanlisCevap1: "${data[(widget.cart[index])-1]["title"]}",
                  yanlisCevap: [
                    "${data[(widget.cart[index])-1]["comments"][0]["comment"]}",
                  ],
                  dogruBas: () async {
                    await Future.delayed(Duration(seconds: 2));
                    setState(() {});
                  },
                  yanlisBas: () {
                    setState(() {});
                  },
                  yanlisCevap1Bas: () {
                    setState(() {});
                  },
                ),
                Divider(
                  height: 10,
                )
              ],
            );
          }),
    );
  }
}
