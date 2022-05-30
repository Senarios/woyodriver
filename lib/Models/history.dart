import 'package:firebase_database/firebase_database.dart';

class History {
  String paymentMethod;
  String createdAt;
  String status;
  String fares;
  String dropOff;
  String pickup;
  String riderId;

  History({
    this.paymentMethod,
    this.createdAt,
    this.status,
    this.fares,
    this.dropOff,
    this.pickup,
    this.riderId,
  });

  History.fromSnapshot(DataSnapshot snapshot) {
    paymentMethod = snapshot.value["payment_method"];
    createdAt = snapshot.value["created_at"];
    status = snapshot.value["status"];
    fares = snapshot.value["fares"];
    dropOff = snapshot.value["dropoff_address"];
    pickup = snapshot.value["pickup_address"];
    riderId = snapshot.value["rider_id"];
  }
}
