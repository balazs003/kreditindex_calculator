import 'package:flutter/material.dart';
import 'package:kreditindex_calculator/subject.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'credit_division_notifier.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _creditCount = 0;
  SubjectList subjectList = SubjectList();
  late ResultPanel indexPanel;
  late ResultPanel averagePanel;
  late ResultPanel weightedPanel;
  final GlobalKey<_ResultPanelState> indexPanelKey = GlobalKey();
  final GlobalKey<_ResultPanelState> averagePanelKey = GlobalKey();
  final GlobalKey<_ResultPanelState> weightedPanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    indexPanel = ResultPanel(
        name: 'Kreditindex',
        initialValue: 0.0,
        panelColor: Colors.blueAccent,
        key: indexPanelKey);
    weightedPanel = ResultPanel(
        name: 'Súlyozott kreditindex',
        initialValue: 0.0,
        panelColor: Colors.deepOrangeAccent,
        key: weightedPanelKey);
    averagePanel = ResultPanel(
        name: 'Átlag',
        initialValue: 0.0,
        panelColor: Colors.redAccent,
        key: averagePanelKey);
  }

  void reCalculateCreditIndex(int creditDivisionNumber) {
    int sum = 0;
    for (var subject in subjectList.subjects) {
      sum += subject.weight * subject.grade;
    }

    double creditIndex = sum / creditDivisionNumber.toDouble();

    setState(() {
      indexPanelKey.currentState?.updateValue(creditIndex);
    });
  }

  void reCalculateAverage() {
    int sum = 0;
    for (var subject in subjectList.subjects) {
      sum += subject.grade;
    }

    double average = subjectList.size() == 0 ? 0.0 : sum / subjectList.size();

    setState(() {
      averagePanelKey.currentState?.updateValue(average);
    });
  }

  void reCalculateWeightedCreditIndex() {
    int sum = 0;
    for (var subject in subjectList.subjects) {
      sum += subject.weight * subject.grade;
    }

    double weightedCreditIndex =
        _creditCount == 0 ? 0.0 : sum / _creditCount.toDouble();

    setState(() {
      weightedPanelKey.currentState?.updateValue(weightedCreditIndex);
    });
  }

  void reCalculateAllData() {
    int creditDivisionNumber =
        context.read<CreditDivisionNotifier>().creditDivisionNumber;
    reCalculateCreditIndex(creditDivisionNumber);
    reCalculateAverage();
    reCalculateWeightedCreditIndex();
  }

  @override
  Widget build(BuildContext context) {
    int creditDivisionNumber =
        context.watch<CreditDivisionNotifier>().creditDivisionNumber;

    // Recalculate the credit index whenever the credit division number changes
    reCalculateCreditIndex(creditDivisionNumber);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Felvett kreditek száma: $_creditCount",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                indexPanel,
                const SizedBox(height: 10),
                weightedPanel,
                const SizedBox(height: 10),
                averagePanel,
                const SizedBox(height: 50),
                const Text(
                  "Tantárgyak:",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: subjectList.subjects.length,
                  itemBuilder: (BuildContext context, int index) {
                    Subject subject = subjectList.subjects[index];
                    return ListTile(
                      title: Text(subject.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Kredit: ${subject.weight}, Jegy: ${subject.grade}"),
                          Slider(
                            value: subject.grade.toDouble(),
                            min: 1,
                            max: 5,
                            divisions: 4,
                            label: subject.grade.toString(),
                            onChanged: (double value) {
                              setState(() {
                                subject.setGrade(value.toInt());
                                reCalculateAllData();
                              });
                            },
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _creditCount -= subject.weight;
                            subjectList.removeSubject(subject);
                            reCalculateAllData();
                          });
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showAddSubjectDialog(context);
                  },
                  child: const Text('Új tárgy felvétele'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to show a dialog for adding a new subject
  Future<void> _showAddSubjectDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController weightController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Új tárgy felvétele'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Név',
                ),
              ),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(
                  labelText: 'Kredit',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Mégse'),
            ),
            TextButton(
              onPressed: () {
                String name = nameController.text.trim();
                int weight = int.tryParse(weightController.text.trim()) ?? 0;
                int grade = 5;

                if (name.isNotEmpty && weight > 0) {
                  Subject newSubject = Subject(
                      newName: name, newWeight: weight, newGrade: grade);
                  setState(() {
                    subjectList.addSubject(newSubject);
                    _creditCount += weight;
                    reCalculateAllData();
                  });
                  Navigator.of(context).pop(); // Close dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'A kredit és jegy mezőkben helyes számérték kell szerepeljen!'),
                    ),
                  );
                }
              },
              child: const Text('Hozzáadás'),
            ),
          ],
        );
      },
    );
  }
}

class ResultPanel extends StatefulWidget {
  final String name;
  late double initialValue;
  final Color panelColor;

  ResultPanel(
      {Key? key,
      required this.name,
      required this.initialValue,
      required this.panelColor})
      : super(key: key);

  @override
  _ResultPanelState createState() => _ResultPanelState();
}

class _ResultPanelState extends State<ResultPanel> {
  late double value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  void updateValue(double newValue) {
    setState(() {
      value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: widget.panelColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            value.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30.0,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
