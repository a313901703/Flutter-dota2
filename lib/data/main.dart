import 'package:flutter/material.dart';
import "package:flutter_spinkit/flutter_spinkit.dart";
import '../components/subhead.dart';
import './match.dart';
import '../global.dart';
import '../model/leagues.dart';
import 'package:provider/provider.dart';

class DataPage extends StatefulWidget {
  DataPageState createState() {
    return new DataPageState();
  }
}

class DataPageState extends State<DataPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ScrollController _controller = new ScrollController();

  bool isLoading = false;
  int page = 1;
  final int pageSize = 10;
  int count = 9999;
  List items = [];

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _loadData();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext content) {
    return Container(
      decoration: BoxDecoration(color: Global.bgColor),
      child: Container(
        child: ListView.separated(
            controller: _controller,
            physics: new ClampingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _header();
              }
              if (index >= this.items.length + 1) {
                return _renderBottom();
              }
              return new Match(
                index: index - 1,
                item: this.items[index - 1],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return new Divider(
                height: 0,
              );
            },
            itemCount: this.items.length + 2),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        new Subhead(label: "游戏资料", icon: Icons.person),
        _grids(),
        new Subhead(label: "官方赛事", icon: Icons.person),
      ],
    );
  }

  //顶部栏目
  Widget _grids() {
    List<Widget> items = new List();
    var _grids = [
      {"title": "英雄", 'icon': "images/dota2.png", "router": "/heroes"},
      {"title": "物品", 'icon': "images/items.png", "router": "/items"},
      {"title": "职业战队", 'icon': "images/team.png", "router": "/team"},
      {"title": "选手", 'icon': "images/users.png"},
      {"title": "数据专题", 'icon': "images/dota2.png"},
      {"title": "排行榜", 'icon': "images/dota2.png"},
      {"title": "数据直播", 'icon': "images/dota2.png"},
      // {"title": "英雄", 'icon': "images/dota2.png"},
    ];
    for (var i = 0; i < _grids.length; i++) {
      items.add(_renderGridItem(_grids[i]));
    }
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 10),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        // mainAxisSpacing: 10.0,
        // crossAxisSpacing: 10.0,
        // padding: const EdgeInsets.all(10.0),
        childAspectRatio: 1.3,
        shrinkWrap: true,
        children: items,
      ),
    );
  }

  Widget _renderGridItem(Map item) {
    return InkWell(
      //onTap: () => goRouter(item['router']),
      onTap: () {
        if (item['router'] != null) {
          Navigator.pushNamed(context, item['router']);
        }
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: <Widget>[
            Expanded(child: Image.asset(item["icon"])),
            Text(item['title'])
          ],
        ),
      ),
    );
  }

  Widget _renderBottom() {
    Widget _widget;
    if (items.length >= count) {
      _widget = Text("没有更多数据");
    } else if (isLoading == false) {
      return Container();
    } else {
      _widget = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(""),
          ),
          SpinKitFadingCircle(color: Colors.black, size: 20.0),
          Text("   加载中"),
          Expanded(
            child: Text(""),
          ),
        ],
      );
    }

    return Container(
      height: 40,
      alignment: Alignment.center,
      child: _widget,
    );
  }

  void goRouter(String router) {
    if (router != null && router.length >= 0) {
      Navigator.pushNamed(context, router);
    }
  }

  _loadData() async {
    if (isLoading == false && items.length < count) {
      this.setState(() {
        isLoading = true;
      });
      Provider.of<LeagueModel>(context, listen: false)
          .loadData(this.page, this.pageSize)
          .then((res) {
        this.setState(() {
          items = Provider.of<LeagueModel>(context, listen: false).lists;
          count = Provider.of<LeagueModel>(context, listen: false).count;
          isLoading = false;
        });
        if (items.length < count) {
          this.setState(() {
            page = page + 1;
          });
        }
      }).catchError((e) {
        this.setState(() {
          isLoading = false;
        });
      });
    }
  }
}
