import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();

  var _title;
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    if (_formKey.currentState!.validate() &&
        _selectedImage != null &&
        _selectedLocation != null) {
      _formKey.currentState!.save();
    }

    if (_selectedImage == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.red, size: 30),
                SizedBox(width: 10),
                Text(
                  'Attention',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            content: Text(
              'Merci de mettre une image !!!',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    if (_selectedLocation == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.red, size: 30),
                SizedBox(width: 10),
                Text(
                  'Attention',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            content: Text(
              'Merci de choisir la localisation!!!',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    ref
        .read(userPlacesProvider.notifier)
        .addPlace(_title, _selectedImage!, _selectedLocation!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Place"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16.0,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                maxLength: 30,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Title"),
                validator: (value) {
                  if (value == "" || value!.length <= 2) {
                    return "Valeur non conforme";
                  }

                  return null;
                },
                onSaved: (newValue) {
                  _title = newValue!.trim();
                },
              ),
              //Image Input
              ImageInput(
                onPickedImage: (File image) {
                  _selectedImage = image;
                },
              ),
              LocationInput(
                onSelectLocation: (location) {
                  _selectedLocation = location;
                },
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                onPressed: _savePlace,
                label: Text('Add Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
