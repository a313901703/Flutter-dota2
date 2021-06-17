import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/PageView.dart';
import './news.dart';
import '../model/news.dart';
import './newsFull.dart';

class NewsPage extends StatefulWidget {
  NewsState createState() {
    return new NewsState();
  }
}

class NewsState extends State<NewsPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List data = [];
  int pageSize = 10;
  int page = 1;
  int count = 9999;
  bool isLoading = false;

  Widget build(BuildContext content) {
    return Container(
      padding: EdgeInsets.only(top: 3.0),
      //padding: const EdgeInsets.all(10.0),
      color: Colors.white,
      child: new LoadingListView(
          data: data,
          pageSize: pageSize,
          page: page,
          count: count,
          loadData: () => loadData(),
          isLoading: isLoading,
          itemBuilder: itemBuilder),
    );
  }

  Widget itemBuilder(BuildContext context, item, [int index]) {
    if (index != null && index % 5 == 0) {
      return Container(
        child: NewsFull(data: item),
      );
    }
    return Container(
      child: new NewsItem(
        data: item,
      ),
    );
  }

  loadData() async {
    if (isLoading == false && data.length < count) {
      this.setState(() {
        isLoading = true;
      });
      Provider.of<NewsModel>(context, listen: false)
          .loadData(this.page, this.pageSize)
          .then((res) {
        this.setState(() {
          data = Provider.of<NewsModel>(context, listen: false).lists;
          count = Provider.of<NewsModel>(context, listen: false).count;
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
