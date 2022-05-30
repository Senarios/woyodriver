import 'dart:math';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cheetah_driver/DataHandler/appData.dart';
import 'package:cheetah_driver/Models/rideDetails.dart';
import 'package:cheetah_driver/configMaps.dart';
import 'package:cheetah_driver/utils/custom_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:cheetah_driver/Assets/Strings.dart';
import 'package:provider/provider.dart';

import '../Assets/assets.dart';
import '../Theme/style.dart';
import '../main.dart';

class RideEndPage extends StatefulWidget {
  final RideDetails rideDetails;
  String conditionAmount;
  RideEndPage({
    this.rideDetails,
    this.conditionAmount,
  });

  @override
  _RideEndPageState createState() => _RideEndPageState();
}

class _RideEndPageState extends State<RideEndPage> {
  RideDetails rideDetails;
  String _rideStatus;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    _rideStatus = Provider.of<AppData>(context, listen: false).rideStatus;
    rideDetails = Provider.of<AppData>(context, listen: false).rideDetails;

    return Padding(
      padding: EdgeInsets.all(20),
      child: Material(
        color: Theme.of(context).backgroundColor,
        child: FadedSlideAnimation(
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  Assets.Driver,
                                  height: 72,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                widget.rideDetails.rider_name != null
                                    ? widget.rideDetails.rider_name
                                    : "",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  GestureDetector(
                                    // onTap: () {
                                    //   Navigator.pushNamed(
                                    //       context, PageRoutes.reviewsPage);
                                    // },
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
                                  // SizedBox(
                                  //   width: 8,
                                  // ),
                                  // Text(
                                  //   '(128)',
                                  //   style: Theme.of(context)
                                  //       .textTheme
                                  //       .bodyText1
                                  //       .copyWith(
                                  //           color: Theme.of(context).hintColor),
                                  // )
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Strings.RIDE_FARE,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                        color: Theme.of(context).hintColor),
                              ),
                              SizedBox(height: 4),
                              Text(
                                widget.conditionAmount == null
                                    ? widget.rideDetails
                                                .rider_suggested_amount !=
                                            null
                                        ? "\$ ${widget.rideDetails.rider_suggested_amount.toString()}"
                                        : ""
                                    : '\$ ${widget.conditionAmount}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                        color: Theme.of(context).primaryColor),
                              ),
                              SizedBox(height: 24),
                              Text(
                                Strings.PAYMENT_VIA,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    widget.rideDetails.payment_method == 'Cash'
                                        ? Icons.account_balance_wallet
                                        : Icons.credit_card_sharp,
                                    color: theme.primaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    widget.rideDetails.payment_method == null
                                        ? 'Cash'
                                        : widget.rideDetails.payment_method,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text(
                        Strings.RIDE_INFO,
                        style: theme.textTheme.headline6
                            .copyWith(color: theme.hintColor),
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
                    SizedBox(
                      height: 20,
                    ),
                    Divider(),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
              PositionedDirectional(
                start: 0,
                end: 0,
                child: CustomButton(
                  onTap: () {
                    String rideRequestId = rideDetails.ride_request_id;

                    if (_rideStatus == 'onride') {
                      newRequestsRef
                          .child(rideRequestId)
                          .child("status")
                          .set("ended");
                      endTheTrip();
                      Provider.of<AppData>(context, listen: false)
                          .updateRideStatus("ended");
                    }
                    Navigator.pop(context);
                  },
                  text: Strings.COLLECT_PAYMENT,
                ),
              ),
            ],
          ),
          beginOffset: Offset(0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ),
      ),
    );
  }

  endTheTrip() async {
    print('END THE TRIP');

    String rideRequestId = widget.rideDetails.ride_request_id;

    if (widget.conditionAmount == null) {
      newRequestsRef
          .child(rideRequestId)
          .child("fares")
          .set(widget.rideDetails.rider_suggested_amount.toString());
      print(widget.rideDetails.rider_suggested_amount);
      saveEarnings(widget.rideDetails.rider_suggested_amount.toString());
    } else if (widget.conditionAmount != null) {
      newRequestsRef
          .child(rideRequestId)
          .child("fares")
          .set(widget.conditionAmount.toString());
      print(widget.conditionAmount);

      saveEarnings(widget.conditionAmount);
    }
  }

  void saveEarnings(String fareAmount) {
    print(fareAmount);
    driversRef
        .child(driversInformation.id)
        .child("earnings")
        .once()
        .then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null) {
        double oldEarnings = double.parse(dataSnapShot.value.toString());
        double totalEarnings = double.parse(fareAmount) + oldEarnings;

        print("oldEarnings $oldEarnings");
        print("totalEarnings $totalEarnings");

        driversRef
            .child(currentfirebaseUser.uid)
            .child("earnings")
            .set(totalEarnings.toStringAsFixed(2));
      } else {
        double totalEarnings = double.parse(fareAmount);

        print("totalEarnings $totalEarnings");

        driversRef
            .child(currentfirebaseUser.uid)
            .child("earnings")
            .set(totalEarnings.toStringAsFixed(2));
      }
    });
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
