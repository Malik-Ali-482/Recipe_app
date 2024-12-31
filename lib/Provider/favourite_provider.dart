import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userId; // Store the current user's ID
  List<String> get favorites => _favoriteIds;

  FavoriteProvider(String userId) {
    _userId = userId;
    loadFavorites();
  }

  // Toggle favorite state for a specific meal
  void toggleFavorite(DocumentSnapshot meal) async {
    String mealId = meal.id;
    if (_favoriteIds.contains(mealId)) {
      _favoriteIds.remove(mealId);
      await _removeFavorite(mealId);
    } else {
      _favoriteIds.add(mealId);
      await _addFavorite(mealId);
    }
    notifyListeners();
  }

  // Check if a meal is favorited
  bool isExist(DocumentSnapshot meal) {
    return _favoriteIds.contains(meal.id);
  }

  // Add a favorite to the user's subcollection in Firestore
  Future<void> _addFavorite(String mealId) async {
    if (_userId == null) return;
    try {
      await _firestore
          .collection("users")
          .doc(_userId)
          .collection("favorites")
          .doc(mealId)
          .set({'isFavorite': true});
    } catch (e) {
      print(e.toString());
    }
  }

  // Remove a favorite from the user's subcollection in Firestore
  Future<void> _removeFavorite(String mealId) async {
    if (_userId == null) return;
    try {
      await _firestore
          .collection("users")
          .doc(_userId)
          .collection("favorites")
          .doc(mealId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // Load favorites from the user's subcollection in Firestore
  Future<void> loadFavorites() async {
    if (_userId == null) return;
    try {
      QuerySnapshot snapshot = await _firestore
          .collection("users")
          .doc(_userId)
          .collection("favorites")
          .get();
      _favoriteIds = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  // Static method to access the provider from any context
  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoriteProvider>(
      context,
      listen: listen,
    );
  }
}
