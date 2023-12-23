import 'package:covid_tracker/Model/WorldStatesModel.dart';
import 'package:covid_tracker/Services/states_services.dart';
import 'package:covid_tracker/View/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({Key? key}) : super(key: key);

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    Colors.blue,
    Colors.green,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * .01,
              ),
              FutureBuilder(
                  future: statesServices.fetchWorldStatesRecords(),
                  builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)  {
                      return  Expanded(
                        child: SpinKitFadingCircle(
                          color: Colors.blue,
                          size: 50,
                          controller:_controller,
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          PieChart(
                            legendOptions: const LegendOptions(
                                legendPosition: LegendPosition.left),
                            animationDuration: const Duration(milliseconds: 1200),
                            chartRadius: MediaQuery.sizeOf(context).width / 3.2,
                            dataMap: {
                              "Total":
                                  double.parse(snapshot.data!.cases!.toString()),
                              "Recovered": double.parse(
                                  snapshot.data!.recovered!.toString()),
                              "Deaths":
                                  double.parse(snapshot.data!.deaths!.toString()),
                            },
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValuesInPercentage: true,
                            ),
                            chartType: ChartType.ring,
                            colorList: colorList,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.sizeOf(context).height * .06),
                            child: Card(
                              child: Column(
                                children: [
                                  ReuseAbleRow(
                                      title: "Total",
                                      value: snapshot.data!.cases!.toString()),
                                  ReuseAbleRow(
                                      title: "Recovered",
                                      value:
                                          snapshot.data!.recovered!.toString()),
                                  ReuseAbleRow(
                                      title: "Deaths",
                                      value: snapshot.data!.deaths!.toString()),
                                  ReuseAbleRow(
                                      title: "Active",
                                      value: snapshot.data!.active!.toString()),
                                  ReuseAbleRow(
                                      title: "Critical",
                                      value: snapshot.data!.critical!.toString()),
                                  ReuseAbleRow(
                                      title: "Total Deaths",
                                      value:
                                          snapshot.data!.todayDeaths!.toString()),
                                  ReuseAbleRow(
                                      title: "Total Recovered",
                                      value: snapshot.data!.todayRecovered!
                                          .toString()),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CountriesListScreen()));
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text("Track Countries"),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ReuseAbleRow extends StatelessWidget {
  String title, value;

  ReuseAbleRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
