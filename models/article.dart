import 'package:qiita_search/models/user.dart';

class Article {
  //Constructor
  Article({
    required this.title,
    required this.user,
    this.likesCount = 0, //default 0
    this.tags = const [], //default ""
    required this.createdAt,
    required this.url,
  });

  final String title;
  final User user;
  final int likesCount;
  final List<String> tags;
  final DateTime createdAt;
  final String url;

  // JsonからArticleを生成
  factory Article.fromJson(dynamic json){
    return Article(
      title: json['title'] as String,
      user: User.fromJson(json['user']), // Userを生成
      url: json['url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      likesCount: json['likes_count'] as int,
      tags: List<String>.from(json['tags'].map((tag) => tag['name'])),
    );
  }
}