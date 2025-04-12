import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedValue = 'Men';
  List<String> items = ['Men', 'Female', 'Unisex'];

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          SizedBox(height: 10), // Space from top
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              decoration: BoxDecoration(
                color: Colors.white, // White background
                borderRadius: BorderRadius.circular(10), // Curved edges
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12, // Soft shadow
                    blurRadius: 10,
                    offset: Offset(2, 5),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedValue,
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 0), // Reduced padding
                        child: Text(item, style: TextStyle(fontSize: 16)),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  dropdownColor: Colors.white, // Background color of dropdown
                  style: TextStyle(color: Colors.black), // Text color
                  menuMaxHeight: 200, // Ensures all items are visible without excessive scrolling
                ),
              ),
            ),
          ),
        ],
      );
  }
}
