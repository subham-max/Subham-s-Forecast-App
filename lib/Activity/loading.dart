import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather/Worker/worker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math';// You can add a spinner for animation.

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  // Example values, replace with your actual weather data retrieval logic.
  String? hum;
  String? desc;
  String? temp;
  String? airSpeed;
  String? main;
  String? searchedCity;
  String? gettingDataFrom;



  String? city = 'Fetching location...'; // Default text while fetching city
  List<String> defaultCities = ['Kolkata'];



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCityName();  // Moved the logic here instead of initState()
  }


  Future<void> _getCityName() async {
    bool serviceEnabled;
    LocationPermission permission;
    Map<String, dynamic>? searchText = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String? searchedCity = searchText != null ? searchText['location'] as String? : null;


    // First, check if searchedCity is available
    if (searchedCity != null ) {
      // If searchedCity is provided, use it
      setState(() {
        city = searchedCity; // Set city to the searched city
      });

      // Fetch weather data for searchedCity
      getLatLon instance = getLatLon(location: city);
      await instance.getLatLonData();

      worker getWeatherData = worker(lat: instance.latitude, lon: instance.longitude);
      await getWeatherData.getData();

      temp = getWeatherData.temp;
      hum = getWeatherData.humidity;
      airSpeed = getWeatherData.airSpeed;
      main = getWeatherData.main;
      desc = getWeatherData.description;
      gettingDataFrom = "If service using searchedCity";

      // After fetching the data, navigate to the home screen.
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        "temp_value": temp,
        "humidity_value": hum,
        "airSpeed_value": airSpeed,
        "main_value": main,
        "desc_value": desc,
        "gettingDataFrom": gettingDataFrom,
        "city": city,
      });
      return;
    }

    // If searchedCity is not provided, continue with the current logic for fetching city based on location

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If not enabled, use a random city
      setState(() {
        city = _getRandomCity();
      });

      getLatLon instance = getLatLon(location: city);
      await instance.getLatLonData();

      worker getWeatherData = worker(lat: instance.latitude, lon: instance.longitude);
      await getWeatherData.getData();

      temp = getWeatherData.temp;
      hum = getWeatherData.humidity;
      airSpeed = getWeatherData.airSpeed;
      main = getWeatherData.main;
      desc = getWeatherData.description;
      gettingDataFrom = "If service not enabled";

      // Navigate to the home screen with fetched data
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        "temp_value": temp,
        "humidity_value": hum,
        "airSpeed_value": airSpeed,
        "main_value": main,
        "desc_value": desc,
        "gettingDataFrom": gettingDataFrom,
      });
      return;
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          city = _getRandomCity();
        });

        getLatLon instance = getLatLon(location: city);
        await instance.getLatLonData();

        worker getWeatherData = worker(lat: instance.latitude, lon: instance.longitude);
        await getWeatherData.getData();

        temp = getWeatherData.temp;
        hum = getWeatherData.humidity;
        airSpeed = getWeatherData.airSpeed;
        main = getWeatherData.main;
        desc = getWeatherData.description;
        gettingDataFrom = "If service denied";

        // Navigate to the home screen with fetched data
        Navigator.pushReplacementNamed(context, '/home', arguments: {
          "temp_value": temp,
          "humidity_value": hum,
          "airSpeed_value": airSpeed,
          "main_value": main,
          "desc_value": desc,
          "gettingDataFrom": gettingDataFrom,
          "city": city,
        });

        return;
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          city = _getRandomCity();
        });

        getLatLon instance = getLatLon(location: city);
        await instance.getLatLonData();

        worker getWeatherData = worker(lat: instance.latitude, lon: instance.longitude);
        await getWeatherData.getData();

        temp = getWeatherData.temp;
        hum = getWeatherData.humidity;
        airSpeed = getWeatherData.airSpeed;
        main = getWeatherData.main;
        desc = getWeatherData.description;
        gettingDataFrom = "If service denied";

        // Navigate to the home screen with fetched data
        Navigator.pushReplacementNamed(context, '/home', arguments: {
          "temp_value": temp,
          "humidity_value": hum,
          "airSpeed_value": airSpeed,
          "main_value": main,
          "desc_value": desc,
          "gettingDataFrom": gettingDataFrom,
          "city": city,
        });

        return;
      }
    }

    // Fetch current location and city if permissions are granted
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String cityName = await _getCityFromLatLon(position.latitude, position.longitude);

    setState(() {
      city = cityName;
    });

    getLatLon instance = getLatLon(location: city);
    await instance.getLatLonData();

    worker getWeatherData = worker(lat: position.latitude.toString(), lon: position.longitude.toString());
    await getWeatherData.getData();

    temp = getWeatherData.temp;
    hum = getWeatherData.humidity;
    airSpeed = getWeatherData.airSpeed;
    main = getWeatherData.main;
    desc = getWeatherData.description;
    gettingDataFrom = "If service getting from geo location";

    // Navigate to the home screen with fetched data
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      "temp_value": temp,
      "humidity_value": hum,
      "airSpeed_value": airSpeed,
      "main_value": main,
      "desc_value": desc,
      "gettingDataFrom": gettingDataFrom,
      "city": city,
    });

    return;
  }






  // Function to get a random city from the list
  String _getRandomCity() {
    final randomIndex = Random().nextInt(defaultCities
        .length); // Generates a random index between 0 and length-1
    return defaultCities[randomIndex];
  }

  // Dummy function for reverse geocoding (replace with actual implementation)
  Future<String> _getCityFromLatLon(double lat, double lon) async {



    // Convert lat and lon from double to String
    String latString = lat.toString();
    String lonString = lon.toString();

    // Print lat and lon as Strings
    print('Latitude: $latString');
    print('Longitude: $lonString');


    // getLatLon instance = getLatLon(location: "kolkata");
    // await instance.getLatLonData();

    worker getWeatherData = worker(lat: latString, lon: lonString);
    await getWeatherData.getData();




    temp= getWeatherData.temp;
    hum= getWeatherData.humidity;
    airSpeed= getWeatherData.airSpeed;
    main= getWeatherData.main;
    desc= getWeatherData.description;
    gettingDataFrom= "If service getting from geo loaction";
    // Example to simulate loading of weather data
    await Future.delayed(Duration(seconds: 3));





    // After fetching the data, navigate to the home screen.
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      "temp_value": temp,
      "humidity_value": hum,
      "airSpeed_value": airSpeed,
      "main_value": main,
      "desc_value": desc,
      "gettingDataFrom": gettingDataFrom,
      "city": "Current Location",
    });



    // For now, we are just returning a dummy city.
    // You can use an API to get the city name based on latitude and longitude.
    return 'Current Location City';
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


  @override
  Widget build(BuildContext context) {
    List<Color> backgroundColors = _getBackgroundColors();




    return Scaffold(
      backgroundColor: backgroundColors[0],


    // Background color
      body: SafeArea(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add an icon or image in the center
            Image.asset(
              'assets/images/Subham.png', // Make sure you add your cloud image asset in your project
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            // App name and credits

            SizedBox(height: 10),

            SizedBox(height: 30),
            // Loading spinner animation
            SpinKitWave(
              color: Colors.white,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
