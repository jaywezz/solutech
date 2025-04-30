import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidgets {
  static Widget buildShimmerCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Container(
              width: 60,
              height: 14,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 4),
            Container(
              width: 40,
              height: 24,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildShimmerListTile() {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 20,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Container(
              width: 80,
              height: 16,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: Colors.grey[300],
                ),
                const SizedBox(width: 8),
                Container(
                  width: 100,
                  height: 16,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 