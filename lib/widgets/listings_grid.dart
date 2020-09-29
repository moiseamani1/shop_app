import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/listings.dart';
import 'listing_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final listingsData = Provider.of<Listings>(context);
    final listings = showFavs ? listingsData.favoriteItems : listingsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: listings.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: listings[i],
        child: ListingItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
