import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipie_app/Provider/favourite_provider.dart';
import 'package:recipie_app/Provider/quantity.dart';
import 'package:recipie_app/Utils/constants.dart';
import 'package:recipie_app/Widget/quantity_increment_decrement.dart';
import 'package:recipie_app/screens/instructions_screen.dart';
import 'package:recipie_app/Provider/theme_provider.dart';

class RecipeDetailScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const RecipeDetailScreen({super.key, required this.documentSnapshot});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<double> baseAmounts = widget.documentSnapshot['ingredients']
          .map<double>((ingredient) => double.parse(ingredient['quantity'].toString()))
          .toList();

      // Set the base ingredient amounts in the provider
      Provider.of<QuantityProvider>(context, listen: false)
          .setBaseIngredientAmounts(baseAmounts);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final quantityProvider = Provider.of<QuantityProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Hero(
            tag: widget.documentSnapshot['img'],
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.documentSnapshot['img']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Back button and notification
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios_new),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Iconsax.notification),
                ),
              ],
            ),
          ),
          // Draggable detail section
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

              return Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pull-up handle
                        Center(
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Recipe Name
                        Text(
                          widget.documentSnapshot['name'],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Calories and Time
                        Row(
                          children: [
                            Icon(Icons.flash_on, color: clessdetailColor),
                            const SizedBox(width: 5),
                            Text(
                              "${widget.documentSnapshot['cal']} Cal",
                              style: TextStyle(color: clessdetailColor),
                            ),
                            const SizedBox(width: 15),
                            Icon(Icons.timer, color: clessdetailColor),
                            const SizedBox(width: 5),
                            Text(
                              "${widget.documentSnapshot['time']} Min",
                              style: TextStyle(color: clessdetailColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Rating
                        Row(
                          children: [
                            const Icon(Iconsax.star1, color: Colors.amber),
                            const SizedBox(width: 5),
                            Text(
                              widget.documentSnapshot['rating'].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "/5",
                              style: TextStyle(color: clessdetailColor),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${widget.documentSnapshot['reviews']} Reviews",
                              style: TextStyle(color: clessdetailColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Ingredients Title
                        const Text(
                          "Ingredients",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Quantity increment/decrement
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "How many servings?",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            QuantityIncrementDecrement(
                              currentNumber: quantityProvider.currentNumber,
                              onAdd: () => quantityProvider.increaseQuantity(),
                              onRemov: () => quantityProvider.decreaseQuantity(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Ingredients List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.documentSnapshot['ingredients'].length,
                          itemBuilder: (context, index) {
                            var ingredient = widget.documentSnapshot['ingredients'][index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(ingredient['image']),
                              ),
                              title: Text(
                                ingredient['name'],
                                style: TextStyle(color: cprimaryColor),
                              ),
                              trailing: Text(
                                "${quantityProvider.updateIngredientAmounts[index]} ${ingredient['type']}",
                                style: TextStyle(color: cprimaryColor),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Start Cooking Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: csecondaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CookingInstructionsScreen(
                                      instructions: widget.documentSnapshot['instructions'],
                                      recipeName: widget.documentSnapshot['name'],
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                "Start Cooking",
                                style: TextStyle(fontSize: 18, color: isDarkMode ? Colors.white : Colors.black),
                              ),
                            ),
                            const SizedBox(width: 20), // Add some space between the buttons
                            // Favorite Button
                            IconButton(
                              onPressed: () {
                                provider.toggleFavorite(widget.documentSnapshot);
                              },
                              icon: Icon(
                                provider.isExist(widget.documentSnapshot)
                                    ? Iconsax.heart5
                                    : Iconsax.heart,
                                color: provider.isExist(widget.documentSnapshot) ? Colors.red : Colors.black,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
