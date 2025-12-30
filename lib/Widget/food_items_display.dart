import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipie_app/Provider/favourite_provider.dart';
import 'package:recipie_app/screens/recipe_detail_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FoodItemsDisplay extends StatelessWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const FoodItemsDisplay({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);

    // Safely check if the document exists and has data
    if (!documentSnapshot.exists || documentSnapshot.data() == null) {
      return const SizedBox.shrink(); // Return nothing if doc doesn't exist
    }

    final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    // Safely get fields with fallbacks
    final String name = data['name'] ?? 'Unknown Recipe';
    final String rawImg = data['img'] ?? '';
    final String imageUrl = rawImg.trim();
    final String cal = data['cal']?.toString() ?? '0';
    final String time = data['time']?.toString() ?? '0';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RecipeDetailScreen(documentSnapshot: documentSnapshot),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        height: 250,
        width: 230,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: imageUrl,
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: imageUrl.isNotEmpty
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(imageUrl),
                            )
                          : null,
                      color: Colors.grey[300],
                    ),
                    child: imageUrl.isEmpty
                        ? const Icon(Icons.image_not_supported)
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Iconsax.flash_1,
                      size: 16,
                      color: Colors.grey,
                    ),
                    Text(
                      "$cal Cal",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      " · ",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.grey,
                      ),
                    ),
                    const Icon(
                      Iconsax.clock,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "$time Min",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
            // for favorite button
            Positioned(
              top: 5,
              right: 5,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: InkWell(
                  onTap: () {
                      provider.toggleFavorite(documentSnapshot);
                  },
                  child: Icon(
                    provider.isExist(documentSnapshot)
                        ? Iconsax.heart5
                        : Iconsax.heart,
                    color: provider.isExist(documentSnapshot)
                        ? Colors.red
                        : Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
