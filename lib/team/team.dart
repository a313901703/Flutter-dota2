import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/PageView.dart';
import '../model/team.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TeamPage extends StatefulWidget {
  TeamState createState() {
    return new TeamState();
  }
}

class TeamState extends State<TeamPage> {
  List data = [];
  int pageSize = 20;
  int page = 1;
  int count = 9999;
  bool isLoading = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("职业战队"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 3.0),
        //padding: const EdgeInsets.all(10.0),
        color: Colors.white,
        child: new LoadingListView(
            data: data,
            pageSize: pageSize,
            page: page,
            count: count,
            header: _readerHeader(),
            loadData: () => loadData(),
            isLoading: isLoading,
            itemBuilder: itemBuilder),
      ),
    );
  }

  Widget itemBuilder(BuildContext context, item, [int index]) {
    var winRate = (item["wins"] * 100 / (item["losses"] + item["wins"]))
            .toStringAsFixed(2) +
        "%";
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/teamInfo", arguments: {"item": item});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7),
        child: Row(
          children: <Widget>[
            Container(
                width: 30,
                alignment: Alignment.center,
                child: Text((index + 1).toString())),
            Container(
              margin: EdgeInsets.only(right: 10.0),
              padding: EdgeInsets.symmetric(vertical: 5.0),
              width: 60,
              height: 40,
              child: item["logo_url"] == null
                  ? Container()
                  : CachedNetworkImage(
                      imageUrl: item["logo_url"], fit: BoxFit.fill),
            ),
            Expanded(
                child: Container(
                    child: Text(
              item["name"],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ))),
            Container(width: 80, child: Text(winRate)),
            Container(
                width: 80,
                child: Text((item["wins"] + item["losses"]).toString())),
            //Container(width: 80, child: Text(item["rating"].toString())),
          ],
        ),
      ),
    );
  }

  Widget _readerHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(width: 30, alignment: Alignment.center, child: Text("排名")),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: Text("战队"),
          )),
          Container(width: 80, child: Text("胜率")),
          Container(width: 80, child: Text("场次")),
          //Container(width: 80, child: Text("rate")),
        ],
      ),
    );
  }

  loadData() async {
    if (isLoading == false && data.length < count) {
      this.setState(() {
        isLoading = true;
      });
      Provider.of<TeamModel>(context, listen: false)
          .loadData(this.page, this.pageSize)
          .then((res) {
        this.setState(() {
          data = Provider.of<TeamModel>(context, listen: false).lists;
          count = Provider.of<TeamModel>(context, listen: false).count;
          isLoading = false;
        });
        if (data.length < count) {
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
