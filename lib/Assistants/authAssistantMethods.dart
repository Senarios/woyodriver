import 'package:cheetah_driver/Models/drivers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../configMaps.dart';
import '../main.dart';

class AuthAssistantMethods {
  static dynamic saveUserToRtDatabase(RegistrationDriver driver){
    return {
      "firstName": driver.firstName.trim(),
      "lastName": driver.lastName.trim(),
      "email": driver.email.trim(),
      "phone": driver.phone.trim(),
      "permis" : driver.permis.trim(),
      "carMade" : driver.marque.trim(),
      "carModel" : driver.model.trim(),
      "carColour" : driver.colour.trim(),
    };
  }

  static Future<User> saveUserToFireStoreDatabase(RegistrationDriver driver, User fireBase) async {
    final QuerySnapshot resultQuery = await FirebaseFirestore.instance
        .collection("users").where("id", isEqualTo: fireBase.uid).get();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;
      if(documentSnapshots.length == 0)
      {
        FirebaseFirestore.instance.collection("users").doc(fireBase.uid).set({
          "lastName" : driver.lastName.trim(),
          "firstName" : driver.firstName.trim(),
          "phone" : driver.phone.trim(),
          "email" : fireBase.email.trim(),
          "id" : fireBase.uid,
          "createdAt" : DateTime.now().millisecondsSinceEpoch.toString(),
          "chattingWith" : null,
        });

        return fireBase;
        // //Write data to Local
        // currentUser = firebaseUser;
        // await preferences.setString("id", currentUser.uid);
        // await preferences.setString("nickname", currentUser.displayName);
        // await preferences.setString("photoUrl", currentUser.photoURL);
      }
  }
}