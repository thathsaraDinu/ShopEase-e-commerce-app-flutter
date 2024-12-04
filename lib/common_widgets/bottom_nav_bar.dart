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
    Center(child: RecycledItemsMain()),
    Center(child: WishListPage()),
    Center(child: ShoppingCart(isMainPage: true,)),
    Center(
      child: ProfilePage(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    var red = Colors.red[900];
    return BackgroundImageWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.red[100],
          type: BottomNavigationBarType.fixed,
          selectedItemColor: red, // Color for the selected item
          unselectedItemColor: Colors.red[300], // Color for unselected items
          showUnselectedLabels: false, // Hides unselected labels
          showSelectedLabels: false, // Hides selected labels
          elevation: 15, // Adds shadow effect
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon:
                  Icon(Icons.home, size: 30), // Active icon with larger size
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite, size: 30),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart, size: 30),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person, size: 30),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
