import 'package:flutter/material.dart';
import 'package:rooya_app/utils/AppFonts.dart';

class CustomTextFields extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final Widget? suffixIcon;
  final bool? visible;

  const CustomTextFields(
      {Key? key,
      this.controller,
      this.labelText,
      this.suffixIcon,
      this.visible = false})
      : super(key: key);

  @override
  _CustomTextFieldsState createState() => _CustomTextFieldsState();
}

class _CustomTextFieldsState extends State<CustomTextFields> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: const Color(0x290bab0d),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        cursorColor: Colors.black,
        keyboardType: TextInputType.emailAddress,
        obscureText: widget.visible!,
        decoration: new InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding:
              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          labelText: widget.labelText,
          //  hintText: '+923331234567',
          suffixIcon: widget.suffixIcon,
          labelStyle: TextStyle(
            fontFamily: AppFonts.segoeui,
            fontSize: 13,
            color: const Color(0xff1e1e1e),
          ),
        ),
      ),
    );
  }
}
