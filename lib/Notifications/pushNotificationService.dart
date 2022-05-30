// import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cheetah_driver/AllScreens/registerUserScreen.dart';
import 'package:cheetah_driver/BookRide/ride_booked_page.dart';
import 'package:cheetah_driver/DataHandler/appData.dart';
import 'package:cheetah_driver/Models/rideDetails.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../configMaps.dart';
import '../main.dart';
import 'notificationDialog.dart';

class PushNotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future initializeRideMessage(context) async {
    rideMessage.onValue.listen((event) async {
      if (event.snapshot.value == null) {
        return;
      }
      Map map = event.snapshot.value;
      var first = map.values.toList().first;
      var riderId = map.values.toList().first["ride_request_id"];
      rideMessage.child(map.keys.first).remove();
      if (riderId != null) {
        retrieveRideRequestInfo(riderId, context);
      }
    });
  }

  Future initialize(context) async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print('getInitialMessage! ${message}');
      }
    });

    // FirebaseMessaging.instance.sendMessage()
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print('A new onMessage event was published!');
      // print(message.data);
      retrieveRideRequestInfo(getRideRequestId(message.data), context);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print('A new onMessageOpenedApp event was published!: ${message}');
      retrieveRideRequestInfo(getRideRequestId(message.data), context);
    });
  }

  Future assignTokenToDriver() async {
    String token = await firebaseMessaging.getToken();
    driversRef.child(currentfirebaseUser.uid).child("token").set(token);

    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
  }

  String getRideRequestId(Map<String, dynamic> message) {
    String rideRequestId = "";
    if (Platform.isAndroid) {
      rideRequestId = message['ride_request_id'];
    } else {
      rideRequestId = message['ride_request_id'];
    }

    return rideRequestId;
  }

  void retrieveRideRequestInfo(String rideRequestId, BuildContext context) {
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
        String _status = dataSnapShot.value["status"];
        String noOfPassengers = dataSnapShot.value["no_of_passengers"];

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

  

  // void setScheduleTripInfo(String rideRequestId, BuildContext context) {
  //   newRequestsRef
  //       .child(rideRequestId)
  //       .once()
  //       .then((DataSnapshot dataSnapShot) {
  //     if (dataSnapShot.value != null) {
  //       assetsAudioPlayer.open(Audio("sounds/alert.mp3"));
  //       assetsAudioPlayer.play();

  //       double pickUpLocationLat =
  //           double.parse(dataSnapShot.value['pickup']['latitude'].toString());
  //       double pickUpLocationLng =
  //           double.parse(dataSnapShot.value['pickup']['longitude'].toString());
  //       String pickUpAddress = dataSnapShot.value['pickup_address'].toString();

  //       double dropOffLocationLat =
  //           double.parse(dataSnapShot.value['dropoff']['latitude'].toString());
  //       double dropOffLocationLng =
  //           double.parse(dataSnapShot.value['dropoff']['longitude'].toString());
  //       String dropOffAddress =
  //           dataSnapShot.value['dropoff_address'].toString();

  //       String paymentMethod = dataSnapShot.value['payment_method'].toString();

  //       String rider_name = dataSnapShot.value["rider_name"];
  //       String rider_phone = dataSnapShot.value["rider_phone"];
  //       String _status = dataSnapShot.value["status"];
  //       double riderAmount = 0;

  //       riderAmount =
  //             double.tryParse(dataSnapShot.value['amount_from_rider'].toString());

  //         RideDetails rideDetails = RideDetails();
  //         rideDetails.ride_request_id = rideRequestId;
  //         rideDetails.pickup_address = pickUpAddress;
  //         rideDetails.dropoff_address = dropOffAddress;
  //         rideDetails.pickup = LatLng(pickUpLocationLat, pickUpLocationLng);
  //         rideDetails.dropoff = LatLng(dropOffLocationLat, dropOffLocationLng);
  //         rideDetails.payment_method = paymentMethod;
  //         rideDetails.rider_name = rider_name;
  //         rideDetails.rider_phone = rider_phone;
  //         rideDetails.status = _status;
  //         rideDetails.rider_suggested_amount =
  //             riderAmount == null ? 0 : riderAmount;

  //       Navigator.pushNamed(context, RideBookedPage.idScreen,arguments: rideDetails);
  //   //    Provider.of<AppData>(context, listen: false).updateJobRequests(rideDetails);
  //   //
  //   //       showCupertinoModalBottomSheet(
  //   //         expand: false,
  //   //         context: context,
  //   //         backgroundColor: Colors.transparent,
  //   //         builder: (context) => NotificationDialog(
  //   //           rideDetails: rideDetails,
  //   //         ),
  //   //       );
  //       // showDialog(
  //       //   context: context,
  //       //   barrierDismissible: false,
  //       //   builder: (BuildContext context) => NotificationDialog(rideDetails: rideDetails,),
  //       //   builder: (BuildContext context) => NotificationDialog(rideDetails: rideDetails,),
  //       // );
  //     }
  //   });
  // }
}

class ModalFit extends StatelessWidget {
  const ModalFit({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Edit'),
            leading: Icon(Icons.edit),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Copy'),
            leading: Icon(Icons.content_copy),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Cut'),
            leading: Icon(Icons.content_cut),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Move'),
            leading: Icon(Icons.folder_open),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Delete'),
            leading: Icon(Icons.delete),
            onTap: () => Navigator.of(context).pop(),
          )
        ],
      ),
    ));
  }
}
