import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/item.dart';

class ItemPage extends StatefulWidget {
  State createState() {
    return new ItemPageState();
  }
}

class ItemPageState extends State<ItemPage> {
  bool isAscending = true;

  List lists = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _setLists(Provider.of<ItemModel>(context, listen: false).lists);
      Provider.of<ItemModel>(context, listen: false).loadData().then((res) {
        if (!res.isEmpty) {
          _setLists(res);
        }
      });
    });
  }

  void _setLists(List data) {
    List fliterLists = [];
    data.forEach((v) {
      if (v["thumb"] != '' && v["counts"] != "") {
        if (v['counts'] == "") {
          v['counts'] = "0";
          v["winRate"] = "0.00%";
        }
        v["winPercent"] = double.parse(v["winRate"].replaceAll("%", ""));
        fliterLists.add(v);
      }
    });
    fliterLists
        .sort((a, b) => ((b["winPercent"] - a['winPercent']) * 100).toInt());
    this.setState(() {
      lists = fliterLists;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("物品"),
      ),
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.separated(
          physics: new ClampingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return _item(context, index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return new Divider(
              height: 0,
            );
          },
          itemCount: lists.length + 1),
    );
  }

  Widget _header() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Container(
              padding: EdgeInsets.only(left: 5),
              child: Text("物品"),
            )),
            Container(
              width: 80,
              child: Text("胜率"),
            ),
            Container(
              width: 80,
              child: Text(
                "场次",
                //style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ));
  }

  Widget _item(BuildContext context, int index) {
    if (index == 0) {
      return _header();
    }
    index = index - 1;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/item/info",
            arguments: {"item": lists[index]});
      },
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 50,
              child: CachedNetworkImage(
                imageUrl: lists[index]["thumb"],
                width: 50,
                height: 30,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(lists[index]["cnName"]),
            )),
            Container(
              width: 80,
              child: Text(lists[index]["winRate"]),
            ),
            Container(
              width: 80,
              child: Text(
                lists[index]["counts"],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
