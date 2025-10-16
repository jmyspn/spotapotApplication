import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotapot/screens/location_detail.dart';

class LocationDetailScreen extends StatefulWidget {
  final LocationDetail location;

  const LocationDetailScreen({super.key, required this.location});

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _getFloorSuffix(int floor) {
    if (floor == 1) return 'st';
    if (floor == 2) return 'nd';
    if (floor == 3) return 'rd';
    return 'th';
  }


  List<Widget> _buildStars(double rating, double iconSize) {
    final int full = rating.floor();
    final bool half = (rating - full) >= 0.5;
    final int empty = 5 - full - (half ? 1 : 0);

    final List<Widget> list = [];
    for (int i = 0; i < full; i++) {
      list.add(Icon(Icons.star, size: iconSize, color: Colors.amber));
    }
    if (half) {
      list.add(Icon(Icons.star_half, size: iconSize, color: Colors.amber));
    }
    for (int i = 0; i < empty; i++) {
      list.add(Icon(Icons.star_border, size: iconSize, color: Colors.amber));
    }
    return list;
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentTile(String username, String comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            radius: 18,
            child: Text(
              username[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
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
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  comment,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Update comment to Firestore
  void _addComment() async {
    final String text = _commentController.text.trim();
    if (text.isEmpty) return;

    final user = _auth.currentUser;
    if (user == null) return; // User must be logged in

    await _firestore.collection('comments').add({
      'floor': widget.location.floor,
      'side': widget.location.side,
      'username': user.email ?? '@Anonymous',
      'comment': text,
    });

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final location = widget.location;
    final Color statusColor =
        location.isOpen ? const Color(0xFF2E8B3B) : const Color(0xFFD64545);

    final bool isMale = location.gender.toLowerCase() == 'male';
    final int urinals = isMale ? 3 : 0;
    const int stalls = 3;
    const int sinks = 2;
    const String mirrorStatus = 'Yes';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        toolbarHeight: 56,
        backgroundColor: const Color.fromARGB(255, 61, 160, 94),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          '${location.floor}${_getFloorSuffix(location.floor)} Floor',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Center(
              child: SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: location.images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        location.images[index],
                        width: 110,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            Text(
              '${location.floor}${_getFloorSuffix(location.floor)} Floor',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  'Side: ${location.side}',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    border: Border.all(color: statusColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    location.isOpen ? 'Open' : 'Closed',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Rating and gender
            Row(
              children: [
                ..._buildStars(location.rating, 20),
                const SizedBox(width: 8),
                Text(
                  location.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  isMale ? Icons.male : Icons.female,
                  size: 20,
                  color: isMale ? Colors.blue : Colors.pink,
                ),
                const SizedBox(width: 4),
                Text(
                  location.gender,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isMale ? Colors.blue : Colors.pink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Access Details
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Access Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 61, 160, 94),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This restroom is located on the ${location.floor}${_getFloorSuffix(location.floor)} floor, on the ${location.side} side of the building. It is currently ${location.isOpen ? 'OPEN' : 'CLOSED'}.',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Facilities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildInfoChip('Stalls: $stalls', Icons.wc),
                if (urinals > 0) _buildInfoChip('Urinals: $urinals', Icons.wc),
                _buildInfoChip('Sinks: $sinks', Icons.countertops),
                _buildInfoChip('Bidet: Unavailable', Icons.water),
                _buildInfoChip('Mirror: $mirrorStatus', Icons.window),
                _buildInfoChip('Dipper: Yes', Icons.water_drop),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            const Text(
              'Add a Comment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Write your comment here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Comments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            //  Live Firestore comments
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('comments')
                  .where('floor', isEqualTo: location.floor)
                  .where('side', isEqualTo: location.side)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading comments'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No comments yet. Be the first!'),
                  );
                }

                final docs = snapshot.data!.docs;
                return Column(
                  children: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return _buildCommentTile(
                      data['username'] ?? '@Anonymous',
                      data['comment'] ?? '',
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
