import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cheetah_driver/Models/allUsers.dart';
import 'package:cheetah_driver/Models/drivers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String mapKey = "AIzaSyDNBnsIxeiwwHkg7jGV3rfMYli2avO8UZ8";

User firebaseUser;

Users userCurrentInfo;

User currentfirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;
StreamSubscription<Position> driverTabPageStreamSubscription;

StreamSubscription<Position> rideStreamSubscription;

final assetsAudioPlayer = AssetsAudioPlayer();

Position currentPosition;

Drivers driversInformation;

String title = "";
String selectedRideOption = "Ok";
String conditionAmount = "0";
double starCounter = 0.0;

String rideType = "";

bool isDriverAvailable = false;

List<String> riderHistoric = [];
