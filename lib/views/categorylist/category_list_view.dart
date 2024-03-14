import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/constants.dart';
import '../../firebase/firebase_service.dart';
import '../../models/category.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  Future<void> _showDeleteDialog(Category category, BuildContext context) async {
    var res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('DELETE'),
            ),
          ],
        );
      },
    );

    if (res) {
      await FirebaseService().deleteCategory(category.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: StreamBuilder<List<Category>>(
          stream: FirebaseService().categoryStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Use Shimmer while loading
              return ListView.builder(
                itemCount: 10, // Number of shimmer items
                itemBuilder: (_, __) => ShimmerCategoryCard(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Category category = snapshot.data![index];
                    return CategoryCard(category: category, onDelete: () => _showDeleteDialog(category, context));
                  },
                ),
              );
            } else {
              return Center(child: Text('No categories found'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppConstant.categoryView),
        backgroundColor: Colors.orangeAccent.shade100,
        child: Icon(Icons.add),
      ),
    );
  }
}

class ShimmerCategoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
          ),
          title: Container(
            width: double.infinity,
            height: 8.0,
            color: Colors.white,
          ),
          subtitle: Container(
            margin: EdgeInsets.only(top: 5.0),
            width: double.infinity,
            height: 8.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onDelete;

  const CategoryCard({required this.category, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          onTap: () => Navigator.pushNamed(context, AppConstant.categoryView, arguments: category),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green.shade100,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.network(
                category.imageUrl,
                color: Colors.green.shade800,
              ),
            ),
          ),
          title: Text(category.name, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(category.description),
          trailing: IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete, color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}
