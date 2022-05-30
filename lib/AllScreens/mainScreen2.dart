import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cheetah_driver/AllWidgets/ripple_animation.dart';
import 'package:cheetah_driver/AllWidgets/toast.dart';
import 'package:cheetah_driver/Assistants/assistantMethods.dart';
import 'package:cheetah_driver/DataHandler/appData.dart';
import 'package:cheetah_driver/DrawerPages/app_drawer.dart';
import 'package:cheetah_driver/Models/drivers.dart';
import 'package:cheetah_driver/Models/rideDetails.dart';
import 'package:cheetah_driver/Notifications/pushNotificationService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../configMaps.dart';
import '../main.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

class DriverHomeScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";

  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen>
    with AutomaticKeepAliveClientMixin<DriverHomeScreen> {
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

  Color offlineColor = Colors.red;
  Color onlineColor = Colors.green;
  bool isOnline = false;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  Timer _timer;

  bool isHhistoryLoaded = false;

  RideDetails rideDetails = RideDetails();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: AppDrawer(),
      body: FadedSlideAnimation(
        SafeArea(
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                initialCameraPosition: _kGooglePlex,
                myLocationEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controllerGoogleMap.complete(controller);
                  newGoogleMapController = controller;
                  newGoogleMapController.setMapStyle(
                      '[ { "elementType": "geometry", "stylers": [ { "color": "#212121" } ] }, { "elementType": "labels.icon", "stylers": [ { "visibility": "off" } ] }, { "elementType": "labels.text.fill", "stylers": [ { "color": "#757575" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "color": "#212121" } ] }, { "featureType": "administrative", "elementType": "geometry", "stylers": [ { "color": "#757575" } ] }, { "featureType": "administrative.country", "elementType": "labels.text.fill", "stylers": [ { "color": "#9e9e9e" } ] }, { "featureType": "administrative.land_parcel", "stylers": [ { "visibility": "off" } ] }, { "featureType": "administrative.locality", "elementType": "labels.text.fill", "stylers": [ { "color": "#bdbdbd" } ] }, { "featureType": "poi", "elementType": "labels.text.fill", "stylers": [ { "color": "#757575" } ] }, { "featureType": "poi.park", "elementType": "geometry", "stylers": [ { "color": "#181818" } ] }, { "featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [ { "color": "#616161" } ] }, { "featureType": "poi.park", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1b1b1b" } ] }, { "featureType": "road", "elementType": "geometry.fill", "stylers": [ { "color": "#2c2c2c" } ] }, { "featureType": "road", "elementType": "labels.text.fill", "stylers": [ { "color": "#8a8a8a" } ] }, { "featureType": "road.arterial", "elementType": "geometry", "stylers": [ { "color": "#373737" } ] }, { "featureType": "road.highway", "elementType": "geometry", "stylers": [ { "color": "#3c3c3c" } ] }, { "featureType": "road.highway.controlled_access", "elementType": "geometry", "stylers": [ { "color": "#4e4e4e" } ] }, { "featureType": "road.local", "elementType": "labels.text.fill", "stylers": [ { "color": "#616161" } ] }, { "featureType": "transit", "elementType": "labels.text.fill", "stylers": [ { "color": "#757575" } ] }, { "featureType": "water", "elementType": "geometry", "stylers": [ { "color": "#000000" } ] }, { "featureType": "water", "elementType": "labels.text.fill", "stylers": [ { "color": "#3d3d3d" } ] } ]');
                  locatePosition();
                },
              ),
              Column(
                children: [
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: FadedScaleAnimation(
                        Image.asset('images/user_icon.png'),
                      ),
                    ),
                    /*Image.asset('assets/delivery_boy.png'),*/
                    title: Text(driversInformation == null
                        ? ''
                        : driversInformation?.name),
                    subtitle: Text(
                      driversInformation == null
                          ? ''
                          : driversInformation?.email,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Spacer(),
                  !isOnline
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              isOnline = !isOnline;
                              changeStatus(context);
                            });
                          },
                          child: RipplesAnimation(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
      bottomSheet: SolidBottomSheet(
        maxHeight: 80,
        draggableBody: true,
        canUserSwipe: true,
        toggleVisibilityOnTap: true,
        elevation: 5,
        headerBar: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _drawerKey.currentState.openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(
                      Icons.menu,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 16,
                ),
                CircleAvatar(
                  radius: 5,
                  backgroundColor: isOnline ? onlineColor : offlineColor,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  isOnline
                      ? 'You\'re Online'.toUpperCase()
                      : 'You\'re Offline'.toUpperCase(),
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w500, letterSpacing: 0.5),
                ),
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.keyboard_arrow_up,
                  color: Theme.of(context).primaryColor,
                ),
                Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
        body: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          elevation: 5,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                SizedBox(
                  width: 44,
                ),
                CircleAvatar(
                  radius: 5,
                  backgroundColor: !isOnline ? onlineColor : offlineColor,
                ),
                SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isOnline = !isOnline;
                      changeStatus(context);
                    });
                  },
                  child: Text(
                    !isOnline
                        ? 'You\'re Online'.toUpperCase()
                        : 'You\'re Offline'.toUpperCase(),
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                  ),
                ),
                SizedBox(
                  width: 45,
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeStatus(BuildContext context) {
    if (isOnline) {
      makeDriverOnlineNow();
      getLocationLiveUpdates(true);
      setState(() {
        driverStatusText = "En ligne";
        isDriverAvailable = true;
      });
      displayToastMessage("Vous êtes en ligne maintenant", context);
    } else {
      makeDriverOfflineNow();
      setState(() {
        driverStatusText = "Hors ligne - Se connecter ";
        isDriverAvailable = false;
      });
      displayToastMessage("Vous êtes hors ligne maintenant.", context);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeCurrentDriverInfo();
    _timer =
        Timer.periodic(Duration(seconds: 3), (Timer t) => checkDriverInfo());

    if (!isHhistoryLoaded) {
      AssistantMethods.retrieveHistoryInfo(context);
      setState(() {
        isHhistoryLoaded = true;
      });
    }
  }

//TODO:
  void checkDriverInfo() async {
    var lRideStatus = Provider.of<AppData>(context, listen: false).rideStatus;
    print('CANCELLED');

    var driveStatus;

    await driversRef
        .child(currentfirebaseUser.uid)
        .child('newRide')
        .once()
        .then((value) {
      setState(() {
        driveStatus = value.value;
      });
    });
    if (driveStatus == 'cancelled') {
      print('DRIVER STATUS : ${driveStatus}');
      Navigator.pop(context);
      displayToastMessage("Ride has been Cancelled.", context);
      makeDriverOnlineNow();
      Provider.of<AppData>(context, listen: false).updateRideStatus('');
    }

    if (lRideStatus == 'accepted') {
      var lRideRequestId = Provider.of<AppData>(context, listen: false)
          .rideDetails
          .ride_request_id;

      newRequestsRef.child(lRideRequestId).once().then((DataSnapshot snapShot) {
        if (snapShot.value.isNotEmpty) {
          Provider.of<AppData>(context, listen: false)
              .updateRideStatus(snapShot.value["status"]);
        }
      });
    } else if (lRideStatus == "CANCELLED_BY_PASSENGER") {
      Navigator.pop(context);
      displayToastMessage("Ride has been Cancelled.", context);
      makeDriverOnlineNow();
      Provider.of<AppData>(context, listen: false).updateRideStatus('');
    }

    // else if (lRideStatus == '') {
    //   initializeCurrentDriverInfo();
    // }
  }

  void initializeCurrentDriverInfo() async {
    currentfirebaseUser = await FirebaseAuth.instance.currentUser;

    driversRef
        .child(currentfirebaseUser.uid)
        .once()
        .then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null) {
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

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    if (newGoogleMapController != null) {
      CameraPosition cameraPosition =
          new CameraPosition(target: latLatPosition, zoom: 14);
      newGoogleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    // @todo geofire
    // await Geofire.initialize("availableDrivers");
    // Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);

    GeoFirePoint point = geoFlutterFire.point(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude);
    FirebaseFirestore.instance
        .collection('availableDrivers')
        .doc(currentfirebaseUser.uid)
        .set({'position': point.data});

    rideRequestRef.set("searching");
    rideRequestRef.onValue.listen((event) {
      //print('searching ride');
      //inspect(event);
    });
  }

  void makeDriverOfflineNow() {
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

  void getLocationLiveUpdates(bool zoom) {
    final positionStream = Geolocator.getPositionStream();
    driverTabPageStreamSubscription = positionStream.handleError((error) {
      driverTabPageStreamSubscription.cancel();
      driverTabPageStreamSubscription = null;
    }).listen((Position position) {
      // print('listen on homeTabPageStreamSubscription homepage3 $position');
      if (currentPosition.latitude == position.latitude &&
          currentPosition.longitude == position.longitude) {
        return;
      }
      currentPosition = position;

      // var isAvailable = Provider.of<AppData>(context, listen: false).isDriverAvailable;

      if (isDriverAvailable == true) {
        //@todo geofire
        //Geofire.setLocation(currentfirebaseUser.uid, position.latitude, position.longitude);
        GeoFirePoint point = geoFlutterFire.point(
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude);
        FirebaseFirestore.instance
            .collection('availableDrivers')
            .doc(currentfirebaseUser.uid)
            .set({'position': point.data});
      }

      if (newGoogleMapController != null) {
        LatLng latLng = LatLng(position.latitude, position.longitude);
        newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
      }
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
