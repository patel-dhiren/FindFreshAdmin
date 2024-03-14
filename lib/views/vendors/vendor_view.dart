import 'package:flutter/material.dart';
import 'package:fresh_find_admin/models/vendor.dart';
import 'package:shimmer/shimmer.dart';

import '../../firebase/firebase_service.dart';

class VendorListView extends StatefulWidget {
  const VendorListView({super.key});

  @override
  State<VendorListView> createState() => _VendorListViewState();
}

class _VendorListViewState extends State<VendorListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: StreamBuilder<List<Vendor>>(
          stream: FirebaseService().vendorStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                itemCount: 12, // Number of shimmer items
                itemBuilder: (_, __) => ShimmerLayout(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Vendor vendor = snapshot.data![index];
                    return VendorCard(vendor: vendor);
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
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 24,
        ),
        title: Container(
          height: 10,
          width: double.infinity,
          color: Colors.white,
        ),
        subtitle: Container(
          height: 10,
          width: double.infinity,
          color: Colors.white,
          margin: EdgeInsets.only(top: 5),
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

class VendorCard extends StatelessWidget {
  final Vendor vendor;

  const VendorCard({required this.vendor});

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
              Text(
                vendor.businessName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.person, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(vendor.vendorName),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.account_box_rounded, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(vendor.id!),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.green),
                  SizedBox(width: 8),
                  Text(vendor.contactNumber),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(child: Text('${vendor.address}, ${vendor.city}, ${vendor.state}')),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.email, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(vendor.email),
                ],
              ),
            ],
          ),
        ),
      );
  }

}
