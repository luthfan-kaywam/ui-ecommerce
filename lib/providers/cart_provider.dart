import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [
    CartItemModel(
      product: const ProductModel(
        id: '1',
        title: 'Leather Bag',
        description: 'Premium quality handmade leather bag for daily style.',
        price: 55.0,
        discountPercentage: 10,
        rating: 4.8,
        category: 'Outfit',
        imagePath: 'assets/images/carts/1.jpg',
      ),
      quantity: 1,
      isSelected: true,
    ),
    CartItemModel(
      product: const ProductModel(
        id: '2',
        title: 'Running Shoes',
        description: 'Lightweight ergonomic running shoes with max cushion.',
        price: 120.0,
        discountPercentage: 15,
        rating: 4.9,
        category: 'Outfit',
        imagePath: 'assets/images/carts/2.jpg',
      ),
      quantity: 1,
      isSelected: true,
    ),
    CartItemModel(
      product: const ProductModel(
        id: '3',
        title: 'Smart Watch',
        description: 'Waterproof smart fitness tracker with AMOLED screen.',
        price: 85.0,
        discountPercentage: 5,
        rating: 4.6,
        category: 'Electronic',
        imagePath: 'assets/images/carts/3.jpg',
      ),
      quantity: 1,
      isSelected: true,
    ),
    CartItemModel(
      product: const ProductModel(
        id: '4',
        title: 'Headphones',
        description: 'Wireless noise-canceling over-ear studio headphones.',
        price: 45.0,
        discountPercentage: 20,
        rating: 4.7,
        category: 'Electronic',
        imagePath: 'assets/images/carts/4.jpg',
      ),
      quantity: 1,
      isSelected: true,
    ),
  ];

  String _couponCode = '';
  double _discountPercent = 0.0;

  List<CartItemModel> get items => List.unmodifiable(_items);

  int get totalItemCount {
    int count = 0;
    for (var item in _items) {
      if (item.isSelected) {
        count += item.quantity;
      }
    }
    return count;
  }

  double get subtotal {
    double total = 0.0;
    for (var item in _items) {
      if (item.isSelected) {
        total += item.totalPrice;
      }
    }
    return total;
  }

  String get couponCode => _couponCode;
  double get discountPercent => _discountPercent;

  double get discountAmount => subtotal * (_discountPercent / 100.0);

  double get deliveryFee => subtotal > 0 ? 5.0 : 0.0;

  double get tax => (subtotal - discountAmount) * 0.05;

  double get grandTotal {
    final total = subtotal - discountAmount + deliveryFee + tax;
    return total > 0 ? total : 0.0;
  }

  void addToCart(ProductModel product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItemModel(product: product, quantity: 1, isSelected: true));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  void toggleItemSelection(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].isSelected = !_items[index].isSelected;
      notifyListeners();
    }
  }

  bool applyCoupon(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode.isNotEmpty) {
      _couponCode = cleanCode;
      _discountPercent = 10.0; // 10% discount for valid coupon
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _couponCode = '';
    _discountPercent = 0.0;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _couponCode = '';
    _discountPercent = 0.0;
    notifyListeners();
  }
}
