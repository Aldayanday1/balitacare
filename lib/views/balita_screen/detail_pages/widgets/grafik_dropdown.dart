import 'package:flutter/material.dart';

class GrafikIconMenu extends StatefulWidget {
  final int selectedValue;
  final Function(int) onChanged;
  final List<int> dataOptions;

  GrafikIconMenu({
    required this.selectedValue,
    required this.onChanged,
    required this.dataOptions,
  });

  @override
  _GrafikIconMenuState createState() => _GrafikIconMenuState();
}

class _GrafikIconMenuState extends State<GrafikIconMenu> {
  // For animating the icon press effect
  double _filterScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Grafik Perkembangan, klik :",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 51, 109, 53),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 13.0),
            child: PopupMenuTheme(
              data: PopupMenuThemeData(
                color: Color.fromARGB(255, 84, 156,
                    111), // Set background color of the popup menu to black
              ),
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    _filterScale = 0.9; // Make icon smaller on tap
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    _filterScale = 1.0; // Return to original size
                  });
                },
                onTapCancel: () {
                  setState(() {
                    _filterScale = 1.0; // Return to original size on cancel
                  });
                },
                child: PopupMenuButton<int>(
                  onSelected: widget.onChanged,
                  itemBuilder: (BuildContext context) {
                    return widget.dataOptions
                        .map<PopupMenuEntry<int>>((int value) {
                      return PopupMenuItem<int>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(Icons.bar_chart, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              '$value data terakhir',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  offset: Offset(-32, 0),
                  child: AnimatedScale(
                    scale: _filterScale,
                    duration: Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 84, 156, 111),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.show_chart, // Icon for the dropdown
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
