import 'package:flutter/material.dart';
import 'package:kreditindex_calculator/subject.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'credit_division_notifier.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _creditCount = 0;
  int _finalCreditCount = 0;

  //earlier creditIndex
  double _earlierCreditIndex = 0.0;

  late SubjectList subjectList;
  late ResultPanel indexPanel;
  late ResultPanel summarizedIndexPanel;
  late ResultPanel averagePanel;
  late ResultPanel weightedPanel;
  final GlobalKey<_ResultPanelState> indexPanelKey = GlobalKey();
  final GlobalKey<_ResultPanelState> summarizedIndexPanelKey = GlobalKey();
  final GlobalKey<_ResultPanelState> averagePanelKey = GlobalKey();
  final GlobalKey<_ResultPanelState> weightedPanelKey = GlobalKey();

  //Switch states for result cards
  bool _showCreditIndexCard = true;
  bool _showSummarizedCreditIndexCard = true;
  bool _showWeightedCreditIndexCard = true;
  bool _showAverageCard = true;

  @override
  void initState() {
    super.initState();

    subjectList = Provider.of<SubjectList>(context, listen: false);

    indexPanel = ResultPanel(
        name: 'Kreditindex',
        initialValue: 0.0,
        panelColor: Colors.blueAccent,
        key: indexPanelKey);
    summarizedIndexPanel = ClickableResultPanel(
      name: 'Kreditindex a korábbi félévvel együtt',
      initialValue: 0.0,
      panelColor: Colors.deepPurpleAccent,
      key: summarizedIndexPanelKey,
      onTap: () => _showSetEarlierCreditIndex(context),
    );
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

    loadSavedSubjectData();
    loadSavedCardVisibilityData();
    loadEarlierCreditIndex();
  }

  void loadSavedCardVisibilityData() async {
    var prefs = await SharedPreferences.getInstance();
    _showCreditIndexCard = prefs.getBool('creditIndexVisible') ?? true;
    _showSummarizedCreditIndexCard =
        prefs.getBool('summarizedCreditIndexVisible') ?? true;
    _showWeightedCreditIndexCard =
        prefs.getBool('weightedCreditIndexVisible') ?? true;
    _showAverageCard = prefs.getBool('averageVisible') ?? true;
  }

  void loadSavedSubjectData() async {
    await subjectList.loadSubjectsFromPrefs();
    setState(() {
      _creditCount = subjectList.calculateTotalWeight();
      reCalculateAllData();
    });
  }

  Color getSubjectColor(bool sure) {
    return sure ? Colors.green : Colors.orangeAccent;
  }

  IconData getSubjectIcon(bool sure) {
    return sure ? Icons.bookmark_added : Icons.bookmark;
  }

  void reCalculateFinalCreditCount() {
    _finalCreditCount = _creditCount;

    for (var subject in subjectList.subjects) {
      if (subject.grade < 2) {
        _finalCreditCount -= subject.weight;
      }
    }
  }

  void reCalculateCreditIndex(int creditDivisionNumber) {
    int sum = 0;
    for (var subject in subjectList.subjects) {
      if (subject.grade > 1) {
        sum += subject.weight * subject.grade;
      }
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
      if (subject.grade > 1) {
        sum += subject.weight * subject.grade;
      }
    }

    double weightedCreditIndex =
        _creditCount == 0 ? 0.0 : sum / _creditCount.toDouble();

    setState(() {
      weightedPanelKey.currentState?.updateValue(weightedCreditIndex);
    });
  }

  void reCalculateSummarizedCreditIndex(int creditDivisionNumber) {
    int sum = 0;
    for (var subject in subjectList.subjects) {
      if (subject.grade > 1) {
        sum += subject.weight * subject.grade;
      }
    }

    double creditIndex = sum / creditDivisionNumber.toDouble();

    double summarizedCreditIndex = (creditIndex + _earlierCreditIndex) / 2.0;

    setState(() {
      summarizedIndexPanelKey.currentState?.updateValue(summarizedCreditIndex);
    });
  }

  void reCalculateAllData() {
    int creditDivisionNumber =
        context.read<CreditDivisionNotifier>().creditDivisionNumber;
    reCalculateCreditIndex(creditDivisionNumber);
    reCalculateSummarizedCreditIndex(creditDivisionNumber);
    reCalculateAverage();
    reCalculateWeightedCreditIndex();

    _creditCount = subjectList.calculateTotalWeight();
    reCalculateFinalCreditCount();

    //Saving data after every recalculation
    subjectList.saveSubjectsToPrefs();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings').then((_) {
                setState(() {
                  Navigator.pushReplacementNamed(context, '/');
                });
              });
            },
            icon: const Icon(Icons.settings),
            tooltip: 'Beállítások',
          ),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/info');
              },
              icon: const Icon(Icons.info),
              tooltip: 'Információ',
          )
        ],
      ),
      body: Consumer<SubjectList>(
        builder: (context, subjectList, child) => SingleChildScrollView(
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
                  Text(
                    "Teljesített kreditek száma: $_finalCreditCount",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),

                  //if summarizedCreditIndex is set to visible
                  if (_showSummarizedCreditIndexCard) summarizedIndexPanel,
                  if (_showSummarizedCreditIndexCard) const SizedBox(height: 10),

                  //if creditIndex is set to visible
                  if (_showCreditIndexCard) indexPanel,
                  if (_showCreditIndexCard) const SizedBox(height: 10),

                  //if weightedCreditIndex is set to visible
                  if (_showWeightedCreditIndexCard) weightedPanel,
                  if (_showWeightedCreditIndexCard) const SizedBox(height: 10),

                  //if average is set to visible
                  if (_showAverageCard) averagePanel,
                  if (_showAverageCard) const SizedBox(height: 50),
                  const Text(
                    "Tantárgyak:",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: subjectList.size(),
                    itemBuilder: (BuildContext context, int index) {
                      Subject subject = subjectList.subjects[index];
                      return Slidable(
                        key: Key(subject.name),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                                onPressed: (BuildContext context) {
                                  _showEditSubjectDialog(context, subject);
                                },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Szerkesztés'
                            )
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                                onPressed: (BuildContext context) {
                                  _showDeletionReassuranceDialog(context, subject);
                                },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Törlés',
                            )
                          ],
                        ),
                        child: Card(
                          elevation: 3,
                          child: ListTile(
                            title: Text(
                              subject.name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            textColor: getSubjectColor(subject.sure),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Kredit: ${subject.weight}, Jegy: ${subject.grade}",
                                  style: const TextStyle(fontSize: 18),
                                ),
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
                                  activeColor: getSubjectColor(subject.sure),
                                ),
                              ],
                            ),
                            leading: IconButton(
                              icon: Icon(getSubjectIcon(subject.sure),
                                  size: 30, color: getSubjectColor(subject.sure)),
                              onPressed: () {
                                setState(() {
                                  subject.setSure();
                                });
                              },
                              tooltip: 'Biztos vagyok benne',
                            ),
                          ),
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
      ),
    );
  }

  //Dialog with 2 buttons to delete a subject
  Future<void> _showDeletionReassuranceDialog(
      BuildContext context, Subject subject) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Biztosan törlöd?"),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      _creditCount -= subject.weight;
                      subjectList.removeSubject(subject);
                      reCalculateAllData();
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Igen',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Mégse'))
            ],
          );
        });
  }

  bool creditValidation(String value) {
    final validCreditRegex = RegExp(r'^\d{1,2}$');
    return validCreditRegex.hasMatch(value);
  }

  Future<void> _showSubjectDialog(BuildContext context, {Subject? subject}) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController weightController = TextEditingController();

    if (subject != null) {
      nameController.text = subject.name;
      weightController.text = subject.weight.toString();
    }

    bool isCreditValid = true;
    bool isNameUnique = true;
    bool isNameEmpty = false;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(subject == null ? 'Új tárgy felvétele' : 'Tárgy szerkesztése'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Név',
                      errorText: isNameEmpty ? 'A név nem lehet üres!' : (isNameUnique ? null : 'A név már létezik!'),
                    ),
                    onChanged: (value) {
                      setState(() {
                        isNameUnique = nameIsUnique(value);
                        isNameEmpty = value.isEmpty;
                      });
                    },
                  ),
                  TextField(
                    controller: weightController,
                    decoration: InputDecoration(
                      labelText: 'Kredit',
                      errorText: isCreditValid ? null : 'Egy vagy két számjegyet írj be!',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        isCreditValid = creditValidation(value);
                      });
                    },
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
                  onPressed: isNameEmpty || !isNameUnique || !isCreditValid ? null :() {
                    setState(() {
                      isCreditValid = creditValidation(weightController.text);
                      isNameUnique = nameIsUnique(nameController.text);
                      isNameEmpty = nameController.text.isEmpty;
                    });

                    String name = nameController.text.trim();
                    int weight = int.tryParse(weightController.text.trim()) ?? 0;

                    //values depend on what you modify in the dialog
                    if(subject != null){
                      name = name == subject.name ? subject.name : nameController.text.trim();
                      weight = weight == subject.weight ? subject.weight : int.tryParse(weightController.text.trim()) ?? 0;
                    }

                    if (name.isNotEmpty && isCreditValid) {
                      Subject newSubject = Subject(
                          newName: name, newWeight: weight, newGrade: subject?.grade ?? 5, newSure: subject?.sure ?? true);

                      setState(() {
                        if (subject == null) {
                          // Új tárgy felvétele
                          subjectList.addSubject(newSubject);
                          _creditCount += weight;
                        } else {
                          // Meglévő tárgy szerkesztése
                          subjectList.modifySubject(subject, newSubject);
                          _creditCount -= subject.weight;
                          _creditCount += weight;
                        }
                        reCalculateAllData();
                      });
                      Navigator.of(context).pop(); //Close dialog
                    }
                  },
                  child: Text(subject == null ? 'Hozzáadás' : 'Mentés'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showAddSubjectDialog(BuildContext context) async {
    return _showSubjectDialog(context);
  }

  Future<void> _showEditSubjectDialog(BuildContext context, Subject oldSubject) async {
    return _showSubjectDialog(context, subject: oldSubject);
  }

  void _showSetEarlierCreditIndex(BuildContext context) async {
    TextEditingController earlierCreditController =
        TextEditingController(text: _earlierCreditIndex.toString());
    bool hasError = false;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context,  setState) {
            return AlertDialog(
              title: const Text("Előző félévben a kreditindexed:"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                      controller: earlierCreditController,
                      decoration: InputDecoration(
                        labelText: 'Korábbi kreditindex',
                        errorText: hasError ? 'Helytelen érték!' : null,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        RegExp validInput = RegExp(r'^\d\.\d+$');
                        if (validInput.hasMatch(earlierCreditController.text)) {
                          setState(() {
                            hasError = false;
                            double parsedValue = double.tryParse(value) ?? 0.0;
                            _earlierCreditIndex = parsedValue;
                          });
                        } else {
                          setState(() {
                            hasError = true;
                          });
                        }
                      }),
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
                  onPressed: () async {
                    if (hasError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Ponttal elválasztott tizedes törtet írj be (pl.: 4.52)'),
                        ),
                      );
                    } else {
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      await prefs.setDouble(
                          'earlierCreditIndex', _earlierCreditIndex);
                      setState(() {
                        reCalculateAllData();
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'Mentés',
                  ),
                ),
              ],
            );
          },

        );
      },
    );
  }

  void loadEarlierCreditIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _earlierCreditIndex = prefs.getDouble('earlierCreditIndex') ?? 0.0;
    });
  }

  bool nameIsUnique(String name) {
    name = name.trim().toLowerCase();
    for (var subject in subjectList.subjects) {
      if (subject.name.toLowerCase() == name) {
        return false;
      }
    }
    return true;
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

  get onTap => null;

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

class ClickableResultPanel extends ResultPanel {
  @override
  final VoidCallback onTap;

  ClickableResultPanel({
    super.key,
    required super.name,
    required super.initialValue,
    required super.panelColor,
    required this.onTap,
  });

  @override
  _ClickableResultPanelState createState() => _ClickableResultPanelState();
}

class _ClickableResultPanelState extends _ResultPanelState {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
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
      ),
    );
  }
}
