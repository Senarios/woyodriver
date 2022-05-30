import 'package:cheetah_driver/Assets/Strings.dart';
import 'package:cheetah_driver/Assistants/assistantMethods.dart';
import 'package:cheetah_driver/DataHandler/appData.dart';
import 'package:cheetah_driver/main.dart';
import 'package:cheetah_driver/utils/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:cheetah_driver/Models/scheduleTrip.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ScheduleItems extends StatefulWidget {
  final ScheduleTrip scheduleTrip;
  const ScheduleItems({
    Key key,
    this.scheduleTrip,
  }) : super(key: key);

  @override
  _ScheduleItemsState createState() => _ScheduleItemsState();
}

class _ScheduleItemsState extends State<ScheduleItems> {
  @override
  Widget build(BuildContext context) {
    bool _timeChecking(String tripTime) {
      var inputedStartTime = DateTime.parse(tripTime);
      var mili = inputedStartTime.millisecondsSinceEpoch / 1000;
      var startTime = mili.toInt();

      var inputedENDTime =
          DateTime.parse(DateTime.now().add(Duration(minutes: 25)).toString());
      var miliEND = inputedENDTime.millisecondsSinceEpoch / 1000;
      var endTime = miliEND.toInt();

      var finaltime = startTime - endTime;

      print('START TIME: $inputedStartTime');
      print('START TIME: $startTime');
      print('END TIME: $inputedENDTime');
      print('END TIME: $endTime');
      print('FINAL TIME: $finaltime');

      if (finaltime > -1560 && finaltime < 0) {
        print('TIME Accepted');

        return true;
      } else {
        print('TIME not Accepted');
        return false;
      }
    }

    var tripId = Provider.of<AppData>(context, listen: false).scheduleTripKeys;
    var theme = Theme.of(context);

    return Column(
      children: [
        Container(
          height: 120,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: theme.backgroundColor,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time to PickUp: ',
                    style: theme.textTheme.caption,
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.scheduleTrip.time != null
                        ? AssistantMethods.formatTripDate(
                            widget.scheduleTrip.time)
                        : "",
                    style: theme.textTheme.bodyText2,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Strings.PAID_VIA + widget.scheduleTrip.paymentMethod !=
                                null
                            ? widget.scheduleTrip.paymentMethod
                            : "",
                        textAlign: TextAlign.right,
                        style: theme.textTheme.caption,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        ': \$${widget.scheduleTrip.fares == null ? "" : widget.scheduleTrip.fares}',
                        style: theme.textTheme.bodyText2
                            .copyWith(color: theme.primaryColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Strings.NUMBER_OF_PASSENGERS,
                        textAlign: TextAlign.right,
                        style: theme.textTheme.caption,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        ': ${widget.scheduleTrip.noOfPassengers == null ? "" : widget.scheduleTrip.noOfPassengers}',
                        style: theme.textTheme.bodyText2
                            .copyWith(color: theme.primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              CustomButton(
                text: 'Accept the Ride',
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  if (widget.scheduleTrip.status == 'SCHEDULE_TRIP') {
                    // print('SCHEDULE_TRIP');
                    // print("SCHEDULE_TRIP: ${tripId.toString()}");
                    // print("SCHEDULE_TRIP: ${widget.scheduleTrip.tripID}");
                    bool timeChecking = _timeChecking(widget.scheduleTrip.time);
                    if (timeChecking) {
                      newRequestsRef
                          .child(widget.scheduleTrip.tripID)
                          .child("status")
                          .set("");
                      AssistantMethods.setScheduleTripInfo(
                          widget.scheduleTrip.tripID, context);
                      // print('Accept the ride');
                      // print(
                      //     'Accept the ride R ID${widget.scheduleTrip.tripID}');
                      // print('Accept the ride D ID ${driversInformation.id}');
                      // print('Accept the ride D N${driversInformation.name}');
                      // print('Accept the ride D P${driversInformation.phone}');
                      // print(
                      //     'Accept the ride ${driversInformation.car_color} - ${driversInformation.car_model}');

                      // newRequestsRef
                      //     .child(widget.scheduleTrip.tripID)
                      //     .child("selected_driver_id")
                      //     .set(driversInformation.id);
                      // newRequestsRef
                      //     .child(widget.scheduleTrip.tripID)
                      //     .child("suggested_drivers")
                      //     .child(driversInformation.id)
                      //     .child("driver_name")
                      //     .set(driversInformation.name);

                      // newRequestsRef
                      //     .child(widget.scheduleTrip.tripID)
                      //     .child("suggested_drivers")
                      //     .child(driversInformation.id)
                      //     .child("driver_phone")
                      //     .set(driversInformation.phone);
                      // newRequestsRef
                      //     .child(widget.scheduleTrip.tripID)
                      //     .child("suggested_drivers")
                      //     .child(driversInformation.id)
                      //     .child("driver_id")
                      //     .set(driversInformation.id);
                      // newRequestsRef
                      //     .child(widget.scheduleTrip.tripID)
                      //     .child("suggested_drivers")
                      //     .child(driversInformation.id)
                      //     .child("car_details")
                      //     .set(
                      //         '${driversInformation.car_color} - ${driversInformation.car_model}');
                    } else if (!timeChecking) {
                      print('Don\'t accept the ride');
                      Fluttertoast.showToast(
                        msg: 'Can\'t accept ride until 25 Minutes left',
                      );
                    }
                  }
                },
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     Text(
              //       '\$${widget.scheduleTrip.fares == null ? "" : widget.scheduleTrip.fares}',
              //       style: theme.textTheme.bodyText2
              //           .copyWith(color: theme.primaryColor),
              //     ),
              //     SizedBox(
              //       height: 8,
              //     ),
              //     Text(
              //       Strings.PAID_VIA + widget.scheduleTrip.paymentMethod !=
              //               null
              //           ? widget.scheduleTrip.paymentMethod
              //           : "",
              //       textAlign: TextAlign.right,
              //       style: theme.textTheme.caption,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.location_on,
            color: theme.primaryColor,
            size: 20,
          ),
          title: Text(
            widget.scheduleTrip.pickup != null
                ? widget.scheduleTrip.pickup
                : "",
          ),
          dense: true,
          tileColor: theme.cardColor,
        ),
        ListTile(
          leading: Icon(
            Icons.navigation,
            color: theme.primaryColor,
            size: 20,
          ),
          title: Text(
            widget.scheduleTrip.dropOff != null
                ? widget.scheduleTrip.dropOff
                : "",
          ),
          dense: true,
          tileColor: theme.cardColor,
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
