import 'package:cheetah_driver/Assets/Strings.dart';
import 'package:cheetah_driver/Assets/assets.dart';
import 'package:cheetah_driver/Assistants/assistantMethods.dart';
import 'package:cheetah_driver/Models/history.dart';
import 'package:flutter/material.dart';

import '../configMaps.dart';

class HistoryItem2 extends StatefulWidget {
  final History history;

  HistoryItem2({this.history});

  @override
  State<HistoryItem2> createState() => _HistoryItem2State();
}

class _HistoryItem2State extends State<HistoryItem2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('History Screen');
    print('History ${widget.history.fares}');
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            height: 80,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: theme.backgroundColor,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(Assets.Driver),
                ),
                SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.history.createdAt != null
                          ? AssistantMethods.formatTripDate(
                              widget.history.createdAt)
                          : "",
                      style: theme.textTheme.bodyText2,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      driversInformation.name == null
                          ? ''
                          : driversInformation?.name,
                      style: theme.textTheme.caption,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.history.status == null
                          ? ''
                          : widget.history.status,
                      style: theme.textTheme.caption,
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${widget.history.fares == null ? "" : widget.history.fares}',
                      style: theme.textTheme.bodyText2
                          .copyWith(color: theme.primaryColor),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      Strings.PAID_VIA + widget.history.paymentMethod != null
                          ? widget.history.paymentMethod
                          : "",
                      textAlign: TextAlign.right,
                      style: theme.textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.location_on,
              color: theme.primaryColor,
              size: 20,
            ),
            title: Text(
                widget.history.pickup != null ? widget.history.pickup : ""),
            dense: true,
            tileColor: theme.cardColor,
          ),
          ListTile(
            leading: Icon(
              Icons.navigation,
              color: theme.primaryColor,
              size: 20,
            ),
            title: Text(
                widget.history.dropOff != null ? widget.history.dropOff : ""),
            dense: true,
            tileColor: theme.cardColor,
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
