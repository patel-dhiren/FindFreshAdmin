import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fresh_find_admin/models/vendor.dart';
import 'package:image_picker/image_picker.dart';

import '../models/category.dart';
import '../models/order.dart';
import '../models/user.dart';



class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Stream<List<UserData>> get userStream {
    return _database.ref().child('users').onValue.map((event) {
      List<UserData> categories = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> userMap =
        event.snapshot.value as Map<dynamic, dynamic>;
        userMap.forEach((key, value) {
          final user = UserData.fromJson(value);
          categories.add(user);
        });
      }
      return categories;
    });
  }

  Future<void> updateUserStatus(bool status, String uid) async {
    try {
      await _database.ref("users").child(uid).update({
        'isActive': status,
        // You can add more fields to update here if needed
      });
    } catch (e) {
      print('Error updating user data: $e');
      throw e;
    }
  }

  Future<void> updateVendorStatus(bool status, String uid) async {
    try {
      await _database.ref("vendors").child(uid).update({
        'isActive': status,
        // You can add more fields to update here if needed
      });
    } catch (e) {
      print('Error updating vendor status: $e');
      throw e;
    }
  }


  Stream<List<Vendor>> get vendorStream {
    return _database.ref().child('vendors').onValue.map((event) {
      List<Vendor> vendors = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> vendorMap =
        event.snapshot.value as Map<dynamic, dynamic>;
        vendorMap.forEach((key, value) {
          final user = Vendor.fromJson(value);
          vendors.add(user);
        });
      }
      return vendors;
    });
  }

  Stream<List<Category>> get categoryStream {
    return _database.ref().child('categories').onValue.map((event) {
      List<Category> categories = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> categoriesMap =
        event.snapshot.value as Map<dynamic, dynamic>;
        categoriesMap.forEach((key, value) {
          final category = Category.fromJson(value);
          categories.add(category);
        });
      }
      return categories;
    });
  }

  Future<bool> deleteCategory(String categoryId) async {
    try {
      await _database.ref().child('categories').child(categoryId).remove();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool?> addOrUpdateCategory(
      {String? categoryId,
        required String name,
        required String description,
        XFile? newImage,
        String? existingImageUrl,
        int? createdAt,
        required BuildContext context}) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            )),
      );

      String imageUrl = existingImageUrl ?? '';
      if (newImage != null) {
        // If a new image is selected, upload it
        String filePath =
            'categories/${DateTime.now().millisecondsSinceEpoch}.png';
        File file = File(newImage.path);
        TaskSnapshot snapshot =
        await _storage.ref().child(filePath).putFile(file);
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      int timestamp = createdAt ?? DateTime.now().millisecondsSinceEpoch;

      Category category = Category(
          id: categoryId,
          name: name,
          description: description,
          imageUrl: imageUrl,
          createdAt: timestamp);

      if (categoryId == null) {
        var id = _database.ref().child('categories').push().key;
        category.id = id;
        await _database
            .ref()
            .child('categories')
            .child(id!)
            .set(category.toJson());
      } else {
        // Update existing category
        await _database
            .ref()
            .child('categories')
            .child(categoryId)
            .update(category.toJson());
      }
      Navigator.pop(context);
      return true;
    } catch (e) {
      print(e);
      Navigator.pop(context);
      return false;
    }
  }

  Stream<List<Order>> get orderStream {


    return _database
        .ref()
        .child('orders')
        .onValue
        .map((event) {
      dynamic ordersMap = event.snapshot.value ?? {};
      List<Order> orders = [];
      ordersMap.forEach((key, value) {
        orders.add(Order.fromJson(Map<String, dynamic>.from(value)));
      });
      return orders;
    });
  }


  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

}
