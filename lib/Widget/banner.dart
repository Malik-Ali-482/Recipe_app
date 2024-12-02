import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:recipie_app/Utils/constants.dart';

class BannerToExplore extends StatelessWidget {
  const BannerToExplore({super.key});
  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://www.allrecipes.com/'); // Replace with your desired URL
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: kbannerColor,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            right: -20,
            child: Image.network(
              "https://i.postimg.cc/15gnLQJ6/food-recipe-app-removebg-preview-removebg-preview.png",
            ),
          ),
          Positioned(
            top: 32,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Cook the best\nrecipes at home",
                  style: TextStyle(
                    height: 1.1,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 33,
                    ),
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  onPressed: _launchURL,
                  child: const Text(
                    "Explore",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}