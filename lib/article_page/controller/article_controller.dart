import 'dart:convert';
import 'package:article/article_page/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/article_model.dart';

class ArticleController {
  final List<Widget> tabWidget = [
    Tab(
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            const Icon(
              Icons.list_rounded,
              size: 28,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "News",
              style: robotoTextTab(20, FontWeight.w700),
            ),
          ],
        ),
      ),
    ),
    Tab(
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            const Icon(
              Icons.favorite,
              size: 28,
              color: Colors.red,
            ),
            const SizedBox(
              width: 10,
            ),
            Text("Favs", style: robotoTextTab(20, FontWeight.w700))
          ],
        ),
      ),
    ),
  ];

  List<ArticleData> articleData = [];

  List<ArticleData> fav = [];

  Future<Article> fetchArticle(String date) async {
    String url =
        "https://newsapi.org/v2/everything?q=tesla&from=2024-04-24&sortBy=publishedAt&apiKey=8aa8f4f91bb5414cbe669cd59f08092a";
    http.Response response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    return Article.fromJson(data);
  }
}
