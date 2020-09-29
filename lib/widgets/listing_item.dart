import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:provider/provider.dart';

import '../screens/ListingDetailScreen.dart';
import '../providers/listing.dart';
import '../providers/cart.dart';

class ListingItem extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final listing = Provider.of<Listing>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData=Provider.of<Auth>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ListingDetailScreen.routeName,
              arguments: listing.id,
            );
          },
          child: Image.network(
            listing.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Listing>(
            builder: (ctx, listing, _) => IconButton(
              icon: Icon(
                listing.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () =>
                listing.toggleFavoriteStatus(authData.token,authData.userId),
            ),
          ),
          title: Text(
            listing.title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(listing.id, listing.price, listing.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Added  item to cart'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(label: 'UNDO', onPressed: (){

                  cart.removeSingleItem(listing.id);
                }),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
