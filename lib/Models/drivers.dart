import 'package:firebase_database/firebase_database.dart';

class Drivers
{
  String name;
  String phone;
  String email;
  String id;
  String rating;
  String car_color;
  String car_model;
  String car_number;
  String car_type;

  Drivers({this.name, this.phone, this.email, this.id,this.rating, this.car_color, this.car_model, this.car_number,this.car_type});

  Drivers.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key;
    phone = dataSnapshot.value["phone"];
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
    rating = dataSnapshot.value["ratings"];
    car_color = dataSnapshot.value["car_details"]["car_color"];
    car_model = dataSnapshot.value["car_details"]["car_model"];
    car_number = dataSnapshot.value["car_details"]["car_number"];
    car_type = dataSnapshot.value["car_details"]["type"];
  }
}

class RegistrationDriver {
  String firstName = '';
  String lastName = '';
  String phone = '';
  String email = '';
  String password = '';
  String permis = '';
  String marque = '';
  String model = '';
  String year = '';
  String colour = '';
}
