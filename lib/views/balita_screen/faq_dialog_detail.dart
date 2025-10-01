import 'package:flutter/material.dart';

class FAQDialogDetail extends StatefulWidget {
  @override
  _FAQDialogState createState() => _FAQDialogState();
}

class _FAQDialogState extends State<FAQDialogDetail>
    with TickerProviderStateMixin {
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

  Widget _buildFAQItem(String question, String answer,
      {List<InlineSpan>? customAnswer}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Q: $question",
          style: TextStyle(
            fontSize: 13.7,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 83, 103, 104),
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 4),
        customAnswer == null
            ? Text(
                "A: $answer",
                style: TextStyle(
                  fontSize: 13,
                  color: Color.fromARGB(255, 83, 103, 104),
                  fontFamily: 'Poppins',
                ),
              )
            : RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(255, 83, 103, 104),
                    fontFamily: 'Poppins',
                  ),
                  children: customAnswer,
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
          backgroundColor: Colors.white,
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
                        color: Color.fromARGB(255, 83, 103, 104),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  _buildFAQItem(
                    "Bagaimana cara menambahkan data perkembangan balita?",
                    "",
                    customAnswer: [
                      TextSpan(
                          text:
                              "Untuk menambahkan data perkembangan balita yang diisi per bulan, klik ikon "),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(Icons.add_circle_outline_sharp,
                            size: 17, color: Color.fromARGB(255, 83, 103, 104)),
                      ),
                      TextSpan(
                          text:
                              " di pojok kanan bawah. Pastikan data yang diinputkan sesuai dengan waktu dan kondisi perkembangan balita pada bulan tersebut. "),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 32,
          top: 275,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
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
                  color: Color.fromARGB(255, 83, 103, 104),
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
