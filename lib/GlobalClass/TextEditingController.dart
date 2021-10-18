import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFromFieldsCustom extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final Widget? posticon;

  const TextFromFieldsCustom(
      {Key? key, this.controller, this.hint, this.posticon})
      : super(key: key);

  @override
  _TextFromFieldsCustomState createState() => _TextFromFieldsCustomState();
}

class _TextFromFieldsCustomState extends State<TextFromFieldsCustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.040,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        color: Colors.grey[200],
      ),
      child: TextFormField(
        cursorColor: Colors.black,
        controller: widget.controller,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
            suffixIcon: widget.posticon,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 15),
            hintStyle: TextStyle(color: Colors.black45, fontSize: 10),
            hintText: widget.hint!),
      ),
    );
  }
}
