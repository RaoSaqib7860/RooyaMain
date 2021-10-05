import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimerEffect extends StatefulWidget {
  const ShimerEffect({Key? key, this.child}) : super(key: key);
  final Widget? child;

  @override
  _ShimerEffectState createState() => _ShimerEffectState();
}

class _ShimerEffectState extends State<ShimerEffect> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: widget.child!,
    );
  }
}
