import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pets_tracker/screens/add_pet.dart';
import 'package:pets_tracker/screens/view_pets.dart';
import 'package:pets_tracker/models/pet.dart';
import 'package:pets_tracker/screens/pet_details.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  int? _selectedImageIndex;

  Future<List<Pet>> _loadPets() async {
    final url = Uri.https(
      'cpd-project-2025-default-rtdb.europe-west1.firebasedatabase.app',
      'pets.json',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> firebaseData = json.decode(response.body);

        if (firebaseData.isNotEmpty) {
          final List<Pet> loadedList = [];
          firebaseData.forEach((id, petData) {
            final Pet pet = Pet(
              id: id,
              name: petData["name"],
              species: petData["species"],
              dob: DateTime.parse(petData["dob"]),
              images: List<String>.from(petData["images"] ?? []),
            );
            loadedList.add(pet);
          });

          return loadedList;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _switchToViewPets() {
    setState(() {
      _selectedPageIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage;

    if (_selectedPageIndex == 1) {
      activePage = AddPet(
        switchToViewPets: _switchToViewPets,
      );
    } else {
      activePage = FutureBuilder<List<Pet>>(
        future: _loadPets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final pets = snapshot.data ?? [];
            return PetsScreen(
              allPets: pets,
              onPetSelected: (pet) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => PetDetails(
                      pet: pet,
                      onImageSelected: (index) {
                        setState(() {
                          _selectedImageIndex = index;
                        });
                        print('Selected Image Index: $_selectedImageIndex');
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      );
    }

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
        selectedItemColor: Colors.black,
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
