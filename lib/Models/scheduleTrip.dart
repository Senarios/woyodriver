import 'package:firebase_database/firebase_database.dart';

class ScheduleTrip {
  String time;
  String fares;
  String tripID;
  String status;
  String pickup;
  String riderId;
  String dropOff;
  String createdAt;
  String paymentMethod;
  String noOfPassengers;

  ScheduleTrip({
    this.time,
    this.fares,
    this.tripID,
    this.status,
    this.pickup,
    this.riderId,
    this.dropOff,
    this.createdAt,
    this.paymentMethod,
    this.noOfPassengers,
  });

  ScheduleTrip.fromSnapshot(DataSnapshot snapshot) {
    tripID = snapshot.key;
    time = snapshot.value["time"];
    status = snapshot.value["status"];
    riderId = snapshot.value["rider_id"];
    createdAt = snapshot.value["created_at"];
    pickup = snapshot.value["pickup_address"];
    fares = snapshot.value["amount_from_rider"];
    dropOff = snapshot.value["dropoff_address"];
    paymentMethod = snapshot.value["payment_method"];
    noOfPassengers = snapshot.value["no_of_passengers"];
  }
}
