import 'package:flutter/material.dart';
import 'package:shopease/common_widgets/background_image_wrapper.dart';
import 'package:shopease/screens/_main_screens/profile_page.dart';
import 'package:shopease/screens/_main_screens/search_products.dart';
import 'package:shopease/screens/_main_screens/wish_list_page.dart';
import 'package:shopease/screens/search_products_related/shopping_cart.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    RecycledItemsMain(),
    WishListPage(),
    ShoppingCart(
      isMainPage: true,
    ),
    ProfilePage(),
  ];

  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Exit', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
    return shouldExit ?? false; // Return `false` if the dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Intercept back button
      child: BackgroundImageWrapper(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _pages[_selectedIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            shadowColor: Colors.red,
            indicatorColor: Colors.redAccent[200],
            onDestinationSelected: _onItemTapped,
            backgroundColor: Colors.red[50],
            elevation: 3,
            height: 70,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home, size: 28, color: Colors.white),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_outline),
                selectedIcon:
                    Icon(Icons.favorite, size: 28, color: Colors.white),
                label: 'Wish List',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_cart_outlined),
                selectedIcon:
                    Icon(Icons.shopping_cart, size: 28, color: Colors.white),
                label: 'Cart',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person, size: 28, color: Colors.white),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
