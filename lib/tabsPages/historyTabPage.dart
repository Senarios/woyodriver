import 'package:cheetah_driver/AllWidgets/HistoryItem.dart';
import 'package:cheetah_driver/Assistants/assistantMethods.dart';
import 'package:cheetah_driver/DataHandler/appData.dart';
import 'package:cheetah_driver/Models/history.dart';
import 'package:cheetah_driver/pro_kit/banking/utils.dart';
import 'package:cheetah_driver/pro_kit/ora_pay/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nb_utils/nb_utils.dart';

class HistoryTabPage extends StatefulWidget {

  static const String idScreen = "history";
  @override
  _HistoryTabPageState createState() => _HistoryTabPageState();
}

class _HistoryTabPageState extends State<HistoryTabPage> {

  @override
  Widget build(BuildContext context)
  {
    var historyList = Provider.of<AppData>(context, listen: false).tripHistoryDataList;
    sortHistoryList(historyList);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Divider(height: 2.0, thickness: 2.0,),
          70.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: double.infinity,
                  minWidth: 150
                ),
                decoration: boxDecorationWithShadow(borderRadius: BorderRadius.circular(10), backgroundColor: qIBus_rating),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                  child: Row(
                    children: [
                      Icon(
                          Icons.car_rental,
                          size: 32.0
                      ),
                      5.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Voyages', style: TextStyle(color: Banking_TextColorSecondary),),
                          Text("${Provider.of<AppData>(context, listen: true).countTrips}", style: TextStyle(color: Banking_TextColorPrimary, fontSize: 25),)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: double.infinity,
                    minWidth: 150
                ),
                decoration: boxDecorationWithShadow(borderRadius: BorderRadius.circular(10), backgroundColor: opOrangeColor),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    children: [
                      Icon(
                          Icons.monetization_on,
                          size: 32.0
                      ),
                      5.width,

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Revenus', style: TextStyle(color: Banking_TextColorSecondary, fontSize: 18),),
                          Text("\$${Provider.of<AppData>(context, listen: false).earnings}", style: TextStyle(color: Banking_TextColorPrimary, fontSize: 25),)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          20.height,
          ListView.separated(
            padding: EdgeInsets.all(0),
            itemBuilder: (context, index)
            {
              return HistoryItem(
                history: historyList[index],
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(thickness: 3.0, height: 3.0,),
            itemCount: historyList.length,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
          ),
        ],
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
