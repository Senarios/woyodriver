import 'package:cheetah_driver/AllScreens/ajouts/registerWalkThroughScreen.dart';
import 'package:cheetah_driver/AllScreens/registerUserScreen.dart';
import 'package:cheetah_driver/AllWidgets/progressDialog.dart';
import 'package:cheetah_driver/pro_kit/nb/utils.dart';
import 'package:cheetah_driver/pro_kit/ora_pay/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configMaps.dart';
import '../main.dart';
import 'mainscreen.dart';


class LoginScreen extends StatefulWidget
{
  static const String idScreen = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen>
{
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 200.0,),
              Image.asset('images/pro_kit/qibus/qibus_ic_logo_splash.gif', width: 75, height: 75, fit: BoxFit.fill),
              SizedBox(height: 10),
              Text("JOMAR TAXI", style: boldTextStyle(size: 20)),
              SizedBox(height: 5.0,),
              Text(
                "Driver Login",
                style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 20.0,),
                    RaisedButton(
                      color: qIBus_rating,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Connexion",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: ()
                      {
                        if(!emailTextEditingController.text.contains("@"))
                        {
                          displayToastMessage("Addresse courriel non valide.", context);
                        }
                        else if(passwordTextEditingController.text.isEmpty)
                        {
                          displayToastMessage("Le mot de passe est obligatoire.", context);
                        }
                        else
                        {
                          loginAndAuthenticateUser(context);
                        }
                      },
                    ),

                  ],
                ),
              ),

              // FlatButton(
              //   onPressed: ()
              //   {
              //     Navigator.pushNamedAndRemoveUntil(context, RegisterWalkThroughScreen.idScreen, (route) => false);
              //   },
              //   child: Text(
              //     "Vous n'avez pas de compte? Inscrivez-vous ici",
              //   ),
              // ),
              SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You do not have an account? ', style: primaryTextStyle()),
                  Text(' Register here', style: boldTextStyle(color: qIBus_orange)).onTap(() {
                    Navigator.pushNamedAndRemoveUntil(context, RegisterUserScreen.idScreen, (route) => false);
                  }),
                ],
              ),
              SizedBox(height: 16.0,),
              Row(
                children: [
                  Divider(thickness: 2).expand(),
                  8.width,
                  Text('Or register with', style: secondaryTextStyle()),
                  8.width,
                  Divider(thickness: 2).expand(),
                ],
              ),
              SizedBox(height: 20.0,),
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
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async
  {
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
        password: passwordTextEditingController.text
    ).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;

    if(firebaseUser != null)
    {
      driversRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
        if(snap.value != null)
        {
          currentfirebaseUser = firebaseUser;
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMessage("Vous êtes connecté.", context);
        }
        else
        {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("Aucun compte n'existe pour cet utilisateur. Veuillez créer un nouveau compte.", context);
        }
      });
    }
    else
    {
      Navigator.pop(context);
      displayToastMessage("Une erreur s'est produite, ne peut pas être connecté.", context);
    }
  }
}
