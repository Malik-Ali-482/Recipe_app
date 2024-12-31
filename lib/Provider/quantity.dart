import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  int _currentNumber = 1;
  List<double> _baseIngredientAmounts = [];
  int get currentNumber => _currentNumber;

  bool isDataReady = false; // Flag to indicate when the data is fully ready

  List<double> get baseIngredientAmounts => _baseIngredientAmounts;

  // Method to set base ingredient amounts and mark data as ready
  void setBaseIngredientAmounts(List<double> amounts) {
  _baseIngredientAmounts = amounts;
  isDataReady = true;
  notifyListeners();
  }


  // Update ingredient amounts based on the quantity
  List<String> get updateIngredientAmounts {
    return _baseIngredientAmounts
        .map<String>((amount) => (amount * _currentNumber).toStringAsFixed(1))
        .toList();
  }

  // increase servings
  void increaseQuantity() {
    _currentNumber++;
    notifyListeners();
  }

  // decrease servings
  void decreaseQuantity() {
    if (_currentNumber > 1) {
      _currentNumber--;
      notifyListeners();
    }
  }
}