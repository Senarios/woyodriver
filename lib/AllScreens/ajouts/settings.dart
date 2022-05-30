import 'package:cheetah_driver/AllScreens/loginScreen.dart';
import 'package:cheetah_driver/DataHandler/appData.dart';
import 'package:cheetah_driver/configMaps.dart';
import 'package:cheetah_driver/main.dart';
import 'package:cheetah_driver/pro_kit/ora_pay/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cheetah_driver/pro_kit/banking/utils.dart';
import 'package:provider/provider.dart';

import 'ShareInformation.dart';
import 'changePasword.dart';

class SettingsScreen extends StatefulWidget {
  static var tag = "/BankingMenu";

  static const String idScreen = "settings";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Banking_app_Background,
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 10.height,
              // Text('Menu', style: boldTextStyle(color: Banking_TextColorPrimary, size: 35)),
              50.height,
              SizedBox(
                child: Container(
                  // height: 250,
                  padding: EdgeInsets.all(8),
                  decoration: boxDecorationWithShadow(borderRadius: BorderRadius.circular(10), backgroundColor: qIBus_rating),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(child: CircleAvatar(backgroundImage: AssetImage(Banking_ic_user1), radius: 40),),
                          10.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              5.height,
                              Text(driversInformation.name, style: boldTextStyle(color: Banking_TextColorPrimary, size: 18)),
                              5.height,
                              Text(driversInformation.phone, style: primaryTextStyle(color: Banking_TextColorSecondary, size: 16))
                            ],
                          ).expand()
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              5.height,
                              Icon(
                                Icons.timelapse,
                                size: 32.0
                              ),
                              5.height,
                              Text('10.2', style: primaryTextStyle(color: Banking_TextColorSecondary, size: 16)),
                              5.height,
                              Text('Connected Hours', style: primaryTextStyle(color: Banking_TextColorSecondary, size: 12)),
                            ],
                          ).expand(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              5.height,
                              Icon(
                                  Icons.speed_sharp,
                                  size: 32.0
                              ),
                              5.height,
                              Text('30km', style: primaryTextStyle(color: Banking_TextColorSecondary, size: 16)),
                              5.height,
                              Text('Distance', style: primaryTextStyle(color: Banking_TextColorSecondary, size: 12)),
                            ],
                          ).expand(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              5.height,
                              Icon(
                                  Icons.event_note,
                                  size: 32.0
                              ),
                              5.height,
                              Text('20', style: primaryTextStyle(color: Banking_TextColorSecondary, size: 16)),
                              5.height,
                              Text('Missions', style: primaryTextStyle(color: Banking_TextColorSecondary, size: 12)),
                            ],
                          ).expand()
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    option(Banking_ic_Setting, 'Driver Info', Banking_TextColorSecondary).onTap(() {
                      ShareInformation().launch(context);
                    }),
                    option(Banking_ic_Setting, 'Car Info', Banking_TextColorSecondary).onTap(() {
                      ShareInformation().launch(context);
                    }),
                    option(Banking_ic_Setting, 'Paiement Method', Banking_TextColorSecondary).onTap(() {
                      ShareInformation().launch(context);
                    })
                  ],
                ),
              ),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    option(Banking_ic_security, 'Change Password', Banking_TextColorSecondary).onTap(() {
                      ChangePassword().launch(context);
                    }),
                    option(Banking_ic_Share, 'Share ', Banking_TextColorSecondary).onTap(() {
                      ShareInformation().launch(context);
                    }),
                  ],
                ),
              ),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    option(Banking_ic_TC, 'Termes & Conditions', Banking_TextColorSecondary).onTap(() {
                      // BankingTermsCondition().launch(context);
                    }),
                    option(Banking_ic_Question, 'Questions', Banking_TextColorSecondary).onTap(() {
                      // BankingQuestionAnswer().launch(context);
                    }),
                    option(Banking_ic_Call, 'Contact', Banking_TextColorSecondary).onTap(() {
                      // BankingContact().launch(context);
                    }),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    option(Banking_ic_Logout, 'Logout', Banking_TextColorSecondary).onTap(() {
                      // Geofire.removeLocation(currentfirebaseUser.uid);
                      if(rideRequestRef!=null) {
                        rideRequestRef.onDisconnect();
                        rideRequestRef.remove();
                      }
                     // rideRequestRef = null;
                      Provider.of<AppData>(context, listen: false).tripHistoryDataList.clear();
                      Provider.of<AppData>(context, listen: false).clearEarnings();
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

dialogContent(BuildContext context) {
  var width = MediaQuery.of(context).size.width;

  return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: const Offset(0.0, 10.0)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          16.height,
          Text('Logout', style: primaryTextStyle(size: 18)).onTap(() {
            // Geofire.removeLocation(currentfirebaseUser.uid);
            // rideRequestRef.onDisconnect();
            // rideRequestRef.remove();
            // rideRequestRef = null;
            //
            // FirebaseAuth.instance.signOut();
            // Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
            // finish(context);
          }).paddingOnly(top: 8, bottom: 8),
          Divider(height: 10, thickness: 1.0, color: Banking_greyColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Cancel", style: primaryTextStyle(size: 18)).onTap(() {
                finish(context);
              }).paddingRight(16),
              Container(width: 1.0, height: 40, color: Banking_greyColor).center(),
              Text("Logout", style: primaryTextStyle(size: 18, color: Banking_Primary)).onTap(() {
                // Geofire.removeLocation(currentfirebaseUser.uid);
                rideRequestRef.onDisconnect();
                rideRequestRef.remove();
                rideRequestRef = null;

                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);

                finish(context);
              }).paddingLeft(16)
            ],
          ),
          16.height,
        ],
      ));
}

Widget option(var icon, var heading, Color color) {
  return Container(
    padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
    child: Row(
      children: <Widget>[
        Row(
          children: <Widget>[
            Image.asset(icon, color: color, height: 20, width: 20),
            16.width,
            Text(heading, style: primaryTextStyle(color: Banking_TextColorPrimary, size: 18)),
          ],
        ).expand(),
        Icon(Icons.keyboard_arrow_right, color: Banking_TextColorSecondary),
      ],
    ),
  );
}
