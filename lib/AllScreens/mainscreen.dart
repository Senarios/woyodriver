
import 'package:cheetah_driver/AllScreens/ajouts/settings.dart';
import 'package:cheetah_driver/Assistants/assistantMethods.dart';
import 'package:cheetah_driver/DataHandler/appData.dart';
import 'package:cheetah_driver/configMaps.dart';
import 'package:cheetah_driver/main.dart';
import 'package:cheetah_driver/tabsPages/driverHomePage3.dart';
import 'package:cheetah_driver/tabsPages/historyTabPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget
{
  static const String idScreen = "mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin
{
  TabController tabController;
  int selectedIndex = 0;
  String token;
  List subscribed = [];

  void onItemClicked(int index)
  {
    setState(() {
      if(index == 1) // Update history tab
        {
          AssistantMethods.retrieveHistoryInfo(context);

        }
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    initializeDriverInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          DriverHomePage3(),
          HistoryTabPage(),
          SettingsScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: "History",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),

        ],
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 12.0),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }

  void initializeDriverInfo(){
    // print('inside main screen');
    AssistantMethods.retrieveHistoryInfo(context);
    getRatings();
    getRideType();
  }

  getRideType()
  {
    driversRef.child(currentfirebaseUser.uid).child("car_details").child("type").once().then((DataSnapshot snapshot)
    {
      if(snapshot.value != null)
      {
        setState(() {
          rideType = snapshot.value.toString();
        });
      }
    });
  }

  getRatings()
  {
    //update ratings
    driversRef.child(currentfirebaseUser.uid).child("ratings").once().then((DataSnapshot dataSnapshot)
    {
      if(dataSnapshot.value != null)
      {
        double ratings = double.parse(dataSnapshot.value.toString());
        setState(() {
          starCounter = ratings;
        });

        if(starCounter <= 1.5)
        {
          setState(() {
            title = "Very Bad";
          });
          return;
        }
        if(starCounter <= 2.5)
        {
          setState(() {
            title = "Bad";
          });

          return;
        }
        if(starCounter <= 3.5)
        {
          setState(() {
            title = "Good";
          });

          return;
        }
        if(starCounter <= 4.5)
        {
          setState(() {
            title = "Very Good";
          });
          return;
        }
        if(starCounter <= 5.0)
        {
          setState(() {
            title = "Excellent";
          });

          return;
        }
      }
    });
  }
}
