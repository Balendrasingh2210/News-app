import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/article-models.dart';
import '../models/category_model.dart';
import '../utils/article_tile.dart';

class CategoryNews extends StatefulWidget {
  const CategoryNews({super.key});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  late final String category;

  @override
  void initState() {
    super.initState();
    loadData();
    _fetchNews(category);
  }

  loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    final categoryJson =
        await rootBundle.loadString("assets/files/Category-data.json");
    final decodeData = jsonDecode(categoryJson);
    var categoryData = decodeData["Category"];
    CategoryModel.categories = List.from(categoryData)
        .map<Category>((categories) => Category.fromMap(categories))
        .toList();
    setState(() {});
  }

  Future<void> _fetchNews(String category) async {
    String url =
        "https://newsapi.org/v2/top-headlines?category=$category&=in&apiKey=faa4d4d9d1914a65ab1578e749493eb8";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);

      var articlesList = responseJson['articles'] as List<dynamic>;
      List<ArticleModel> list = articlesList
          .map(
            (map) => ArticleModel.fromJson(map),
          )
          .toList();
      ArticleModel.articleList = list;
    } else {
      throw Exception('failed to fetch news');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ArticleModel> articles = ArticleModel.articleList;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, // <-- SEE HERE
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Daily",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "News",
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return ArticleTile(
                title: articles[index].title ?? "title not available",
                description:
                    articles[index].description ?? "description not available",
                urlToImage: articles[index].urlToImage ?? "image not available",
                url: articles[index].url!,
              );
            },
          ),
        ),
      ),
    );
  }
}
