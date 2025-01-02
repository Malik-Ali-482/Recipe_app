import 'package:flutter/material.dart';
import 'package:recipie_app/Utils/constants.dart';
import 'package:recipie_app/screens/view_all_items.dart';
import 'package:recipie_app/Widget/banner.dart';
import 'package:recipie_app/Widget/food_items_display.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  // Helper method to fetch time-based greeting
  String _getTimeBasedGreeting() {
    final now = DateTime.now();
    if (now.hour >= 5 && now.hour < 12) {
      return "Good Morning!";
    } else if (now.hour >= 12 && now.hour < 17) {
      return "Good Afternoon!";
    } else {
      return "Good Evening!";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve current user's ID
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Center(
        child: Text(
          "Welcome! Please log in to personalize your experience.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    // Firestore reference for the user's document
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    return FutureBuilder<DocumentSnapshot>(
      future: userDoc.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error loading user data. Please try again later.",
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        // Extract username or show default if not available
        final username = snapshot.data?.get('username') ?? 'User';
        final greeting = _getTimeBasedGreeting();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$greeting\n$username",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
          ],
        );
      },
    );
  }
}


class MyAppHomeScreen extends StatefulWidget {
  const MyAppHomeScreen({super.key});

  @override
  State<MyAppHomeScreen> createState() => _MyAppHomeScreenState();
}

class _MyAppHomeScreenState extends State<MyAppHomeScreen> {
  final now = DateTime.now();
  String category = "All"; // Selected category
  String searchQuery = "";  // To hold the search input
  final TextEditingController _searchController = TextEditingController();  // Controller for the search bar
  final CollectionReference categoriesItems =
  FirebaseFirestore.instance.collection("App-Category");

  // Query to fetch all recipes
  Query get allRecipes => FirebaseFirestore.instance.collection("recipe_data");

  // This function will be used to filter recipes client-side
  Future<List<DocumentSnapshot>> filterRecipes(List<DocumentSnapshot> recipes) async {
    return recipes.where((recipe) {
      final recipeName = (recipe['name'] as String).toLowerCase(); // Convert recipe name to lowercase
      final query = searchQuery.toLowerCase(); // Convert search query to lowercase
      return recipeName.contains(query); // Check if recipe name contains the search query
    }).toList();
  }

  // This function will get recipes from Firestore, apply category and search filters, and return the results
  Future<List<DocumentSnapshot>> getFilteredRecipes() async {
    // Fetch all recipes initially
    Query filteredQuery = allRecipes;

    // Apply category filtering if a category is selected
    if (category != "All") {
      filteredQuery = filteredQuery.where('type', isEqualTo: category);
    }

    // Get all recipes matching the category filter
    final snapshot = await filteredQuery.get();
    final recipes = snapshot.docs;

    // Apply the search filter (client-side) on the fetched recipes
    return await filterRecipes(recipes);
  }

  // Define the headerPart method to return a widget
  Widget headerPart() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: GreetingWidget(),
          ),
        ),
        Image.asset(
          'assets/icon/icon.png', // Path to your logo
          height: 60, // Adjust size as needed
          width: 60,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerPart(),
                    Container(
                      padding: const EdgeInsets.all(10), // Adds inner padding
                      margin: const EdgeInsets.symmetric(vertical: 10), // Adds space around the container
                      decoration: BoxDecoration(
                        color: cbannerColor.withOpacity(0.2), // Light background color
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Text(
                        now.hour >= 5 && now.hour < 12
                            ? "What do you want for breakfast?"
                            : (now.hour >= 12 && now.hour < 17
                            ? "What do you want for Lunch?"
                            : "What do you want for Dinner?"),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: cbannerColor, // Text color
                        ),
                      ),
                    ),
                    mySearchBar(),
                    // for banner
                    const BannerToExplore(),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // for category
                    selectedCategory(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Quick & Easy",
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ViewAllItems(),
                              ),
                            );
                          },
                          child: Text(
                            "View all",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<DocumentSnapshot>>(
                future: getFilteredRecipes(), // Get the filtered recipes
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error loading recipes."),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No results found."),
                    );
                  }
                  final recipes = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: recipes
                            .map((e) => FoodItemsDisplay(documentSnapshot: e))
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> selectedCategory() {
    return StreamBuilder(
      stream: categoriesItems.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                streamSnapshot.data!.docs.length,
                    (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      category = streamSnapshot.data!.docs[index]['name'];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: category == streamSnapshot.data!.docs[index]['name']
                          ? cprimaryColor
                          : cinvertedColor,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.only(right: 20),
                    child: Text(
                      streamSnapshot.data!.docs[index]['name'],
                      style: TextStyle(
                        color: category == streamSnapshot.data!.docs[index]
                        ['name']
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Padding mySearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            searchQuery = value; // Update the search query when the user types
          });
        },
        decoration: InputDecoration(
          filled: true,
          prefixIcon: const Icon(Iconsax.search_normal),
          border: InputBorder.none,
          hintText: "Search any recipes",
          hintStyle: TextStyle(),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}