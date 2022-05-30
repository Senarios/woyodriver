import 'package:cheetah_driver/Models/history.dart';
import 'package:cheetah_driver/Models/rideDetails.dart';
import 'package:cheetah_driver/Models/scheduleTrip.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier {
  String earnings = "0";
  int countTrips = 0;
  int countScheduleTrips = 0;

  List<String> tripHistoryKeys = [];
  List<String> scheduleTripKeys = [];
  List<History> tripHistoryDataList = [];
  List<ScheduleTrip> scheduleTripDataList = [];

  bool isDriverAvailable = false;

  void updateEarnings(String updatedEarnings) {
    earnings = updatedEarnings;
    notifyListeners();
  }

  void clearEarnings() {
    earnings = "0";
  }

  void updateTripsCounter(int tripCounter) {
    countTrips = tripCounter;
    notifyListeners();
  }

  void updateScheduleTripCounter(int scheduletripCounter) {
    countScheduleTrips = scheduletripCounter;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys) {
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateScheduleTripKeys(List<String> newKeys) {
    scheduleTripKeys = newKeys;
    notifyListeners();
  }

  void updateTripHistoryData(History eachHistory) {
    tripHistoryDataList.add(eachHistory);
    notifyListeners();
  }

  void updateScheduleTripData(ScheduleTrip scheduleTrip) {
    scheduleTripDataList.add(scheduleTrip);
    notifyListeners();
  }

  void updateDriverAvailability(bool isAvailable) {
    isDriverAvailable = isAvailable;
    notifyListeners();
  }

  List<RideDetails> currentRideRequests;
  void updateJobRequests(RideDetails rideDetails) {
    currentRideRequests.add(rideDetails);
  }

  String rideStatus = "";
  void updateRideStatus(String pStatus) {
    rideStatus = pStatus;
    notifyListeners();
  }

  RideDetails rideDetails;
  void updateRideDetails(RideDetails pRideDetails) {
    rideDetails = pRideDetails;
    notifyListeners();
  }
}
