import 'package:flutter/material.dart';
import 'package:fresh_find_admin/views/home/home_view.dart';
import 'package:fresh_find_admin/views/login/login_view.dart';
import 'package:fresh_find_admin/views/splash/splash_view.dart';

import '../constants/constants.dart';
import '../models/category.dart';
import '../views/category/category_view.dart';

class AppRoute {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstant.splashView:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );
      case AppConstant.loginView:
        return MaterialPageRoute(
          builder: (context) => LoginView(),
        );
      case AppConstant.homeView:
        return MaterialPageRoute(
          builder: (context) => HomeView(),
        );

      case AppConstant.categoryView:
        Category? category =
        settings.arguments != null ? settings.arguments as Category : null;

        return MaterialPageRoute(
          builder: (context) => CategoryView(
            category: category,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );
    }
  }
}
