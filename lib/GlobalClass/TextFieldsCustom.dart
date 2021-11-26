import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/utils/AppFonts.dart';

class TextFieldsProfile extends StatefulWidget {
  TextFieldsProfile(
      {Key? key,
      this.hint,
      this.controller,
      this.icon,
      this.color,
      this.uperhint,
      this.obsucreTextUp = false,
      this.isnumber = false,
      this.enable = true,
      this.isArabic = false,
      this.width ,
      this.sufixIcon,
      this.maxLines = 1})
      : super(key: key);
  final hint;
  final IconData? icon;
  final width;
  final TextEditingController? controller;
  final color;
  final String? uperhint;
  final bool obsucreTextUp;
  final bool isnumber;
  final bool enable;
  final bool isArabic;
  final Widget? sufixIcon;
  final int? maxLines;

  @override
  _TextFieldsProfileState createState() => _TextFieldsProfileState();
}

class _TextFieldsProfileState extends State<TextFieldsProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: widget.width * 0.015),
          child: Text(
            '${widget.uperhint}',
            style: TextStyle(
                fontSize: 11,
                letterSpacing: 0.4,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.segoeui),
          ),
        ),
        SizedBox(
          height: Get.height / 130,
        ),
        Container(
          width: widget.width,
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
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obsucreTextUp,
            enabled: widget.enable,
            keyboardType: widget.isnumber == true ? TextInputType.number : null,
            textAlign: TextAlign.start,
            maxLines: widget.maxLines,
            style: TextStyle(),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    left: widget.width * 0.030,
                    right: widget.width * 0.030,
                    bottom: widget.width * 0.010),
                border: InputBorder.none,
                suffixIcon: widget.sufixIcon,
                hintText: '${widget.hint}',
                hintStyle: TextStyle(
                    fontSize: 10,
                    fontFamily: AppFonts.segoeui,
                    letterSpacing: 0.5,
                    color: Colors.black54,
                    fontWeight: FontWeight.w300)),
          ),
        ),
      ],
    );
  }
}
