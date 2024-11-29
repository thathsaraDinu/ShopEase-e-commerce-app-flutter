import 'package:flutter/material.dart';
import 'package:shopease/common_widgets/bottom_nav_bar.dart';
import 'package:shopease/common_widgets/widget_tree.dart';
import 'package:shopease/screens/recycled_items_related/product_page.dart';
import 'package:shopease/screens/_main_screens/recycled_items_main.dart';
import 'package:shopease/screens/recycled_items_related/shopping_cart.dart';
import 'package:shopease/screens/_main_screens/signup_login_page.dart';
// Make sure to import all your page files

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/productpage': (context) => const ProductPage(),
      '/shoppingcart': (context) => const ShoppingCart(),
      '/recycleditemsmain': (context) => const RecycledItemsMain(),
      '/bottomnavbar': (context) => const BottomNavBar(),
      '/': (context) => const WidgetTree(),
      '/signupandlogin': (context) => const SignupLoginPage(),
    };
  }
}
