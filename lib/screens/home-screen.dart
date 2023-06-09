import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/models/article-models.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/utils/article_tile.dart';
import '../utils/category-tile.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    loadData();
    _fetchNews();
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

  Future<void> _fetchNews() async {
    const String url =
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=faa4d4d9d1914a65ab1578e749493eb8";
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 70,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: CategoryModel.categories.length,
              itemBuilder: (context, index) {
                return CategoryTile(
                  imagUrl: CategoryModel.categories[index].imageUrl,
                  categoryName: CategoryModel.categories[index].name,
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return ArticleTile(
                    title: articles[index].title ?? "title not available",
                    description: articles[index].description ??
                        "description not available",
                    urlToImage:
                        articles[index].urlToImage ?? "image not available",
                    url: articles[index].url!,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
