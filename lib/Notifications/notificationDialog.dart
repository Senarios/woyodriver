import 'package:cheetah_driver/AllScreens/newRideScreen.dart';
import 'package:cheetah_driver/AllScreens/registerUserScreen.dart';
import 'package:cheetah_driver/AllWidgets/progressDialog.dart';
import 'package:cheetah_driver/Assistants/assistantMethods.dart';
import 'package:cheetah_driver/DataHandler/appData.dart';
import 'package:cheetah_driver/Models/rideDetails.dart';
import 'package:cheetah_driver/Models/ride_request_amount_result.dart';
import 'package:cheetah_driver/pro_kit/ora_pay/utils/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configMaps.dart';
import '../main.dart';

class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    Key key,
    this.label,
    this.padding,
    this.groupValue,
    this.value,
    this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final bool groupValue;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio<bool>(
              groupValue: groupValue,
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class NotificationDialog extends StatefulWidget {
  final RideDetails rideDetails;

  @override
  NotificationDialog({Key key, this.rideDetails}) : super(key: key);

  State createState() => new _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  TextEditingController amountSuggestionController = TextEditingController();
  RideRequestAmountResult _selectedChoice = RideRequestAmountResult.ok;
  bool amountSuggested = false;
  List<RideDetails> rideRequests = [];

  void _handleRadioValueChange(RideRequestAmountResult value) {
    setState(() {
      _selectedChoice = value;

      switch (_selectedChoice) {
        // case 0:
        //   break;
        // case 1:
        //   break;
        // case 2:
        //   break;
        case RideRequestAmountResult.ok:
          // TODO: Handle this case.
          break;
        case RideRequestAmountResult.refuse:
          // TODO: Handle this case.
          break;
        case RideRequestAmountResult.ok_with_condition:
          // TODO: Handle this case.
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Dialog(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    //   backgroundColor: Colors.transparent,
    //   elevation: 1.0,
    //rideRequests = Provider.of<AppData>(context, listen: true).currentRideRequests;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('Nouvelle Demande de lift'),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        margin: EdgeInsets.all(1.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 5.0),
            Image.asset(
              "images/uberx.png",
              width: 75.0,
            ),
            // SizedBox(height: 0.0,),
            // Text("Nouvelle Demande de lift", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,),),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/pickicon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: Container(
                            child: Text(
                          widget.rideDetails.pickup_address,
                          style: TextStyle(fontSize: 16.0),
                        )),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/desticon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                          child: Container(
                              child: Text(
                        widget.rideDetails.dropoff_address,
                        style: TextStyle(fontSize: 16.0),
                      ))),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 150.0,
                          child: Container(
                              child: Text(
                            "Montant suggéré",
                            style: TextStyle(fontSize: 16.0),
                          ))),
                      SizedBox(
                        width: 25.0,
                      ),
                      Expanded(
                          child: Container(
                              child: Text(
                        widget.rideDetails.rider_suggested_amount.toString(),
                        style: TextStyle(fontSize: 14.0),
                      ))),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Radio(
                                  value: RideRequestAmountResult.ok,
                                  groupValue: _selectedChoice,
                                  onChanged: _handleRadioValueChange,
                                ),
                                new Text(
                                  'Ok',
                                  style: new TextStyle(fontSize: 12.0),
                                ),
                                new Radio(
                                  value: RideRequestAmountResult.refuse,
                                  groupValue: _selectedChoice,
                                  onChanged: _handleRadioValueChange,
                                ),
                                new Text(
                                  'Refuser',
                                  style: new TextStyle(fontSize: 12.0),
                                ),
                                new Radio(
                                  value:
                                      RideRequestAmountResult.ok_with_condition,
                                  groupValue: _selectedChoice,
                                  onChanged: _handleRadioValueChange,
                                ),
                                new Text(
                                  'Autre montant',
                                  style: new TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 160.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(1.0),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: amountSuggestionController,
                                    decoration: InputDecoration(
                                      hintText:
                                          "${widget.rideDetails.rider_suggested_amount}",
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(
                                          left: 11.0, top: 8.0, bottom: 8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.0),
            Divider(
              height: 2.0,
              thickness: 4.0,
            ),
            SizedBox(height: 0.0),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  amountSuggested
                      ? Text('Waiting on driver response...',
                          style: TextStyle(fontSize: 14, color: Colors.black))
                      : RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.green)),
                          onPressed: () {
                            print('IM HERE ONP-RESSS START');
                            switch (_selectedChoice) {
                              case RideRequestAmountResult.ok:
                                {
                                  // ok;
                                  assetsAudioPlayer.stop();
                                  checkAvailabilityOfRide(
                                      context,
                                      widget.rideDetails.rider_suggested_amount,
                                      RideRequestAmountResult.ok);
                                }
                                break;

                              case RideRequestAmountResult.refuse:
                                {
                                  //non
                                  assetsAudioPlayer.stop();
                                  Navigator.pop(context);
                                }
                                break;

                              case RideRequestAmountResult.ok_with_condition:
                                {
                                  //other amount;
                                  var amount =
                                      amountSuggestionController.text == null
                                          ? widget.rideDetails
                                              .rider_suggested_amount
                                          : amountSuggestionController.text;
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    amountSuggested = true;
                                  });
                                  print('IM HERE CHECKING AVALIABILITY');
                                  checkAvailabilityOfRide(
                                      context,
                                      double.parse(amount),
                                      RideRequestAmountResult
                                          .ok_with_condition);
                                }
                                break;
                              default:
                                {
                                  assetsAudioPlayer.stop();
                                  checkAvailabilityOfRide(
                                      context,
                                      widget.rideDetails.rider_suggested_amount,
                                      RideRequestAmountResult.ok);
                                }
                                break;
                            }
                          },
                          color: Colors.green,
                          textColor: Colors.white,
                          child: Text("Soumettre".toUpperCase(),
                              style: TextStyle(fontSize: 14)),
                        ),
                ],
              ),
            ),

            SizedBox(height: 0.0),
          ],
        ),
      ),

      // ListView.builder(
      //     itemCount: rideRequests.length,
      //     itemBuilder: (context,index) {
      //       return showRequest(rideRequests[index]);
      //     }),
    );
  }

  Widget showRequest(RideDetails ride) {
    return Container(
      margin: EdgeInsets.all(1.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 5.0),
          Image.asset(
            "images/uberx.png",
            width: 75.0,
          ),
          // SizedBox(height: 0.0,),
          // Text("Nouvelle Demande de lift", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,),),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "images/pickicon.png",
                      height: 16.0,
                      width: 16.0,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: Container(
                          child: Text(
                        ride.pickup_address,
                        style: TextStyle(fontSize: 16.0),
                      )),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "images/desticon.png",
                      height: 16.0,
                      width: 16.0,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                        child: Container(
                            child: Text(
                      ride.dropoff_address,
                      style: TextStyle(fontSize: 16.0),
                    ))),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 150.0,
                        child: Container(
                            child: Text(
                          "Montant suggéré",
                          style: TextStyle(fontSize: 16.0),
                        ))),
                    SizedBox(
                      width: 25.0,
                    ),
                    Expanded(
                        child: Container(
                            child: Text(
                      ride.rider_suggested_amount.toString(),
                      style: TextStyle(fontSize: 14.0),
                    ))),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new Radio(
                                value: RideRequestAmountResult.ok,
                                groupValue: _selectedChoice,
                                onChanged: _handleRadioValueChange,
                              ),
                              new Text(
                                'Ok',
                                style: new TextStyle(fontSize: 12.0),
                              ),
                              new Radio(
                                value: RideRequestAmountResult.refuse,
                                groupValue: _selectedChoice,
                                onChanged: _handleRadioValueChange,
                              ),
                              new Text(
                                'Refuser',
                                style: new TextStyle(fontSize: 12.0),
                              ),
                              new Radio(
                                value:
                                    RideRequestAmountResult.ok_with_condition,
                                groupValue: _selectedChoice,
                                onChanged: _handleRadioValueChange,
                              ),
                              new Text(
                                'Autre montant',
                                style: new TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 160.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(1.0),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: amountSuggestionController,
                                  decoration: InputDecoration(
                                    hintText: "${ride.rider_suggested_amount}",
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(
                                        left: 11.0, top: 8.0, bottom: 8.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 10.0),
          Divider(
            height: 2.0,
            thickness: 4.0,
          ),
          SizedBox(height: 0.0),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                amountSuggested
                    ? Text('Waiting on driver response...',
                        style: TextStyle(fontSize: 14, color: Colors.black))
                    : RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.green)),
                        onPressed: () {
                          switch (_selectedChoice) {
                            case RideRequestAmountResult.ok:
                              {
                                // ok;
                                assetsAudioPlayer.stop();
                                checkAvailabilityOfRide(
                                    context,
                                    widget.rideDetails.rider_suggested_amount,
                                    RideRequestAmountResult.ok);
                              }
                              break;

                            case RideRequestAmountResult.refuse:
                              {
                                //non
                                assetsAudioPlayer.stop();
                                Navigator.pop(context);
                              }
                              break;

                            case RideRequestAmountResult.ok_with_condition:
                              {
                                //other amount;
                                var amount = amountSuggestionController.text ==
                                        null
                                    ? widget.rideDetails.rider_suggested_amount
                                    : amountSuggestionController.text;
                                assetsAudioPlayer.stop();
                                setState(() {
                                  amountSuggested = true;
                                });
                                checkAvailabilityOfRide(
                                    context,
                                    double.parse(amount),
                                    RideRequestAmountResult.ok_with_condition);
                              }
                              break;
                            default:
                              {
                                assetsAudioPlayer.stop();
                                checkAvailabilityOfRide(
                                    context,
                                    widget.rideDetails.rider_suggested_amount,
                                    RideRequestAmountResult.ok);
                              }
                              break;
                          }
                        },
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text("Soumettre".toUpperCase(),
                            style: TextStyle(fontSize: 14)),
                      ),
              ],
            ),
          ),

          SizedBox(height: 0.0),
        ],
      ),
    );
  }

  void checkAvailabilityOfRide(
      context, double amount, RideRequestAmountResult response) {
    rideRequestRef.once().then((DataSnapshot dataSnapShot) {
      String theRideId = "";

      if (dataSnapShot.value != null) {
        theRideId = dataSnapShot.value.toString();
      } else {
        displayToastMessage("Ride not exists.", context);
      }

      if (theRideId == widget.rideDetails.ride_request_id) {
        if (response == RideRequestAmountResult.ok) {
          Navigator.pop(context);
          rideRequestRef.set("accepted");
          AssistantMethods.disableHomeTabLiveLocationUpdates();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NewRideScreen(rideDetails: widget.rideDetails)));
        } else if (response == RideRequestAmountResult.ok_with_condition) {
          String rideRequestId = widget.rideDetails.ride_request_id;

          print('IM HERE 1 Notification');

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
              .update({'from_driver': amount.toString()});
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
          listenForResponse(rideRequestId, context);
        }
      } else if (theRideId == "cancelled") {
        Navigator.pop(context);
        displayToastMessage("Ride has been Cancelled.", context);
      } else if (theRideId == "rejected") {
        Navigator.pop(context);
        displayToastMessage("Ride has been Cancelled.", context);
      } else if (theRideId == "timeout") {
        Navigator.pop(context);
        displayToastMessage("Ride has time out.", context);
      } else {
        Navigator.pop(context);
        displayToastMessage("Ride not exists.", context);
      }
    });
  }

  void listenForResponse(String rideRequestId, context) {
    newRequestsRef.child(rideRequestId).onValue.listen((event) async {
      checkRejectedStatus(event, context);
      if (event.snapshot.value["status"] != null) {
        if (event.snapshot.value["status"] == "accepted") {
          if (event.snapshot.value["selected_driver_id"] ==
              driversInformation.id) {
            rideRequestRef.set("accepted");
            AssistantMethods.disableHomeTabLiveLocationUpdates();
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NewRideScreen(rideDetails: widget.rideDetails)));
            newRequestsRef.onDisconnect();
          } else {
            Navigator.pop(context);
            displayToastMessage("Offer Refused by Customer", context);
            newRequestsRef.onDisconnect();
          }
        }
      }
    });
  }

  void checkRejectedStatus(Event event, context) {
    Map drivers = event.snapshot.value["suggested_drivers"];
    drivers.forEach((key, value) {
      if (value["status"] == "rejected" && key == driversInformation.id) {
        Navigator.pop(context);
        displayToastMessage("Offer Refused by Customer", context);
        newRequestsRef.onDisconnect();
      }
    });
  }
}
