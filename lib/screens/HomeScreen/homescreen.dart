import 'package:flutter/material.dart';
import 'package:weatherr/global/api.dart';
import 'package:weatherr/global/weathermodel.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  ApiResponse? response;
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildsearchwidget(),
            if (inProgress)
              const CircularProgressIndicator()
            else
              _buildWeatherWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherWidget() {
    if (response == null) {
      return const Text("Search any Location for weather details");
    } else {
      return Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  height: 200,
                  child: Image.network(
                    "https:${response?.current?.condition?.icon}"
                        .replaceAll("64x64", "128x128"),
                    scale: 0.7,
                  ),
                ),
              ),
              Text(
                "${response?.current?.tempC.toString() ?? ""}°C",
                style: const TextStyle(fontSize: 80, color: Colors.black),
              ),
              Text(
                (response?.current?.condition?.text.toString() ?? ""),
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.location_on_sharp,
                color: Colors.black,
                size: 40,
              ),
              Text(
                response?.location?.name ?? "",
                style: const TextStyle(fontSize: 40, color: Colors.black),
              ),
              Text(
                response?.location?.country ?? "",
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      );
    }
  }

  Widget _buildsearchwidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchBar(
        leading: const Icon(
          Icons.search_outlined,
        ),
        hintText: "Search Location here",
        onSubmitted: (value) {
          _getWeatherData(value);
        },
      ),
    );
  }

  _getWeatherData(String location) async {
    setState(() {
      inProgress = true;
    });
    try {
      response = await WeatherApi().getCurrentWeather(location);
    } catch (e) {
      // Handle error if needed
      response = null;
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}
