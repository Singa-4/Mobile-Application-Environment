import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const StudentProfileScreen(),
    );
  }
}

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedHouse = 'Slytherin';
  final List<String> _houses = ['Gryffindor', 'Slytherin', 'Ravenclaw', 'Hufflepuff'];

  // Material Date Picker
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Cupertino Date Picker (Modal Sheet)
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _selectedDate,
          onDateTimeChanged: (DateTime newDate) {
            setState(() => _selectedDate = newDate);
          },
        ),
      ),
    );
  }

  // Cupertino Wheel Picker (Modal Sheet)
  void _showCupertinoHousePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 200,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoPicker(
          itemExtent: 32,
          scrollController: FixedExtentScrollController(
            initialItem: _houses.indexOf(_selectedHouse),
          ),
          onSelectedItemChanged: (int index) {
            setState(() => _selectedHouse = _houses[index]);
          },
          children: _houses.map((house) => Center(child: Text(house))).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }

  Widget _buildPortraitView() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const StudentDetailsSection(),
        const SizedBox(height: 16),
        const TitleSection(
          name: 'University of Technology Sarawak',
          location: 'Sibu, Sarawak',
          starCount: 41,
        ),
        const SizedBox(height: 16),
        _buildPickersSection(),
      ],
    );
  }

  Widget _buildLandscapeView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: SingleChildScrollView(
              child: StudentDetailsSection(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const TitleSection(
                    name: 'University of Technology Sarawak',
                    location: 'Sibu, Sarawak',
                    starCount: 41,
                  ),
                  const SizedBox(height: 16),
                  _buildPickersSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Interactive Pickers Card Widget
  Widget _buildPickersSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive Pickers (Lab 2.2)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Selected Date: ${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
            ),
            Text('Selected House: $_selectedHouse'),
            const Divider(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // 1. Material Date Picker Button
                ElevatedButton.icon(
                  onPressed: () => _selectMaterialDate(context),
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Material Date Picker'),
                ),

                // 2. Cupertino Date Picker Button
                OutlinedButton.icon(
                  onPressed: () => _showCupertinoDatePicker(context),
                  icon: const Icon(CupertinoIcons.calendar),
                  label: const Text('Cupertino Date Picker (Modal)'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Material Dropdown: '),
                const SizedBox(width: 8),
                // 3. Material DropdownButton
                DropdownButton<String>(
                  value: _selectedHouse,
                  items: _houses.map((String house) {
                    return DropdownMenuItem<String>(
                      value: house,
                      child: Text(house),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _selectedHouse = newValue);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 4. Cupertino Wheel Picker Button
            OutlinedButton.icon(
              onPressed: () => _showCupertinoHousePicker(context),
              icon: const Icon(CupertinoIcons.list_bullet),
              label: const Text('Cupertino Wheel Picker'),
            ),
          ],
        ),
      ),
    );
  }
}

// Student Details Widget
class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/picture.jpg'),
            ),
            const SizedBox(height: 20),
            const Text(
              'ADRIAN SINGA YUSAK',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Student ID: BCS24090038',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const Divider(height: 32, thickness: 1),
            const Text(
              'Personal Life Goal / Quote:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Everything would be alright',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Deconstructed TitleSection Widget
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.star, color: Colors.red[500]),
                const SizedBox(width: 4),
                Text('$starCount'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}