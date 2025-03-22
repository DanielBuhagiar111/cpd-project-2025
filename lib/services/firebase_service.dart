import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pets_tracker/models/pet.dart';

class FirebaseService {
  final url = Uri.https(
    'cpd-project-2025-default-rtdb.europe-west1.firebasedatabase.app',
    'pets.json',
  );

  Future<void> savePet(Pet pet) async {
    final formatter = DateFormat('yyyy-MM-dd');
    await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': pet.name,
          'species': pet.species,
          'dob': formatter.format(pet.dob),
          'images': pet.images,
        }));
  }

  Future<void> updatePetImages(String petId, List<String> images) async {
    final updateUrl = Uri.https(
      'cpd-project-2025-default-rtdb.europe-west1.firebasedatabase.app',
      'pets/$petId.json',
    );

    await http.patch(
      updateUrl,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'images': images,
      }),
    );
  }

  Future<List<Pet>> loadPets() async {
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
      }
    }
    return [];
  }
}
