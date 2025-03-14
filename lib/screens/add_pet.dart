import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pets_tracker/models/pet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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

  DateTime? _dob;
  String? _imagePath;

  Future<String> generateFilePath(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    return path;
  }

  Future<void> saveImageToAppDirectory(XFile image, String path) async {
    final imageFile = File(path);
    await imageFile.writeAsBytes(await image.readAsBytes());
  }

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
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
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
      final path = await generateFilePath(XFile(_imagePath!));

      Pet pet = Pet(
        id: uuid.v4(),
        name: _nameController.text,
        species: _speciesController.text,
        dob: _dob!,
        images: [path],
      );

      try {
        final url = Uri.https(
          'cpd-project-2025-default-rtdb.europe-west1.firebasedatabase.app',
          'pets.json',
        );

        // Step 3: Send the pet object to Firebase
        final response = await http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'name': pet.name,
              'species': pet.species,
              'dob': formatter.format(pet.dob),
              'images': pet.images,
            }));

        if (response.statusCode == 200) {
          await saveImageToAppDirectory(XFile(_imagePath!), path);

          setState(() {
            _imagePath = path;
          });

          widget.switchToViewPets();
        } else {
          print("Failed to save pet to Firebase: ${response.body}");
        }
      } catch (e) {
        print("Error saving pet to Firebase: $e");
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
              _buildInputField("Name:", _nameController),
              _buildInputField("Species:", _speciesController),
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
                          bottom: BorderSide(color: Colors.white, width: 1.0),
                        ),
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
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Add Image'),
                ),
              ),
              if (_imagePath != null) ...[
                // If an image has been selected, display it
                const SizedBox(height: 20),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.black,
                      child: Image.file(
                        File(_imagePath!),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
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
                      borderRadius: BorderRadius.circular(30),
                    ),
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

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
              textAlign: TextAlign.right,
              maxLength: 20,
            ),
          ),
        ],
      ),
    );
  }
}
