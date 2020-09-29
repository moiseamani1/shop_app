import 'package:flutter/material.dart';

import 'package:flutter_complete_guide/providers/listings.dart';
import 'package:provider/provider.dart';

class ListingDetailScreen extends StatelessWidget {


  static const routeName = '/listing-detail';
  @override
  Widget build(BuildContext context) {
    String listingId = ModalRoute.of(context).settings.arguments as String;

    final loadedListing =
        Provider.of<Listings>(context, listen: false).findById(listingId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedListing.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 300,
              child: Image.network(loadedListing.imageUrl, fit: BoxFit.cover),
            ),
            SizedBox(height: 10),
            Text(
              '\$${loadedListing.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal:10),
              child: Text(loadedListing.description,
                  textAlign: TextAlign.center, softWrap: true),
            )
          ],
        ),
      ),
    );
  }
}
