// ignore_for_file: unused_import

import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(200, 0, 244, 114)),
        useMaterial3: true,
      ),
      home: GeolocationApp(),
    );
  }
}

class GeolocationApp extends StatefulWidget {
  const GeolocationApp({super.key});

  @override
  State<GeolocationApp> createState() => _GeolocationAppState();
}

class _GeolocationAppState extends State<GeolocationApp> {
  Position? _currentlocation;
  late bool servicePermissions = false;
  late LocationPermission permission;
  double? LatitudAnterior;
  double? LongitudAnterior;
  int _counter = 0;
  int DurationMinutes = 10;
  int minutesForUpdate = 1;
  int Distancia = 1;
  double _RangoDistancia = 0.0;
  

  @override
  void initState() {
    super.initState();
    _counter = minutesForUpdate * DurationMinutes;
    _RangoDistancia = Distancia / 1000000;
    _startLocationUpdates();
    _getTimePeriodid();
  }

  Future<void> _startLocationUpdates() async {
    _currentlocation = await _getCurrentLocation();
    await _getAdressFromCoordinates();
    if (LatitudAnterior == null || LongitudAnterior == null) {
      LatitudAnterior = _currentlocation!.latitude;
      LongitudAnterior = _currentlocation!.longitude;
    } else {
      Timer.periodic(Duration(minutes: minutesForUpdate), (Timer timer) async {
        double latDiff = (_currentlocation!.latitude - LatitudAnterior!).abs();
        double lonDiff =
            (_currentlocation!.longitude - LongitudAnterior!).abs();

        if (latDiff > _RangoDistancia || lonDiff > _RangoDistancia) {
          LatitudAnterior = _currentlocation!.latitude;
          LongitudAnterior = _currentlocation!.longitude;
          print(
              "Nueva ubicación: Latitud=${_currentlocation!.latitude}, Longitud=${_currentlocation!.longitude}");
          _showSnackbar(
              "Ubicación actualizada automáticamente, se estableció nueva ubicación");
          setState(() {});
        }
      });
    }
  }

  _getTimePeriodid() async {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        _startLocationUpdates();
        _showSnackbar("Ubicación actualizada automáticamente");
        _counter = minutesForUpdate * DurationMinutes;
      }
    });
  }

  Future<Position> _getCurrentLocation() async {
    servicePermissions = await Geolocator.isLocationServiceEnabled();
    if (!servicePermissions) {
      print("Servicio deshabilitado");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  _getAdressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentlocation!.latitude, _currentlocation!.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAdress = "${place.street}";
        if (place.subLocality != "" && place.locality != "" && place.administrativeArea != "" && place.country != "")
            _currentlocationCity = "${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

        else if (place.subLocality != "" && place.name != "" && place.administrativeArea != "" && place.country != "")
            _currentlocationCity = "${place.subLocality}, ${place.name}, ${place.administrativeArea}, ${place.country}";

        else if (place.subLocality == "" && place.locality != "" && place.administrativeArea != "" && place.country != "")
            _currentlocationCity = "${place.locality}, ${place.administrativeArea}, ${place.country}";

        else if (place.subLocality == "" && place.name != "" && place.administrativeArea != "" && place.country != "")
            _currentlocationCity = "${place.name}, ${place.administrativeArea}, ${place.country}";

        else  
            _currentlocationCity = "${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  String _currentAdress = "";
  String _currentlocationCity = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Localización Data"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_currentlocationCity != "")
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Ubicacion",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text("${_currentlocationCity}"),
                  SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            if (_currentAdress != "")
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Dirección",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text("${_currentAdress}"),
                  SizedBox(
                    height: 30.0,
                  ),
                ],
              ),  
            if (_currentlocation != null)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Coordenadas",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Latitud : ${_currentlocation?.latitude}; Longitud : ${_currentlocation?.longitude}",
                  ),
                ],
              ),
            SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () async {
                _startLocationUpdates();
                //_currentlocation = await _getCurrentLocation();
                //await _getAdressFromCoordinates(); // Restablecer la ubicación actual
                _counter = minutesForUpdate * DurationMinutes; // Reiniciar Contador de actualización
                _showSnackbar("Ubicación actualizada exitosamente.");
              },
              child: Text("Obtener Ubicación"),
            ),
            Text("Próxima actualización en: ${_formatDuration(_counter)}"),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
