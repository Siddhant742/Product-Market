import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ProductTabs extends StatelessWidget {
  final TabController tabController;
  final String description;
  final String ingredients;
  final String howToUse;

  const ProductTabs({
    Key? key,
    required this.tabController,
    required this.description,
    required this.ingredients,
    required this.howToUse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Product Description'),
            Tab(text: 'Product Ingredients'),
            Tab(text: 'How To Use'),
          ],
        ),
        SizedBox(
          height: 200,
          child: TabBarView(
            controller: tabController,
            children: [
              SingleChildScrollView(
                child: Html(data: description),
              ),
              SingleChildScrollView(
                child: Html(data: ingredients),
              ),
              SingleChildScrollView(
                child: Html(data: howToUse),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
