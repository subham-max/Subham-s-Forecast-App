import 'package:http/http.dart';
import 'dart:convert';

class worker{

  String? lat;
  String? lon;


//constructor
  worker({required this.lat, required this.lon}){

    lat=this.lat;
    lon =this.lon;
  }


  String? temp;

  String? humidity;
  String? airSpeed;
  String? description;
  String? main;


  Future<void> getData() async {

    try{
      // Make the API call
      Response response = await get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=5685e259556c61b23e3120fa9ef99e93"));

      // Decode the response body
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        // Access 'main' section for temperature and humidity
        Map<String, dynamic> temp_data = data['main'];

        // Get temperature, wind speed, and humidity
        double getTemp = temp_data['temp'] - 273.15; // Kelvin to Celsius
        double getAirSpeed = data['wind']['speed']/0.2777777778;
        String getHumidity = temp_data['humidity'].toString();

        print("AirSpeed: $getAirSpeed, Humidity: $getHumidity");

        // Access weather data for description
        List<dynamic> weather_data = data['weather'];
        Map<String, dynamic> weather_main_data = weather_data[0];
        String getMainDes = weather_main_data['main'];
        String getDesc = weather_main_data['description'];

        // Assign values to instance variables
        temp = getTemp.toStringAsFixed(2);  // Keeping two decimal places
        humidity = getHumidity;
        airSpeed = getAirSpeed.toString();
        description = getDesc;
        main = getMainDes;
      } else {
        print("No weather data found");
      }
    }
    catch(e){

      temp = "No Data Found";  // Keeping two decimal places
      humidity = "No Data Found";
      airSpeed = "No Data Found";
      description = "No Data Found";
      main = "No Data Found ";

    }

    }


}

class getLatLon{

  String? location;

//constructor
  getLatLon({ required this.location}){
    location = this.location;
  }


  String? latitude;
  String? longitude;






  Future<void> getLatLonData() async {
    Response response = await get(Uri.parse(
        "http://api.openweathermap.org/geo/1.0/direct?q=$location&limit=5&appid=5685e259556c61b23e3120fa9ef99e93"));

    // Decode response body as a list
    List<dynamic> data = jsonDecode(response.body);

    // Check if data is not empty
    if (data.isNotEmpty) {
      // Get the first element (since limit=5, choose the first location)
      Map<String, dynamic> firstLocation = data[0];

      // Get latitude and longitude
      double lat = firstLocation['lat'];
      double lon = firstLocation['lon'];

      print("Latitude: $lat, Longitude: $lon");

      // Assign values
      latitude = lat.toString();
      longitude = lon.toString();
    } else {
      print("No location data found");
    }
  }

}


