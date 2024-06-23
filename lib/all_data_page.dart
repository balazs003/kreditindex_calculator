import 'package:flutter/material.dart';
import 'package:kreditindex_calculator/statistics.dart';
import 'package:kreditindex_calculator/subject.dart';
import 'package:provider/provider.dart';
import 'package:kreditindex_calculator/result_panel.dart';

class AllDataPage extends StatefulWidget {
  const AllDataPage({super.key});

  @override
  State<AllDataPage> createState() => _AllDataPageState();
}

class _AllDataPageState extends State<AllDataPage> {

  late SubjectList subjectList;
  late Statistics statistics;

  //Statistical cards shown on top
  late ResultPanel indexPanel;
  late ResultPanel averagePanel;
  late ResultPanel weightedPanel;

  //Keys to delegate state changing for resultpanel cards
  final GlobalKey<ResultPanelState> indexPanelKey = GlobalKey();
  final GlobalKey<ResultPanelState> averagePanelKey = GlobalKey();
  final GlobalKey<ResultPanelState> weightedPanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    subjectList = Provider.of<SubjectList>(context, listen: false);
    statistics = Statistics(newSubjectList: subjectList, newContext: context);

    indexPanel = ResultPanel(
        name: 'Kreditindex',
        initialValue: statistics.creditIndex,
        panelColor: Colors.blueAccent,
        key: indexPanelKey);
    weightedPanel = ResultPanel(
        name: 'Súlyozott kreditindex',
        initialValue: statistics.weightedCreditIndex,
        panelColor: Colors.deepOrangeAccent,
        key: weightedPanelKey);
    averagePanel = ResultPanel(
        name: 'Átlag',
        initialValue: statistics.average,
        panelColor: Colors.redAccent,
        key: averagePanelKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('Összesített adatok'),
      ),
      body: Consumer<SubjectList>(
        builder: (context, subjectList, child) =>
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Összes felvett kredit száma: ${5}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Összes teljesített kredit száma: ${6}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),

                      indexPanel,
                      const SizedBox(height: 10),

                      weightedPanel,
                      const SizedBox(height: 10),

                      averagePanel,
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}