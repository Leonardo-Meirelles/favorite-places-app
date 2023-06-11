import 'package:flutter/material.dart';

import '../models/favorite_place_model.dart';
import '../views/place_details_view.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({
    super.key,
    required this.placesList,
  });

  final List<FavoritePlaceModel> placesList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: placesList.length,
      itemBuilder: (ctx, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: FileImage(placesList[index].image),
          ),
          title: Text(
            placesList[index].placeName,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          subtitle: Text(
            placesList[index].location.address,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) {
                return PlaceDetailsView(
                  place: placesList[index],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
