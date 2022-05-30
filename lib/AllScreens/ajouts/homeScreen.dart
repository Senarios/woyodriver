import 'package:cheetah_driver/AllScreens/ajouts/registerWalkThroughScreen.dart';
import 'package:cheetah_driver/AllScreens/ajouts/walkthroughScreen.dart';
import 'package:cheetah_driver/AllScreens/loginScreen.dart';
import 'package:cheetah_driver/AllScreens/registerUserScreen.dart';
import 'package:cheetah_driver/BookRide/ride_booked_page.dart';
import 'package:cheetah_driver/DrawerPages/Profile/my_profile.dart';
import 'package:cheetah_driver/DrawerPages/Rides/my_rides_page.dart';
import 'package:cheetah_driver/DrawerPages/Schedule/schedule_trip.dart';
import 'package:cheetah_driver/Theme/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../loginScreen2.dart';
import '../mainScreen2.dart';
import '../registerCarInfoScreen.dart';
import '../mainscreen.dart';
import '../registerCarInfoScreen2.dart';
import '../registerUserScreen2.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lift',
      theme: AppTheme.darkTheme,
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? LoginScreenUI.idScreen
          : DriverHomeScreen.idScreen,
      routes: {
        //RegisterUserScreen.idScreen: (context) => RegisterUserScreen(),
        RegistrationUI.idScreen: (context) => RegistrationUI(),
        //LoginScreen.idScreen: (context) => LoginScreen(),
        LoginScreenUI.idScreen: (context) => LoginScreenUI(),
        //MainScreen.idScreen: (context) => MainScreen(),
        DriverHomeScreen.idScreen: (context) => DriverHomeScreen(),
        //RegisterCarInfoScreen.idScreen: (context) => RegisterCarInfoScreen(),
        CarRegistrationUI.idScreen: (context) => CarRegistrationUI(),
        MyProfilePage.idScreen: (context) => MyProfilePage(),
        MyRidesPage.idScreen: (context) => MyRidesPage(),
        ScheduleTripScreen.idScreen: (context) => ScheduleTripScreen(),
        RideBookedPage.idScreen: (context) => RideBookedPage(),

        WalkThroughScreen.idScreen: (context) => WalkThroughScreen(),
        RegisterWalkThroughScreen.idScreen: (context) =>
            RegisterWalkThroughScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
    // return Scaffold(
    //   body: Center(
    //       child: Text(
    //         "Welcome to home page",
    //         style: TextStyle(fontSize: 25.0),
    //       )),
    // );
  }
}
