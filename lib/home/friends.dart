import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Friends extends StatelessWidget {
  final friends;

  Friends({Key key, this.friends});

  double _itemWidth;
  @override
  Widget build(BuildContext context) {
    _itemWidth = MediaQuery.of(context).size.width;
    List<Widget> widgets = new List();
    this.friends.forEach((v) {
      if (v["withGames"] != null && v["withGames"] > 0 && widgets.length < 10) {
        widgets.add(_friend(v, context));
      }
    });
    //widgets.add()
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      color: Colors.white,
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        children: widgets,
      ),
    );
  }

  Widget _friend(Map item, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/playerInfo', arguments: {"item": item});
      },
      child: Container(
        width: _itemWidth / 4,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              //height: 35,
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  item["avatar"],
                ),
              ),
            ),
            Text(item["personaname"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
