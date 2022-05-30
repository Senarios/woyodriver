import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

const Banking_Primary = Color(0xFFff9a8d);
const Banking_Secondary = Color(0xFF4a536b);
const Banking_ColorPrimaryDark = Color(0xFFFFF);

const Banking_TextColorPrimary = Color(0xFF070706);
const Banking_TextColorSecondary = Color(0xFF747474);
const Banking_TextColorWhite = Color(0xFFffffff);
const Banking_TextColorOrange = Color(0xFFF4413D);
const Banking_TextColorYellow = Color(0xFFff8c42);
const Banking_TextLightGreenColor = Color(0xFF8ed16f);

const Banking_app_Background = Color(0xFFf3f5f9);
const Banking_blackColor = Color(0xFF070706);
const Banking_view_color = Color(0XFFDADADA);
const Banking_blackLightColor = Color(0xFF242525);
const Banking_shadowColor = Color(0X95E9EBF0);
const Banking_greyColor = Color(0xFFA3A0A0);
const Banking_bottomEditTextLineColor = Color(0xFFDBD9D9);
const Banking_backgroundFragmentColor = Color(0xFFF7F5F5);
const Banking_palColor = Color(0xFF4a536b);
const Banking_BalanceColor = Color(0xFF8ed16f);
const Banking_whitePureColor = Color(0xFFffffff);
const Banking_subTitleColor = Color(0xFF5C5454);
const Banking_blueColor = Color(0xFF041887);
const Banking_blueLightColor = Color(0xFF41479B);
const Banking_pinkColor = Color(0xFFE91E63);
const Banking_RedColor = Color(0xFFD80027);
const Banking_greenLightColor = Color(0xFF05E10E);
const Banking_skyBlueColor = Color(0xFF03A9F4);
const Banking_pinkLightColor = Color(0xFFE7586A);
const Banking_purpleColor = Color(0xFFAD3AC3);

/*fonts*/
const fontRegular = 'Regular';
const fontMedium = 'Medium';
const fontSemiBold = 'Semibold';
const fontBold = 'Bold';

/* font sizes*/
const textSizeSmall = 12.0;
const textSizeSMedium = 14.0;
const textSizeMedium = 16.0;
const textSizeLargeMedium = 18.0;
const textSizeNormal = 20.0;
const textSizeLarge = 24.0;
const textSizeXLarge = 28.0;
const textSizeXXLarge = 30.0;
const textSizeBig = 50.0;

const spacing_control_half = 2.0;
const spacing_control = 4.0;
const spacing_standard = 8.0;
const spacing_middle = 10.0;
const spacing_standard_new = 16.0;
const spacing_large = 24.0;
const spacing_xlarge = 32.0;
const spacing_xxLarge = 40.0;

const Banking_ic_user1 = "images/pro_kit/banking/Banking_ic_user1.jpeg";
const Banking_ic_user2 = "images/pro_kit/banking/Banking_ic_user2.jpg";
const Banking_ic_Share = "images/pro_kit/banking/Banking_ic_Share.png";
const Banking_ic_News = "images/pro_kit/banking/Banking_ic_News.png";
const Banking_ic_Chart = "images/pro_kit/banking/Banking_ic_Chart.png";
const Banking_ic_TC = "images/pro_kit/banking/Banking_ic_TC.png";
const Banking_ic_Call = "images/pro_kit/banking/Banking_ic_Call.png";
const Banking_ic_Question = "images/pro_kit/banking/Banking_ic_Question.png";
const Banking_ic_security = "images/pro_kit/banking/Banking_ic_security.png";
const Banking_ic_Pin = "images/pro_kit/banking/Banking_ic_Pin.png";
const Banking_ic_Setting = "images/pro_kit/banking/Banking_ic_Setting.png";
const Banking_ic_Logout = "images/pro_kit/banking/Banking_ic_Logout.png";
const Banking_ic_QR = "images/pro_kit/banking/Banking_ic_QR.png";
const Banking_ic_Skype = "images/pro_kit/banking/Banking_ic_Skype.png";
const Banking_ic_Inst = "images/pro_kit/banking/Banking_ic_Inst.png";
const Banking_ic_WhatsApp = "images/pro_kit/banking/Banking_ic_Whatsup.png";
const Banking_ic_messenger = "images/pro_kit/banking/Banking_ic_messenger.png";
const Banking_ic_facebook = "images/pro_kit/banking/Banking_ic_facebook.png";
const Banking_ic_Website = "images/pro_kit/banking/Banking_ic_Website.png";
const Banking_ic_Clock = "images/pro_kit/banking/Banking_ic_Clock.png";

// widget
class EditText extends StatefulWidget {
  var isPassword;
  var isSecure;
  var fontSize;
  var textColor;
  var fontFamily;
  var text;
  var maxLine;
  TextEditingController mController;

  VoidCallback onPressed;

  EditText({
    var this.fontSize = textSizeNormal,
    var this.textColor = Banking_TextColorPrimary,
    var this.fontFamily = fontRegular,
    var this.isPassword = true,
    var this.isSecure = false,
    var this.text = "",
    var this.mController,
    var this.maxLine = 1,
  });

  @override
  State<StatefulWidget> createState() {
    return EditTextState();
  }
}

class EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isSecure) {
      return TextField(
          controller: widget.mController,
          obscureText: widget.isPassword,
          cursorColor: Banking_Primary,
          maxLines: widget.maxLine,
          style: TextStyle(fontSize: widget.fontSize, color: Banking_TextColorPrimary, fontFamily: widget.fontFamily),
          decoration: InputDecoration(
            hintText: widget.text,
            hintStyle: TextStyle(fontSize: textSizeMedium),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Banking_Primary, width: 0.5),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Banking_TextColorSecondary, width: 0.5),
            ),
          ));
    } else {
      return TextField(
        controller: widget.mController,
        obscureText: widget.isPassword,
        cursorColor: Banking_Primary,
        style: TextStyle(fontSize: widget.fontSize, color: Banking_TextColorPrimary, fontFamily: widget.fontFamily),
        decoration: InputDecoration(
            hintText: widget.text,
            hintStyle: TextStyle(fontSize: textSizeMedium),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  widget.isPassword = !widget.isPassword;
                });
              },
              child: new Icon(
                widget.isPassword ? Icons.visibility : Icons.visibility_off,
                color: Banking_TextColorSecondary,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Banking_TextColorSecondary, width: 0.5),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Banking_Primary, width: 0.5),
            )),
      );
    }
  }
}

// button
class BankingButton extends StatefulWidget {
  static String tag = '/BankingButton';
  var textContent;
  VoidCallback onPressed;
  var isStroked = false;
  var height = 50.0;
  var radius = 5.0;

  BankingButton({@required this.textContent, @required this.onPressed, this.isStroked = false, this.height = 45.0, this.radius = 5.0});

  @override
  BankingButtonState createState() => BankingButtonState();
}

class BankingButtonState extends State<BankingButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: widget.height,
        padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
        alignment: Alignment.center,
        child: Text(
          widget.textContent.toUpperCase(),
          style: primaryTextStyle(color: widget.isStroked ? Banking_Primary : Banking_whitePureColor, size: 18, fontFamily: fontMedium),
        ).center(),
        decoration: widget.isStroked ? boxDecoration(bgColor: Colors.transparent, color: Banking_Primary) : boxDecoration(bgColor: Banking_Secondary, radius: widget.radius),
      ),
    );
  }
}

BoxDecoration boxDecoration({double radius = 2, Color color = Colors.transparent, Color bgColor, var showShadow = false}) {
  return BoxDecoration(
    // color: bgColor ?? appStore.scaffoldBackground,
    boxShadow: showShadow ? defaultBoxShadow(shadowColor: shadowColorGlobal) : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}