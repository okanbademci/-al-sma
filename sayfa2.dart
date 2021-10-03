import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz/paket.dart';
import 'CartPage.dart';
import 'model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class sayfa2 extends StatefulWidget {
  const sayfa2({Key? key}) : super(key: key);

  @override
  _sayfa2State createState() => _sayfa2State();
}

class _sayfa2State extends State<sayfa2> {
  List<int>cart=[];

  Color dogru = Colors.white;
  int soruindex = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(child: Text("oooo"),
          )
        ),
        body: Center(
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
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
                        answerBackgroundColor: dogru,
                        questionColor: Colors.white,
                        backgroundColor: Colors.blueGrey,
                        width: 300,
                        height: 600,
                        question: "",
                        dosruCevap: "${data[soruindex]["date"]}",
                        yanlisCevap1: "${data[soruindex]["title"]}",
                        yanlisCevap: [
                          "${data[soruindex]["comments"][0]["comment"]}",
                        ],
                        dogruBas: () async {
                          await Future.delayed(Duration(seconds: 2));
                          setState(() {
                            _sonrakisoru();
                            dogru = Colors.white;

                          });
                        },
                        yanlisBas: () {
                          setState(() {
                            cart.add((soruindex+1));
                          });
                        },
                        yanlisCevap1Bas: () {
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () => {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => cartPage(soruindex: soruindex, cart: cart)),
                        )
                      },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  void _sonrakisoru() {
    if (soruindex + 1 < data.length) {
      soruindex++;
    } else {
      _showMyDialog();
      soruindex = 0;
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('bilgi testi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('tebrikler '),
                Text('testi başarı ile tamamladınız '),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('yeniden çöz'),
              onPressed: () {
                Navigator.of(context).pop();
                SfCartesianChart(
                  series: 1,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
