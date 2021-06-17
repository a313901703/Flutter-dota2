import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import './components/searchBar.dart';

//page
import './home/main.dart';
import './data/main.dart';
import './new/main.dart';
import './hero/hero.dart';
import './hero/heroInfo.dart';
import './item/main.dart';
import './item/itemInfo.dart';
import './home/inputPlayerId.dart';
import './match/matchInfo.dart';
import './player/playerInfo.dart';
import './team/team.dart';
import './team/teamInfo.dart';
import './match/matches.dart';

//model
import './model/player.dart';
import './model/matchInfo.dart';
import './model/leagues.dart';
import './model/news.dart';
import './model/hero.dart';
import './model/item.dart';
import './model/team.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => PlayerModel()),
      ChangeNotifierProvider(create: (context) => MatchInfoModel()),
      ChangeNotifierProvider(create: (context) => LeagueModel()),
      ChangeNotifierProvider(create: (context) => NewsModel()),
      ChangeNotifierProvider(create: (context) => HeroModel()),
      ChangeNotifierProvider(create: (context) => ItemModel()),
      ChangeNotifierProvider(create: (context) => TeamModel()),
    ], child: MyApp()),
  );
  //ChangeNotifierProvider(
  //create: (context) => PlayerModel(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dota2',
      theme: new ThemeData(
        primaryColor: Colors.black,
        // backgroundColor: Color.fromRGBO(100, 200, 200, 1)
      ),
      //home: Home(),
      //home: MainPage(),
      initialRoute: "/",
      routes: {
        "/": (context) => MainPage(),
        //英雄
        "/heroes": (context) => new HeroPage(),
        "/hero/info": (context) => new HeroInfo(),
        //物品
        "/items": (context) => ItemPage(),
        "/item/info": (context) => ItemInfo(),
        //搜索玩家ID
        '/inputPlayerId': (context) => InputPlayerId(),
        //比赛
        '/matchInfo': (context) => MatchInfo(),
        '/matches': (context) => MatchesPage(),
        //玩家详情
        '/playerInfo': (context) => PlayerInfo(),
        //队伍
        '/team': (context) => TeamPage(),
        '/teamInfo': (context) => TeamInfoPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  //bottom bar tab index
  int tabIndex = 0;

  List<Map> pages = new List();

  var _pageController = PageController();

  void initState() {
    super.initState();
    pages
      ..add({"widget": new Home(), 'title': "我的"})
      ..add({"widget": new DataPage(), 'title': "赛事"})
      ..add({"widget": new NewsPage(), 'title': "新闻"});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(pages[tabIndex]['title']),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchBarDelegate());
            },
          )
        ],
      ),
      body: SafeArea(
        child: PageView.builder(
            //要点1
            physics: NeverScrollableScrollPhysics(),
            //禁止页面左右滑动切换
            controller: _pageController,
            onPageChanged: _pageChanged,
            //回调函数
            itemCount: pages.length,
            itemBuilder: (context, index) => pages[index]['widget']),
      ),
      bottomNavigationBar: new BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
                title: Text('我的'), icon: new Icon(Icons.account_circle)),
            new BottomNavigationBarItem(
                title: Text('数据'), icon: new Icon(Icons.pie_chart_outlined)),
            new BottomNavigationBarItem(
                title: Text('新闻'), icon: new Icon(Icons.insert_comment)),
          ],
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
          currentIndex: tabIndex,
          backgroundColor: Color.fromRGBO(245, 245, 245, 1)),
    );
  }

  void _pageChanged(int index) {
    setState(() {
      if (tabIndex != index) tabIndex = index;
    });
  }
}
