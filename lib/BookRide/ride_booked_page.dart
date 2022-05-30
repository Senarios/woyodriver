import 'dart:async';
import 'dart:math';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cheetah_driver/AllScreens/registerUserScreen.dart';
import 'package:cheetah_driver/Assets/Strings.dart';
import 'package:cheetah_driver/Assistants/assistantMethods.dart';
import 'package:cheetah_driver/BookRide/begin_ride.dart';
import 'package:cheetah_driver/DataHandler/appData.dart';
import 'package:cheetah_driver/Models/rideDetails.dart';
import 'package:cheetah_driver/tabsPages/homeTabPage.dart';
import 'package:cheetah_driver/utils/custom_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../Assets/assets.dart';
import '../Theme/style.dart';
import 'package:chips_choice/chips_choice.dart';

import '../configMaps.dart';
import '../main.dart';

class RideBookedPage extends StatefulWidget {
  static const String idScreen = "rideBookedScreen";

  @override
  _RideBookedPageState createState() => _RideBookedPageState();
}

class _RideBookedPageState extends State<RideBookedPage> {
  bool isOpened = true;
  bool rideAccepted = false;
  double mapPaddingFromBottom = 265;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Set<Marker> markersSet = Set<Marker>();
  Set<Polyline> polyLineSet = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  RideDetails rideDetails;

  bool isRejected = false;

  TextEditingController _autreMontantController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _autreMontantController.clear();

    timeoutchecker();
  }

  void timeoutchecker() {
    print('TIMEOUT START');
    var driveStatus = 'nothing';
    Future.delayed(Duration(seconds: 85)).then((value) async {
      print('TIMEOUT IN');

      await driversRef
          .child(currentfirebaseUser.uid)
          .child('newRide')
          .once()
          .then((value) {
        driveStatus = value.value;
      });
      if (driveStatus == 'timeout') {
        print('DRIVER STATUS : $driveStatus');
        Navigator.pop(context);
        displayToastMessage("Ride timeout.", context);
        // makeDriverOnlineNow();
        Provider.of<AppData>(context, listen: false).updateRideStatus('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    rideDetails = ModalRoute.of(context).settings.arguments as RideDetails;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FadedSlideAnimation(
        Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: mapPaddingFromBottom),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              markers: markersSet,
              polylines: polyLineSet,
              onMapCreated: (GoogleMapController controller) async {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;
                newGoogleMapController.setMapStyle(
                    '[ { "elementType": "geometry", "stylers": [ { "color": "#212121" } ] }, { "elementType": "labels.icon", "stylers": [ { "visibility": "off" } ] }, { "elementType": "labels.text.fill", "stylers": [ { "color": "#757575" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "color": "#212121" } ] }, { "featureType": "administrative", "elementType": "geometry", "stylers": [ { "color": "#757575" } ] }, { "featureType": "administrative.country", "elementType": "labels.text.fill", "stylers": [ { "color": "#9e9e9e" } ] }, { "featureType": "administrative.land_parcel", "stylers": [ { "visibility": "off" } ] }, { "featureType": "administrative.locality", "elementType": "labels.text.fill", "stylers": [ { "color": "#bdbdbd" } ] }, { "featureType": "poi", "elementType": "labels.text.fill", "stylers": [ { "color": "#757575" } ] }, { "featureType": "poi.park", "elementType": "geometry", "stylers": [ { "color": "#181818" } ] }, { "featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [ { "color": "#616161" } ] }, { "featureType": "poi.park", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1b1b1b" } ] }, { "featureType": "road", "elementType": "geometry.fill", "stylers": [ { "color": "#2c2c2c" } ] }, { "featureType": "road", "elementType": "labels.text.fill", "stylers": [ { "color": "#8a8a8a" } ] }, { "featureType": "road.arterial", "elementType": "geometry", "stylers": [ { "color": "#373737" } ] }, { "featureType": "road.highway", "elementType": "geometry", "stylers": [ { "color": "#3c3c3c" } ] }, { "featureType": "road.highway.controlled_access", "elementType": "geometry", "stylers": [ { "color": "#4e4e4e" } ] }, { "featureType": "road.local", "elementType": "labels.text.fill", "stylers": [ { "color": "#616161" } ] }, { "featureType": "transit", "elementType": "labels.text.fill", "stylers": [ { "color": "#757575" } ] }, { "featureType": "water", "elementType": "geometry", "stylers": [ { "color": "#000000" } ] }, { "featureType": "water", "elementType": "labels.text.fill", "stylers": [ { "color": "#3d3d3d" } ] } ]');

                await setRoute();
                // getRideLiveLocationUpdates();
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 12,
                ),
                SafeArea(
                  child: rideAccepted
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Text(
                                Strings.GO_TO_PICKUP,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      letterSpacing: 0.7,
                                      fontSize: 16,
                                    ),
                              ),
                              Spacer(),
                              Text(
                                Strings.NAVIGATE.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Theme.of(context).primaryColor,
                                      letterSpacing: 0.7,
                                      fontSize: 16,
                                    ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.navigation_rounded,
                                color: Theme.of(context).primaryColor,
                              )
                            ],
                          ),
                        )
                      : RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: Strings.RIDE_REQUEST_RECEIVED + '\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).primaryColor,
                                        letterSpacing: 0.5)),
                            // TextSpan(
                            //     text: '0:30 sec left',
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .subtitle1!
                            //         .copyWith(
                            //             fontWeight: FontWeight.w500,
                            //             letterSpacing: 0.5)),
                          ])),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: GestureDetector(
                    onVerticalDragDown: (details) {
                      setState(() {
                        isOpened = !isOpened;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: isOpened ? 110 : 150,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        borderRadius: isOpened
                            ? BorderRadius.circular(16)
                            : BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              Assets.Driver,
                              height: 72,
                              width: 72,
                            ),
                          ),
                          SizedBox(width: 12),
                          Column(
                            // mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rideDetails.rider_name != null
                                    ? rideDetails.rider_name
                                    : "",
                                style: theme.textTheme.headline6,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                Strings.PICKUP_DESTINATION,
                                style: theme.textTheme.caption,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  rideDetails.pickup_address != null
                                      ? rideDetails.pickup_address
                                      : "",
                                  style: theme.textTheme.bodyText1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: AppTheme.ratingsColor,
                              ),
                              child: Row(
                                children: [
                                  // Text('4.2'),
                                  // SizedBox(width: 4),
                                  // Icon(
                                  //   Icons.star,
                                  //   color: AppTheme.starColor,
                                  //   size: 14,
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Details(
                    isOpened ? 350 : 0, rideDetails, _autreMontantController),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 52,
                  color: isOpened ? Colors.transparent : theme.backgroundColor,
                )
              ],
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Container(
            //     // color: Theme.of(context).backgroundColor,
            //     padding:
            //         EdgeInsets.only(left: 8, top: 12, right: 8, bottom: 70),
            //     child: Row(
            //       children: [
            //         buildFlatButton(Icons.call, Strings.CALL_NOW),
            //         Spacer(),
            //         buildFlatButton(Icons.close, Strings.CANCEL),
            //         Spacer(),
            //         buildFlatButton(
            //             isOpened
            //                 ? Icons.keyboard_arrow_down
            //                 : Icons.keyboard_arrow_up,
            //             isOpened ? Strings.LESS : Strings.MORE, () {
            //           setState(() {
            //             isOpened = !isOpened;
            //           });
            //         }),
            //       ],
            //     ),
            //   ),
            // ),
            PositionedDirectional(
              bottom: 0,
              start: 0,
              end: 0,
              child: CustomButton(
                onTap: () {
                  print("RideDetails:${rideDetails.status}=");
                  print("selectedRideOption=${selectedRideOption}=");
                  Provider.of<AppData>(context, listen: false)
                      .updateRideDetails(rideDetails);
                  var rideStatus = rideDetails.status;
                  if (rideDetails.status == '') {
                    if (selectedRideOption == "Ok") {
                      String rideRequestId = rideDetails.ride_request_id;
                      rideStatus = "accepted";
                      rideRequestRef.set("accepted");
                      newRequestsRef
                          .child(rideRequestId)
                          .child("status")
                          .set("accepted");
                      newRequestsRef
                          .child(rideRequestId)
                          .child("selected_driver_id")
                          .set(driversInformation.id);

                      newRequestsRef
                          .child(rideRequestId)
                          .child("suggested_drivers")
                          .child(driversInformation.id)
                          .child("driver_name")
                          .set(driversInformation.name);
                      newRequestsRef
                          .child(rideRequestId)
                          .child("suggested_drivers")
                          .child(driversInformation.id)
                          .child("driver_phone")
                          .set(driversInformation.phone);
                      newRequestsRef
                          .child(rideRequestId)
                          .child("suggested_drivers")
                          .child(driversInformation.id)
                          .child("driver_id")
                          .set(driversInformation.id);
                      newRequestsRef
                          .child(rideRequestId)
                          .child("suggested_drivers")
                          .child(driversInformation.id)
                          .child("car_details")
                          .set(
                              '${driversInformation.car_color} - ${driversInformation.car_model}');

                      Map locMap = {
                        "latitude": currentPosition.latitude.toString(),
                        "longitude": currentPosition.longitude.toString(),
                      };
                      newRequestsRef
                          .child(rideRequestId)
                          .child("driver_location")
                          .set(locMap);

                      driversRef
                          .child(currentfirebaseUser.uid)
                          .child("history")
                          .child(rideRequestId)
                          .set(true);
                    } else if (selectedRideOption == "Refuser") {
                      rideRequestRef.set("timeout");
                      Navigator.pop(context);
                    } else if (selectedRideOption == "Autre montant") {
                      print("conditionAmount=${conditionAmount}=");
                      String rideRequestId = rideDetails.ride_request_id;
                      // rideStatus = "accepted_with_condition";
                      rideRequestRef.set("accepted_with_condition");
                      newRequestsRef
                          .child(rideRequestId)
                          .child("status")
                          .set("accepted_with_condition");
                      newRequestsRef
                          .child(rideRequestId)
                          .child("suggested_drivers")
                          .child(driversInformation.id)
                          .child("status")
                          .set("accepted_with_condition");
                      newRequestsRef
                          .child(rideRequestId)
                          .child("suggested_drivers")
                          .child(driversInformation.id)
                          .child("amount_suggestion")
                          .update({'from_driver': conditionAmount});
                      // newRequestsRef.child(rideRequestId).child("status").set("accepted_with_condition");
                      newRequestsRef
                          .child(rideRequestId)
                          .child("suggested_drivers")
                          .child(driversInformation.id)
                          .child("driver_name")
                          .set(driversInformation.name);
                      newRequestsRef
                          .child(rideRequestId)
                          .child("suggested_drivers")
                          .child(driversInformation.id)
                          .child("driver_phone")
                          .set(driversInformation.phone);
                      newRequestsRef
                          .child(rideRequestId)
                          .child("suggested_drivers")
                          .child(driversInformation.id)
                          .child("driver_id")
                          .set(driversInformation.id);
                      newRequestsRef
                          .child(rideRequestId)
                          .child("suggested_drivers")
                          .child(driversInformation.id)
                          .child("car_details")
                          .set(
                              '${driversInformation.car_color} - ${driversInformation.car_model}');

                      displayToastMessage("request sent", context);
                      listenForResponse(
                        rideRequestId: rideRequestId,
                        context: context,
                        conditionAmount: conditionAmount,
                      );

                      _autreMontantController.clear();
                    }
                  } else {
                    print("rideDetails.status:${rideDetails.status}");
                  }

                  Provider.of<AppData>(context, listen: false)
                      .updateRideStatus(rideStatus);

                  if (rideStatus == "accepted") {
                    print('AFTER ACCEPTED');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BeginRide(
                          rideDetails: rideDetails,
                        ),
                      ),
                    );
                  }

                  setState(() {
                    rideAccepted = true;
                  });
                },
                text: rideAccepted ? Strings.ARRIVED : Strings.ACCEPT_RIDE,
              ),
            )
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

  void listenForResponse(
      {String rideRequestId, context, String conditionAmount}) {
    newRequestsRef.child(rideRequestId).onValue.listen((event) async {
      isRejected == false
          ? checkRejectedStatus(event, context)
          : print('$isRejected');
      if (event.snapshot.value["status"] != null) {
        print('HEllO: ${event.snapshot.value["status"]} && $conditionAmount');
        if (event.snapshot.value["status"] == "accepted_with_condition") {
          if (event.snapshot.value["selected_driver_id"] ==
              driversInformation.id) {
            Provider.of<AppData>(context, listen: false)
                .updateRideStatus('accepted');
            rideRequestRef.set("accepted");
            AssistantMethods.disableHomeTabLiveLocationUpdates();
            Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BeginRide(
                  rideDetails: rideDetails,
                  conditionAmount: conditionAmount,
                ),
              ),
            );
            newRequestsRef.onDisconnect();
          }
        }
      }
    });
  }

  void checkRejectedStatus(Event event, context) {
    Map drivers = event.snapshot.value["suggested_drivers"];
    drivers.forEach((key, value) {
      print('VALUE: ${value["status"]} && KEY: $key');

      if (value["status"] == "rejected" && key == driversInformation.id) {
        setState(() {
          isRejected = true;
        });
        print('REJECTED');
        rideRequestRef.set("timeout");
        Navigator.pop(context);
        _autreMontantController.clear();
      }
      if (value["staus"] == 'accepted') {
        setState(() {
          isRejected = true;
        });
      }
    });
  }

  Widget buildFlatButton(IconData icon, String text, [Function onTap]) {
    return Expanded(
      flex: 10,
      child: TextButton.icon(
        onPressed: onTap as void Function() ?? () {},
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        icon: Icon(
          icon,
          size: 18,
          color: Theme.of(context).primaryColor,
        ),
        label: Text(
          text,
          style: Theme.of(context).textTheme.caption.copyWith(fontSize: 13),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Future<void> setRoute() async {
    await setPolyLine();

    animateCamera();

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      position: rideDetails.pickup,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: rideDetails.dropoff,
      markerId: MarkerId("dropOffId"),
    );

    Polyline polyline = Polyline(
      color: Colors.pink,
      polylineId: PolylineId("PolylineID"),
      jointType: JointType.round,
      points: polylineCoordinates,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    initMap(polyline, pickUpLocMarker, dropOffLocMarker);
  }

  void initMap(
      Polyline polyline, Marker pickUpLocMarker, Marker dropOffLocMarker) {
    if (this.mounted) {
      setState(() {
        polyLineSet.add(polyline);

        markersSet.add(pickUpLocMarker);
        markersSet.add(dropOffLocMarker);
      });
    }
  }

  void animateCamera() {
    LatLngBounds latLngBounds;
    if (rideDetails.pickup.latitude > rideDetails.dropoff.latitude &&
        rideDetails.pickup.longitude > rideDetails.dropoff.longitude) {
      latLngBounds = LatLngBounds(
          southwest: rideDetails.dropoff, northeast: rideDetails.pickup);
    } else if (rideDetails.pickup.longitude > rideDetails.dropoff.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(
              rideDetails.pickup.latitude, rideDetails.dropoff.longitude),
          northeast: LatLng(
              rideDetails.dropoff.latitude, rideDetails.pickup.longitude));
    } else if (rideDetails.pickup.latitude > rideDetails.dropoff.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(
              rideDetails.dropoff.latitude, rideDetails.pickup.longitude),
          northeast: LatLng(
              rideDetails.pickup.latitude, rideDetails.dropoff.longitude));
    } else {
      latLngBounds = LatLngBounds(
          southwest: rideDetails.pickup, northeast: rideDetails.dropoff);
    }

    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
  }

  Future<void> setPolyLine() async {
    print(rideDetails.pickup);

    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        rideDetails.pickup, rideDetails.dropoff);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);

    polylineCoordinates.clear();

    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();
  }
}

class Details extends StatefulWidget {
  final double height;
  final RideDetails rideDetails;
  TextEditingController _autreMontantController;

  Details(this.height, this.rideDetails, this._autreMontantController);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int tripAcceptVal = -1;

  List<String> options = [
    'Ok',
    'Refuser',
    'Autre montant',
  ];
  String status;
  int tag = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      int tag = 0;
      selectedRideOption = 'Ok';
    });
    widget._autreMontantController.clear();
    widget._autreMontantController.text = '';
    print('ALL SET');
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: MediaQuery.of(context).size.height * 0.6,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      Strings.RIDE_INFO,
                      style: theme.textTheme.bodyText1
                          .copyWith(color: theme.hintColor, fontSize: 18),
                    ),
                    trailing: Text(
                        calculateDistance(
                                    widget.rideDetails.pickup.latitude,
                                    widget.rideDetails.pickup.longitude,
                                    widget.rideDetails.dropoff.latitude,
                                    widget.rideDetails.dropoff.longitude)
                                .toStringAsFixed(1) +
                            " km",
                        style: theme.textTheme.headline6),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: theme.primaryColor,
                    ),
                    title: Text(widget.rideDetails.pickup_address != null
                        ? widget.rideDetails.pickup_address
                        : ""),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.navigation,
                      color: theme.primaryColor,
                    ),
                    title: Text(widget.rideDetails.dropoff_address != null
                        ? widget.rideDetails.dropoff_address
                        : ""),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  buildRowItem(
                    theme,
                    Strings.PAYMENT_VIA,
                    widget.rideDetails.payment_method != null
                        ? widget.rideDetails.payment_method.toString()
                        : "",
                    Icons.account_balance_wallet,
                  ),
                  Spacer(),
                  buildRowItem(
                    theme,
                    Strings.RIDE_FARE,
                    widget.rideDetails.rider_suggested_amount != null
                        ? '\$${widget.rideDetails.rider_suggested_amount.toString()}'
                        : "",
                    Icons.account_balance_wallet,
                  ),
                  Spacer(),
                  buildRowItem(
                    theme,
                    Strings.NUMBER_OF_PASSENGERS,
                    widget.rideDetails.noOfPassengers != null
                        ? widget.rideDetails.noOfPassengers
                        : '',
                    Icons.drive_eta,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  // RadioListTile(
                  //   activeColor: theme.primaryColor,
                  //   value: 0,
                  //   groupValue: tripAcceptVal,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       tripAcceptVal = value;
                  //     });
                  //   },
                  //   title: Text("Ok"),
                  // ),
                  // // Spacer(),
                  // RadioListTile(
                  //   activeColor: theme.primaryColor,
                  //   value: 1,
                  //   groupValue: tripAcceptVal,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       tripAcceptVal = value;
                  //     });
                  //   },
                  //   title: Text("Refuser"),
                  // ),
                  // //   Spacer(),
                  // RadioListTile(
                  //   activeColor: theme.primaryColor,
                  //   value: 2,
                  //   groupValue: tripAcceptVal,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       tripAcceptVal = value;
                  //     });
                  //   },
                  //   title: Text("Autre montant"),
                  // ),

                  Container(
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                    child: ChipsChoice<int>.single(
                      choiceStyle: C2ChoiceStyle(
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                      value: tag,
                      onChanged: (val) {
                        if (val == 0) {
                          setState(() {
                            status = null;
                          });
                        }
                        setState(() {
                          tag = val;
                          if (tag > 0) {
                            status = options[val];
                            print('opention $status');
                          }
                          // if (options[val] == 'Ok') {
                          //   conditionAmount = '';
                          //   _autreMontantController.clear();
                          //   print(
                          //       "VAL ${options[val]} && conditionAmount: $conditionAmount");
                          // }
                          selectedRideOption = options[val];
                          print('Opention ${options[val]}');
                        });
                      },
                      choiceItems: C2Choice.listFrom<int, String>(
                        source: options,
                        value: (i, v) => i,
                        label: (i, v) => v,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: widget._autreMontantController,
                onChanged: conditionalAmount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  errorText:
                      validatePassword(widget._autreMontantController.text),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                  ),
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Autre montant',
                  hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                  prefixIcon: Icon(
                    Icons.monetization_on_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  border: OutlineInputBorder(),
                  focusColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
          ],
        ),
      ),
    );
  }

  validatePassword(String value) {
    if (!(value.length > 0) & value.isNotEmpty) {
      return "Autre montant couldn\'t be empty";
    }
  }

  void conditionalAmount(String pConditionAmount) async {
    if (pConditionAmount.length >= 1 && pConditionAmount.isNotEmpty) {
      conditionAmount = widget._autreMontantController.text;
    } else {
      return null;
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Column buildRowItem(
      ThemeData theme, String title, String subtitle, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyText1.copyWith(color: theme.hintColor),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, color: theme.primaryColor),
            SizedBox(width: 12),
            Text(
              subtitle,
              style: theme.textTheme.bodyText1.copyWith(fontSize: 16),
            ),
          ],
        )
      ],
    );
  }
}
