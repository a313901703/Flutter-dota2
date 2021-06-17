import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsItem extends StatelessWidget {
  NewsItem({Key key, @required this.data});
  final Map data;

  final double _itemHeight = 100;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      child: Row(
        children: <Widget>[
          _renderLeft(),
          Expanded(
            child: _renderRight(),
          )
        ],
      ),
    );
  }

  Widget _renderLeft() {
    return Container(
      //padding: const EdgeInsets.only(left: 5),
      child: CachedNetworkImage(
        imageUrl: this.data['thumb'],
        width: _itemHeight * 1.4,
        height: _itemHeight,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _renderRight() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[_renderTitle(), _renderInfo()],
      ),
    );
  }

  Widget _renderTitle() {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            this.data['title'],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ))
        ],
      ),
    );
  }

  Widget _renderInfo() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            this.data['date'],
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.remove_red_eye,
                size: 15,
                color: Colors.grey,
              ),
              Text(
                "  0",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }
}
