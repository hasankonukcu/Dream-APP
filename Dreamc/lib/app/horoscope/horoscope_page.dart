import 'package:dream/animation/fadeanimation.dart';
import 'package:dream/app/horoscope/horoscope_details.dart';
import 'package:dream/app/tarot/bgfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slider/carousel.dart';
import 'package:google_fonts/google_fonts.dart';

class HoroscopePage extends StatefulWidget {
  const HoroscopePage({Key? key}) : super(key: key);

  @override
  State<HoroscopePage> createState() => _HoroscopePageState();
}

class _HoroscopePageState extends State<HoroscopePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StarBackground(),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Container(
              child: Center(
                child: Carousel(
                  isCircle: true,
                  activateIndicatorColor: Colors.white,
                  indicatorBarColor: Colors.transparent,
                  items: [
                    horoscopeWidget(
                        context, "Koç", "koc.jpg", "21 Mart", "20 Nisan"),
                    horoscopeWidget(
                        context, "Boga", "boga.jpg", "21 Nisan", "21 Mayıs"),
                    horoscopeWidget(context, "Ikizler", "ikizler.jpg",
                        "22 Mayıs", "22 Haziran"),
                    horoscopeWidget(context, "Yengeç", "yengec.jpg",
                        "23 Haziran", "22 Temmuz"),
                    horoscopeWidget(context, "Aslan", "aslan.jpg", "23 Temmuz",
                        "22 Agustos"),
                    horoscopeWidget(context, "Basak", "basak.jpg", "23 Agustos",
                        "22 Eylül"),
                    horoscopeWidget(
                        context, "Terazi", "terazi.jpg", "23 Eylül", "22 Ekim"),
                    horoscopeWidget(
                        context, "Akrep", "akrep.jpg", "23 Ekim", "21 Kasım"),
                    horoscopeWidget(
                        context, "Yay", "yay.jpg", "22 Kasım", "21 Aralık"),
                    horoscopeWidget(
                        context, "Oglak", "oglak.jpg", "22 Aralık", "21 Ocak"),
                    horoscopeWidget(
                        context, "Kova", "kova.jpg", "22 Ocak", "19 Subat"),
                    horoscopeWidget(
                        context, "Balık", "balik.jpg", "20 Subat", "20 Mart"),
                  ],
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget horoscopeWidget(BuildContext context, String title, String image,
      String start, String end) {
    return Center(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        height: MediaQuery.of(context).size.height * 0.80,
        width: MediaQuery.of(context).size.width * 0.70,
        child: Column(children: [
          Center(
            child: FadeAnimation(
              delay: 0.2,
              child: Text(
                title,
                style: GoogleFonts.amaranth(color: Colors.white, fontSize: 35),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FadeAnimation(
            delay: 0.5,
            child: Image.asset(
              "images/" + image,
              height: 270,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: FadeAnimation(
              delay: 0.7,
              child: Text(
                start,
                style: GoogleFonts.amaranth(color: Colors.white, fontSize: 35),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: FadeAnimation(
              delay: 0.9,
              child: Text(
                end,
                style: GoogleFonts.amaranth(color: Colors.white, fontSize: 35),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FadeAnimation(
            delay: 1.1,
            child: Container(
              width: 75,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: TextButton(
                onPressed: () async {
                  var lastIndex = image.indexOf(".");
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HoroscopeDetails(
                              horoscope: image.substring(0, lastIndex),
                              way: '',
                              title: '',
                            )),
                  );
                },
                child: Center(
                  child: Text(
                    "Seç",
                    style:
                        GoogleFonts.amaranth(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
