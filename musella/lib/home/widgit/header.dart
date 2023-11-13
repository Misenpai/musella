import 'package:flutter/material.dart';

class AppHeader extends StatefulWidget {
  final Function(int) onCategorySelected;
  const AppHeader({Key? key, required this.onCategorySelected})
      : super(key: key);

  @override
  _AppHeaderState createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  // Current selected index
  int _selectedIndex = 0;

  final List<String> categories = ['Suggested', 'Songs', 'Artists', 'Albums'];

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;
    // Calculate the width for each item
    double itemWidth = screenWidth / categories.length;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Musella',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.search),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 30, // Set the height of the container
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) => Container(
              width: itemWidth, // Set the calculated width for each item
              alignment: Alignment.center,
              child: _buildScrollItem(
                title: categories[index],
                index: index,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollItem({required String title, required int index}) {
    bool isSelected = index == _selectedIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          // Handle the button press
        });
        widget.onCategorySelected(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.orange : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Container(
              height: 2,
              color: Colors.orange,
            ),
        ],
      ),
    );
  }
}
