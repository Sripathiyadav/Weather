import 'package:flutter/material.dart';
import 'package:weatherr/global/api.dart';
import 'package:weatherr/global/weathermodel.dart';

class Homescreen extends StatefulWidget {
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
        body: Container(
          child: Column(
            children: [
              _buildsearchwidget(),
              if (inProgress)
                CircularProgressIndicator()
              else
                _buildWeatherWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherWidget() {
    if (response == null) {
      return Text("Search any Location for weather details");
    } else {
      return Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 200,
                  child: Image.network(
                    "https:${response?.current?.condition?.icon}"
                        .replaceAll("64x64", "128x128"),
                    scale: 0.7,
                  ),
                ),
              ),
              Text(
                (response?.current?.tempC.toString() ?? "") + "°C",
                style: TextStyle(fontSize: 80, color: Colors.black),
              ),
              Text(
                (response?.current?.condition?.text.toString() ?? ""),
                style: TextStyle(fontSize: 20, color: Colors.black),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.location_on_sharp,
                color: Colors.black,
                size: 40,
              ),
              Text(
                response?.location?.name ?? "",
                style: TextStyle(fontSize: 40, color: Colors.black),
              ),
              Text(
                response?.location?.country ?? "",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          //  SelectableText(response?.toJson().toString() ?? ""),
        ],
      );
    }
  }

  Widget _buildsearchwidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchBar(
        leading: Icon(
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
    } finally {
      inProgress = false;
    }
  }
}
