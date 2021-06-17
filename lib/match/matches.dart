import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import "../components/pageview.dart";
import '../util/dioUtil.dart';
import './components/match.dart';
import '../entity/matches.dart' as matchesEntity;

class MatchesPage extends StatefulWidget {
  MatchesPageState createState() {
    return new MatchesPageState();
  }
}

class MatchesPageState extends State<MatchesPage> {
  List data = [];
  int pageSize = 20;
  int page = 1;
  int count = 9999;
  bool isLoading = false;

  String playerID = "";

  static const URL = "players/%s/matches";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("全部比赛"),
      ),
      body: RefreshIndicator(
          child: LoadingListView(
              data: data,
              pageSize: pageSize,
              page: page,
              count: count,
              loadData: () => loadData(),
              isLoading: isLoading,
              itemBuilder: itemBuilder),
          onRefresh: () async {
            this.page = 1;
            loadData(true);
          }),
      // body: LoadingListView(
      //     data: data,
      //     pageSize: pageSize,
      //     page: page,
      //     count: count,
      //     loadData: () => loadData(),
      //     isLoading: isLoading,
      //     itemBuilder: itemBuilder),
    );
  }

  Widget itemBuilder(BuildContext context, item, [int index]) {
    return MatchComponent(item: matchesEntity.Matches.fromJson(item));
  }

  getPlayerId() {
    if (this.playerID == "") {
      final Map args = ModalRoute.of(context).settings.arguments;
      this.playerID = args["playerID"].toString();
    }
    return this.playerID;
  }

  loadData([refresh = false]) async {
    var pid = getPlayerId();
    if (isLoading == false && data.length < count && pid != "") {
      this.setState(() {
        isLoading = true;
      });

      try {
        var dio = new DioUtil();
        var resp = await dio.get(URL.replaceAll('%s', pid),
            {"page": this.page, "pageSize": this.pageSize});

        if (resp.data != null) {
          if (refresh != null && refresh == true) {
            this.setState(() {
              data = resp.data;
            });
          } else {
            this.setState(() {
              data.addAll(resp.data);
            });
          }

          if (resp.data.length >= pageSize) {
            this.setState(() {
              page = page + 1;
            });
          } else {
            this.setState(() {
              count = data.length;
            });
          }
        }
        this.setState(() {
          isLoading = false;
        });
      } catch (e) {
        print(e);
        this.setState(() {
          isLoading = false;
        });
      }
    }
  }
}
