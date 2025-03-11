import 'package:flutter/material.dart';
import 'package:pets_tracker/models/pet.dart';

var dummyPets = [
  Pet(
    id: '1',
    name: 'Buddy',
    species: 'Dog',
    dob: DateTime(2020, 5, 15),
    images: const [
      'assets/dog-1.png',
      'assets/dog-2.png',
    ],
  ),
  Pet(
    id: '2',
    name: 'Daddy',
    species: 'Cat',
    dob: DateTime(2021, 5, 15),
    images: const [
      'assets/cat-1.png',
    ],
  ),
  Pet(
    id: '3',
    name: 'Twin',
    species: 'Cat',
    dob: DateTime(2021, 5, 15),
    images: const [
      'assets/cat-2.png',
    ],
  ),
];
