import 'package:flutter/material.dart';
import 'package:pets_tracker/models/pet.dart';
import 'package:pets_tracker/services/firebase_service.dart';
import 'package:pets_tracker/services/image_service.dart';
import 'package:pets_tracker/services/notifications.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets_tracker/widgets/input_field.dart';
import 'package:pets_tracker/widgets/pet_image.dart';

class AddPet extends StatefulWidget {
  const AddPet({required this.switchToViewPets, super.key});

  final VoidCallback switchToViewPets;

  @override
  State<AddPet> createState() {
    return _AddPetState();
  }
}

class _AddPetState extends State<AddPet> {
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final uuid = Uuid();
  final NotificationService _notificationService = NotificationService();
  final ImageService _imageService = ImageService();
  final FirebaseService _firebaseService = FirebaseService();

  DateTime? _dob;
  String? _imagePath;

  void _presentDatePicker() async {
    var now = DateTime.now();
    var firstDate = DateTime(now.year - 30, now.month, now.day);

    var tmpDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
      initialDate: now,
    );

    if (tmpDate != null) {
      setState(() {
        _dob = tmpDate;
      });
    }
  }

  void _pickImage() async {
    try {
      final imagePath = await _imageService.pickImage();
      if (imagePath != null) {
        setState(() {
          _imagePath = imagePath;
        });
      }
    } catch (e) {
      _notificationService.showNotification(
          2, 'Fail!', 'Could not pick image!');
    }
  }

  void _submitPet() async {
    if (_nameController.text.trim().isEmpty ||
        _speciesController.text.trim().isEmpty ||
        _dob == null ||
        _imagePath == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input",
              style: TextStyle(color: Colors.white)),
          content: const Text("Make sure to fill every input and add an image!",
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      try {
        final path = await _imageService.generateFilePath(XFile(_imagePath!));
        await _imageService.saveImageToAppDirectory(XFile(_imagePath!), path);

        Pet pet = Pet(
          id: uuid.v4(),
          name: _nameController.text,
          species: _speciesController.text,
          dob: _dob!,
          images: [path],
        );

        await _firebaseService.savePet(pet);

        setState(() {
          _imagePath = path;
        });

        _notificationService.showNotification(
            2, 'Success!', 'Pet was saved to firebase!');
        widget.switchToViewPets();
      } catch (e) {
        _notificationService.showNotification(
            2, 'Fail!', 'Pet could not be saved to firebase!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Input Pet Details:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              InputField(label: "Name:", controller: _nameController),
              InputField(label: "Species:", controller: _speciesController),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Date of Birth:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(
                    width: 225,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.white, width: 1.0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _dob == null
                                ? "No Date Selected"
                                : formatter.format(_dob!),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_month,
                                color: Colors.white),
                            onPressed: _presentDatePicker,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Add Image'),
                ),
              ),
              if (_imagePath != null) ...[
                const SizedBox(height: 20),
                Center(
                  child: PetImage(imagePath: _imagePath!),
                ),
              ],
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitPet,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Save Pet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
