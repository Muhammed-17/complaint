import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/complaint.dart';
import 'package:intl/intl.dart';
import 'add_new_complaint.dart';
import 'details_page.dart';
import 'settings_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController =
      TextEditingController(); // Added
  final List<String> _filters = ['All', 'Pending', 'In Progress', 'Resolved'];

  @override
  void initState() {
    super.initState();
    // Use this to populate dummy data once if box is empty
    final box = Hive.box<Complaint>('complaints');
    if (box.isEmpty) {
      _addDummyData(box);
    }
  }

  void _addDummyData(Box<Complaint> box) {
    box.add(
      Complaint(
        id: '#COMP-2023-892',
        title: 'Broken Projector in Room 304',
        description: 'The projector keeps flickering.',
        category: 'Facilities / IT',
        date: DateTime(2023, 10, 24),
        status: 'IN PROGRESS',
        studentName: 'Alex Smith',
        studentId: '12345678',
      ),
    );
    box.add(
      Complaint(
        id: '#COMP-2023-901',
        title: 'Library Wi-Fi Connectivity',
        description: 'Cannot connect to Eduroam.',
        category: 'Facilities / IT',
        date: DateTime(2023, 11, 1),
        status: 'PENDING',
        studentName: 'Alex Smith',
        studentId: '12345678',
      ),
    );
  }

  // Helpers for UI
  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'IN PROGRESS':
        return const Color(0xFF2563EB); // Blue
      case 'RESOLVED':
        return const Color(0xFF10B981); // Green
      case 'PENDING':
      default:
        return const Color(0xFFF59E0B); // Amber/Orange
    }
  }

  IconData _getIconForCategory(String category) {
    if (category.contains('IT') || category.contains('Facilities')) {
      return Icons
          .videocam_off_outlined; // Or wifi_off depending on context, simplified for now
    } else if (category.contains('Sanitation') || category.contains('Food')) {
      return Icons.restaurant_outlined;
    } else {
      return Icons.assignment_late_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Slate 900
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text(
          'My Complaints',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28, // Slightly larger as per designs
          ),
        ),

        leading: IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.white, size: 28),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNewComplaint()),
                );
              },
            ),
          ),
          // const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController, // Bound controller
              onChanged: (value) {
                setState(() {}); // Trigger rebuild to filter list
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E293B), // Slate 800
                hintText: 'Search by subject or ID...',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: const Color(0xFF1E293B),
                    selectedColor: Colors.white,
                    checkmarkColor: Colors.black,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF334155),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Active Complaints Header & List
          // Active Complaints Header & List
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<Complaint>('complaints').listenable(),
              builder: (context, Box<Complaint> box, _) {
                // Filter Logic
                final complaints = box.values.toList().where((c) {
                  final matchesFilter =
                      _selectedFilter == 'All' ||
                      c.status.toUpperCase() == _selectedFilter.toUpperCase();
                  final searchQuery = _searchController.text.toLowerCase();
                  final matchesSearch =
                      c.title.toLowerCase().contains(searchQuery) ||
                      c.id.toLowerCase().contains(searchQuery);

                  return matchesFilter && matchesSearch;
                }).toList();

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${complaints.length} ACTIVE COMPLAINTS',
                            style: const TextStyle(
                              color: Color(0xFF94A3B8), // Muted text
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              letterSpacing: 1.0,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Sort action
                            },
                            child: const Text(
                              'Sort by Date',
                              style: TextStyle(
                                color: Color(0xFF3B82F6), // Blue link color
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: complaints.length,
                        itemBuilder: (context, index) {
                          final complaint = complaints[index];
                          final statusColor = _getStatusColor(complaint.status);
                          final icon = _getIconForCategory(complaint.category);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Slidable(
                              key: ValueKey(complaint.id),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  CustomSlidableAction(
                                    onPressed: (context) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddNewComplaint(
                                            complaintData: complaint,
                                          ),
                                        ),
                                      );
                                    },
                                    backgroundColor: const Color(0xFF334155),
                                    foregroundColor: Colors.white,
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.edit, size: 20),
                                        SizedBox(height: 4),
                                        Text(
                                          'EDIT',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CustomSlidableAction(
                                    onPressed: (context) {
                                      complaint.delete();
                                    },
                                    backgroundColor: const Color(0xFFEF4444),
                                    foregroundColor: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.delete, size: 20),
                                        SizedBox(height: 4),
                                        Text(
                                          'DELETE',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsPage(complaint: complaint),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF334155,
                                      ).withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: statusColor.withValues(
                                                alpha: 0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              icon,
                                              color:
                                                  statusColor, // Simplified mapping
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  complaint.title,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'ID: ${complaint.id}',
                                                  style: const TextStyle(
                                                    color: Color(0xFF94A3B8),
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                Text(
                                                  'Student ID: ${complaint.studentId}',
                                                  style: const TextStyle(
                                                    color: Color(0xFF94A3B8),
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.calendar_today,
                                                      size: 14,
                                                      color: Color(0xFF94A3B8),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      DateFormat(
                                                        'MMM dd, yyyy',
                                                      ).format(complaint.date),
                                                      style: const TextStyle(
                                                        color: Color(
                                                          0xFF94A3B8,
                                                        ),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(
                                            Icons.more_horiz, // Three dots icon
                                            color: Color(0xFF64748B),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      const Divider(color: Color(0xFF334155)),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusColor.withValues(
                                                alpha: 0.2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  size: 8,
                                                  color: statusColor,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  complaint.status,
                                                  style: TextStyle(
                                                    color: statusColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'Updated moments ago', // Placeholder
                                            style: const TextStyle(
                                              color: Color(0xFF94A3B8),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
