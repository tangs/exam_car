import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lpinyin/lpinyin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '汽车维修',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '汽车维修查询系统'),
    );
  }
}

class Cell {
  int type;
  String title;
  List<String> answers;
  String pinyin;
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> 
    with TickerProviderStateMixin {

  String keyword = '';
  int type = 3;
  List<Cell> datas;
  int loadCnt = 0;

  _MyHomePageState(): super() {
    datas = List();
    loadConfigs();
  }

  void update() {
    setState(() {
    });
  }

  loadConfig(String path, int type) {
    rootBundle.loadString(path).then((String txt) {
      // print(txt);
      for (var line in txt.split('\n')) {
        var words = line.split(',');
        if (words.length < 2) continue;
        var cell = Cell();
        cell.type = type;
        cell.title = words[1];
        cell.answers = words.sublist(2);
        cell.pinyin = PinyinHelper.getShortPinyin(cell.title).toLowerCase();
        datas.add(cell);
      }
      if (++loadCnt == 3) {
        this.setState(() {

        });
      }
    });
  }

  loadConfigs() {
    loadConfig('assets/RADIO.csv', 0);
    loadConfig('assets/MULTISELECT.csv', 1);
    loadConfig('assets/JUDGE.csv', 2);
  }

  List<Cell> getData() {
    print(this.keyword);
    if (this.keyword == null || this.keyword.length == 0) {
      return datas;
    }
    var key = this.keyword.toLowerCase();
    List<Cell> curDatas = [];
    for (var cell in datas) {
      if (type != 3 && type != cell.type) {
        continue;
      }
      if (cell.pinyin.indexOf(key) != -1) {
        curDatas.add((cell));
      }
    }
    curDatas.sort((cell1, cell2) {
      var num1 = cell1.pinyin.indexOf(key);
      var num2 = cell2.pinyin.indexOf(key);
      return num1 - num2;
    });
    return curDatas;
  }

  ListView getList() {
    var datas = this.getData();
    var cnt = datas == null ? 0 : datas.length;
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: cnt,
      itemBuilder: (BuildContext context, int idx) {
        // return Text(datas[idx].title);
        var data = datas[idx];
        var children = List<Widget>();
        children.add(
          Row(children: <Widget>[
            Expanded(
              child: Text(
                '题目:' + data.title,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff000000)
                ),
              ),
            ),],
          )
        );
        for (var answer in data.answers) {
          children.add(
            Row(children: <Widget>[
              Expanded(
                child: Text(
                  '答案:' + answer,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xffff0000)
                  ),
                ),
              ),],
            )
          );
        }
        children.add(
          Row(children: <Widget>[
            Expanded(
              child: Text(
                'keyword:' + data.pinyin.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff777700)
                ),
              ),
            ),],
          )
        );
        children.add(Padding(padding: EdgeInsets.all(20),));
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: children,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[            
            Expanded(
              child: TextFormField(
                initialValue: this.keyword,
                onChanged:(txt) {
                  print(txt);
                  this.keyword = txt;
                  this.update();
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TabBar(
                    unselectedLabelColor: Colors.green,
                    labelColor: Colors.orange,
                    onTap: (idx) {
                      print(idx);
                      this.type = idx;
                      this.update();
                    },
                    tabs: <Widget>[
                      Tab(text: '单选题',),
                      Tab(text: '多选题',),
                      Tab(text: '判断',),
                      Tab(text: '全部',),
                    ],
                    controller: TabController(
                      initialIndex: this.type,
                      length: 4,
                      vsync: this,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: getList(),
            )
          ],
        ),
      ),
    );
  }
}
