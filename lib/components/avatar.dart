import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  Avatar({@required this.width, @required this.height, @required this.src});
  final double width;
  final double height;
  final String src;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: NetworkImage(this.src))),
    );
  }
}
