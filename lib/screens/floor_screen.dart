import 'package:flutter/material.dart';
import 'package:spotapot/screens/location_detail.dart';
import 'package:spotapot/screens/loc_details.dart';
import 'package:spotapot/screens/location_card.dart';

class FloorScreen extends StatefulWidget {
  const FloorScreen({super.key});

  @override
  State<FloorScreen> createState() => _FloorScreenState();
}

class _FloorScreenState extends State<FloorScreen> {
  final List<LocationDetail> mockLocations = List.from(initialMockLocations);
  String _query = '';
  final Set<String> _selectedFloors = {};
  final Set<String> _selectedGenders = {};
  bool _showFilters = false;

  final List<String> availableFloors = ['1', '2', '3'];
  final List<String> availableGenders = ['Male', 'Female'];

  List<LocationDetail> get filtered {
    return mockLocations.where((loc) {
      final q = _query.toLowerCase();
      final matchesSearch =
          q.isEmpty ||
          ('floor ${loc.floor}'.toLowerCase().contains(q)) ||
          (loc.side.toLowerCase().contains(q)) ||
          (loc.gender.toLowerCase().contains(q)) ||
          (loc.isOpen && 'open'.contains(q)) ||
          (!loc.isOpen && 'closed'.contains(q));

      final matchesFloor =
          _selectedFloors.isEmpty || _selectedFloors.contains('${loc.floor}');
      final matchesGender =
          _selectedGenders.isEmpty || _selectedGenders.contains(loc.gender);

      return matchesSearch && matchesFloor && matchesGender;
    }).toList();
  }

  void _toggleStatus(LocationDetail location) {
    setState(() {
      location.isOpen = !location.isOpen;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${location.gender} Floor ${location.floor} - ${location.side} is now ${location.isOpen ? "Open" : "Closed"}',
          ),
        ),
      );
    });
  }

  void _showDetails(LocationDetail loc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationDetailScreen(location: loc),
      ),
    );
  }

  void _showReport(LocationDetail loc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Report'),
        content: const Text('Report feature coming soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterContent() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedFloors.clear();
                    _selectedGenders.clear();
                  });
                },
                child: const Text('Reset', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...availableGenders.map(
            (gender) => CheckboxListTile(
              title: Text(gender),
              value: _selectedGenders.contains(gender),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    _selectedGenders.add(gender);
                  } else {
                    _selectedGenders.remove(gender);
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              activeColor: const Color.fromARGB(255, 61, 160, 94),
            ),
          ),
          const Divider(),
          ...availableFloors.map(
            (floor) => CheckboxListTile(
              title: Text('Floor $floor'),
              value: _selectedFloors.contains(floor),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    _selectedFloors.add(floor);
                  } else {
                    _selectedFloors.remove(floor);
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              activeColor: const Color.fromARGB(255, 61, 160, 94),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationsToShow = filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 61, 160, 94),
        title: const Text(
          'Spot a Pot',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                onChanged: (v) => setState(() => _query = v),
                                decoration: const InputDecoration(
                                  hintText: 'Search...',
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        _showFilters ? Icons.close : Icons.tune_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _showFilters = !_showFilters),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  "Note: The directions are shown as if you're facing the SJH building.",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  itemCount: locationsToShow.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, idx) {
                    final loc = locationsToShow[idx];
                    return LocationCard(
                      location: loc,
                      onDetails: () => _showDetails(loc),
                      onReport: () => _showReport(loc),
                      onToggleStatus: () => _toggleStatus(loc),
                    );
                  },
                ),
              ),
            ],
          ),
          if (_showFilters)
            Positioned(
              top: 80,
              left: 12,
              right: 12,
              child: _buildFilterContent(),
            ),
        ],
      ),
    );
  }
}
