import 'dart:async';
import 'dart:math';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cheetah_driver/BookRide/ride_end_page.dart';
import 'package:cheetah_driver/DataHandler/appData.dart';
import 'package:cheetah_driver/configMaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:cheetah_driver/Assets/Strings.dart';
import 'package:cheetah_driver/Assistants/assistantMethods.dart';
import 'package:cheetah_driver/Models/rideDetails.dart';
import 'package:cheetah_driver/utils/custom_button.dart';
import 'package:provider/provider.dart';

import '../Assets/assets.dart';
import '../Theme/style.dart';
import '../main.dart';

class BeginRide extends StatefulWidget {
  RideDetails rideDetails;
  String conditionAmount;
  BeginRide({
    this.rideDetails,
    this.conditionAmount,
  });

  @override
  _BeginRideState createState() => _BeginRideState();
}

class _BeginRideState extends State<BeginRide> {
  bool isOpened = true;
  bool beginRide = false;
  int counter = 0;
  String rideState = "accepted";

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
  String _rideStatus;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 2), () {
    //   showDialog(context: context, builder: (context) => RateRideDialog());
    // });
    //  rideDetails = ModalRoute.of(context).settings.arguments as RideDetails;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    _rideStatus = Provider.of<AppData>(context, listen: false).rideStatus;
    rideDetails = Provider.of<AppData>(context, listen: false).rideDetails;
    return Stack(
      children: [
        //TODO add google maps here
        Scaffold(
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
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            !beginRide ? Strings.BEGIN_RIDE : Strings.YOUR_TRIP,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(letterSpacing: 0.7, fontSize: 16),
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
                                    fontSize: 16),
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
                    )),
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
                                : BorderRadius.vertical(
                                    top: Radius.circular(16)),
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
                                    widget.rideDetails.rider_name != null
                                        ? widget.rideDetails.rider_name
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                      widget.rideDetails.pickup_address != null
                                          ? widget.rideDetails.pickup_address
                                          : "",
                                      style: theme.textTheme.bodyText1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              // GestureDetector(
                              //   onTap: () {},
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal: 6, vertical: 2),
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(30),
                              //       color: AppTheme.ratingsColor,
                              //     ),
                              //     child: Row(
                              //       children: [
                              //         Text('4.2'),
                              //         SizedBox(width: 4),
                              //         Icon(
                              //           Icons.star,
                              //           color: AppTheme.starColor,
                              //           size: 14,
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Details(
                      height: isOpened ? 270 : 0,
                      rideDetails: widget.rideDetails,
                      conditionAmount: widget.conditionAmount,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: 72,
                      color:
                          isOpened ? Colors.transparent : theme.backgroundColor,
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
                //         SizedBox(width: 8),
                //         buildFlatButton(Icons.close, Strings.CANCEL, () {
                //           Navigator.pop(context);
                //           Navigator.pop(context);
                //         }),
                //         SizedBox(width: 8),
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
                      print(
                          "_rideStatus= STATUS: ${_rideStatus} = ${Provider.of<AppData>(context, listen: false).rideStatus}");
                      String rideRequestId = rideDetails.ride_request_id;
                      var lRideStatus =
                          Provider.of<AppData>(context, listen: false)
                              .rideStatus;

                      if (lRideStatus == 'accepted') {
                        newRequestsRef
                            .child(rideRequestId)
                            .child("status")
                            .set("arrived");
                        setState(() {
                          rideState = "arrived";
                        });
                        Provider.of<AppData>(context, listen: false)
                            .updateRideStatus("arrived");
                      } else if (lRideStatus == 'arrived') {
                        newRequestsRef
                            .child(rideRequestId)
                            .child("status")
                            .set("onride");
                        setState(() {
                          rideState = "onride";
                        });
                        Provider.of<AppData>(context, listen: false)
                            .updateRideStatus("onride");
                      } else if (lRideStatus == 'onride') {
                        /* newRequestsRef
                              .child(rideRequestId)
                              .child("status")
                              .set("onride");*/
                        Future.delayed(Duration(seconds: 2), () {
                          print('conditionAmount: $conditionAmount');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RideEndPage(
                                rideDetails: widget.rideDetails,
                                conditionAmount: widget.conditionAmount,
                              ),
                            ),
                          );
                        });
                      }

                      /* if (beginRide) {}
                      setState(() {
                        beginRide = true;
                        counter++;
                      });
                      if (counter == 2)*/
                      /*    Future.delayed(Duration(seconds: 2), () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RideEndPage(
                                rideDetails: widget.rideDetails,
                              ),
                            ),
                          );
                        });
                    */
                    },
                    text: rideState == 'accepted'
                        ? Strings.ARRIVE
                        : (rideState == 'arrived'
                            ? Strings.START_THE_TRIP
                            : (rideState == 'onride'
                                ? Strings.END_THE_TRIP
                                : Strings.COLLECT_PAYMENT)),
                  ),
                )
              ],
            ),
            beginOffset: Offset(0, 0.3),
            endOffset: Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
          ),
        ),
      ],
    );
  }

  Widget buildFlatButton(IconData icon, String text, [Function onTap]) {
    return Expanded(
      child: TextButton.icon(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        onPressed: onTap as void Function() ?? () {},
        icon: Icon(
          icon,
          size: 18,
          color: Theme.of(context).primaryColor,
        ),
        label: Text(
          text,
          style: Theme.of(context).textTheme.caption.copyWith(fontSize: 13),
        ),
      ),
    );
  }

  Future<void> setRoute() async {
    await setPolyLine();

    animateCamera();

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      position: widget.rideDetails.pickup,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: widget.rideDetails.dropoff,
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
    if (widget.rideDetails.pickup.latitude >
            widget.rideDetails.dropoff.latitude &&
        widget.rideDetails.pickup.longitude >
            widget.rideDetails.dropoff.longitude) {
      latLngBounds = LatLngBounds(
          southwest: widget.rideDetails.dropoff,
          northeast: widget.rideDetails.pickup);
    } else if (widget.rideDetails.pickup.longitude >
        widget.rideDetails.dropoff.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(widget.rideDetails.pickup.latitude,
              widget.rideDetails.dropoff.longitude),
          northeast: LatLng(widget.rideDetails.dropoff.latitude,
              widget.rideDetails.pickup.longitude));
    } else if (widget.rideDetails.pickup.latitude >
        widget.rideDetails.dropoff.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(widget.rideDetails.dropoff.latitude,
              widget.rideDetails.pickup.longitude),
          northeast: LatLng(widget.rideDetails.pickup.latitude,
              widget.rideDetails.dropoff.longitude));
    } else {
      latLngBounds = LatLngBounds(
          southwest: widget.rideDetails.pickup,
          northeast: widget.rideDetails.dropoff);
    }

    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
  }

  Future<void> setPolyLine() async {
    print(widget.rideDetails.pickup);
    print(widget.rideDetails.pickup);
    print(widget.rideDetails.pickup);
    print(widget.rideDetails.pickup);
    print(widget.rideDetails.pickup);
    print(widget.rideDetails.pickup);
    print(widget.rideDetails.pickup);

    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        widget.rideDetails.pickup, widget.rideDetails.dropoff);

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
  RideDetails rideDetails;
  String conditionAmount;

  final double height;

  Details({this.height, this.rideDetails, this.conditionAmount});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: MediaQuery.of(context).size.height * 0.35,
      // height: widget.height,
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
                    title: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        widget.rideDetails.pickup_address != null
                            ? widget.rideDetails.pickup_address
                            : "",
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.navigation,
                      color: theme.primaryColor,
                    ),
                    title: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        widget.rideDetails.dropoff_address != null
                            ? widget.rideDetails.dropoff_address
                            : "",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  buildRowItem(
                    theme,
                    Strings.PAYMENT_VIA,
                    widget.rideDetails.payment_method == null
                        ? "Cash"
                        : widget.rideDetails.payment_method,
                    Icons.account_balance_wallet,
                  ),
                  Spacer(),
                  buildRowItem(
                      theme,
                      Strings.RIDE_FARE,
                      widget.conditionAmount == null
                          ? widget.rideDetails.rider_suggested_amount != null
                              ? '\$ ${widget.rideDetails.rider_suggested_amount}'
                                  .toString()
                              : ''
                          : '\$ ${widget.conditionAmount}',
                      Icons.account_balance_wallet),
                  Spacer(),
                  buildRowItem(
                      theme, Strings.RIDE_TYPE, "Go Private", Icons.drive_eta),
                ],
              ),
            ),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
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

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
