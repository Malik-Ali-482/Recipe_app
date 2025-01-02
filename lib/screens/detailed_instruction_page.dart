import 'package:flutter/material.dart';
import 'package:recipie_app/Widget/timer_widget.dart';  // Importing TimerWidget
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipie_app/Provider/quantity.dart';
import 'package:provider/provider.dart';  // Import for Consumer

class DetailedInstructionScreen extends StatelessWidget {
  final DocumentSnapshot<Object?> recipeData; // Full recipe data
  final Map<String, dynamic> stepData; // Adjusted to be more descriptive
  final String recipeName;

  const DetailedInstructionScreen({
    super.key,
    required this.recipeData,
    required this.stepData, // Renamed from stepIndex
    required this.recipeName,
  });

  @override
  Widget build(BuildContext context) {
    // Extracting the instructions array from the recipeData map
    List<dynamic> instructions_ingredients = stepData['instruction_ingredients'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(recipeName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipeData['name'] ?? 'Recipe Name', // Display the recipe name
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Display detailed step based on passed stepData
            Text(
              stepData['title'] ?? 'Step Title',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Timer widget, if available
            TimerWidget(minutes: int.tryParse(stepData['timer'].toString()) ?? 0),
            const SizedBox(height: 10),
            Text(
              stepData['description'] ?? 'Step Description',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Ingredients List specific to this step
            Text(
              "Ingredients used:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Consumer<QuantityProvider>(
              builder: (context, quantityProvider, child) {
                // Access the updated ingredient amounts based on the current number
                List<String> updatedIngredients = quantityProvider.updateIngredientAmounts;

                return ListView.builder(
                  shrinkWrap: true, // Prevents infinite height error
                  itemCount: instructions_ingredients.length,
                  itemBuilder: (context, ingredientIndex) {
                    var instruc_ingre = stepData['instruction_ingredients'][ingredientIndex];
                    var ingredient = recipeData['ingredients']?.firstWhere(
                          (ingredients) => ingredients['name'] == instruc_ingre,
                      orElse: () => null,
                    );

                    // Safely convert the quantity string to a double and multiply by currentNumber
                    double ingredientQuantity = 0.0;
                    if (ingredient != null && ingredient['quantity'] != null) {
                      ingredientQuantity = double.tryParse(ingredient['quantity'].toString()) ?? 0.0;
                    }

                    // Multiply the quantity by the current serving number
                    double newQuantity = ingredientQuantity * quantityProvider.currentNumber;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(ingredient['image'] ?? ''),
                      ),
                      title: Text(ingredient['name'] ?? 'Ingredient Name'),
                      trailing: Text(
                        "${newQuantity.toStringAsFixed(1)} ${ingredient['type'] ?? ''}",
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
