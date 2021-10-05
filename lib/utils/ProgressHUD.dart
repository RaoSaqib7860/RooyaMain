import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProgressHUD extends StatefulWidget {
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
  _ProgressHUDState createState() => _ProgressHUDState();
}

class _ProgressHUDState extends State<ProgressHUD>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = <Widget>[];
    widgetList.add(widget.child!);
    if (widget.inAsyncCall!) {
      final modal = new Stack(
        children: [
          new Opacity(
            opacity: widget.opacity!,
            child: ModalBarrier(dismissible: false, color: widget.color),
          ),
          new Center(
            child: SpinKitSpinningLines(
              color: Colors.white,
              size: 50.0,
            ),
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
