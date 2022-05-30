import 'dart:async';
import 'dart:developer';

import 'package:cheetah_driver/AllWidgets/toast.dart';
import 'package:cheetah_driver/DataHandler/appData.dart';
import 'package:cheetah_driver/Models/drivers.dart';
import 'package:cheetah_driver/Notifications/pushNotificationService.dart';
import 'package:cheetah_driver/pro_kit/ora_pay/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
// import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../configMaps.dart';
import '../main.dart';

class DriverHomePage3 extends StatefulWidget {

  @override
  _DriverHomePage3State createState() => _DriverHomePage3State();
}

class _DriverHomePage3State extends State<DriverHomePage3> with AutomaticKeepAliveClientMixin<DriverHomePage3> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(5.316667, -4.033333),
    zoom: 14.4746,
  );

  String driverStatusText = "Offline - Log in";
  Color driverStatusColor = Colors.black;
  String driverName = '';
  GeoFlutterFire geoFlutterFire = GeoFlutterFire();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller)
          {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;
            locatePosition();
          },
        ),

        Container(
          padding: EdgeInsets.fromLTRB(16, 42, 16, 32),
          margin: EdgeInsets.only(bottom: 0, top: 0),
          width: double.infinity,
          height: 106.0,
          color: qIBus_rating,
          child: Row(
            children: [
              // CircleAvatar(backgroundImage: AssetImage(Banking_ic_user1), radius: 24),
              // 10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Text(driversInformation == null ? '' : driversInformation?.name),
                  Text(driversInformation == null ? '' :driversInformation?.email),
                ],
              ),
              // Icon(Icons.notifications, size: 30)
            ],
          ),
        ),

        Positioned(
          top: 40.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Switch(
                  value: isDriverAvailable,
                  onChanged: (value) {
                    if(value == true){
                      makeDriverOnlineNow();
                      getLocationLiveUpdates(true);
                      setState(() {
                        driverStatusColor = Colors.green;
                        driverStatusText = "En ligne ";
                        isDriverAvailable = true;
                      });
                      displayToastMessage("Vous êtes en ligne maintenant", context);
                    }else{
                      makeDriverOfflineNow();
                      setState(() {
                        driverStatusColor = Colors.black;
                        driverStatusText = "Hors ligne - Se connecter ";
                        isDriverAvailable = false;
                      });
                      displayToastMessage("Vous êtes hors ligne maintenant.", context);
                    }
                  },
                  activeTrackColor: Colors.black12,
                  activeColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    initializeCurrentDriverInfo();
  }

  void initializeCurrentDriverInfo() async
  {
    currentfirebaseUser = await FirebaseAuth.instance.currentUser;

    driversRef.child(currentfirebaseUser.uid).once().then((DataSnapshot dataSnapShot){
      if(dataSnapShot.value != null)
      {
        driversInformation = Drivers.fromSnapshot(dataSnapShot);

        setState(() {
          driverName = driversInformation.name;
        });

      }
    });

    PushNotificationService pushNotificationService = PushNotificationService();
    pushNotificationService.initialize(context);
    pushNotificationService.assignTokenToDriver();

    // AssistantMethods.retrieveHistoryInfo(context);
    // getRatings();
    // getRideType();

    // getLocationLiveUpdates(false);

    // driverStatusText = _isListening() ? 'Diver is online' : 'Driver is offline';
    // driverStatusColor = _isListening() ? Colors.green : Colors.red;
    // fred fix error on init isDriverAvailable = _isListening();
  }

  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    if(newGoogleMapController != null){
      CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);
      newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  void makeDriverOnlineNow() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    // @todo geofire
    // await Geofire.initialize("availableDrivers");
    // Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);

    GeoFirePoint point = geoFlutterFire.point(latitude: currentPosition.latitude, longitude: currentPosition.longitude);
    FirebaseFirestore.instance
        .collection('availableDrivers')
        .doc(currentfirebaseUser.uid)
        .set({
      'position': point.data
    });

    rideRequestRef.set("searching");
    rideRequestRef.onValue.listen((event) {
      //print('searching ride');
      //inspect(event);
    });
  }

  void makeDriverOfflineNow()
  {
    // print('is makeDriverOfflineNow');
    // @todo geofire
    // Geofire.removeLocation(currentfirebaseUser.uid);
    // GeoFirePoint point = geoFlutterFire.point(latitude: currentPosition.latitude, longitude: currentPosition.longitude);
    FirebaseFirestore.instance
        .collection('availableDrivers')
        .doc(currentfirebaseUser.uid)
        .delete();

    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    // rideRequestRef= null;
  }

  void getLocationLiveUpdates(bool zoom)
  {
    final positionStream = Geolocator.getPositionStream();
    driverTabPageStreamSubscription = positionStream
      .handleError((error) {
        driverTabPageStreamSubscription.cancel();
        driverTabPageStreamSubscription = null;
      })
      .listen((Position position) {
        // print('listen on homeTabPageStreamSubscription homepage3 $position');
        if(currentPosition.latitude == position.latitude && currentPosition.longitude == position.longitude){
          return;
        }
        currentPosition = position;

        // var isAvailable = Provider.of<AppData>(context, listen: false).isDriverAvailable;

        if(isDriverAvailable == true){
          //@todo geofire
          //Geofire.setLocation(currentfirebaseUser.uid, position.latitude, position.longitude);
          GeoFirePoint point = geoFlutterFire.point(latitude: currentPosition.latitude, longitude: currentPosition.longitude);
          FirebaseFirestore.instance
              .collection('availableDrivers')
              .doc(currentfirebaseUser.uid)
              .set({
                'position': point.data
              });
        }

        if(newGoogleMapController != null){
          LatLng latLng = LatLng(position.latitude, position.longitude);
          newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
        }
      });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
