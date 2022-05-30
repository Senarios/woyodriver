// ignore_for_file: unrelated_type_equality_checks

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cheetah_driver/Assistants/requestAssistant.dart';
import 'package:cheetah_driver/BookRide/ride_booked_page.dart';
import 'package:cheetah_driver/DataHandler/appData.dart';
import 'package:cheetah_driver/Models/directDetails.dart';
import 'package:cheetah_driver/Models/history.dart';
import 'package:cheetah_driver/Models/rideDetails.dart';
import 'package:cheetah_driver/Models/scheduleTrip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
// import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../configMaps.dart';
import '../main.dart';

class AssistantMethods {
  static Future<DirectionDetails> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    // var res = await RequestAssistant.getRequest(directionUrl);
    var res = await RequestAssistant.get(
        'maps.googleapis.com', '/maps/api/directions/json', {
      'origin': '${initialPosition.latitude},${initialPosition.longitude}',
      'destination': '${finalPosition.latitude},${finalPosition.longitude}',
      'key': mapKey
    });

    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    //in terms USD
    double timeTraveledFare = (directionDetails.durationValue / 60) * 0.20;
    double distancTraveledFare = (directionDetails.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distancTraveledFare;

    //Local Currency
    //1$ = 160 RS
    //double totalLocalAmount = totalFareAmount * 160;
    if (rideType == "uber-x") {
      double result = (totalFareAmount.truncate()) * 2.0;
      return result.truncate();
    } else if (rideType == "uber-go") {
      return totalFareAmount.truncate();
    } else if (rideType == "bike") {
      double result = (totalFareAmount.truncate()) / 2.0;
      return result.truncate();
    } else {
      return totalFareAmount.truncate();
    }
  }

  static void disableHomeTabLiveLocationUpdates() {
    // todo
    // homeTabPageStreamSubscription.pause();
    // Geofire.removeLocation(currentfirebaseUser.uid);

    FirebaseFirestore.instance
        .collection('availableDrivers')
        .doc(currentfirebaseUser.uid)
        .delete();
  }

  static void enableHomeTabLiveLocationUpdates() {
    // todo
    // homeTabPageStreamSubscription.resume();
    // Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);
    GeoFlutterFire geoFlutterFire = GeoFlutterFire();
    GeoFirePoint point = geoFlutterFire.point(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude);
    FirebaseFirestore.instance
        .collection('availableDrivers')
        .doc(currentfirebaseUser.uid)
        .set({'position': point.data});
  }

  static void retrieveHistoryInfo(context) {
    //retrieve and display Earnings
    driversRef
        .child(currentfirebaseUser.uid)
        .child("earnings")
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot != null) {
        print("Earnings: ${dataSnapshot.value.toString()}");
        if (dataSnapshot.value != null) {
          String earnings = dataSnapshot.value.toString();
          Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
        }
      }
    });

    //retrieve and display Trip History
    driversRef
        .child(currentfirebaseUser.uid)
        .child("history")
        .once()
        .then((DataSnapshot dataSnapshot) {
      print("dataSnapshot: ${dataSnapshot.value}");
      if (dataSnapshot != null) {
        if (dataSnapshot.value != null) {
          //update total number of trip counts to provider
          Map<dynamic, dynamic> keys = dataSnapshot.value;
          int tripCounter = keys.length;
          print(tripCounter);
          Provider.of<AppData>(context, listen: false)
              .updateTripsCounter(tripCounter);

          //update trip keys to provider
          List<String> tripHistoryKeys = [];
          keys.forEach((key, value) {
            tripHistoryKeys.add(key);
          });
          Provider.of<AppData>(context, listen: false)
              .updateTripKeys(tripHistoryKeys);
          obtainTripRequestsHistoryData(context);
        }
      }
    });
  }

  static bool timeChecking(String date) {
    var inputedStartTime = DateTime.parse(date);
    var mili = inputedStartTime.millisecondsSinceEpoch / 1000;
    var startTime = mili.toInt();

    var inputedENDTime = DateTime.parse(DateTime.now().toString());
    var miliEND = inputedENDTime.millisecondsSinceEpoch / 1000;
    var endTime = miliEND.toInt();

    var finalTime = endTime - startTime;

    print("COMPARE TO START: $startTime");
    print("COMPARE TO END: $endTime");
    print("COMPARE TO FINAL: ${endTime - startTime}");
    if (finalTime <= 0) {
      return true;
    } else {
      return false;
    }
  }

  static void retrieveScheduleTripInfo(context) {
    //retrieve and display Trip Schedule List
    newRequestsRef.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot != null) {
        if (dataSnapshot.value != null) {
          Map<dynamic, dynamic> keys = dataSnapshot.value;
          int scheduleTripCount = keys.length;
          Provider.of<AppData>(context, listen: false)
              .updateScheduleTripCounter(scheduleTripCount);
          List<String> scheduleTripKeys = [];
          keys.forEach((key, value) {
            if (value['time'] != null) {
              bool passOrNot = timeChecking(value['time']);
              if (passOrNot) {
                scheduleTripKeys.add(key);
              }
            }
          });
          print("retrieveScheduleTripInfo: ${scheduleTripKeys.length}");
          Provider.of<AppData>(context, listen: false)
              .updateScheduleTripKeys(scheduleTripKeys);
          obtainScheduleTripRequestsData(context);
        }
      }
      print("retrieveScheduleTripInfo: ${dataSnapshot.value.length}");
    });
  }

  static void setScheduleTripInfo(String rideRequestId, BuildContext context) {
    newRequestsRef
        .child(rideRequestId)
        .once()
        .then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null) {
        assetsAudioPlayer.open(Audio("sounds/alert.mp3"));
        assetsAudioPlayer.play();

        double pickUpLocationLat =
            double.parse(dataSnapShot.value['pickup']['latitude'].toString());
        double pickUpLocationLng =
            double.parse(dataSnapShot.value['pickup']['longitude'].toString());
        String pickUpAddress = dataSnapShot.value['pickup_address'].toString();

        double dropOffLocationLat =
            double.parse(dataSnapShot.value['dropoff']['latitude'].toString());
        double dropOffLocationLng =
            double.parse(dataSnapShot.value['dropoff']['longitude'].toString());
        String dropOffAddress =
            dataSnapShot.value['dropoff_address'].toString();

        String paymentMethod = dataSnapShot.value['payment_method'].toString();

        String rider_name = dataSnapShot.value["rider_name"];
        String rider_phone = dataSnapShot.value["rider_phone"];
        String noOfPassengers = dataSnapShot.value["no_of_passengers"];
        String _status = dataSnapShot.value["status"];
        double riderAmount = 0;

        riderAmount =
            double.tryParse(dataSnapShot.value['amount_from_rider'].toString());

        RideDetails rideDetails = RideDetails();
        rideDetails.ride_request_id = rideRequestId;
        rideDetails.pickup_address = pickUpAddress;
        rideDetails.dropoff_address = dropOffAddress;
        rideDetails.pickup = LatLng(pickUpLocationLat, pickUpLocationLng);
        rideDetails.dropoff = LatLng(dropOffLocationLat, dropOffLocationLng);
        rideDetails.payment_method = paymentMethod;
        rideDetails.rider_name = rider_name;
        rideDetails.noOfPassengers =
            noOfPassengers == null ? 1 : noOfPassengers;
        rideDetails.rider_phone = rider_phone;
        rideDetails.status = _status;
        rideDetails.rider_suggested_amount =
            riderAmount == null ? 0 : riderAmount;

        Navigator.pushNamed(context, RideBookedPage.idScreen,
            arguments: rideDetails);
        //    Provider.of<AppData>(context, listen: false).updateJobRequests(rideDetails);
        //
        //       showCupertinoModalBottomSheet(
        //         expand: false,
        //         context: context,
        //         backgroundColor: Colors.transparent,
        //         builder: (context) => NotificationDialog(
        //           rideDetails: rideDetails,
        //         ),
        //       );
        // showDialog(
        //   context: context,
        //   barrierDismissible: false,
        //   builder: (BuildContext context) => NotificationDialog(rideDetails: rideDetails,),
        //   builder: (BuildContext context) => NotificationDialog(rideDetails: rideDetails,),
        // );
      }
    });
  }

  // static void retrieveScheduleTripInfo(context) {
  //   //retrieve and display Trip Schedule List
  //   newRequestsRef.once().then((DataSnapshot dataSnapshot) {
  //     if (dataSnapshot != null) {
  //       if (dataSnapshot.value != null) {
  //         Map<dynamic, dynamic> keys = dataSnapshot.value;
  //         int scheduleTripCount = keys.length;
  //         print("scheduleTripCount: $scheduleTripCount");
  //         Provider.of<AppData>(context, listen: false)
  //             .updateScheduleTripCounter(scheduleTripCount);
  //         List<String> scheduleTripKeys = [];
  //         keys.forEach((key, value) {
  //           print('KEY and Value: $key : $value');
  //           scheduleTripKeys.add(key);
  //         });
  //         print("retrieveScheduleTripInfo: ${scheduleTripKeys.length}");

  //         Provider.of<AppData>(context, listen: false)
  //             .updateScheduleTripKeys(scheduleTripKeys);
  //         obtainScheduleTripRequestsData(context);
  //       }
  //     }
  //     print("retrieveScheduleTripInfo: ${dataSnapshot.value.length}");
  //   });
  // }

  // static bool _timeConversion(_schedualDateTime) {
  //   DateTime parseDate =
  //       new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(_schedualDateTime);
  //   if (parseDate.year > DateTime.now().year &&
  //       parseDate.month > DateTime.now().month &&
  //       parseDate.day > DateTime.now().day &&
  //       parseDate.hour > DateTime.now().hour &&
  //       parseDate.minute > DateTime.now().minute) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  static void obtainScheduleTripRequestsData(context) {
    var keys = Provider.of<AppData>(context, listen: false).scheduleTripKeys;
    Provider.of<AppData>(context, listen: false).scheduleTripDataList.clear();
    for (String key in keys) {
      newRequestsRef.child(key).once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var schedule = ScheduleTrip.fromSnapshot(snapshot);
          if (schedule.status == 'SCHEDULE_TRIP') {
            if (schedule.time != null) {
              // bool pass = _timeConversion(schedule.time);
              // if (pass) {
              print("retrieveScheduleTripInfo: ${schedule.time}");
              Provider.of<AppData>(context, listen: false)
                  .updateScheduleTripData(schedule);
              // }
            }
          }
        }
      });
    }
  }

  static void obtainTripRequestsHistoryData(context) {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;
    Provider.of<AppData>(context, listen: false).tripHistoryDataList.clear();
    for (String key in keys) {
      newRequestsRef
          .child(key)
          .child('status')
          .equalTo('ended')
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var history = History.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false)
              .updateTripHistoryData(history);
        }
      });
    }
  }

  static String formatTripDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDate;
  }
}
