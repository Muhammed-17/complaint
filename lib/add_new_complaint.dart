import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'models/complaint.dart';

class AddNewComplaint extends StatefulWidget {
  final Complaint? complaintData;

  const AddNewComplaint({super.key, this.complaintData});

  @override
  State<AddNewComplaint> createState() => _AddNewComplaintState();
}

class _AddNewComplaintState extends State<AddNewComplaint> {
  final TextEditingController _nameController = TextEditingController();
  // Student ID is now automated
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.complaintData != null) {
      // Pre-fill data for editing
      _subjectController.text = widget.complaintData!.title;
      _descriptionController.text = widget.complaintData!.description;
      _nameController.text = widget.complaintData!.studentName;
      // _studentIdController.text = widget.complaintData!.studentId;
      _selectedCategory = widget.complaintData!.category;
    }
  }

  final List<String> _categories = [
    'Facilities / IT',
    'Sanitation / Hygiene',
    'Academic Issue',
    'Harassment / Safety',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Slate 900
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.complaintData != null ? 'Edit Complaint' : 'New Complaint',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (_selectedCategory == null) {
                // Determine category or show error. For now, default if null?
                // Or showing snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a category')),
                );
                return;
              }

              final box = Hive.box<Complaint>('complaints');

              if (widget.complaintData != null) {
                // Update existing
                final complaint = widget.complaintData!;
                complaint.title = _subjectController.text;
                complaint.description = _descriptionController.text;
                complaint.category = _selectedCategory!;
                complaint.studentName = _nameController.text;
                // complaint.studentId = "12345678";
                complaint.save(); // Hive save
              } else {
                // Create new
                final newComplaint = Complaint(
                  id: '#COMP-${DateTime.now().year}-${DateTime.now().millisecond}',
                  title: _subjectController.text,
                  description: _descriptionController.text,
                  category: _selectedCategory!,
                  date: DateTime.now(),
                  status: 'PENDING',
                  studentName: _nameController.text,
                  studentId: "12345678",
                );
                box.add(newComplaint);
              }
              Navigator.pop(context);
            },
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Color(0xFF3B82F6),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Row
            _buildLabel('Student Name'),
            const SizedBox(height: 8),
            _buildTextField(controller: _nameController, hint: 'mohamed '),
            const SizedBox(height: 24),
            _buildLabel('Category'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  hint: const Text(
                    'Select Complaint Type',
                    style: TextStyle(color: Color(0xFF94A3B8)),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF94A3B8),
                  ),
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            _buildLabel('Subject'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: TextField(
                controller: _subjectController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Brief summary of the issue',
                  hintStyle: TextStyle(color: Color(0xFF64748B)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel('Description'),
                const Text(
                  '0/500',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: null,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText:
                      'Please describe the incident or issue in detail...',
                  hintStyle: TextStyle(color: Color(0xFF64748B)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            _buildLabel('Evidence (Optional)'),
            const SizedBox(height: 8),
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF334155),
                  style: BorderStyle.none,
                ), // Using CustomPaint for dashed border is clearer, but strict dashed border is hard in basic container.
              ),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate_rounded,
                        color: Color(0xFF3B82F6),
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tap to upload files',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Photos or documents (PDF, JPG,\nPNG) to support your complaint.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF172033), // Slightly lighter than bg
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_rounded,
                    color: Color(0xFF3B82F6),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Your identity will remain confidential unless you explicitly choose to disclose it later in the process. We take all reports seriously.',
                      style: TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF64748B)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double radius = 12;
    RRect rRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    Path path = Path()..addRRect(rRect);

    Path dashPath = Path();
    double dashWidth = 8.0;
    double dashSpace = 6.0;
    double distance = 0.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
