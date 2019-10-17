// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:lpinyin/lpinyin.dart';

// class ContentList extends StatefulWidget {
//   ContentList({Key key}) : super(key: key);

//   final ValueChanged<void> onChanged;

//   // setData(int type, String keyword) {
//   //   this.type = type;
//   //   this.keyword = keyword;
//   //   if (state != null) {
//   //     state.setData(type, keyword);
//   //   }
//   // }

//   @override
//   State<StatefulWidget> createState() {
//     return _ContentListState();
//   }
// }

// class Cell {
//   int type;
//   String title;
//   List<String> answers;
//   String pinyin;
// }

// class _ContentListState extends State<ContentList> {
//   List<Cell> datas;
//   int loadCnt;
//   String keyword = '';
//   int type = -1;

//   _ContentListState(): super() {
//     // print(type);
//     datas = List();
//     loadCnt = 0;
//     loadConfigs();
//   }

//   setData(int type, String keyword) {
//     this.type = type;
//     this.keyword = keyword;
//     print('k:' + keyword);
//     this.setState((){});
//   }

//   getData() {
//     print(this.keyword);
//     if (this.keyword == null || this.keyword.length == 0) {
//       return datas;
//     }
//     var key = this.keyword.toLowerCase();
//     List<Cell> curDatas;
//     for (var data in datas) {
//       if (data.pinyin.indexOf(key) != -1) {
//         curDatas.add((data));
//       }
//     }
//     return curDatas;
//   }

//   loadConfig(String path, int type) {
//     rootBundle.loadString(path).then((String txt) {
//       // print(txt);
//       for (var line in txt.split('\n')) {
//         var words = line.split(',');
//         if (words.length < 2) continue;
//         var cell = Cell();
//         cell.type = type;
//         cell.title = words[1];
//         cell.answers = words.sublist(2);
//         cell.pinyin = PinyinHelper.getShortPinyin(cell.title).toLowerCase();
//         datas.add(cell);
//       }
//       if (++loadCnt == 3) {
//         this.setState(() {

//         });
//       }
//     });
//   }

//   loadConfigs() {
//     loadConfig('assets/RADIO.csv', 0);
//     loadConfig('assets/MULTISELECT.csv', 1);
//     loadConfig('assets/JUDGE.csv', 2);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var datas = this.getData();
//     var cnt = datas == null ? 0 : datas.length;
//     return ListView.builder(
//       padding: EdgeInsets.all(20),
//       itemCount: cnt,
//       itemBuilder: (BuildContext context, int idx) {
//         // return Text(datas[idx].title);
//         var data = datas[idx];
//         var children = List<Widget>();
//         children.add(
//           Row(children: <Widget>[
//             Expanded(
//               child: Text(
//                 '题目:' + data.title,
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Color(0xff000000)
//                 ),
//               ),
//             ),],
//           )
//         );
//         for (var answer in data.answers) {
//           children.add(
//             Row(children: <Widget>[
//               Expanded(
//                 child: Text(
//                   '答案:' + answer,
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Color(0xffff0000)
//                   ),
//                 ),
//               ),],
//             )
//           );
//         }
//         children.add(Padding(padding: EdgeInsets.all(20),));
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: children,
//         );
//       },
//     );
//   }

// }