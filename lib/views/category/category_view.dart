import 'package:flutter/material.dart';

import '../../models/category.dart';
import 'components/category_form.dart';


class CategoryView extends StatelessWidget {

  Category? category;


  CategoryView({this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Category',
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: CategoryForm(category),
          ),
        ),
      ),
    );
  }
}
