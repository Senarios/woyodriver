
import 'package:cheetah_driver/AllScreens/mainscreen.dart';
import 'package:cheetah_driver/Assistants/authAssistantMethods.dart';
import 'package:cheetah_driver/Models/drivers.dart';
import 'package:cheetah_driver/pro_kit/ora_pay/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../configMaps.dart';
import '../../main.dart';
import '../registerCarInfoScreen.dart';
import '../registerUserScreen.dart';

class RegisterWalkThroughScreen extends StatefulWidget {
  static const String idScreen = "registerWalkThrough";
  TextEditingController firstNameTextEditingController = TextEditingController();

  @override
  _RegisterWalkThroughScreenState createState() => new _RegisterWalkThroughScreenState();
}

class _RegisterWalkThroughScreenState extends State<RegisterWalkThroughScreen> {

  int currentStep = 0;
  bool complete = false;
  StepperType stepperType = StepperType.horizontal;
  List<Step> _stepList = [];

  static var _focusNode = new FocusNode();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  RegistrationDriver userInfo = new RegistrationDriver();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<Step> _createSteps(BuildContext context) {
    List<Step> steps = [
      Step(
        title: const Text('Chauffeur'),
        isActive: _isActive(0),
        state: _getState(0),
        content: Column(
          children: <Widget>[
            // textField(title: 'Nom', image: Icons.person, textEditingController: firstNameTextEditingController),
            // textField(title: 'Prenom', image: Icons.person, textEditingController: lastNameTextEditingController),
            new TextFormField(
              initialValue: '',
              keyboardType: TextInputType.text,
              autocorrect: true,
              validator: (value) {
                // if (value.isEmpty) {
                //   return 'Veuillez fournir votre nom';
                // }
              },

              onSaved: (String value) {
                userInfo.lastName = value;
              },
              maxLines: 1,
              decoration: new InputDecoration(
                  labelText: 'Entrez votre nom',
                  hintText: 'Entrez votre nom',
                  icon: const Icon(Icons.person),
                  labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
            ),
            new TextFormField(
              keyboardType: TextInputType.text,
              autocorrect: false,
              validator: (value) {

              },
              onSaved: (String value) {
                userInfo.firstName = value;
              },
              maxLines: 1,
              decoration: new InputDecoration(
                  labelText: 'Entrez votre prenom',
                  hintText: 'Entrez votre prenom',
                  icon: const Icon(Icons.person_add),
                  labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
            ),
            new TextFormField(
              keyboardType: TextInputType.phone,
              autocorrect: false,
              validator: (value) {
                // if (value.isEmpty || value.length < 10) {
                //   return 'Entrez un numero valid';
                // }
              },
              onSaved: (String value) {
                userInfo.phone = value;
              },
          maxLines: 1,
          decoration: new InputDecoration(
              labelText: 'Numéro de téléphone',
              hintText: 'Numéro de téléphone',
              icon: const Icon(Icons.phone),
              labelStyle:
              new TextStyle(decorationStyle: TextDecorationStyle.solid))
            ),
            new TextFormField(
                keyboardType: TextInputType.text,
                autocorrect: false,
                validator: (value) {
                  // if (value.isEmpty || value.length < 10) {
                  //   return 'Entrez un numero valid';
                  // }
                },
                onSaved: (String value) {
                  userInfo.password = value;
                },
                maxLines: 1,
                decoration: new InputDecoration(
                    labelText: 'Mot de passe',
                    hintText: 'Mot de passe',
                    icon: const Icon(Icons.phone),
                    labelStyle:
                    new TextStyle(decorationStyle: TextDecorationStyle.solid))
            ),
            new TextFormField(
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              validator: (value) {
                // if (value.isEmpty || !value.contains('@')) {
                //   return 'Veuillez entrer une addresse courriel valide';
                // }
              },
              onSaved: (String value) {
                userInfo.email = value;
              },
              maxLines: 1,
              decoration: new InputDecoration(
                  labelText: 'Entrez votre addresse courriel',
                  hintText: 'Entrez votre addresse courriel',
                  icon: const Icon(Icons.email),
                  labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
            ),
            new TextFormField(
              keyboardType: TextInputType.text,
              autocorrect: false,
              validator: (value) {
                // if (value.isEmpty || !value.contains('@')) {
                //   return 'Veuillez entrer une addresse courriel valide';
                // }
              },
              onSaved: (String value) {
                userInfo.permis = value;
              },
              maxLines: 1,
              decoration: new InputDecoration(
                  labelText: 'Permis de conduire',
                  hintText: 'Permis de conduire',
                  // icon: const Icon(Icons.email),
                  labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
            ),
            // textField(title: 'Email', image: Icons.email, textEditingController: emailTextEditingController),
            // textField(title: 'Permis de conduire', image: Icons.card_membership, textEditingController: permitTextEditingController),
            // TextFormField(
            //   decoration: InputDecoration(labelText: 'Password'),
            // ),
          ],
        ),
      ),
      Step(
        isActive: _isActive(1),
        state: _getState(1),
        title: const Text('Auto'),
        content: Column(
          children: <Widget>[

            TextFormField(
              initialValue: '',
              keyboardType: TextInputType.text,
              autocorrect: true,
              validator: (value) {
              },
              onSaved: (String value) {
                // data.email = value;
              },
              maxLines: 1,
              decoration: new InputDecoration(
                  labelText: 'Marque',
                  hintText: 'Marque',
                  // icon: const Icon(Icons.car_rental),
                  labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
            ),
            TextFormField(
              initialValue: '',
              keyboardType: TextInputType.text,
              autocorrect: true,
              validator: (value) {
              },
              onSaved: (String value) {
                userInfo.model = value;
              },
              maxLines: 1,
              decoration: new InputDecoration(
                  labelText: 'Modele',
                  hintText: 'Modele',
                  // icon: const Icon(Icons.car_rental),
                  labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
            ),
            TextFormField(
              initialValue: '',
              keyboardType: TextInputType.text,
              autocorrect: true,
              validator: (value) {
              },
              onSaved: (String value) {
                userInfo.colour = value;
              },
              maxLines: 1,
              decoration: new InputDecoration(
                  labelText: 'Couleur',
                  hintText: 'Couleur',
                  // icon: const Icon(Icons.car_rental),
                  labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
            ),
            TextFormField(
              initialValue: '',
              keyboardType: TextInputType.number,
              autocorrect: true,
              validator: (value) {
              },
              onSaved: (String value) {
                userInfo.year = value;
              },
              maxLines: 1,
              decoration: new InputDecoration(
                  labelText: 'Annee',
                  hintText: 'Annee',
                  // icon: const Icon(Icons.car_rental),
                  labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
            ),
          ],
        ),
      ),
      Step(
        isActive: _isActive(2),
        state: _getState(2),
        title: const Text('Paiement'),
        // subtitle: const Text("Error!"),
        content: Column(
          children: <Widget>[

          ],
        ),
      ),
    ];

    return steps;
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _stepList = _createSteps(context);

    return new Scaffold(
        appBar: AppBar(
          title: Text('Veuillez remplir vos informations'),
          backgroundColor: qIBus_colorPrimary,
        ),
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              Expanded(
                child: Stepper(
                  steps: _stepList,
                  type: stepperType,
                  currentStep: currentStep,
                  onStepContinue: next,
                  onStepTapped: (step) => goTo(step),
                  onStepCancel: cancel,
                ),
              ),
              // complete ? Expanded(
              //   child: Center(
              //     child: AlertDialog(
              //       title: new Text("Votre profil a ete cree"),
              //       content: new Text(
              //         "Vous pouvez confirmer vos informations envoyees par email et commencer a utiliser l'application!",
              //       ),
              //       actions: <Widget>[
              //         new FlatButton(
              //           child: new Text("Se connecter"),
              //           onPressed: () {
              //             Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
              //             // setState(() => complete = false);
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ) :
              // Expanded(
              //     child: Stepper(
              //       steps: _stepList,
              //       type: stepperType,
              //       currentStep: currentStep,
              //       onStepContinue: next,
              //       onStepTapped: (step) => goTo(step),
              //       onStepCancel: cancel,
              //     ),
              //   ),
            ]),
          ),
        ));
  }

  bool _isActive(int i) {
    return currentStep == i;
  }

  StepState _getState(int i) {
    print('_getState: ${currentStep} ${i}');

    if (currentStep >= i){
      return StepState.complete;
    }
    else
      return StepState.indexed;
  }

  next() {
    final FormState formState = _formKey.currentState;
    if(!formState.validate()){
      return;
    }
    formState.save();

    currentStep + 1 != _stepList.length
        ? goTo(currentStep + 1)
        : setState(() => complete = true);


      if(complete == true){
        saveDriverInfoToDataBase();
      }
      formState.reset();
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  saveDriverInfoToDataBase() async {

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
        email: userInfo.email,
        password: userInfo.password
    ).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;

    if(firebaseUser != null) //user created
    {
      //save user info to database
      var userDataMap = AuthAssistantMethods.saveUserToRtDatabase(userInfo);
      driversRef.child(firebaseUser.uid).set(userDataMap);
      currentfirebaseUser = firebaseUser;

      // save to fireStore
      final QuerySnapshot resultQuery = await FirebaseFirestore.instance
          .collection("users").where("id", isEqualTo: firebaseUser.uid).get();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;
      if(documentSnapshots.length == 0)
      {
        FirebaseFirestore.instance.collection("users").doc(firebaseUser.uid).set({
          "lastName" : userInfo.lastName.trim(),
          "firstName" : userInfo.firstName.trim(),
          "phone" : userInfo.phone.trim(),
          "email" : firebaseUser.email.trim(),
          "id" : firebaseUser.uid,
          "createdAt" : DateTime.now().millisecondsSinceEpoch.toString(),
          "chattingWith" : null,
        });

        // //Write data to Local
        // currentUser = firebaseUser;
        // await preferences.setString("id", currentUser.uid);
        // await preferences.setString("nickname", currentUser.displayName);
        // await preferences.setString("photoUrl", currentUser.photoURL);
      }

      displayToastMessage("Congratulations, your account has been created.", context);

      Navigator.pushNamed(context, RegisterCarInfoScreen.idScreen);
    }
    else
    {
      Navigator.pop(context);
      //error occured - display error msg
      displayToastMessage("New user account has not been Created.", context);
    }
  }
}
