import 'package:flutter/material.dart';
import 'bags_page.dart';
import 'shop_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void setPageindex(int index){
  setState(() {
    _currentindex=index;
  });
}
  int _currentindex = 0;
  List<Widget> Pages = [const ShopPage(), const BagsPage(),const FavoritePage(), const ProfilePage()];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Pages[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentindex,
        onTap: setPageindex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Shopping'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Bag'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'favorite'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile'),
        ]),
    );
  }
  }

  

