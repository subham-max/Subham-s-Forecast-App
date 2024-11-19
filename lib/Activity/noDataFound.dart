import 'package:flutter/material.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({Key? key}) : super(key: key);

  List<Color> _getBackgroundColors() {
    int hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return [Colors.orange[600] ?? Colors.orange, Colors.orange[300] ?? Colors.orangeAccent];
    } else if (hour >= 12 && hour < 17) {
      return [Colors.blue[800] ?? Colors.blue, Colors.blue[300] ?? Colors.lightBlue];
    } else if (hour >= 17 && hour < 19) {
      return [Colors.deepOrange[600] ?? Colors.deepOrange, Colors.orange[300] ?? Colors.orangeAccent];
    } else {
      return [Colors.indigo[800] ?? Colors.indigo, Colors.indigo[300] ?? Colors.indigoAccent];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> backgroundColors = _getBackgroundColors();
    return Scaffold(
      appBar: AppBar(
        title: Text("Subham's Forecast"),
        backgroundColor: backgroundColors[0],
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: backgroundColors,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ensures the box is only as big as its content
                children: [
                  // Image Section
                  Image.asset(
                    'assets/images/Subham.png', // Add your image asset
                    width: 80, // Smaller image
                    height: 80,
                  ),
                  const SizedBox(height: 15),
                  // Title Text
                  Text(
                    'No Data Found!',
                    style: TextStyle(
                      fontSize: 18, // Slightly smaller font
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Subtext
                  Text(
                    'Invalid city name or no data available.',
                    style: TextStyle(
                      fontSize: 14, // Smaller subtext font size
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/loading');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColors[0],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                    child: Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
