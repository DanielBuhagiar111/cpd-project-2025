import 'package:flutter/material.dart';

class Pet {
  const Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.dob,
    required this.images,
  });

  final String id;
  final String name;
  final String species;
  final DateTime dob;
  final List<String> images;
}