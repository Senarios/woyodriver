import 'package:cheetah_driver/pro_kit/banking/utils.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangePassword extends StatefulWidget {
  static var tag = "/BankingChangePassword";

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Banking_app_Background,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.chevron_left, size: 25, color: Banking_blackColor).onTap(
                        () {
                          finish(context);
                        },
                      ),
                      20.height,
                      Text("Change\nPassword", style: boldTextStyle(size: 30, color: Banking_TextColorPrimary)),
                    ],
                  ),
                  20.height,
                  EditText(text: "Old Password", isPassword: true, isSecure: true),
                  16.height,
                  EditText(text: "New Password", isPassword: true, isSecure: true),
                  16.height,
                  40.height,
                  BankingButton(
                      textContent: 'Confirmer',
                      onPressed: () {
                        toast('Password Successfully Changed');
                        finish(context);
                      }),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'JOMAR TAXI',
              style: primaryTextStyle(color: Banking_TextColorSecondary, size: 18),
            ),
          ).paddingBottom(16),
        ],
      ),
    );
  }
}
