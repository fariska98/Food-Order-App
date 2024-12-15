import 'package:flutter/material.dart';
import 'package:zartek_test/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  // Get total item count
  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  // Get total amount
  double get totalAmount => _items.values.fold(
        0,
        (sum, item) => sum + (item.price * item.quantity),
      );

  // Get count for specific item
  int getItemCount(String id) {
    if (_items.containsKey(id)) {
      return _items[id]!.quantity;
    }
    return 0;
  }

  // Add item
  void addItem(String id, String name, double price) {
    if (_items.containsKey(id)) {
      // Update existing item quantity
      _items.update(
        id,
        (existing) => CartItem(
          id: existing.id,
          name: existing.name,
          price: existing.price,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      // Add new item
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: id,
          name: name,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  // Decrement item quantity
  void decrementItem(String id, String name, double price) {
    if (!_items.containsKey(id)) return;

    if (_items[id]!.quantity > 1) {
      // Reduce quantity by 1
      _items.update(
        id,
        (existing) => CartItem(
          id: existing.id,
          name: existing.name,
          price: existing.price,
          quantity: existing.quantity - 1,
        ),
      );
    } else {
      // Remove item if quantity becomes 0
      _items.remove(id);
    }
    notifyListeners();
  }

  // Remove item completely
  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  // Clear cart
  void clear() {
    _items = {};
    notifyListeners();
  }

  // Get item details
  CartItem? getItem(String id) {
    return _items[id];
  }

  // Update item quantity directly
  void updateItemQuantity(String id, int quantity) {
    if (_items.containsKey(id)) {
      if (quantity <= 0) {
        _items.remove(id);
      } else {
        _items.update(
          id,
          (existing) => CartItem(
            id: existing.id,
            name: existing.name,
            price: existing.price,
            quantity: quantity,
          ),
        );
      }
      notifyListeners();
    }
  }

  // Check if cart has items
  bool get isEmpty => _items.isEmpty;

  // Get total number of unique items
  int get uniqueItemCount => _items.length;

  // Get formatted total amount
  String getFormattedTotal() {
    return 'INR ${totalAmount.toStringAsFixed(2)}';
  }
}