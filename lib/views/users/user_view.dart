import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../firebase/firebase_service.dart';
import '../../models/user.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: StreamBuilder<List<UserData>>(
          stream: FirebaseService().userStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Shimmer loading effect
              return ListView.builder(
                itemCount: 6, // Number of shimmer items to show
                itemBuilder: (_, __) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ShimmerLayout(),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    UserData user = snapshot.data![index];
                    return UserCard(user: user);
                  },
                ),
              );
            } else {
              return Center(
                child: Text('No users found'),
              );
            }
          },
        ),
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: ShimmerWidget.circular(
              width: 64,
              height: 64,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          title: Align(
            alignment: Alignment.centerLeft,
            child: ShimmerWidget.rectangular(height: 16),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ShimmerWidget.rectangular(height: 14),
          ),
        ),
      ),
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({
    this.width = double.infinity,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.circular({
    required this.width,
    required this.height,
    required this.shapeBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: Colors.grey[400]!,
        shape: shapeBorder,
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final UserData user;

  const UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      surfaceTintColor: Colors.white,
      margin: EdgeInsets.all(4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch(
                  value: user.isActive,
                  onChanged: (value) {
                    FirebaseService().updateUserStatus(value, user.id);
                  },
                )
              ],
            ),

            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.account_box_rounded, color: Colors.orange),
                SizedBox(width: 8),
                Text(user.id),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.green),
                SizedBox(width: 8),
                Text(user.contact),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.email, color: Colors.blue),
                SizedBox(width: 8),
                Text(user.email),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
