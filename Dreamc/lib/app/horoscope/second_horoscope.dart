import 'package:dream/app/horoscope/horoscope_details.dart';
import 'package:dream/wrapper.dart';
import 'package:flutter/material.dart';

class SecondHoroscope extends StatefulWidget {
  String horoscope;
  SecondHoroscope({Key? key, required this.horoscope}) : super(key: key);

  @override
  State<SecondHoroscope> createState() => _SecondHoroscopeState();
}

class _SecondHoroscopeState extends State<SecondHoroscope> {
  List data = [
    {"title": "Günlük", "link": ""},
    {"title": "Ask", "link": "ask"},
    {"title": "Kariyer", "link": "kariyer"},
    {"title": "Olumlu Yönler", "link": "olumlu-yonler"},
    {"title": "Olumsuz Yönler", "link": "olumsuz-yonler"},
    {"title": "Sağlık", "link": "saglik"},
    {"title": "Stil", "link": "stil"},
    {"title": "Diyet", "link": "diyet"},
    {"title": "Zıt Burçları", "link": "zit-burclari"},
    {"title": "Eğlence Hayatı", "link": "eglence-hayati"},
    {"title": "Makyaj", "link": "makyaj"},
    {"title": "Saç Stili", "link": "sac-stili"},
    {"title": "Sifalı Bitkiler", "link": "sifali-bitkileri"},
    {"title": "Cocuklugu", "link": "cocuklugu"},
    {"title": "Kadını", "link": "kadini"},
    {"title": "Erkegi", "link": "erkegi"},
    {"title": "Gezegeni", "link": "gezegeni"},
    {"title": "Tası", "link": "tasi"},
  ];
  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Kategori Seç"),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(data[index]["title"]),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HoroscopeDetails(
                            horoscope: widget.horoscope,
                            title: data[index]["title"],
                            way: data[index]["link"],
                          )),
                );
              },
            );
          },
          itemCount: data.length,
        ),
      ),
    );
  }
}
