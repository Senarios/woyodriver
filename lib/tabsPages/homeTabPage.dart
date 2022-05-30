import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cheetah_driver/AllScreens/registerUserScreen.dart';
import 'package:cheetah_driver/Assistants/assistantMethods.dart';
import 'package:cheetah_driver/Models/drivers.dart';
import 'package:cheetah_driver/Notifications/pushNotificationService.dart';
import 'package:cheetah_driver/configMaps.dart';
import 'package:cheetah_driver/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabPage extends StatefulWidget
{
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  var geoLocator = Geolocator();

  String driverStatusText = "Offline Now - Go Online ";
  Color driverStatusColor = Colors.black;
  bool isDriverAvailable = false;

  @override
  void initState() {
    super.initState();

    initializeCurrentDriverInfo();
  }
  // get driver info
  void initializeCurrentDriverInfo() async
  {
    currentfirebaseUser = await FirebaseAuth.instance.currentUser;

    driversRef.child(currentfirebaseUser.uid).once().then((DataSnapshot dataSnapShot){
      if(dataSnapShot.value != null)
      {
        driversInformation = Drivers.fromSnapshot(dataSnapShot);
      }
    });

    PushNotificationService pushNotificationService = PushNotificationService();
    pushNotificationService.initialize(context);
    pushNotificationService.assignTokenToDriver();

    AssistantMethods.retrieveHistoryInfo(context);
    getRatings();
    getRideType();

    getLocationLiveUpdates(false);

    driverStatusText = _isListening() ? 'Diver is online' : 'Driver is offline';
    driverStatusColor = _isListening() ? Colors.green : Colors.red;
    // fred fix error on init isDriverAvailable = _isListening();
  }

  getRideType()
  {
    driversRef.child(currentfirebaseUser.uid).child("car_details").child("type").once().then((DataSnapshot snapshot)
    {
      if(snapshot.value != null)
      {
        setState(() {
          rideType = snapshot.value.toString();
        });
      }
    });
  }
  
  getRatings()
  {
    //update ratings
    driversRef.child(currentfirebaseUser.uid).child("ratings").once().then((DataSnapshot dataSnapshot)
    {
      if(dataSnapshot.value != null)
      {
        double ratings = double.parse(dataSnapshot.value.toString());
        setState(() {
          starCounter = ratings;
        });

        if(starCounter <= 1.5)
        {
          setState(() {
            title = "Very Bad";
          });
          return;
        }
        if(starCounter <= 2.5)
        {
          setState(() {
            title = "Bad";
          });

          return;
        }
        if(starCounter <= 3.5)
        {
          setState(() {
            title = "Good";
          });

          return;
        }
        if(starCounter <= 4.5)
        {
          setState(() {
            title = "Very Good";
          });
          return;
        }
        if(starCounter <= 5.0)
        {
          setState(() {
            title = "Excellent";
          });

          return;
        }
      }
    });
  }

  // get driver last position
  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  bool _isListening() => !(homeTabPageStreamSubscription == null || homeTabPageStreamSubscription.isPaused);

  @override
  Widget build(BuildContext context)
  {
    return Stack(
      children: [

        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: HomeTabPage._kGooglePlex,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller)
          {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;
            locatePosition();
          },
        ),

        //online offline driver Container
        // Container(
        //   height: 140.0,
        //   width: double.infinity,
        //   color: Colors.red,
        // ),

        Container(
          padding: EdgeInsets.fromLTRB(16, 42, 16, 32),
          margin: EdgeInsets.only(bottom: 0, top: 0),
          width: double.infinity,
          height: 106.0,
          color: Colors.white70,
          child: Row(
            children: [
              // CircleAvatar(backgroundImage: AssetImage(Banking_ic_user1), radius: 24),
              // 10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Text("Hello,Laura"),
                  Text("How are you today?"),
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
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(24.0),
                  ),
                  onPressed: ()
                  {
                    if(isDriverAvailable != true)
                    {
                      makeDriverOnlineNow();
                      getLocationLiveUpdates(true);

                      setState(() {
                        driverStatusColor = Colors.green;
                        driverStatusText = "Online Now ";
                        isDriverAvailable = true;
                      });

                      displayToastMessage("you are Online Now.", context);
                    }
                    else
                    {
                      makeDriverOfflineNow();
                      turnOffLivePosition();

                      setState(() {
                        driverStatusColor = Colors.black;
                        driverStatusText = "Offline Now - Go Online ";
                        isDriverAvailable = false;
                      });

                      displayToastMessage("you are Offline Now.", context);
                    }
                  },
                  color: driverStatusColor,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(driverStatusText, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white),),
                        Icon(Icons.phone_android, color: Colors.white, size: 14.0,),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }

  @override
  void dispose() {
    if (homeTabPageStreamSubscription != null) {
      homeTabPageStreamSubscription.cancel();
      homeTabPageStreamSubscription = null;
    }
    super.dispose();
  }

  void makeDriverOnlineNow() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    // @todo geofire
    // bool isReady = await Geofire.initialize("availableDrivers");
    // Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);

    rideRequestRef.set("searching");
    rideRequestRef.onValue.listen((event) {
      print('searching ride');
      inspect(event);
    });
  }

  void getLocationLiveUpdates(bool zoom)
  {
    final positionStream = Geolocator.getPositionStream();
    print('inside getLocationLiveUpdates');

    homeTabPageStreamSubscription = positionStream
        .handleError((error) {
          print('error on homeTabPageStreamSubscription: $error');
          homeTabPageStreamSubscription.cancel();
          homeTabPageStreamSubscription = null;
        })
        .listen((Position position) {
          print('listen on homeTabPageStreamSubscription home tab $position');

          currentPosition = position;
          if(isDriverAvailable == true)
          {
            // @todo geofire
            // Geofire.setLocation(currentfirebaseUser.uid, position.latitude, position.longitude);
          }
          if(newGoogleMapController != null && zoom){
            LatLng latLng = LatLng(position.latitude, position.longitude);
            newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
          }
          // homeTabPageStreamSubscription.pause();
        });

    // setState(() {
    //   if (homeTabPageStreamSubscription == null) {
    //     return;
    //   }
    //
    //   if (homeTabPageStreamSubscription.isPaused) {
    //     homeTabPageStreamSubscription.resume();
    //   } else {
    //     homeTabPageStreamSubscription.pause();
    //   }
    // });
  }

  void turnOffLivePosition(){
    setState(() {
      if (homeTabPageStreamSubscription == null) {
        return;
      }

      if (!homeTabPageStreamSubscription.isPaused) {
        homeTabPageStreamSubscription.pause();
      }
    });
  }

  void makeDriverOfflineNow()
  {
    print('is makeDriverOfflineNow');
    // @todo geofire
    // Geofire.removeLocation(currentfirebaseUser.uid);
    // rideRequestRef.onDisconnect();
    // rideRequestRef.remove();
    // rideRequestRef= null;
  }
}
