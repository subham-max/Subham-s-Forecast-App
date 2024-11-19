import 'package:flutter/material.dart';
import 'package:weather/Activity/home.dart';
import 'package:weather/Activity/loading.dart';
import 'package:weather/Activity/location.dart';
import 'package:weather/Activity/noDataFound.dart';
void main() {
  runApp(MaterialApp(
    // home: const Home(),
    routes: {
      "/" : (context) => const Loading(),
      "/home" : (context) => const Home(),
      "/loading" : (context) => const Loading(),
      "/noDataFound" : (context) => const NoDataFound(),

    },
  ));
}

