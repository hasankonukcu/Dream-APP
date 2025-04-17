import 'package:dream/animation/fadeanimation.dart';
import 'package:dream/app/error.dart';
import 'package:dream/app/sign_in/email_login.dart';
import 'package:dream/commen_widget/alert_dialog.dart';
import 'package:dream/commen_widget/social_login_button.dart';
import 'package:dream/model/user.dart';
import 'package:dream/viewmodel/user_model.dart';
import 'package:dream/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

PlatformException? myError;

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  /*void _misafirGirisi(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    Users? _user = await _userModel.signInAnonymous();
    print("oturum acan userid: " + _user!.usersID.toString());
  }*/
  void _loginWithGoogle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    await _userModel.signInWithGoogle();
  }

  void _loginWithFacebook(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    try {
      await _userModel.signInWithFacebook();
    } on PlatformException catch (e) {
      myError = e;
      print(e);
    }
  }

  void _emailAndPasswordLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailAndPasswordLogin(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (myError != null) {
        PlatformSensAlertDialog(
          title: "Oturum açarken hata",
          content: Errors.show(myError!.code),
          mainButtonText: "Tamam",
        ).show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserModel>(context);

    return AppWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Rüya Perisi"),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: FadeAnimation(
                  delay: 0.1,
                  child: const Text(
                    "Oturum Açın",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              FadeAnimation(
                delay: 1.4,
                child: SocialLoginButton(
                  buttonColor: Colors.white,
                  buttonText: "Gmail ile Giriş",
                  textColor: Colors.black,
                  buttonIcon: Image.asset("images/google-logo.png"),
                  onPressed: () => _loginWithGoogle(context),
                ),
              ),
              FadeAnimation(
                delay: 1.8,
                child: SocialLoginButton(
                  buttonColor: const Color(0xFF334D92),
                  buttonIcon: Image.asset("images/facebook-logo.png"),
                  buttonText: "Facebook ile Giriş",
                  onPressed: () => _loginWithFacebook(context),
                ),
              ),
              FadeAnimation(
                delay: 2.5,
                child: SocialLoginButton(
                  buttonColor: const Color(0xFF334D92),
                  buttonText: "Email ve Şifre ile Giriş",
                  buttonIcon: const Icon(
                    Icons.email,
                    size: 32,
                    color: Colors.white,
                  ),
                  onPressed: () => _emailAndPasswordLogin(context),
                ),
              ),
              /*SocialLoginButton(
                buttonColor: Color(0xFF334D92),
                buttonText: "Misafir Girişi",
                onPressed: () => _misafirGirisi(context),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
