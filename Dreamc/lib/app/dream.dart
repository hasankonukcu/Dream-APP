import 'package:dream/app/home_page.dart';
import 'package:dream/model/dreams.dart';
import 'package:dream/viewmodel/user_model.dart';
import 'package:dream/wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class Dream extends StatefulWidget {
  final Dreams oneDream;

  const Dream({Key? key, required this.oneDream}) : super(key: key);

  @override
  _DreamState createState() => _DreamState();
}

class _DreamState extends State<Dream> {
  @override
  Widget build(BuildContext context) {
    var myBackgrounColor = Theme.of(context).primaryColor;
    var myTextColor = Theme.of(context).focusColor;
    var myTextStyle = GoogleFonts.firaSans();

    Dreams _dreams = widget.oneDream;

    return AppWrapper(
      child: WillPopScope(
        onWillPop: () async {
          if (_dreams.point == 0 && _dreams.request!.length > 5) {
            _showRaitingDialog(context);
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: IconThemeData(color: myTextColor),
            backgroundColor: Colors.transparent,
            title: Text(
              "Rüya",
              style: GoogleFonts.amaranth(),
            ),
          ),
          body: Center(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                //top: BorderSide(width: 1.0, color: Colors.black),
                                left:
                                    BorderSide(width: 1.0, color: Colors.black),
                                right:
                                    BorderSide(width: 1.0, color: Colors.black),
                                //bottom: BorderSide(width: 1.0, color: Colors.black),
                              ),
                              //color: Color.fromARGB(255, 241, 240, 171),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(_dreams.content!, style: myTextStyle),
                            ),
                          ),
                        ),
                        _dreams.request!.length > 1
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          width: 1.0, color: Colors.black),
                                      left: BorderSide(
                                          width: 1.0, color: Colors.black),
                                      right: BorderSide(
                                          width: 1.0, color: Colors.black),
                                    ),
                                    color: Color.fromARGB(255, 42, 2, 58),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      _dreams.request!,
                                      style: myTextStyle,
                                    ),
                                  ),
                                ),
                              )
                            : const Center(
                                child: Icon(Icons.av_timer),
                              ),
                        _dreams.commenter != null
                            ? Text(_dreams.commenter!)
                            : Container()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showRaitingDialog(BuildContext contextt) async {
    Dreams _dreams = widget.oneDream;
    //int? point = widget.point

    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 300,
              child: Column(
                children: [
                  const Center(child: Icon(Icons.nights_stay)),
                  const Center(
                    child: Text(
                        "Size daha iyi hizmet verebilmemiz için cevabımızı yorumlayın"),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: RatingBar.builder(
                        initialRating: _dreams.point!.toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          _dreams.point = rating.toInt();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Center(
                child: CupertinoDialogAction(
                    child: Text("Tamam"),
                    onPressed: () async {
                      if (_dreams.point != 0) {
                        //var result = await _userModel.savePoint(_dreams);
                        Navigator.of(context).pop();
                      }
                    }),
              ),
            ],
          );
        });
  }
}
