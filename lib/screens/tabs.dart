import 'package:flutter/material.dart';
import 'package:pets_tracker/screens/view_pets.dart';
import 'package:pets_tracker/data/dummy_data.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = PetsScreen(
      allPets: dummyPets,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pets Tracker",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF424141),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF424141),
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            label: 'View Pets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_outlined),
            label: 'Add Pets',
          ),
        ],
      ),
    );
  }
}
