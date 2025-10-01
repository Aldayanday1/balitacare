import 'package:flutter/material.dart';

class FAQDialog extends StatefulWidget {
  @override
  _FAQDialogState createState() => _FAQDialogState();
}

class _FAQDialogState extends State<FAQDialog> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
    _animationController.forward();
  }

  Widget _buildFAQItem(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Q: $question",
          style: TextStyle(
            fontSize: 13.7,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "A: $answer",
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 10,
          backgroundColor: Color.fromARGB(255, 132, 164, 165),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      "FAQ",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  _buildFAQItem(
                    "Apa itu Balicare?",
                    "Balicare adalah aplikasi untuk mencatat data balita.",
                  ),
                  _buildFAQItem(
                    "Bagaimana cara menambahkan data balita?",
                    "Klik tombol tambah, lalu isi formulir yang tersedia.",
                  ),
                  _buildFAQItem(
                    "Bagaimana cara menghapus/mengedit data balita?",
                    "Geser card ke arah ujung samping, baik ke kanan maupun ke kiri.",
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 32,
          top: 230,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 132, 158, 165),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
