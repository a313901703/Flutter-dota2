import 'package:flutter/material.dart';

class Subhead extends StatelessWidget {
  Subhead({@required this.label, this.icon, this.operate});
  final String label;
  final icon;
  final Widget operate;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = new List();
    if (this.icon is IconData) {
      items.add(Icon(this.icon, size: 15.0));
    }
    items.add(Text(' ' + this.label));
    if (this.operate != null && this.operate is Widget) {
      items.add(Expanded(
          child: Container(
              alignment: Alignment.centerRight, child: this.operate)));
    }
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: items,
      ),
    );
  }
}
