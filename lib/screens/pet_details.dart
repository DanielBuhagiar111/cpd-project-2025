import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pets_tracker/models/pet.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pets_tracker/services/notifications.dart';

class PetDetails extends StatefulWidget {
  const PetDetails({super.key, required this.pet});

  final Pet pet;

  @override
  _PetDetailsState createState() => _PetDetailsState();
}

class _PetDetailsState extends State<PetDetails> {
  String? _imagePath;
  final NotificationService _notificationService = NotificationService();

  Future<String> generateFilePath(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();
    final String path =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    return path;
  }

  Future<void> saveImageToAppDirectory(XFile image, String path) async {
    final imageFile = File(path);
    await imageFile.writeAsBytes(await image.readAsBytes());
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        final path = await generateFilePath(image);
        await saveImageToAppDirectory(image, path);

        setState(() {
          _imagePath = path;
          widget.pet.images.add(path);
        });

        final url = Uri.https(
          'cpd-project-2025-default-rtdb.europe-west1.firebasedatabase.app',
          'pets/${widget.pet.id}.json',
        );

        try {
          final response = await http.patch(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'images': widget.pet.images,
            }),
          );

          if (response.statusCode == 200) {
            _notificationService.showNotification(
                2, 'Sucess!', 'Pet was updated in firebase!');
          } else {
            _notificationService.showNotification(
                2, 'Fail!', 'Pet was not updated in firebase!');
          }
        } catch (e) {
          _notificationService.showNotification(
              2, 'Fail!', 'Pet was not updated in firebase!');
        }
      }
    } catch (e) {
      _notificationService.showNotification(
          2, 'Fail!', 'Could not pick image!');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(context, 'Name:', widget.pet.name),
              _buildDetailRow(context, 'Species:', widget.pet.species),
              _buildDetailRow(context, 'Date of Birth:',
                  DateFormat('yyyy-MM-dd').format(widget.pet.dob)),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text(
                  'All Images:',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              for (var image in widget.pet.images)
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.black,
                      child: Image.file(
                        File(image),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
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
            ],
          ),
        ),
      ),
    );
  }
}
