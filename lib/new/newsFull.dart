import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../global.dart';

class NewsFull extends StatelessWidget {
  NewsFull({Key key, @required this.data});
  final Map data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: data['thumb'],
          imageBuilder: (context, imageProvider) => Container(
            height: 200,
            decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.fill)),
          ),
        ),
        Positioned(
          child: Container(
            width: Global.physicalWidth / Global.dpr,
            child: Text(
              data['title'],
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          bottom: 30,
        ),
        Positioned(
          child: Container(
            //color: Colors.black,
            child: Text(
              data['date'],
              style: TextStyle(color: Colors.white),
            ),
          ),
          bottom: 5,
        ),
      ],
      alignment: Alignment.bottomCenter,
    );
  }
}
