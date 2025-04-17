import 'package:dream/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class HoroscopeDetails extends StatefulWidget {
  String horoscope;
  String title;
  String way;
  HoroscopeDetails(
      {Key? key,
      required this.horoscope,
      required this.way,
      required this.title})
      : super(key: key);

  @override
  State<HoroscopeDetails> createState() => _HoroscopeDetailsState();
}

class _HoroscopeDetailsState extends State<HoroscopeDetails> {
  //ads
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  int selectedCategoryIndex = 0;
  var burc = "";
  var ozellik = "";
  var mottosu = "";
  var gunlukYorum = "";
  var baslik = "";
  var yorum = "";
  var gezegeni = "";
  var elementi = "";

  var haftalikMotto = "";
  var aylikMotto = "";
  var yillikMotto = "";
  var haftalikYorum = "";
  var aylikYorum = "";
  var yillikYorum = "";

  bool isLoading = true;
  bool error = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(widget.horoscope, widget.way);
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-9241755428967871/3952571690',
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          print("Failed to load Ad banner: " + error.toString());
          _isBannerAdReady = false;
          ad.dispose();
        }),
        request: AdRequest())
      ..load();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppWrapper(
      child: Scaffold(
        body: SafeArea(
            child: error == false
                ? SingleChildScrollView(
                    child: isLoading != true
                        ? Column(
                            children: [
                              Image.asset(
                                "images/" + widget.horoscope + ".jpg",
                                height: 300.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  height: size.height * 0.075,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Center(
                                        child: _buildCategoryList(
                                            context, index, widget.title),
                                      );
                                    },
                                    itemCount: 4,
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              ),
                              selectedCategoryIndex == 0
                                  ? dailyOrCategorie(
                                      burc: burc,
                                      ozellik: ozellik,
                                      gezegeni: gezegeni,
                                      elementi: elementi,
                                      mottosu: mottosu,
                                      gunlukYorum: gunlukYorum,
                                      baslik: baslik,
                                      yorum: yorum,
                                    )
                                  : Center(),
                              selectedCategoryIndex == 1
                                  ? otherCategorie(
                                      burc: burc,
                                      elementi: elementi,
                                      gezegeni: gezegeni,
                                      mottosu: haftalikMotto,
                                      yorum: haftalikYorum,
                                    )
                                  : Center(),
                              selectedCategoryIndex == 2
                                  ? otherCategorie(
                                      burc: burc,
                                      elementi: elementi,
                                      gezegeni: gezegeni,
                                      mottosu: aylikMotto,
                                      yorum: aylikYorum,
                                    )
                                  : Center(),
                              selectedCategoryIndex == 3
                                  ? otherCategorie(
                                      burc: burc,
                                      elementi: elementi,
                                      gezegeni: gezegeni,
                                      mottosu: yillikMotto,
                                      yorum: yillikYorum,
                                    )
                                  : Center(),
                              if (_isBannerAdReady)
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Container(
                                      height: _bannerAd.size.height.toDouble(),
                                      child: AdWidget(ad: _bannerAd),
                                    ),
                                  ),
                                ),
                            ],
                          )
                        : SizedBox(
                            height: size.height,
                            width: size.width,
                            child: const Center(
                                child: CircularProgressIndicator(
                              backgroundColor: Colors.transparent,
                            )),
                          ))
                : SafeArea(
                    child: SizedBox(
                    height: size.height,
                    width: size.width,
                    child: const Center(
                      child: Text(
                          "Bir hata oluştu lütfen internet bağlanıtınızı kontrol edip tekrar deneyin...",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ))),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext contex, int index, title) {
    List categoryList = [
      "Günlük",
      "Haftalık",
      "Aylık",
      "Yıllık",
    ];
    return GestureDetector(
      onTap: () {
        if (index != selectedCategoryIndex) {
          setState(() {
            selectedCategoryIndex = index;
          });
          //         _userModel.slider = categoryList[index];
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Column(
          children: [
            Text(
              categoryList[index],
              style: TextStyle(
                color: selectedCategoryIndex == index
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                fontSize: 18,
                fontWeight: selectedCategoryIndex == index
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
            Container(
              height: 3,
              width: 20,
              decoration: BoxDecoration(
                  color: selectedCategoryIndex == index
                      ? Colors.orange
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30)),
            )
          ],
        ),
      ),
    );
  }

  void getData(String horoscope, String way) async {
    var statusCode = 200;
    if (way == "") {
      var url = Uri.parse("https://www.mynet.com/kadin/burclar-astroloji/" +
          horoscope +
          "-burcu-gunluk-yorumu.html");
      var res = await http.get(url);
      final document = html.parse(res.body);
      final paragraphs = document.querySelectorAll('p');

      //burc = data[0]["Burc"];
      //mottosu = data[0]["Mottosu"];
      gunlukYorum = paragraphs[2].text;
      print(gunlukYorum);
      //gezegeni = data[0]["Gezegeni"];
      //elementi = data[0]["Elementi"];
    }

    var haftalik = Uri.parse("https://www.mynet.com/kadin/burclar-astroloji/" +
        horoscope +
        "-burcu-haftalik-yorumu.html");
    var haftalikres = await http.get(haftalik);
    final document = html.parse(haftalikres.body);
    final paragraphs = document.querySelectorAll('p');

    //burc = haftalikdata[0]["Burc"];
    //haftalikMotto = haftalikdata[0]["Mottosu"];
    haftalikYorum = paragraphs[2].text;
    //gezegeni = haftalikdata[0]["Gezegeni"];
    //elementi = haftalikdata[0]["Elementi"];

    var aylik = Uri.parse("https://www.mynet.com/kadin/burclar-astroloji/" +
        horoscope +
        "-burcu-aylik-yorumu.html");
    var aylikres = await http.get(aylik);
    final document1 = html.parse(aylikres.body);
    final paragraphs2 = document1.querySelectorAll('p');

    //burc = aylikData[0]["Burc"];
    //aylikMotto = aylikData[0]["Mottosu"];
    aylikYorum = paragraphs2[2].text;
    // gezegeni = aylikData[0]["Gezegeni"];
    // elementi = aylikData[0]["Elementi"];

    var yillik = Uri.parse("https://www.mynet.com/kadin/burclar-astroloji/" +
        horoscope +
        "-burcu-yillik-yorumu.html?day=2&month=2&year=2023");
    var yillikres = await http.get(yillik);
    var document2 = html.parse(yillikres.body);
    final paragraphs3 = document2.querySelectorAll('p');

    //burc = yillikData[0]["Burc"];
    //yillikMotto = yillikData[0]["Mottosu"];
    yillikYorum = paragraphs3[2].text;
    //gezegeni = yillikData[0]["Gezegeni"];
    //elementi = yillikData[0]["Elementi"];

    setState(() {
      isLoading = false;
      if (statusCode != 200) {
        error = true;
      } else {
        error = false;
      }
    });
  }
}

class dailyOrCategorie extends StatelessWidget {
  const dailyOrCategorie({
    Key? key,
    required this.burc,
    required this.ozellik,
    required this.gezegeni,
    required this.elementi,
    required this.mottosu,
    required this.gunlukYorum,
    required this.baslik,
    required this.yorum,
  }) : super(key: key);

  final String burc;
  final String ozellik;
  final String gezegeni;
  final String elementi;
  final String mottosu;
  final String gunlukYorum;
  final String baslik;
  final String yorum;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 41, 45, 78),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          Text(
            burc,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          gezegeni.length > 1
              ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Gezegeni: ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            gezegeni,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Elementi: ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            elementi,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const Center(),
          ozellik.length > 1
              ? Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Row(
                    children: [
                      const Text(
                        "Özellik: ",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(ozellik,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16)),
                    ],
                  ),
                )
              : const Center(),
          baslik.length > 1
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(baslik,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16)),
                )
              : const Center(),
          mottosu.length > 1
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    mottosu,
                    style: const TextStyle(fontSize: 16),
                  ),
                )
              : const Center(),
          gunlukYorum.length > 1
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child:
                      Text(gunlukYorum, style: const TextStyle(fontSize: 16)),
                )
              : const Center(),
          yorum.length > 1
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(yorum,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16)),
                )
              : const Center(),
        ],
      ),
    );
  }
}

class otherCategorie extends StatelessWidget {
  const otherCategorie({
    Key? key,
    required this.burc,
    required this.gezegeni,
    required this.elementi,
    required this.mottosu,
    required this.yorum,
  }) : super(key: key);

  final String burc;
  final String gezegeni;
  final String elementi;
  final String mottosu;
  final String yorum;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 41, 45, 78),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          Text(
            burc,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          gezegeni.length > 1
              ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Gezegeni: ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            gezegeni,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Elementi: ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            elementi,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const Center(),
          mottosu.length > 1
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    mottosu,
                    style: const TextStyle(fontSize: 16),
                  ),
                )
              : const Center(),
          yorum.length > 1
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(yorum, style: const TextStyle(fontSize: 16)),
                )
              : const Center(),
        ],
      ),
    );
  }
}
