import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cheetah_driver/Assets/Strings.dart';
import 'package:cheetah_driver/utils/custom_button.dart';
import 'package:cheetah_driver/utils/entry_field.dart';
import 'package:flutter/material.dart';
import '../../Assets/assets.dart';
import '../../configMaps.dart';

class MyProfilePage extends StatefulWidget {
  static const String idScreen = "profileScreen";
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: FadedSlideAnimation(
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            "My Profile",
                            style: theme.textTheme.headline4,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          child: Text(
                            "Your account details",
                            style: theme.textTheme.bodyText2
                                .copyWith(color: theme.hintColor),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 72),
                          height: 72,
                          color: theme.backgroundColor,
                        ),
                      ],
                    ),
                    PositionedDirectional(
                      start: 24,
                      top: 120,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: AssetImage(Assets.Driver))),
                        alignment: Alignment.center,
                      ),
                    ),
                    PositionedDirectional(
                      start: 140,
                      top: 128,
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).primaryColor,
                              size: 24,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              Strings.CHANGE_PICTURE,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Theme.of(context).hintColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: theme.backgroundColor,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        EntryField(
                          label: Strings.PHONE,
                          initialValue: driversInformation.phone == null
                              ? ''
                              : driversInformation?.phone,
                          readOnly: true,
                        ),
                        EntryField(
                          label: Strings.FULL_NAME,
                          initialValue: driversInformation.name == null
                              ? ''
                              : driversInformation?.name,
                        ),
                        EntryField(
                          label: Strings.EMAIL,
                          initialValue: driversInformation.email == null
                              ? ''
                              : driversInformation?.email,
                        ),
                        SizedBox(height: 28),
                        Divider(
                          color: theme.scaffoldBackgroundColor,
                          thickness: 20,
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            Strings.CAR_INFO,
                            style: theme.textTheme.headline4,
                          ),
                        ),
                        EntryField(
                          initialValue: driversInformation.car_type == null
                              ? ''
                              : driversInformation?.car_type,
                          label: Strings.CAR_TYPE,
                          readOnly: true,
                        ),
                        EntryField(
                          initialValue: driversInformation.car_model == null
                              ? ''
                              : driversInformation?.car_model,
                          label: Strings.CAR_MODEL,
                          readOnly: true,
                        ),
                        EntryField(
                          initialValue: driversInformation.car_number == null
                              ? ''
                              : driversInformation?.car_number,
                          label: Strings.VEHICLE_NUM,
                          readOnly: true,
                        ),
                        SizedBox(height: 20),
                        Divider(
                          color: theme.scaffoldBackgroundColor,
                          thickness: 20,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                // CustomButton(
                //   text: getString(Strings.UPDATE_INFO),
                //   // onTap: () => widget.registrationInteractor
                //   //     .register(_nameController.text, _emailController.text),
                // ),
              ],
            ),
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
