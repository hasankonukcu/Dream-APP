import 'package:dream/app/home_page.dart';
import 'package:dream/app/sign_in/sing_in_page.dart';
import 'package:dream/viewmodel/user_model.dart';
import 'package:dream/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var myBackgrounColor = Theme.of(context).primaryColor;
    var myButtonColor = Theme.of(context).colorScheme.secondary;

    final _userModel = Provider.of<UserModel>(context);
    if (_userModel.state == ViewState.Idle) {
      if (_userModel.user == null) {
        return AppWrapper(child: SignInPage());
      } else {
        return HomePage(user: _userModel.user!);
      }
    } else {
      return AppWrapper(
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(myButtonColor),
            ),
          ),
        ),
      );
    }
  }
}
