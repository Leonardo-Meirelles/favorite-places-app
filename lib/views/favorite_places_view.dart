import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorite_places_provider.dart';
import '../widgets/places_list.dart';
import 'add_new_favorite_place_view.dart';

class FavoritePlacesView extends ConsumerStatefulWidget {
  const FavoritePlacesView({super.key});

  @override
  ConsumerState<FavoritePlacesView> createState() => _FavoritePlacesViewState();
}

class _FavoritePlacesViewState extends ConsumerState<FavoritePlacesView> {
  late Future<void> _placesFutures;

  @override
  void initState() {
    super.initState();
    _placesFutures =
        ref.read(favoritePlacesProvider.notifier).loadInitialData();
  }

  void _navigateTo() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AddNewFavoritePlaceView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritePlacesList = ref.watch(favoritePlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Places'),
        actions: [
          IconButton(
            onPressed: _navigateTo,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: favoritePlacesList.isEmpty
          ? Center(
              child: Text(
                'Please add some places!',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: FutureBuilder(
                future: _placesFutures,
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : PlacesList(
                          placesList: favoritePlacesList,
                        );
                },
              ),
            ),
    );
  }
}
