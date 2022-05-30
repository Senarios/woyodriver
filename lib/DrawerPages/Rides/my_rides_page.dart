import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cheetah_driver/AllWidgets/HistoryItem.dart';
import 'package:cheetah_driver/AllWidgets/HistoryItem2.dart';
import 'package:cheetah_driver/Assets/Strings.dart';
import 'package:cheetah_driver/Assistants/assistantMethods.dart';
import 'package:cheetah_driver/DataHandler/appData.dart';
import 'package:cheetah_driver/Models/history.dart';
import 'package:cheetah_driver/pro_kit/banking/utils.dart';
import 'package:cheetah_driver/pro_kit/ora_pay/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:nb_utils/src/extensions.dart';
import 'package:provider/provider.dart';
import '../../Assets/assets.dart';

class MyRidesPage extends StatefulWidget {
  static const String idScreen = "myRidesScreen";


  @override
  State<MyRidesPage> createState() => _MyRidesPageState();
}

class _MyRidesPageState extends State<MyRidesPage> {

  @override
  void initState() {
    // TODO: implement initState
    AssistantMethods.retrieveHistoryInfo(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var historyList = Provider.of<AppData>(context, listen: false).tripHistoryDataList;
    sortHistoryList(historyList);
    return Scaffold(
      appBar: AppBar(),
      body: FadedSlideAnimation(
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Divider(height: 2.0, thickness: 2.0,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
                child: Text(
                  Strings.MY_RIDES,
                  style: theme.textTheme.headline4,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: double.infinity, minWidth: 150),
                    decoration: boxDecorationWithShadow(
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: qIBus_rating),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                      child: Row(
                        children: [
                          Icon(Icons.car_rental, size: 32.0),
                          5.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Voyages',
                                style: TextStyle(
                                    color: Banking_TextColorSecondary),
                              ),
                              Text(
                                "${Provider.of<AppData>(context, listen: true).countTrips}",
                                style: TextStyle(
                                    color: Banking_TextColorPrimary,
                                    fontSize: 25),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: double.infinity, minWidth: 150),
                    decoration: boxDecorationWithShadow(
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: opOrangeColor),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Row(
                        children: [
                          Icon(Icons.monetization_on, size: 32.0),
                          5.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Revenus',
                                style: TextStyle(
                                    color: Banking_TextColorSecondary,
                                    fontSize: 18),
                              ),
                              Text(
                                "\$${Provider.of<AppData>(context, listen: false).earnings}",
                                style: TextStyle(
                                    color: Banking_TextColorPrimary,
                                    fontSize: 25),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              20.height,
              ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Text(
                      Strings.LIST_OF_RIDES_COMPLETED,
                      style: theme.textTheme.bodyText2
                          .copyWith(color: theme.hintColor),
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: historyList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return HistoryItem2(
                        history: historyList[index],
                      );
                    }
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

  void sortHistoryList(List<History> historyList) {
    historyList.sort((a,b){
      var aDate = DateTime.parse(a.createdAt);
      var bDate = DateTime.parse(b.createdAt);
      return bDate.compareTo(aDate);
    });
  }
}
