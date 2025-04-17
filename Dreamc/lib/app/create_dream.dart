import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/commen_widget/alert_dialog.dart';
import 'package:dream/model/dreams.dart';
import 'package:dream/viewmodel/user_model.dart';
import 'package:dream/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateDream extends StatefulWidget {
  const CreateDream({Key? key}) : super(key: key);

  @override
  _CreateDreamState createState() => _CreateDreamState();
}

class _CreateDreamState extends State<CreateDream> {
  String? dream;
  InterstitialAd? _interstitialAd;
  bool _isLoading = false;

  bool _IsInterstitalAdReady = false;

  var _messageController = TextEditingController();
  List yorumcuList = [];
  @override
  void initState() {
    super.initState();
    getCommenter();
    InterstitialAd.load(
        adUnitId: "ca-app-pub-9241755428967871/3081393093",
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          _interstitialAd = ad;
          _IsInterstitalAdReady = true;
        }, onAdFailedToLoad: (error) {
          print("failed to load Interstital ad : " + error.message.toString());
        }));
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    var myBackgrounColor = Theme.of(context).primaryColor;
    var myButtonColor = Theme.of(context).colorScheme.secondary;
    var myTextColor = Theme.of(context).focusColor;

    return AppWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(color: myTextColor),
          backgroundColor: Colors.transparent,
          title: Text(
            "Rüyanı anlat",
            style: GoogleFonts.amaranth(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                TextFormField(
                    controller: _messageController,
                    minLines: 7,
                    maxLines: 18,
                    onSaved: (String? message) {
                      dream = message;
                    },
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: "Rüyanızı anlatın...",
                      border: OutlineInputBorder(),
                    )),
                const SizedBox(height: 5),
                _isLoading == false
                    ? Container(
                        width: MediaQuery.of(context).size.width - 20,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: myButtonColor,
                            ),
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              if (_userModel.user!.jeton! <= 0) {
                                PlatformSensAlertDialog(
                                  title: "Hiç jetonununz kalmadı",
                                  content:
                                      "Hiç jetonunuz kalmadığı için işlemi gerçekleştiremiyoruz...",
                                  mainButtonText: "Tamam",
                                ).show(context);
                              } else {
                                if (_messageController.text.trim().length >
                                    10) {
                                  var result = false;
                                  var eskiContext = context;
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        bool _yorumcuSecLoading = false;
                                        return AlertDialog(
                                            actions: [
                                              TextButton(
                                                child: Text("Geri Dön"),
                                                onPressed: () {
                                                  setState(() {
                                                    _isLoading = false;
                                                    _yorumcuSecLoading = false;
                                                  });

                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                            title: Text("Yorumcunu Seç"),
                                            content: _yorumcuSecLoading == false
                                                ? ListView.builder(
                                                    itemCount:
                                                        yorumcuList.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      var musaitlik = "";
                                                      var cevapSuresi = "";
                                                      var timer1 = 0;
                                                      var timer2 = 0;
                                                      if (yorumcuList[index]
                                                              ['state'] <=
                                                          10) {
                                                        musaitlik = "Müsait";
                                                        cevapSuresi =
                                                            "10-30 Dakika arası";
                                                        timer1 = 10;
                                                        timer2 = 30;
                                                      }
                                                      if (yorumcuList[index]
                                                                  ['state'] <=
                                                              30 &&
                                                          yorumcuList[index]
                                                                  ['state'] >
                                                              10) {
                                                        musaitlik = "Yoğun";
                                                        cevapSuresi =
                                                            "20-40 Dakika arası";
                                                        timer1 = 20;
                                                        timer2 = 40;
                                                      }
                                                      if (yorumcuList[index]
                                                              ['state'] >
                                                          30) {
                                                        musaitlik = "Çok Yoğun";
                                                        cevapSuresi =
                                                            "30-60 Dakika arası";
                                                        timer1 = 30;
                                                        timer2 = 60;
                                                      }

                                                      return _yorumcuSecLoading ==
                                                              false
                                                          ? GestureDetector(
                                                              onTap: () async {
                                                                Navigator.pop(
                                                                    context);
                                                                if (_yorumcuSecLoading ==
                                                                    false) {
                                                                  setState(() {
                                                                    _isLoading =
                                                                        true;
                                                                    _yorumcuSecLoading =
                                                                        true;
                                                                  });
                                                                  Dreams _saveMessage = Dreams(
                                                                      usersID: _userModel
                                                                          .user!
                                                                          .usersID,
                                                                      email: _userModel
                                                                          .user!
                                                                          .email,
                                                                      userName: _userModel
                                                                          .user!
                                                                          .userName,
                                                                      content:
                                                                          _messageController
                                                                              .text,
                                                                      commenter: yorumcuList[
                                                                              index]
                                                                          [
                                                                          'name'],
                                                                      timer1:
                                                                          timer1,
                                                                      timer2:
                                                                          timer2);
                                                                  result =
                                                                      await _userModel
                                                                          .saveDream(
                                                                    _saveMessage,
                                                                    yorumcuList[
                                                                            index]
                                                                        ['id'],
                                                                    yorumcuList[
                                                                            index]
                                                                        [
                                                                        'state'],
                                                                  );
                                                                  var contentMessage =
                                                                      _messageController
                                                                          .text;

                                                                  if (result ==
                                                                      true) {
                                                                    var jetonUpdate = await _userModel.jetonUpdate(
                                                                        _userModel
                                                                            .user!
                                                                            .usersID,
                                                                        _userModel
                                                                            .user!
                                                                            .jeton);
                                                                    if (jetonUpdate) {
                                                                      _userModel
                                                                          .user!
                                                                          .jeton = _userModel
                                                                              .user!
                                                                              .jeton! -
                                                                          1;
                                                                    }
                                                                    _messageController
                                                                        .clear();
                                                                    if (_IsInterstitalAdReady) {
                                                                      _interstitialAd!
                                                                          .show();
                                                                    }

                                                                    Navigator.pop(
                                                                        eskiContext,
                                                                        Dreams(
                                                                            usersID:
                                                                                _userModel.user!.usersID,
                                                                            email: _userModel.user!.email,
                                                                            content: contentMessage));

                                                                    setState(
                                                                        () {
                                                                      _yorumcuSecLoading =
                                                                          false;
                                                                      _isLoading =
                                                                          false;
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      _isLoading =
                                                                          false;
                                                                      _yorumcuSecLoading =
                                                                          false;
                                                                    });
                                                                    PlatformSensAlertDialog(
                                                                      title:
                                                                          "Hata",
                                                                      content:
                                                                          "Bir hata oluştu,lütfen daha sonra tekrar deneyin.",
                                                                      mainButtonText:
                                                                          "Tamam",
                                                                    ).show(
                                                                        context);
                                                                  }
                                                                }
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            15),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    CircleAvatar(
                                                                      radius:
                                                                          25,
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                        yorumcuList[index]
                                                                            [
                                                                            'photo'],
                                                                      ),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        Text(
                                                                            yorumcuList[index][
                                                                                'name'],
                                                                            style:
                                                                                TextStyle(fontSize: 16)),
                                                                        Text(
                                                                            cevapSuresi,
                                                                            style:
                                                                                TextStyle(fontSize: 9)),
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                      musaitlik,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : CircularProgressIndicator(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                            );
                                                      /*return ListTile(
                                              
      
                                              onTap: () async {
                                                
                                              },
                                              title: Text(
                                                  yorumcuList[index]['name'],
                                                  style: TextStyle(fontSize: 14)),
                                              subtitle:
                                                  Text("10-30 Dakika arası",style: TextStyle(fontSize: 8)),
                                              trailing: Text("Müsait"),
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    yorumcuList[index]['photo']),
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                            );*/
                                                    },
                                                  )
                                                : CircularProgressIndicator(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  ));
                                      });
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  PlatformSensAlertDialog(
                                    title: "Hata",
                                    content:
                                        "Rüyanızın uzunluğu en az 10 karakter olmalıdır.",
                                    mainButtonText: "Tamam",
                                  ).show(context);
                                }
                              }
                            },
                            child: Text("Yorumcu Seç",
                                style:
                                    GoogleFonts.firaSans(color: Colors.white))),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                      ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getCommenter() async {
    QuerySnapshot _querySnapShot;
    _querySnapShot =
        await FirebaseFirestore.instance.collection("yorumcu").get();
    for (DocumentSnapshot snap in _querySnapShot.docs) {
      var oneDream = snap.data() as Map<String, dynamic>;
      var id = snap.id;
      yorumcuList.add({
        "id": id,
        "name": oneDream['name'],
        "state": oneDream['state'],
        "photo": oneDream['photo'],
      });
    }
  }
}
