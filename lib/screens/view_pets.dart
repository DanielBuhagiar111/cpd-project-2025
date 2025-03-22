import 'package:flutter/material.dart';
import 'package:pets_tracker/models/pet.dart';
import 'package:pets_tracker/screens/pet_details.dart';
import 'package:pets_tracker/widgets/pet_item.dart';

class PetsScreen extends StatelessWidget {
  const PetsScreen({super.key, required this.allPets});

  final List<Pet> allPets;

  void _selectPet(BuildContext context, Pet clickedPet) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => PetDetails(pet: clickedPet)),
    ); // Navigator.push(context, route)
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(
              left: 24.0,
              top: 15.0,
              right: 24.0,
              bottom: 0), // Reduced bottom padding
          child: Text(
            'Pets:',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Expanded(
          child: GridView(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            children: [
              if(allPets.isNotEmpty)
                for (final pet in allPets)
                  PetItem(
                    pet: pet,
                    onSelectPet: () {
                      _selectPet(context, pet);
                    },
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
