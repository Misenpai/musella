import 'package:flutter/material.dart';

class AppHeader extends StatefulWidget {
  final Function(int) onCategorySelected;
  final PageController pageController; // Add this line
  const AppHeader(
      {super.key,
      required this.onCategorySelected,
      required this.pageController});

  @override
  _AppHeaderState createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  int _selectedIndex = 0;

  final List<String> categories = [
    'Suggested',
    'Songs',
    'Artists',
    'Album',
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double itemWidth = screenWidth / categories.length;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note, // Choose the appropriate icon
              color: Colors.orange, // Set the desired color
            ),
            SizedBox(width: 8),
            Text(
              'Musella',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) => Container(
              width: itemWidth,
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

  @override
  void initState() {
    super.initState();

    widget.pageController.addListener(() {
      setState(() {
        _selectedIndex = widget.pageController.page!.round();
      });
    });
  }

  Widget _buildScrollItem({required String title, required int index}) {
    bool isSelected = index == _selectedIndex;
    return GestureDetector(
      onTap: () {
        setState(
          () {
            _selectedIndex = index;
          },
        );

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
