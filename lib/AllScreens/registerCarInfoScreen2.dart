import 'package:cheetah_driver/main.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cheetah_driver/utils/custom_button.dart';
import 'package:cheetah_driver/utils/entry_field.dart';
import 'package:cheetah_driver/utils/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configMaps.dart';
import 'mainscreen.dart';

class CarRegistrationUI extends StatefulWidget {
  static const String idScreen = "registerCarInfo";

  @override
  _CarRegistrationUIState createState() => _CarRegistrationUIState();
}

class _CarRegistrationUIState extends State<CarRegistrationUI> {
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController = TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  List<String> carTypesList = ['jomar-x', 'jomar-go'];
  String selectedCarType;
  SharedPreferences preferences;

  @override
  void dispose() {
    carModelTextEditingController.dispose();
    carNumberTextEditingController.dispose();
    carColorTextEditingController.dispose();
    super.dispose();
  }

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
                          padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                          child: Text(
                            "Car Info",
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
                                  label: "Made",
                                  controller: carModelTextEditingController,
                                  keyboardType: TextInputType.text,
                                ),
                                EntryField(
                                  controller: carNumberTextEditingController,
                                  label: "Numberplate",
                                  keyboardType: TextInputType.text,
                                ),
                                EntryField(
                                  controller: carColorTextEditingController,
                                  label: "Color",
                                  keyboardType: TextInputType.text,
                                ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DropdownButton(
                                      iconSize: 40,
                                      hint: Text('Choose a type of car'),
                                      value: selectedCarType,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedCarType = newValue;
                                          displayToastMessage(selectedCarType, context);
                                        });
                                      },
                                      items: carTypesList.map((car) {
                                        return DropdownMenuItem(
                                          child: new Text(car),
                                          value: car,
                                        );
                                      }).toList(),
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
                text: "SUIV",
                onTap: () {
                  if(carModelTextEditingController.text.isEmpty)
                  {
                    displayToastMessage("please write Car Model.", context);
                  }
                  else if(carNumberTextEditingController.text.isEmpty)
                  {
                    displayToastMessage("please write Car Number.", context);
                  }
                  else if(carColorTextEditingController.text.isEmpty)
                  {
                    displayToastMessage("please write Car Color.", context);
                  }
                  else if(selectedCarType == null)
                  {
                    displayToastMessage("please choose Car Type.", context);
                  }
                  else
                  {
                    saveDriverCarInfo(context);
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

  void saveDriverCarInfo(context)
  {
    String userId = currentfirebaseUser.uid;

    Map carInfoMap =
    {
      "car_color": carColorTextEditingController.text,
      "car_number": carNumberTextEditingController.text,
      "car_model": carModelTextEditingController.text,
      "type": selectedCarType,
    };

    driversRef.child(userId).child("car_details").set(carInfoMap);

    Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
  }
}
