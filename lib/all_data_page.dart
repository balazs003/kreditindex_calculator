import 'package:flutter/material.dart';
import 'package:kreditindex_calculator/statistics.dart';
import 'package:kreditindex_calculator/subject.dart';
import 'package:provider/provider.dart';
import 'package:kreditindex_calculator/result_panel.dart';

import 'alldata_statistics.dart';
import 'commondatacard.dart';

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

  @override
  void initState() {
    super.initState();

    subjectList = Provider.of<SubjectList>(context, listen: false);
    statistics = AllDataStatistics(newSubjectList: subjectList, newContext: context);

    //method parameter doesn't matter here
    statistics.calculateAllData(0);

    indexPanel = ResultPanel(
        name: 'Összesített kreditindex',
        initialValue: statistics.creditIndex,
        panelColor: Colors.blueAccent);
    weightedPanel = ResultPanel(
        name: 'Összesített súlyozott kreditindex',
        initialValue: statistics.weightedCreditIndex,
        panelColor: Colors.deepOrangeAccent);
    averagePanel = ResultPanel(
        name: 'Összesített átlag',
        initialValue: statistics.average,
        panelColor: Colors.redAccent);
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
                      indexPanel,
                      const SizedBox(height: 10),

                      weightedPanel,
                      const SizedBox(height: 10),

                      averagePanel,
                      const SizedBox(height: 20),

                      CommonDataCard.showDataCard('Összes felvett kredit száma:', statistics.creditCount),
                      const SizedBox(height: 10),
                      CommonDataCard.showDataCard('Összes teljesített kredit száma:', statistics.finalCreditCount),
                      const SizedBox(height: 10),
                      CommonDataCard.showDataCard('Felvett szabadon választható tárgyak száma:', statistics.optionalSubjectCount),
                      const SizedBox(height: 10),
                      CommonDataCard.showDataCard('Szabadon választható tárgyakból származó kreditek:', statistics.optionalSubjectCreditCount),
                      const SizedBox(height: 10),
                      CommonDataCard.showDataCard('Bukások száma:', statistics.getFailedSubjectCount(), Colors.red),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}