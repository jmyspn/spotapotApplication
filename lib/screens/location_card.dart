import 'package:flutter/material.dart';
import 'package:spotapot/screens/location_detail.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class LocationCard extends StatelessWidget {
  final LocationDetail location;
  final VoidCallback onDetails;
  final VoidCallback onReport;
  final VoidCallback onToggleStatus;

  const LocationCard({
    required this.location,
    required this.onDetails,
    required this.onReport,
    required this.onToggleStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = location.isOpen
        ? const Color(0xFF2E8B3B)
        : const Color(0xFFD64545);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9E6EE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(location.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Floor ${location.floor} — ${location.side} Side',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      location.gender.toLowerCase() == 'male'
                          ? Icons.male
                          : Icons.female,
                      size: 14,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Gender: ${location.gender}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: location.rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 18,
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (newRating) {
                        // Update the rating in the parent (FloorScreen)
                        location.rating = newRating;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Rated ${newRating.toStringAsFixed(1)} stars',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      location.rating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: onDetails,
                      child: const Text(
                        'Details',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: onReport,
                      child: const Text(
                        'Report',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onToggleStatus,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.08),
                border: Border.all(color: statusColor),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                location.isOpen ? 'OPEN' : 'CLOSED',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
