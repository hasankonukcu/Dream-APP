import 'package:dream/animation/fadeanimation.dart';
import 'package:dream/commen_widget/alert_dialog.dart';
import 'package:dream/commen_widget/social_login_button.dart';
import 'package:dream/viewmodel/user_model.dart';
import 'package:dream/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController? _controllerUserName;
  TextEditingController? _controllerSurname;
  TextEditingController? _controllerJob;
  TextEditingController? _controllerDate;
  TextEditingController? _controllerHoroscope;
  TextEditingController? _controllermaritalStatus;
  DateTime selectedDate = DateTime.now();
  //bool isDateSelected = false;
  //String? birthDateInString;
  //DateTime? birthDate;
  // DateFormat? dateFormat;

  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
    _controllerSurname = TextEditingController();
    _controllerJob = TextEditingController();
    _controllerDate = TextEditingController();
    _controllerHoroscope = TextEditingController();
    _controllermaritalStatus = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName!.dispose();
    _controllerSurname!.dispose();
    _controllerJob!.dispose();
    _controllerDate!.dispose();
    _controllerHoroscope!.dispose();
    _controllermaritalStatus!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var myBackgrounColor = Theme.of(context).primaryColor;
    var myButtonColor = Theme.of(context).colorScheme.secondary;
    var myTextColor = Theme.of(context).focusColor;
    var myTextStyle = GoogleFonts.firaSans();

    UserModel _userModel = Provider.of<UserModel>(context);
    _controllerUserName!.text = _userModel.user!.userName!;
    _controllerSurname!.text = _userModel.user!.surname!;
    _controllerJob!.text = _userModel.user!.job!;
    if (_userModel.user!.dateOfBirth != null) {
      _controllerDate!.text = _userModel.user!.dateOfBirth!;
    }
    if (_userModel.user!.horoscope != null) {
      _controllerHoroscope!.text = _userModel.user!.horoscope!;
    }
    if (_userModel.user!.maritalStatus != null) {
      _controllermaritalStatus!.text = _userModel.user!.maritalStatus!;
    }

    return AppWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            TextButton(
                onPressed: () => _exitQuestion(context),
                child: Text("Çıkış",
                    style: GoogleFonts.firaSans(color: Colors.white)))
          ],
          title: Text(
            "Profil",
            style: GoogleFonts.amaranth(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FadeAnimation(
                          delay: 1,
                          child: TextFormField(
                            style: TextStyle(color: myTextColor),
                            controller: _controllerUserName,
                            decoration: InputDecoration(
                              focusColor: myTextColor,
                              label: Text(
                                "Kullanıcı adı",
                                style: myTextStyle,
                              ),
                              border: new OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FadeAnimation(
                          delay: 1,
                          child: TextFormField(
                            controller: _controllerSurname,
                            decoration: InputDecoration(
                                label: Text("Soyisim"),
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FadeAnimation(
                          delay: 1.5,
                          child: TextFormField(
                            controller: _controllerJob,
                            decoration: InputDecoration(
                                label: Text("Meslek"),
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FadeAnimation(
                              delay: 1.5,
                              child: TextFormField(
                                style: const TextStyle(fontSize: 12.0),
                                controller: _controllerDate,
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                  label: Text("Doğum Tarihi"),
                                  border: OutlineInputBorder(),
                                  hintText: 'Doğum tarihini seçiniz',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FadeAnimation(
                          delay: 2,
                          child: TextFormField(
                            controller: _controllerHoroscope,
                            decoration: InputDecoration(
                                label: Text("Burç"),
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FadeAnimation(
                          delay: 2,
                          child: TextFormField(
                            controller: _controllermaritalStatus,
                            decoration: InputDecoration(
                                label: Text("İlişki durumu"),
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FadeAnimation(
                    delay: 2.5,
                    child: TextFormField(
                      initialValue: _userModel.user!.email,
                      readOnly: true,
                      decoration: InputDecoration(
                          label: Text("Email"), border: OutlineInputBorder()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FadeAnimation(
                    delay: 3,
                    child: SocialLoginButton(
                      buttonColor: myButtonColor,
                      buttonText: "Kaydet",
                      onPressed: () {
                        if (_userModel.user!.userName !=
                                _controllerUserName!.text ||
                            _userModel.user!.surname !=
                                _controllerSurname!.text ||
                            _userModel.user!.job != _controllerJob!.text ||
                            _userModel.user!.dateOfBirth !=
                                _controllerDate!.text ||
                            _userModel.user!.horoscope !=
                                _controllerHoroscope!.text ||
                            _userModel.user!.maritalStatus !=
                                _controllermaritalStatus!.text) {
                          try {
                            _userNameUpdate(context);
                            _surnameUpdate(context);
                            _jobUpdate(context);
                            _dateOfUpdate(context);
                            _horoscopeUpdate(context);
                            _maritalStatusUpdate(context);
                            PlatformSensAlertDialog(
                              title: "Başarılı",
                              content: "Değişiklikleriniz tamamlandı",
                              mainButtonText: "Tamam",
                            ).show(context);
                          } catch (e) {
                            PlatformSensAlertDialog(
                              title: "Hata",
                              content:
                                  "Bir sorun oluştu, lütfen tekrar deneyiniz",
                              mainButtonText: "Tamam",
                            ).show(context);
                          }
                        } else {
                          PlatformSensAlertDialog(
                            title: "Değişiklik yapılmadı",
                            content: "Henüz bir değişiklik yapmadınız",
                            mainButtonText: "Tamam",
                          ).show(context);
                        }
                      },
                    ),
                  ),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    bool sonuc = await _userModel.signOut();
    return sonuc;
  }

  Future _exitQuestion(BuildContext context) async {
    final sonuc = await PlatformSensAlertDialog(
      title: "Emin misiniz?",
      content: "Çıkmak istediğinizden emin misiniz",
      mainButtonText: "Evet",
      cancelButtonText: "Vazgeç",
    ).show(context);
    if (sonuc == true) {
      _cikisYap(context);
    }
  }

  void _userNameUpdate(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user!.userName != _controllerUserName!.text) {
      var updateResult = await _userModel.updateUserName(
          _userModel.user!.usersID, _controllerUserName!.text);
      if (updateResult == true) {
      } else {
        _controllerUserName!.text = _userModel.user!.userName!;
      }
    }
  }

  void _surnameUpdate(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user!.surname != _controllerSurname!.text) {
      var updateResult = await _userModel.updateSurname(
          _userModel.user!.usersID, _controllerSurname!.text);
      if (updateResult == true) {
      } else {
        _controllerSurname!.text = _userModel.user!.surname!;
      }
    }
  }

  void _jobUpdate(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user!.job != _controllerJob!.text) {
      var updateResult = await _userModel.updateJob(
          _userModel.user!.usersID, _controllerJob!.text);
      if (updateResult == true) {
      } else {
        _controllerJob!.text = _userModel.user!.job!;
      }
    }
  }

  void _horoscopeUpdate(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user!.horoscope != _controllerHoroscope!.text) {
      var updateResult = await _userModel.updateHoroscope(
          _userModel.user!.usersID, _controllerHoroscope!.text);
      if (updateResult == true) {
      } else {
        _controllerHoroscope!.text = _userModel.user!.horoscope!;
      }
    }
  }

  void _maritalStatusUpdate(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user!.maritalStatus != _controllermaritalStatus!.text) {
      var updateResult = await _userModel.updateMaritalStatus(
          _userModel.user!.usersID, _controllermaritalStatus!.text);
      if (updateResult == true) {
      } else {
        _controllermaritalStatus!.text = _userModel.user!.maritalStatus!;
      }
    }
  }

  void _dateOfUpdate(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user!.dateOfBirth != _controllerDate!.text) {
      var updateResult = await _userModel.updateDateOfBirth(
          _userModel.user!.usersID, _controllerDate!.text);
      if (updateResult == true) {
      } else {
        _controllerDate!.text = _userModel.user!.dateOfBirth!;
      }
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateFormat formatter =
        DateFormat('dd/MM/yyyy'); //specifies day/month/year format

    final DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale("tr", "TR"),
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: selectedDate);
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      _controllerDate!.value = TextEditingValue(
          text: formatter.format(
              picked)); //Use formatter to format selected date and assign to text field
    }
  }
}
