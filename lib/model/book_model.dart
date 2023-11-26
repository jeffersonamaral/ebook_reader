class BookModel {
  late int id;

  late String title;

  late String author;

  late String coverUrl;

  late String downloadUrl;

  bool favorite = false;

  BookModel(this.id, this.title, this.author, this.coverUrl, this.downloadUrl);

  BookModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    author = map['author'];
    coverUrl = map['cover_url'];
    downloadUrl = map['download_url'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'cover_url': coverUrl,
      'download_url': downloadUrl,
    };
  }
}