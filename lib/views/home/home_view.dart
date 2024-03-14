import 'package:flutter/material.dart';
import 'package:fresh_find_admin/constants/constants.dart';
import 'package:fresh_find_admin/firebase/firebase_service.dart';
import 'package:fresh_find_admin/views/categorylist/category_list_view.dart';
import 'package:fresh_find_admin/views/orders/order_view.dart';
import 'package:fresh_find_admin/views/users/user_view.dart';
import 'package:fresh_find_admin/views/vendors/vendor_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    Text('Orders'),
    Text('Categories'),
    Text('Users'),
    Text('Vendors'),
    Text('Logout'),
  ];

  final List<Widget> _widgetPages = [
    OrderView(),
    CategoryListView(),
    UserListView(),
    VendorListView()
  ];

  Future<void> _onItemTapped(int index) async {
    if(index==_widgetOptions.length-1){
      await FirebaseService().logout();
      Navigator.pushNamedAndRemoveUntil(context, AppConstant.loginView, (route) => false);
    }else{
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetPages[_selectedIndex],
      appBar: AppBar(
        title: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.redAccent,
        indicatorColor: Colors.orangeAccent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Orders',
            selectedIcon: Icon(Icons.list_alt_outlined),
          ),
          NavigationDestination(
            icon: Icon(Icons.category),
            label: 'Category',
            selectedIcon: Icon(Icons.category_outlined),
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Users',
            selectedIcon: Icon(Icons.people_alt_outlined),
          ),
          NavigationDestination(
            icon: Icon(Icons.store),
            label: 'Vendors',
            selectedIcon: Icon(Icons.store_mall_directory_outlined),
          ),
          NavigationDestination(
            icon: Icon(Icons.logout),
            label: 'Logout',
            selectedIcon: Icon(Icons.exit_to_app),
          ),
        ],
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
