import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../firebase/firebase_service.dart';
import '../../../models/category.dart';
import '../../../utils/app_util.dart';


class CategoryForm extends StatefulWidget {
  Category? category;

  CategoryForm(this.category);

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _desc = '';
  XFile? _newImage;
  String? existingImageUrl;

  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description cannot be empty';
    }
    return null;
  }

  Future<void> pickImage() async {
    var image = await AppUtil.pickImageFromGallery();

    if (image != null) {
      setState(() {
        _newImage = image;
      });
    }
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate() &&
        (existingImageUrl != null || _newImage != null)) {
      _formKey.currentState!.save();

      bool? result = await FirebaseService().addOrUpdateCategory(
          name: _name,
          description: _desc,
          newImage: _newImage,
          context: context,
          existingImageUrl: existingImageUrl,
          createdAt: widget.category?.createdAt,
          categoryId: widget.category?.id);

      if (result == true) {
        AppUtil.showToast('Category changed successfully');
        Navigator.pop(context);
      } else {
        AppUtil.showToast('Error occurred while managing category.');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.category != null) {
      existingImageUrl = widget.category!.imageUrl;
      _nameController.text = widget.category!.name;
      _descController.text = widget.category!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white.withOpacity(.7),
                    child: _newImage == null && existingImageUrl != null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.orange.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Image.network(
                                existingImageUrl!,
                                color: Colors.orange,
                              ),
                            ),
                          )
                        : _newImage != null
                            ? CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.orange.shade100,
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Image.file(
                                    File(_newImage!.path),
                                    color: Colors.orange,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.add,
                                size: 40,
                                color: Colors.grey,
                              ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(labelText: 'Category Name'),
                  onSaved: (value) {
                    _name = value ?? '';
                  },
                  validator: _validateName,
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _descController,
                  keyboardType: TextInputType.name,
                  decoration:
                      InputDecoration(labelText: 'Category Description'),
                  maxLines: 3,
                  onSaved: (value) {
                    _desc = value ?? '';
                  },
                  validator: _validateDescription,
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white
                    ),
                    child: Text(widget.category == null ? 'Add Category' : 'Update Category'),
                    onPressed: () {
                      _submitForm(context);
                    },
                  ),
                )

              ],
            ),
          ),
        ),
      ],
    );
  }
}
