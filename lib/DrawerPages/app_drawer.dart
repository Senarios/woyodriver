import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cheetah_driver/AllScreens/ajouts/settings.dart';
import 'package:cheetah_driver/AllScreens/loginScreen2.dart';
import 'package:cheetah_driver/AllScreens/mainScreen2.dart';
import 'package:cheetah_driver/Assets/Strings.dart';
import 'package:cheetah_driver/Assistants/assistantMethods.dart';
import 'package:cheetah_driver/DataHandler/appData.dart';
import 'package:cheetah_driver/DrawerPages/Profile/my_profile.dart';
import 'package:cheetah_driver/DrawerPages/Schedule/schedule_trip.dart';
import 'package:cheetah_driver/Theme/style.dart';
import 'package:cheetah_driver/configMaps.dart';
import 'package:cheetah_driver/tabsPages/historyTabPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'Rides/my_rides_page.dart';

class AppDrawer extends StatefulWidget {
  final bool fromHome;

  AppDrawer([this.fromHome = true]);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Builder(builder: (BuildContext context) {
      return Drawer(
        child: SafeArea(
          child: FadedSlideAnimation(
            ListView(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 12, right: 12, top: 20),
                  color: theme.scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'images/user_icon.png',
                                height: 72,
                                width: 72,
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  driversInformation.name == null
                                      ? ''
                                      : driversInformation?.name,
                                  style: theme.textTheme.headline5,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  driversInformation.phone == null
                                      ? ''
                                      : driversInformation?.phone,
                                  style: theme.textTheme.caption,
                                ),
                                SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: AppTheme.ratingsColor,
                                  ),
                                  child: Row(
                                    children: [
                                      // Text(
                                      //   driversInformation.rating == null
                                      //       ? ''
                                      //       : driversInformation.rating
                                      //           .substring(0, 3),
                                      // ),
                                      // SizedBox(width: 4),
                                      // Icon(
                                      //   Icons.star,
                                      //   color: AppTheme.starColor,
                                      //   size: 14,
                                      // )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.close),
                          color: theme.primaryColor,
                          iconSize: 28,
                          onPressed: () => Navigator.pop(context)),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                buildListTile(context, Icons.home, Strings.HOME, () {
                  if (widget.fromHome)
                    Navigator.pushReplacementNamed(
                        context, DriverHomeScreen.idScreen);
                  else
                    Navigator.pushReplacementNamed(
                        context, DriverHomeScreen.idScreen);
                }),
                buildListTile(context, Icons.person, Strings.PROFILE, () {
                  Navigator.popAndPushNamed(context, MyProfilePage.idScreen);
                }),
                buildListTile(context, Icons.drive_eta, Strings.HISTORY, () {
                  //  AssistantMethods.retrieveHistoryInfo(context);
                  Navigator.popAndPushNamed(context, MyRidesPage.idScreen);
                }),
                buildListTile(
                    context, Icons.calendar_today_outlined, Strings.SCHEDULE,
                    () {
                  //  AssistantMethods.retrieveHistoryInfo(context);
                  Navigator.popAndPushNamed(context, ScheduleTripScreen.idScreen);
                }),
                buildListTile(context, Icons.logout, Strings.LOGOUT, () {
                  // Geofire.removeLocation(currentfirebaseUser.uid);
                  onLogout(context);
                }),
              ],
            ),
            beginOffset: Offset(0, 0.3),
            endOffset: Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
          ),
        ),
      );
    });
  }

  void onLogout(BuildContext context) {
    // Geofire.removeLocation(currentfirebaseUser.uid);
    if (rideRequestRef != null) {
      rideRequestRef.onDisconnect();
      rideRequestRef.remove();
    }
    // rideRequestRef = null;
    Provider.of<AppData>(context, listen: false).tripHistoryDataList.clear();
    Provider.of<AppData>(context, listen: false).clearEarnings();
    FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreenUI.idScreen, (route) => false);
  }

  ListTile buildListTile(BuildContext context, IconData icon, String title,
      [Function onTap]) {
    var theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.primaryColor, size: 24),
      title: Text(
        title,
        style: theme.textTheme.headline5
            .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      onTap: onTap as void Function(),
    );
  }
}
