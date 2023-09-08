class User{
  //constructor
  User({
    required this.id,
    required this.profileImageUrl,
  });
  //property
  final String id;
  final String profileImageUrl;

  //受け取ったJsonからUserを生成するconstructor
  //dynamic型としてJsonを受け取り、１つ１つ展開する
  factory User.fromJson(dynamic json){
    return User(
      id: json['id'] as String,
      profileImageUrl: json['profile_image_url'] as String,
    );
  }
}