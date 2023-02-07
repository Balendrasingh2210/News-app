import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/category_model.dart';

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
  }

  loadData() async {
    await Future.delayed(Duration(seconds: 2));
    final CategoryJson =
        await rootBundle.loadString("assets/files/Category-data.json");
    final decodeData = jsonDecode(CategoryJson);
    var CategoryData = decodeData["Category"];
    CategoryModel.categories = List.from(CategoryData)
        .map<Category>((categories) => Category.fromMap(categories))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
      body: Container(
        child: Column(
          children: [
            Container(
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
            )
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final imagUrl, categoryName;

  const CategoryTile({super.key, this.imagUrl, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [Image.network(imagUrl, width: 120, height: 60)]),
    );
  }
}
