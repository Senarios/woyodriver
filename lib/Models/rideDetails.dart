import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails {
  LatLng pickup;
  String status;
  LatLng dropoff;
  String rider_name;
  String rider_phone;
  String pickup_address;
  String payment_method;
  String noOfPassengers;
  String dropoff_address;
  String ride_request_id;
  double rider_suggested_amount;

  RideDetails({
    this.status,
    this.pickup,
    this.dropoff,
    this.rider_name,
    this.rider_phone,
    this.pickup_address,
    this.payment_method,
    this.noOfPassengers,
    this.dropoff_address,
    this.ride_request_id,
    this.rider_suggested_amount,
  });
}
