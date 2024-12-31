import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipie_app/Widget/food_items_display.dart';
import 'package:recipie_app/Widget/icon_button.dart';
import 'package:recipie_app/screens/recipe_detail_screen.dart';

class ViewAllItems extends StatefulWidget {
  const ViewAllItems({super.key});

  @override
  State<ViewAllItems> createState() => _ViewAllItemsState();
}

class _ViewAllItemsState extends State<ViewAllItems> {
  final CollectionReference completeApp =
  FirebaseFirestore.instance.collection("recipe_data");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: StreamBuilder(
          stream: completeApp.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return _buildGridView(streamSnapshot);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      actions: [
        const SizedBox(width: 15),
        MyIconButton(
          icon: Icons.arrow_back_ios_new,
          pressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        const Text(
          "Quick & Easy",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Image.asset(
          'assets/icon/icon.png', // Path to your logo
          height: 60, // Adjust size as needed
          width: 60,
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget _buildGridView(AsyncSnapshot<QuerySnapshot> streamSnapshot) {
    return GridView.builder(
      itemCount: streamSnapshot.data!.docs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.60,
        crossAxisSpacing: 15, // Space between columns
        mainAxisSpacing: 15, // Space between rows
      ),
      itemBuilder: (context, index) {
        final DocumentSnapshot documentSnapshot =
        streamSnapshot.data!.docs[index];
        return _buildItemCard(documentSnapshot);
      },
    );
  }

  Widget _buildItemCard(DocumentSnapshot documentSnapshot) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(documentSnapshot: documentSnapshot),
          ),
        );
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: FoodItemsDisplay(documentSnapshot: documentSnapshot),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
