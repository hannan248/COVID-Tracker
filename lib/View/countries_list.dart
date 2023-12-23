import 'package:covid_tracker/Services/states_services.dart';
import 'package:covid_tracker/View/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({Key? key}) : super(key: key);

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    StatesServices stateServices = StatesServices();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  hintText: "Search with country Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  )),
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: stateServices.countriesListApi(),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Shimmer(
                          child: Column(
                            children: [
                              ListTile(
                                  title: Container(
                                    height: 10,
                                    width: 89,
                                    color: Colors.white,
                                  ),
                                  subtitle: Container(
                                    height: 10,
                                    width: 89,
                                    color: Colors.white,
                                  ),
                                  leading: Container(
                                    height: 50,
                                    width: 50,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                          gradient:
                              const LinearGradient(colors: [Colors.white]));
                    });
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      String name = snapshot.data![index]['country'];
                      if (searchController.text.isEmpty) {
                        return InkWell(
                          onTap:  () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  name: snapshot.data![index]
                                  ['country'],
                                  image:snapshot.data![index]
                                  ['countryInfo']['flag'],
                                  totalCases:snapshot.data![index]
                                  ['cases'],
                                  totalDeaths:snapshot.data![index]
                                  ["deaths"],
                                  totalRecovered:snapshot.data![index]
                                  ['recovered'],
                                  active:snapshot.data![index]
                                  ['active'],
                                  critical:snapshot.data![index]
                                  ['critical'],
                                  todayRecovered:snapshot.data![index]
                                  ['todayRecovered'],
                                  test:snapshot.data![index]
                                  ['tests'],
                                ),
                              ));
                        },
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(snapshot.data![index]['country']),
                                subtitle: Text(
                                    snapshot.data![index]['country'].toString()),
                                leading: Image(
                                  height: 50,
                                  width: 50,
                                  image: NetworkImage(
                                    snapshot.data![index]['countryInfo']['flag'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (name
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase())) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                    name: snapshot.data![index]
                                    ['country'],
                                    image:snapshot.data![index]
                                    ['countryInfo']['flag'],
                                    totalCases:snapshot.data![index]
                                    ['cases'],
                                    totalDeaths:snapshot.data![index]
                                    ["deaths"],
                                    totalRecovered:snapshot.data![index]
                                    ['recovered'],
                                    active:snapshot.data![index]
                                    ['active'],
                                    critical:snapshot.data![index]
                                    ['critical'],
                                    todayRecovered:snapshot.data![index]
                                    ['todayRecovered'],
                                    test:snapshot.data![index]
                                    ['tests'],
                                  ),
                                ));
                          },
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(snapshot.data![index]['country']),
                                subtitle: Text(
                                    snapshot.data![index]['country'].toString()),
                                leading: Image(
                                  height: 50,
                                  width: 50,
                                  image: NetworkImage(
                                    snapshot.data![index]['countryInfo']['flag'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    });
              }
            },
          ))
        ],
      )),
    );
  }
}
