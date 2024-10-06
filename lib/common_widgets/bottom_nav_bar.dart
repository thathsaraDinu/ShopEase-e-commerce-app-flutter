import 'package:flutter/material.dart';
import 'package:shoppingapp/common_widgets/background_image_wrapper.dart';
import 'package:shoppingapp/screens/_main_screens/profile_page.dart';
import 'package:shoppingapp/screens/_main_screens/recycled_items_main.dart';

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
    Center(child: Text('Search Page')),
    Center(child: Text('Settings Page')),
    Center(
      child: ProfilePage(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,

          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.teal, // Color for the selected item
          unselectedItemColor: Colors.grey[400], // Color for unselected items
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
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search, size: 30),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings, size: 30),
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
