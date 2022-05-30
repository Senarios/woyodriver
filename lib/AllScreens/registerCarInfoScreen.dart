import 'package:cheetah_driver/AllScreens/registerUserScreen.dart';
import 'package:cheetah_driver/pro_kit/ora_pay/utils/colors.dart';
import 'package:flutter/material.dart';

import '../configMaps.dart';
import '../main.dart';
import 'mainscreen.dart';


class RegisterCarInfoScreen extends StatefulWidget
{
  static const String idScreen = "registerCarInfo";

  @override
  _RegisterCarInfoScreenState createState() => _RegisterCarInfoScreenState();
}

class _RegisterCarInfoScreenState extends State<RegisterCarInfoScreen> {
  TextEditingController carModelTextEditingController = TextEditingController();

  TextEditingController carNumberTextEditingController = TextEditingController();

  TextEditingController carColorTextEditingController = TextEditingController();

  List<String> carTypesList = ['jomar-x', 'jomar-go'];

  String selectedCarType;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 150.0,),
              Image.asset('images/pro_kit/qibus/qibus_ic_logo_splash.gif', width: 75, height: 75, fit: BoxFit.fill),
              // Image.asset("images/logo.png", width: 390.0, height: 250.0,),
              Padding(
                padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                child: Column(
                  children: [
                    SizedBox(height: 12.0,),
                    Text("Car info", style: TextStyle(fontFamily: "Brand Bold", fontSize: 24.0),),

                    SizedBox(height: 26.0,),
                    TextField(
                      controller: carModelTextEditingController,
                      decoration: InputDecoration(
                        labelText: "Made",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),

                      ),
                      style: TextStyle(fontSize: 15.0),
                    ),

                    SizedBox(height: 10.0,),
                    TextField(
                      controller: carNumberTextEditingController,
                      decoration: InputDecoration(
                        labelText: "Numberplate",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),

                      ),
                      style: TextStyle(fontSize: 15.0),
                    ),

                    SizedBox(height: 10.0,),
                    TextField(
                      controller: carColorTextEditingController,
                      decoration: InputDecoration(
                        labelText: "Color",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),

                      ),
                      style: TextStyle(fontSize: 15.0),
                    ),

                    SizedBox(height: 26.0,),

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

                    SizedBox(height: 42.0,),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: ()
                        {
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
                        color: qIBus_orange,
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("SUIV", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                              Icon(Icons.arrow_forward, color: Colors.white, size: 26.0,),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
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
