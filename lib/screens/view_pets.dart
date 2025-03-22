import 'package:flutter/material.dart';
import 'package:pets_tracker/models/pet.dart';
import 'package:pets_tracker/widgets/pet_item.dart';

class PetsScreen extends StatelessWidget {
  const PetsScreen({super.key, required this.allPets, this.onPetSelected});

  final List<Pet> allPets;
  final Function(Pet)? onPetSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding:
              EdgeInsets.only(left: 24.0, top: 15.0, right: 24.0, bottom: 0),
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
              if (allPets.isNotEmpty)
                for (final pet in allPets)
                  PetItem(
                    pet: pet,
                    onSelectPet: () {
                      if (onPetSelected != null) {
                        onPetSelected!(pet);
                      }
                    },
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
