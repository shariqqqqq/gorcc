import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final double width;
  final double imageHeight; // Added image height parameter
  final VoidCallback onTap;

  const CustomCard({super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap,
    required this.width,
    this.imageHeight = 100, // Set default image height to 150
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(8),
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all( 3.0),
                child: Image.network(
                  imageUrl,
                  height: imageHeight, // Set the height of the image
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 16),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
