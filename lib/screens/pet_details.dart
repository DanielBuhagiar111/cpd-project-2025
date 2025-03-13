import 'package:flutter/material.dart';
import 'package:pets_tracker/models/pet.dart';
import 'package:intl/intl.dart';

class PetDetails extends StatelessWidget {
  const PetDetails({super.key, required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(context, 'Name:', pet.name),
              _buildDetailRow(context, 'Species:', pet.species),
              _buildDetailRow(context, 'Date of Birth:',
                  DateFormat('yyyy-MM-dd').format(pet.dob)),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text(
                  'All Images:',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              for (var image in pet.images)
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      image,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Add Image'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(color: Colors.white),
              ),
              Container(
                width: 200,
                height: 2,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
