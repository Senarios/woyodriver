import 'dart:async';

import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:cheetah_driver/AllWidgets/ScheduleItems.dart';
import 'package:cheetah_driver/Assets/Strings.dart';
import 'package:cheetah_driver/Assistants/assistantMethods.dart';
import 'package:cheetah_driver/DataHandler/appData.dart';
import 'package:cheetah_driver/Models/scheduleTrip.dart';
import 'package:cheetah_driver/pro_kit/ora_pay/utils/colors.dart';
import 'package:cheetah_driver/utils/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ScheduleTripScreen extends StatefulWidget {
  static const String idScreen = "scheduleTripScreen";

  const ScheduleTripScreen({Key key}) : super(key: key);

  @override
  _ScheduleTripScreenState createState() => _ScheduleTripScreenState();
}

class _ScheduleTripScreenState extends State<ScheduleTripScreen> {
  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    // _timer = Timer.periodic(
    //   Duration(seconds: 2),
    //   (Timer t) => AssistantMethods.retrieveScheduleTripInfo(context),
    // );
    AssistantMethods.retrieveScheduleTripInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var scheduleTripList =
        Provider.of<AppData>(context, listen: false).scheduleTripDataList;
    sortScheduleTripList(scheduleTripList);

    return Scaffold(
      appBar: AppBar(),
      body: FadedSlideAnimation(
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Text(
                  Strings.SCHEDULE,
                  style: theme.textTheme.headline4,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: double.infinity,
                      minWidth: 150,
                    ),
                    decoration: boxDecorationWithShadow(
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: qIBus_rating,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Strings.LIST_OF_SCHEDULE_RIDES,
                          style: theme.textTheme.bodyText2
                              .copyWith(color: theme.hintColor),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => super.widget,
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          icon: Icon(Icons.refresh),
                        )
                      ],
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: scheduleTripList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      print("LIST VIEW LENGTH: ${scheduleTripList.length}");
                      return ScheduleItems(
                        scheduleTrip: scheduleTripList[index],
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

  void sortScheduleTripList(List<ScheduleTrip> scheduleTripList) {
    scheduleTripList.sort((a, b) {
      var aDate = DateTime.parse(a.time);
      var bDate = DateTime.parse(b.time);
      return aDate.compareTo(bDate);
    });
  }
}
