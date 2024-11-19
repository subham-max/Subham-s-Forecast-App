import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'loading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math';
import 'package:weather/Worker/worker.dart'; // You can add a spinner for animation.
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;




import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'noDataFound.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? city = 'Fetching location...'; // Default text while fetching city
  List<String> defaultCities = ['Kolkata', 'Mumbai', 'Delhi'];


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

  }


  //Notification Part





  //Notification Part





  // Helper function to return the image based on weather condition
  String _getWeatherImage(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'haze':
        return 'assets/images/Haze2.png';
      case 'clouds':
        return 'assets/images/6122561.png';
      case 'clear':
        return 'assets/images/summy.webp';
      case 'smoke':
        return 'assets/images/Smoke.png';
      case 'rain':
        return 'assets/images/Rain3.webp';
      case 'fog':
        return 'assets/images/Smoke.png';
      default:
        return 'assets/images/summy.webp'; // Fallback image if the condition is unknown
    }
  }

  // The method to perform the search
  void _searchLocation(String location) {
    if (location.isEmpty) {
      // Show a popup if the location is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(
                "Location cannot be empty. Please enter a valid location."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the popup
                },
              ),
            ],
          );
        },
      );
    } else {
      // Navigate to the loading screen if the location is not empty
      Navigator.pushReplacementNamed(
        context,
        '/loading',
        arguments: {"location": location},
      );
    }
  }

  List<Color> _getBackgroundColors() {
    // Get the current hour
    int hour = DateTime.now().hour;

    // Return colors based on time of day
    if (hour >= 5 && hour < 12) {
      // Morning (5 AM to 11 AM)
      return [
        Colors.orange[600] ?? Colors.orange,
        Colors.orange[300] ?? Colors.orangeAccent
      ];
    } else if (hour >= 12 && hour < 17) {
      // Afternoon (12 PM to 4 PM)
      return [
        Colors.blue[800] ?? Colors.blue,
        Colors.blue[300] ?? Colors.lightBlue
      ];
    } else if (hour >= 17 && hour < 19) {
      // Evening (5 PM to 7 PM)
      return [
        Colors.deepOrange[600] ?? Colors.deepOrange,
        Colors.orange[300] ?? Colors.orangeAccent
      ];
    } else {
      // Night (8 PM to 4 AM)
      return [
        Colors.indigo[800] ?? Colors.indigo,
        Colors.indigo[300] ?? Colors.indigoAccent
      ];
    }
  }

  TextEditingController searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments from the previous screen
    final Map<String, dynamic> data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};

    // Extract the values
    final String tempValue = data["temp_value"].toString();
    final String humidityValue = data["humidity_value"].toString();
    final String airValue = data["airSpeed_value"].toString();
    final String airSpeedValue =
        double.tryParse(data["airSpeed_value"].toString())
                ?.toStringAsFixed(1) ??
            '0.0';
    final String mainValue = data["main_value"] ?? "N/A";
    final String descValue = data["desc_value"] ?? "N/A";
    final String GettingData = data["gettingDataFrom"] ?? "N/A";
    final String CityfromLoading = data["city"] ?? "N/A";

    // Print the values in the console (for debugging)
    print("Temperature: $tempValue");
    print("Humidity: $humidityValue");
    print("Air Speed: $airSpeedValue");
    print("Main Weather: $mainValue");
    print("Description: $descValue");
    print("Getting Data: $GettingData");
    print("City: $CityfromLoading");
    print("airspeed: $airValue");

    if (tempValue == "No Data Found") {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NoDataFound()),
        );
      });
    }

    Map<dynamic, dynamic> info =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: GradientAppBar(
          gradient: LinearGradient(
            colors: _getBackgroundColors(),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity, // Full width
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: _getBackgroundColors(),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width *
                      0.05, // Adjust margin based on screen width
                  vertical: MediaQuery.of(context).size.height * 0.02,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "$CityfromLoading",
                          contentPadding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height *
                                0.015, // Adjust vertical padding for center alignment
                            horizontal: MediaQuery.of(context).size.width *
                                0.04, // Adjust horizontal padding for centering the text
                          ),
                        ),
                        onSubmitted: (value) {
                          // Trigger the search when the user presses the search button on the keyboard
                          _searchLocation(value);
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Trigger the search when the user taps on the search icon
                        _searchLocation(searchController.text);
                      },
                      child: Container(
                        child: Icon(
                          Icons.search,
                          color: Colors.blue,
                        ),
                        margin: EdgeInsets.fromLTRB(
                            7, 0, 3, 0), // Adjust the icon position
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue
                            .shade50, // Light background for better contrast
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.03,
                        vertical: MediaQuery.of(context).size.height * 0.01,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.03,
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Row(
                        children: [
                          // Weather Icon
                          Image.asset(
                            _getWeatherImage(
                                mainValue), // Determine the image dynamically
                            width: MediaQuery.of(context).size.width * 0.12,
                            height: MediaQuery.of(context).size.width * 0.12,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04),
                          // Weather Details
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$mainValue",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "In $CityfromLoading",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue.shade50,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.thermostat, size: 40, color: Colors.red),
                        SizedBox(height: 10),
                        Text(
                          "$tempValue°C",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.08,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Temperature",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.045,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildWeatherCard(
                    context,
                    icon: Icons.air,
                    value: "$airSpeedValue km/hr",
                    label: "Air Speed",
                    color: Colors.green.shade50,
                  ),
                  _buildWeatherCard(
                    context,
                    icon: Icons.water_drop,
                    value: "$humidityValue%",
                    label: "Humidity",
                    color: Colors.blue.shade50,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centers the content horizontally
                  crossAxisAlignment: CrossAxisAlignment.center, // Aligns the content vertically
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/Subham.png', // Your image file path
                      width: MediaQuery.of(context).size.width * 0.15, // Adjust the width
                      height: MediaQuery.of(context).size.height * 0.1, // Adjust the height
                      fit: BoxFit.contain, // Ensures the image fits within its box
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03), // Space between logo and text
                    // Text Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                      mainAxisAlignment: MainAxisAlignment.center, // Center the text vertically
                      children: [
                        Text(
                          "Made By Subham Paul",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                        Text(
                          "Data Provided By Openweathermap.org",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildWeatherCard(BuildContext context,
    {required IconData icon,
    required String value,
    required String label,
    required Color color}) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.2,
    width: MediaQuery.of(context).size.width * 0.4,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: color,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    ),
    padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.02),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: Colors.teal),
        SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    ),
  );



  Widget _buildWeatherCard(
      BuildContext context, {
        required IconData icon,
        required String value,
        required String label,
        required Color color,
      }) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.black87),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.035,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

}
