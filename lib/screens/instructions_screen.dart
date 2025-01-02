import 'package:flutter/material.dart';
import 'package:recipie_app/screens/app_main_screen.dart';
import 'package:recipie_app/Utils/constants.dart';
import 'package:recipie_app/Utils/notification_helper.dart';
import 'package:recipie_app/screens/detailed_instruction_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CookingInstructionsScreen extends StatelessWidget {
  final List<dynamic> instructions; // Adjusted to use the new map structure
  final DocumentSnapshot<Object?> recipeData;
  final String recipeName;

  const CookingInstructionsScreen({
    super.key,
    required this.instructions,
    required this.recipeData,
    required this.recipeName,
  });

  @override
  Widget build(BuildContext context) {
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
        child: ListView.builder(
          itemCount: instructions.length,
          itemBuilder: (context, index) {
            var step = instructions[index];
            return GestureDetector(
              onTap: () {
                // Navigate to detailed step view
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailedInstructionScreen(
                      recipeData: recipeData,
                      stepData: step,
                      recipeName: recipeName,
                    ),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step['title'] ?? 'Step Title', // Handling potential null values
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              step['description'] ?? 'Default Text', // Description field
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: cbannerColor,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          onPressed: () {
            NotificationHelper().showRateAppNotification();
            NotificationHelper().scheduleDishReminderNotification();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppMainScreen(),
              ),
            );
          },
          child: Text(
            "Finish",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
