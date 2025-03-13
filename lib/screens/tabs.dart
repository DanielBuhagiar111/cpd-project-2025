import 'package:flutter/material.dart';
import 'package:pets_tracker/screens/add_pet.dart';
import 'package:pets_tracker/screens/view_pets.dart';
import 'package:pets_tracker/data/dummy_data.dart';
import 'package:pets_tracker/models/pet.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0; // To keep track of the selected tab

  // Pet data for the view
  final List<Pet> _pets = dummyPets;

  // Function to add a new pet
  void _addNewPet(Pet pet) {
    setState(() {
      _pets.add(pet);
    });
  }

  // Function to handle page change (tab selection)
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Active screen widget
    Widget activePage = PetsScreen(
      allPets: _pets,
    );

    // Change active screen based on selected index
    if (_selectedPageIndex == 1) {
      activePage = AddPet(
        onAddPet: _addNewPet, // Pass the callback to AddPet
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pets Tracker", // Use the active page title
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF424141),
      ),
      body: activePage, // Show active page based on the selected tab
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF424141),
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.black, // Highlight selected icon
        unselectedItemColor: Colors.grey,
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
