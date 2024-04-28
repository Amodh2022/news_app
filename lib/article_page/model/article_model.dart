class Article {
  String? status;
  int? totalResults;
  List<ArticleData>? articleData;

  Article({this.status, this.articleData, this.totalResults});

  factory Article.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['articles'] as List;
    List<ArticleData> articlesList =
        list.map((i) => ArticleData.fromJson(i)).toList();
    return Article(
        status: parsedJson['status'],
        totalResults: parsedJson['totalResults'],
        articleData: articlesList);
  }
}

class ArticleData {
  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  ArticleData(
      {this.source,
      this.author,
      this.title,
      this.description,
      this.url,
      this.content,
      this.publishedAt,
      this.urlToImage});

  factory ArticleData.fromJson(Map<String, dynamic> parsedJson) {
    return ArticleData(
        source: Source.fromJson(parsedJson['source']),
        author: parsedJson['author'],
        title: parsedJson['title'],
        description: parsedJson['description'],
        url: parsedJson['url'],
        urlToImage: parsedJson['urlToImage'],
        publishedAt: parsedJson['publishedAt'],
        content: parsedJson['content']);
  }
}

class Source {
  String? id;
  String? name;

  Source({this.id, this.name});
  factory Source.fromJson(Map<String, dynamic> parsedJson) {
    return Source(id: parsedJson['id'], name: parsedJson['name']);
  }
}
