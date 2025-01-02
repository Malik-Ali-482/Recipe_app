import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userId; // Store the current user's ID dynamically
  List<String> get favorites => _favoriteIds;

  FavoriteProvider();

  // Set the user ID dynamically and load favorites
  Future<void> setUserId(String userId) async {
    _userId = userId;
    await loadFavorites();
  }

  Future<void> loadFavorites() async {
    if (_userId == null || _userId!.isEmpty) return;
    try {
      QuerySnapshot snapshot = await _firestore
          .collection("users")
          .doc(_userId)
          .collection("favorites")
          .get();
      _favoriteIds = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print("Error loading favorites: ${e.toString()}");
    }
    notifyListeners();
  }

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

  bool isExist(DocumentSnapshot meal) {
    return _favoriteIds.contains(meal.id);
  }

  Future<void> _addFavorite(String mealId) async {
    if (_userId == null || _userId!.isEmpty) return;
    try {
      await _firestore
          .collection("users")
          .doc(_userId)
          .collection("favorites")
          .doc(mealId)
          .set({'isFavorite': true, 'timestamp': FieldValue.serverTimestamp()});
      print("Favorite added successfully for user: $_userId");
    } catch (e) {
      print("Error adding favorite for user: $_userId - ${e.toString()}");
    }
    notifyListeners();
  }

  Future<void> _removeFavorite(String mealId) async {
    if (_userId == null || _userId!.isEmpty) return;
    try {
      await _firestore
          .collection("users")
          .doc(_userId)
          .collection("favorites")
          .doc(mealId)
          .delete();
      print("Favorite removed successfully for user: $_userId");
    } catch (e) {
      print("Error removing favorite for user: $_userId - ${e.toString()}");
    }
    notifyListeners();
  }

  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoriteProvider>(context, listen: listen);
  }
}
