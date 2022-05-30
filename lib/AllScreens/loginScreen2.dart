import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cheetah_driver/AllScreens/registerUserScreen.dart';
import 'package:cheetah_driver/main.dart';
import 'package:cheetah_driver/pro_kit/nb/utils.dart';
import 'package:cheetah_driver/pro_kit/ora_pay/utils/colors.dart';
import 'package:cheetah_driver/utils/colors.dart';
import 'package:cheetah_driver/utils/custom_button.dart';
import 'package:cheetah_driver/utils/entry_field.dart';
import 'package:cheetah_driver/utils/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configMaps.dart';
import 'mainscreen.dart';

class LoginScreenUI extends StatefulWidget {
  static const String idScreen = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenUI> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: FadedSlideAnimation(
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        // AppBar(),
                        Image.asset(
                            'images/pro_kit/qibus/qibus_ic_logo_splash.gif',
                            width: 75,
                            height: 75,
                            fit: BoxFit.fill),
                        Text("JOMAR TAXI"),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            "Driver Login",
                            style: theme.textTheme.headline4,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: theme.backgroundColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                EntryField(
                                  controller: emailTextEditingController,
                                  label: "Courriel",
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                EntryField(
                                  controller: passwordTextEditingController,
                                  label: "Mot de passe",
                                  obscureText: true,
                                ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('You do not have an account? '),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            RegisterUserScreen.idScreen,
                                            (route) => false);
                                      },
                                      child: Text("Register Here",
                                          style: boldTextStyle(
                                              color: qIBus_orange)),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Divider(thickness: 2).expand(),
                                    8.width,
                                    Text('Or register with', style: secondaryTextStyle()),
                                    8.width,
                                    Divider(thickness: 2).expand(),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppButton(
                                      child: Row(
                                        children: [
                                          Image.asset(NBFacebookLogo, width: 20, height: 20),
                                          8.width,
                                          // Text('Facebook', style: primaryTextStyle(color: white)),
                                        ],
                                      ),
                                      onTap: () {},
                                      // width: (context.width() - (3 * 16)) * 0.5,
                                      color: NBFacebookColor,
                                      elevation: 0,
                                    ).cornerRadiusWithClipRRect(20),
                                    16.width,
                                    AppButton(
                                      child: Row(
                                        children: [
                                          Image.asset(NBGoogleLogo, width: 20, height: 20),
                                          8.width,
                                          // Text('Google', style: primaryTextStyle(color: black)),
                                        ],
                                      ),
                                      onTap: () {},
                                      // width: (context.width() - (3 * 16)) * 0.5,
                                      elevation: 0,
                                      shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(width: 1, color: grey)),
                                    ),
                                  ],
                                ),
                                Spacer(flex: 6),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            PositionedDirectional(
              start: 0,
              end: 0,
              child: CustomButton(
                text: "Connexion",
                onTap: () {
                  if (!emailTextEditingController.text.contains("@")) {
                    displayToastMessage(
                        "Addresse courriel non valide.", context);
                  } else if (passwordTextEditingController.text.isEmpty) {
                    displayToastMessage(
                        "Le mot de passe est obligatoire.", context);
                  } else {
                    loginAndAuthenticateUser(context);
                  }
                },
              ),
            ),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context)
    //   {
    //     return ProgressDialog(message: "Authenticating, Please wait...",);
    //   }
    // );

    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      driversRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          currentfirebaseUser = firebaseUser;
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage("Vous êtes connecté.", context);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage(
              "Aucun compte n'existe pour cet utilisateur. Veuillez créer un nouveau compte.",
              context);
        }
      });
    } else {
      Navigator.pop(context);
      displayToastMessage(
          "Une erreur s'est produite, ne peut pas être connecté.", context);
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
