import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'listing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Listings with ChangeNotifier {
  List<Listing> _items = [];

  var _showFavoritesOnly = false;

  final String authToken;
  final String userId;
  Listings(this.authToken, this.userId, this._items);

  List<Listing> get items {
    return [..._items];
  }

  Listing findById(String listingId) {
    return _items.firstWhere((listing) => listing.id == listingId);
  }

  List<Listing> get favoriteItems {
    return _items.where((listingItem) => listingItem.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts([bool filtering = false]) async {
    final sFilter = filtering ? 'orderBy="creator"&equalTo="$userId"' : '';

    final url =
        '[DATABASE_URL]/listings.json?auth=$authToken&$sFilter';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final favoriteFlowersResponse = await http.get(
          '[DATABASE_URL]/userFavoriteFlowers/$userId.json?auth=$authToken');
      final favoriteFlowersData = json.decode(favoriteFlowersResponse.body);
      final List<Listing> loadedProducts = [];
      extractedData.forEach((listingId, listingData) {
        loadedProducts.add(Listing(
            id: listingId,
            title: listingData['title'],
            description: listingData['description'],
            price: listingData['price'],
            isFavorite: favoriteFlowersData == null
                ? false
                : favoriteFlowersData[listingId] ?? false,
            imageUrl: listingData['imageUrl']));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Listing listing) async {
    final url =
        '[DATABASE_URL]/listings.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': listing.title,
            'description': listing.description,
            'imageUrl': listing.imageUrl,
            'price': listing.price,
            'creator': userId
          }));
      final newProduct = Listing(
          title: listing.title,
          description: listing.description,
          price: listing.price,
          imageUrl: listing.imageUrl,
          id: json.decode(response.body)['name']);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Listing newProduct) async {
    final listingIndex = _items.indexWhere((listing) => listing.id == id);

    if (listingIndex >= 0) {
      final url =
          '[DATABASE_URL]/listings/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));

      _items[listingIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        '[DATABASE_URL]/listings/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((listing) => listing.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete listing.');
    }
    existingProduct = null;
  }
}
