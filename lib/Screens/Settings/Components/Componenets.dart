import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rooya_app/AppThemes/AppThemes.dart';
import 'package:rooya_app/utils/AppFonts.dart';

Widget settingRow(
    {double? height, double? width, String? svgname, String? title}) {
  return Container(
    height: height! * 0.060,
    margin: EdgeInsets.only(bottom: height * 0.015),
    width: width,
    padding: EdgeInsets.symmetric(horizontal: width! * 0.030),
    child: Row(
      children: [
        Row(
          children: [
            SizedBox(
              width: width * 0.1,
              child: SvgPicture.asset(
                svgname!,
                color: darkoffBlackColor,
              ),
            ),
            SizedBox(
              width: width * 0.030,
            ),
            Text(
              title!,
              style: TextStyle(
                  fontSize: 12.5,
                  fontFamily: AppFonts.segoeui,
                  color: darkoffBlackColor),
            ),
          ],
        ),
        Icon(
          CupertinoIcons.chevron_forward,
          color: darkoffBlackColor,
          size: 20,
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
    ),
    decoration: BoxDecoration(
        color: settingGreyColor, borderRadius: BorderRadius.circular(5)),
  );
}

Widget seetingRowWithOutIcon(
    {double? height,
    double? width,
    String? title,
    Color textColor = const Color(0xff5A5A5A)}) {
  return Container(
    height: height! * 0.060,
    margin: EdgeInsets.only(bottom: height * 0.015),
    width: width,
    padding: EdgeInsets.symmetric(horizontal: width! * 0.030),
    child: Row(
      children: [
        Row(
          children: [
            SizedBox(
              width: width * 0.030,
            ),
            Text(
              title!,
              style: TextStyle(
                  fontSize: 12.5,
                  fontFamily: AppFonts.segoeui,
                  color: textColor),
            ),
          ],
        ),
        Icon(
          CupertinoIcons.chevron_forward,
          color: darkoffBlackColor,
          size: 20,
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
    ),
    decoration: BoxDecoration(
        color: settingGreyColor, borderRadius: BorderRadius.circular(5)),
  );
}

Widget switchwithRow({double? height, double? width, String? title}) {
  return Container(
    height: height! * 0.060,
    width: width,
    padding: EdgeInsets.symmetric(horizontal: width! * 0.015),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$title',
          style: TextStyle(
              fontSize: 11,
              letterSpacing: 0.4,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.segoeui),
        ),
        CupertinoSwitch(
          value: true,
          onChanged: (v) {},
          activeColor: greenColor,
        )
      ],
    ),
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.green.withOpacity(0.10),
              offset: Offset(4, 4),
              blurRadius: 3),
          BoxShadow(
              color: Colors.green.withOpacity(0.1),
              offset: Offset(-0.5, -0.5),
              blurRadius: 1)
        ],
        borderRadius: BorderRadius.circular(5)),
  );
}
