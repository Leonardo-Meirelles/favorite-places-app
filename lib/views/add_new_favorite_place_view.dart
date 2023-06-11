import 'dart:io';

import 'package:favorite_places_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/favorite_place_model.dart';
import '../providers/favorite_places_provider.dart';
import '../widgets/image_input.dart';

class AddNewFavoritePlaceView extends ConsumerStatefulWidget {
  const AddNewFavoritePlaceView({super.key});

  @override
  ConsumerState<AddNewFavoritePlaceView> createState() =>
      _AddFavoritePlaceViewState();
}

class _AddFavoritePlaceViewState
    extends ConsumerState<AddNewFavoritePlaceView> {
  final _formKey = GlobalKey<FormState>();

  late final String _enteredPlaceName;
  File? _selectedImage;
  PlaceLocationModel? _selectedLocation;

  void _saveFavorite() {
    if (_formKey.currentState!.validate() &&
        _selectedImage != null &&
        _selectedLocation != null) {
      FocusScope.of(context).unfocus();

      _formKey.currentState!.save();

      ref.read(favoritePlacesProvider.notifier).addFavoritePlace(
            placeName: _enteredPlaceName,
            image: _selectedImage!,
            location: _selectedLocation!,
          );

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _cancel() {
    FocusScope.of(context).unfocus();

    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Favorite Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 25,
                decoration: InputDecoration(
                  labelText: 'Place Name',
                  labelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 25) {
                    return 'Must be between 1 and 25 characters long!';
                  }
                  return null;
                },
                onSaved: (value) => _enteredPlaceName = value!,
              ),
              const SizedBox(height: 20),
              ImageInput(onSelectImage: (image) => _selectedImage = image),
              const SizedBox(height: 20),
              LocationInput(
                  onSelectLocation: (location) => _selectedLocation = location),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _cancel,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () => _saveFavorite(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Place'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
