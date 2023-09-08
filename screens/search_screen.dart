import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // httpという変数を通して、httpパッケージにアクセス
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qiita_search/models/article.dart';
import 'package:qiita_search/widgets/article_container.dart';
import 'package:qiita_search/models/user.dart';

Future<List<Article>> searchQiita(String keyword) async {
  //1. http通信に必要なデータを準備
  // Uri.https([baseUrl], [Urlパス], Map<String,dynamic>[クエリパラメータ])
  final uri = Uri.https('qiita.com', '/api/v2/items', {
    'query': 'title:$keyword', // タイトルで検索をかけるため
    'per_page': '10',
  });
  // アクセストークンを取得
  final String token = dotenv.env['QIITA_ACCESS_TOKEN'] ?? '';
  //2. Qiita APIにリクエストを送る
  // アクセストークンを含めてリクエストを送信
  final http.Response res = await http.get(uri, headers: {
    'Authorization': 'Bearer $token',
  });
  //3. 戻り値をArticleクラスの配列に変換し、変換した配列を返す
  if (res.statusCode == 200) {
    // モデルクラスへ変換
    final List<dynamic> body = jsonDecode(res.body);
    return body.map((dynamic json) => Article.fromJson(json)).toList();
  } else {
    return [];
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Article> articles = []; //検索結果を格納する変数

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qiita Search'),
      ),
      body: Column(
        children: <Widget>[
          //検索ボックス
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 36,
            ),
            child: TextField(
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'search',
                hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
              ),
              onSubmitted: (value) async {
                final result = await searchQiita(value);//検索処理実行
                setState(()=>articles = result);//検索結果を代入
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: articles
                  .map((article)=> ArticleContainer(article: article))
                  .toList(),
            )
          )
        ]
      ),
    );
  }
}