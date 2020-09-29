import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String listingId,
    double price,
    String title,
  ) {
    if (_items.containsKey(listingId)) {
      _items.update(
        listingId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        listingId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String listingId) {
    _items.remove(listingId);
    notifyListeners();
  }

  void removeSingleItem(String listingId) {
    if (!_items.containsKey(listingId)) {
      return;
    }
    if (_items[listingId].quantity > 1) {
      _items.update(
          listingId,
          (existingCartitem) => CartItem(
              id: existingCartitem.id,
              price: existingCartitem.price,
              quantity: existingCartitem.quantity - 1,
              title: existingCartitem.title));
    }else{
      _items.remove(listingId);


    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
