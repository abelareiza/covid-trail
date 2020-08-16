import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HomeCountries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: "Covid-19");
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Country>> _getCountries() async {
    var data = await http.get("https://api.covid19api.com/summary");
    var jsonData = json.decode(data.body);

    List<Country> countries = [];

    for (var x in jsonData["Countries"]) {
      Country country = Country(x["Country"], x["TotalConfirmed"],
          x["TotalDeaths"], x["TotalRecovered"]);
      countries.add(country);
    }
    print(countries.length);
    return countries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
            future: _getCountries(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Cargando...")
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data[index].name),
                      subtitle: Text('Confirmados: ' +
                          snapshot.data[index].totalConfirmed.toString()),
                      trailing: Icon(Icons.bookmark_border),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}

class Country {
  final String name;
  final int totalConfirmed;
  final int totalDeaths;
  final int totalRecovered;

  Country(
      this.name, this.totalConfirmed, this.totalDeaths, this.totalRecovered);
}