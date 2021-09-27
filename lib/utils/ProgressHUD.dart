import 'package:flutter/material.dart';

class ProgressHUD extends StatelessWidget {

  final Widget? child;
  final bool? inAsyncCall;
  final double? opacity;
  final Color? color;
  final Animation<Color>? valueColor;

  ProgressHUD({
    Key? key,
    @required this.child,
    @required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.black,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList =  <Widget>[];
    widgetList.add(child!);
    if (inAsyncCall!) {
      final modal = new Stack(
        children: [
          new Opacity(
            opacity: opacity!,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          new Center(
            child: CircularProgressIndicator(),
//            Image(
//              height: 100,
//              image: AssetImage('assets/images/loading1.gif'),
//            ),
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}