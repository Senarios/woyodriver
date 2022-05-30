import 'package:cheetah_driver/pro_kit/ora_pay/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configMaps.dart';
import '../main.dart';
import 'registerCarInfoScreen.dart';
import 'loginScreen.dart';


class RegisterUserScreen extends StatelessWidget
{
  static const String idScreen = "registerUser";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  SharedPreferences preferences;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   // super.initState();
  //   getPreferrences();
  // }

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
              SizedBox(height: 5),
              Text(
                "Register a driver",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
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
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
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
                            "Create an account",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: ()
                      {
                        if(nameTextEditingController.text.length < 3)
                        {
                          displayToastMessage("Le nom doit comporter au moins 3 caractères.", context);
                        }
                        else if(!emailTextEditingController.text.contains("@"))
                        {
                          displayToastMessage("L'adresse email n'est pas valide.", context);
                        }
                        else if(phoneTextEditingController.text.isEmpty)
                        {
                          displayToastMessage("Le numéro de téléphone est obligatoire.", context);
                        }
                        else if(passwordTextEditingController.text.length < 6)
                        {
                          displayToastMessage("Le mot de passe doit être au moins de 6 caractères.", context);
                        }
                        else
                        {
                          registerNewUser(context);
                        }
                      },
                    ),

                  ],
                ),
              ),

              FlatButton(
                onPressed: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Already have an account? Log in here",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getPreferrences() async {
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async
  {
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context)
    //     {
    //       return ProgressDialog(message: "Registering, Please wait...",);
    //     }
    // );

    final User firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;

    if(firebaseUser != null) //user created
    {
      //save user info to database
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };
      driversRef.child(firebaseUser.uid).set(userDataMap);
      currentfirebaseUser = firebaseUser;

      // save to firestore
      final QuerySnapshot resultQuery = await FirebaseFirestore.instance
          .collection("users").where("id", isEqualTo: firebaseUser.uid).get();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;
      if(documentSnapshots.length == 0)
      {
        FirebaseFirestore.instance.collection("users").doc(firebaseUser.uid).set({
          "name" : nameTextEditingController.text.trim(),
          "phone" : phoneTextEditingController.text.trim(),
          "email" : firebaseUser.email.trim(),
          "id" : firebaseUser.uid,
          "createdAt" : DateTime.now().millisecondsSinceEpoch.toString(),
          "chattingWith" : null,
        });
        // print(firebaseUser);
        // //Write data to Local
        // currentUser = firebaseUser;
        preferences = await SharedPreferences.getInstance();
        await preferences.setString("id", firebaseUser.uid);
        await preferences.setString("name", nameTextEditingController.text.trim());
        await preferences.setString("email", firebaseUser.email);
        await preferences.setString("phone", phoneTextEditingController.text.trim());
        // await preferences.setString("photoUrl", firebaseUser.photoURL);
      }

      displayToastMessage("Félicitations, votre compte a été créé.", context);
      Navigator.pushNamed(context, RegisterCarInfoScreen.idScreen);
    }
    else
    {
      Navigator.pop(context);
      //error occured - display error msg
      displayToastMessage("Le nouveau compte utilisateur n'a pas été créé.", context);
    }
  }
}

displayToastMessage(String message, BuildContext context)
{
  Fluttertoast.showToast(msg: message);
}
