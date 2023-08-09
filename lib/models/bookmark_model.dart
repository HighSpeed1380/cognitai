class BookmarkModel {
  String? key;
  String tweetId;
  String createdAt;
  String userId;

  BookmarkModel({
    this.key,
    required this.tweetId,
    required this.createdAt,
    required this.userId,
  });

  factory BookmarkModel.fromJson(Map<dynamic, dynamic> json) => BookmarkModel(
        key: json["key"] ?? json["tweetId"],
        userId: json["userId"],
        tweetId: json["tweetId"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "userId": userId,
        "tweetId": tweetId,
        "created_at": createdAt,
      };

  // new features
  factory BookmarkModel.fromSnapshot(final snapshot) {
    final newBookmark =
        BookmarkModel.fromJson(snapshot.data() as Map<String, dynamic>);
    newBookmark.key = snapshot.reference.id;
    return newBookmark;
  }
}
