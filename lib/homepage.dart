import 'package:flutter/material.dart';
import 'package:kreditindex_calculator/statistics.dart';
import 'package:kreditindex_calculator/subject.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kreditindex_calculator/result_panel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late int currentSemester = 1;
  int semesterCount = 11;
  String currentSemesterNumberKey = 'currentSemesterNumber';

  late SubjectList subjectList;
  late Statistics statistics;

  //Statistical cards shown on top
  late ResultPanel indexPanel;
  late ResultPanel summarizedIndexPanel;
  late ResultPanel averagePanel;
  late ResultPanel weightedPanel;

  //Keys to delegate state changing for resultpanel cards
  final GlobalKey<ResultPanelState> indexPanelKey = GlobalKey();
  final GlobalKey<ResultPanelState> summarizedIndexPanelKey = GlobalKey();
  final GlobalKey<ResultPanelState> averagePanelKey = GlobalKey();
  final GlobalKey<ResultPanelState> weightedPanelKey = GlobalKey();

  //Switch states for result cards
  bool _showCreditIndexCard = true;
  bool _showSummarizedCreditIndexCard = true;
  bool _showWeightedCreditIndexCard = true;
  bool _showAverageCard = true;

  @override
  void initState() {
    super.initState();

    subjectList = Provider.of<SubjectList>(context, listen: false);
    //IMPORTANT: setting current semester value for subjectlist is done in loadAllData() meththod
    statistics = Statistics(newSubjectList: subjectList, newContext: context);

    indexPanel = ResultPanel(
        name: 'Kreditindex',
        initialValue: statistics.creditIndex,
        panelColor: Colors.blueAccent,
        key: indexPanelKey);
    summarizedIndexPanel = ResultPanel(
      name: 'Kreditindex a korábbi félévvel együtt',
      initialValue: statistics.summarizedCreditIndex,
      panelColor: Colors.deepPurpleAccent,
      key: summarizedIndexPanelKey);
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

    loadAllSavedData().then((_) {
      //Delay is needed for all data to be loaded so the content of the cards can be shown
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          updateAllData();
        });
      });
    });
  }

  Future<void> loadAllSavedData() async {
    await loadCurrentSemesterNumber();
    await loadSavedSubjectData();
    await loadSavedCardVisibilityData();

    //setting the data to show currently
    setState(() {
      subjectList.setCurrentSemesterNumber(currentSemester);
    });
  }

  Future<void> saveCurrentSemesterNumber() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt(currentSemesterNumberKey, currentSemester);
  }

  Future<void> loadCurrentSemesterNumber() async {
    var prefs = await SharedPreferences.getInstance();
    currentSemester = prefs.getInt(currentSemesterNumberKey) ?? 1;
  }

  Future<void> loadSavedCardVisibilityData() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      _showCreditIndexCard = prefs.getBool('creditIndexVisible') ?? true;
      _showSummarizedCreditIndexCard =
          prefs.getBool('summarizedCreditIndexVisible') ?? true;
      _showWeightedCreditIndexCard =
          prefs.getBool('weightedCreditIndexVisible') ?? true;
      _showAverageCard = prefs.getBool('averageVisible') ?? true;
    });
  }

  Future<void> loadSavedSubjectData() async {
    await subjectList.loadSubjectsFromDatabase();
    setState(() {
      updateAllData();
    });
  }

  Color getSubjectColor(bool sure) {
    return sure ? Colors.green : Colors.orangeAccent;
  }

  IconData getSubjectIcon(bool sure) {
    return sure ? Icons.bookmark_added : Icons.bookmark;
  }

  void updateAllData() {
    statistics.calculateAllData(currentSemester);
    setPanelData();
  }

  void setPanelData() {
    setState(() {
      indexPanelKey.currentState?.updateValue(statistics.creditIndex);
      summarizedIndexPanelKey.currentState?.updateValue(statistics.summarizedCreditIndex);
      weightedPanelKey.currentState?.updateValue(statistics.weightedCreditIndex);
      averagePanelKey.currentState?.updateValue(statistics.average);
    });
  }

  List<Widget> buildSemesterList(int semesterCount){
    List<Widget> semesters = [];
    for(int i=1; i<=semesterCount; i++){
      semesters.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text('$i. félév',
            style: TextStyle(
                fontSize: 17,
                color: i == currentSemester ? Colors.white : const TextStyle().color,
                fontWeight: i == currentSemester ? FontWeight.bold : FontWeight.normal,
            ),),
            onTap: () {
              onTapSemester(i);
            },
            tileColor: i == currentSemester ? Colors.green : const CardTheme().color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: i == currentSemester ? const BorderSide(color: Colors.green, width: 2) : const BorderSide(color: Colors.green, width: 2)
            ),
          ),
        )
      );
    }

    return semesters;
  }

  void onTapSemester(int semesterNumber){
    currentSemester = semesterNumber;
    saveCurrentSemesterNumber();
    subjectList.setCurrentSemesterNumber(currentSemester);
    updateAllData();
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('$currentSemester. félév'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/alldata');
            },
            icon: const Icon(Icons.poll),
            tooltip: 'Összesített adatok',
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings').then((_) async {
                await loadAllSavedData().then((_) {
                  //Delay is needed for all data to be loaded so the content of the cards can be shown
                  Future.delayed(const Duration(milliseconds: 200), () {
                    setState(() {
                      updateAllData();
                    });
                  });
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
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 40),
          children: [
            //wrapped int Theme widget to make divider line transparent
            Theme(
              data: Theme.of(context).copyWith(dividerTheme: const DividerThemeData(color: Colors.transparent)),
              child: UserAccountsDrawerHeader(
                accountName: const Text('ÁtlagoSCH 2.0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                accountEmail: const Text('Fejlesztette: balazs003'),
                currentAccountPicture: const Icon(Icons.account_circle_rounded, color: Colors.white, size: 70,),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Colors.green,
                      Color(0xff64c200),
                      Color(0xff8cb900),
                      Color(0xffabae00),
                      Color(0xffc6a100),
                      Color(0xffdd9300),
                      Color(0xfff08400),
                      Color(0xffff7411),
                    ], // Gradient from https://learnui.design/tools/gradient-generator.html
                    tileMode: TileMode.mirror,
                  ),
                ),
              ),
            ),
            ...buildSemesterList(semesterCount)
          ],
        ),
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
                    "Felvett kreditek száma: ${statistics.creditCount}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Teljesített kreditek száma: ${statistics.finalCreditCount}",
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
                  ReorderableListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        //Generic reordable behavior
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        subjectList.reorderSubjects(newIndex, oldIndex);
                      });
                    },
                    children: List.generate(subjectList.filteredSubjects.length, (index) {
                      Subject subject = subjectList.filteredSubjects[index];
                      return Padding(
                        key: Key(subject.id.toString()),
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Slidable(
                          key: Key(subject.id.toString()),
                          startActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                  onPressed: (BuildContext context) {
                                    _showEditSubjectDialog(context, subject);
                                  },
                                  borderRadius: BorderRadius.circular(15),
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Szerkesztés')
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (BuildContext context) {
                                  _showDeletionReassuranceDialog(
                                      context, subject);
                                },
                                borderRadius: BorderRadius.circular(15),
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Törlés',
                              )
                            ],
                          ),
                          child: Card(
                            margin: EdgeInsets.zero,
                            elevation: 4,
                            child: ListTile(
                              title: Text(
                                subject.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                        updateAllData();
                                      });
                                    },
                                    activeColor: getSubjectColor(subject.sure),
                                  ),
                                ],
                              ),
                              leading: IconButton(
                                icon: Icon(
                                  getSubjectIcon(subject.sure),
                                  size: 30,
                                  color: getSubjectColor(subject.sure),
                                ),
                                onPressed: () {
                                  setState(() {
                                    subject.setSure();
                                  });
                                },
                                tooltip: 'Biztos vagyok benne',
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
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
                      subjectList.removeSubject(subject);
                      updateAllData();
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

  Future<void> _showSubjectDialog(BuildContext context,
      {Subject? subject}) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController weightController = TextEditingController();

    if (subject != null) {
      nameController.text = subject.name;
      weightController.text = subject.weight.toString();
    }

    bool isCreditValid = true;
    bool isNameEmpty = false;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(subject == null
                  ? 'Új tárgy felvétele'
                  : 'Tárgy szerkesztése'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Név',
                      errorText: isNameEmpty
                          ? 'A név nem lehet üres!'
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        isNameEmpty = value.isEmpty;
                      });
                    },
                  ),
                  TextField(
                    controller: weightController,
                    decoration: InputDecoration(
                      labelText: 'Kredit',
                      errorText: isCreditValid
                          ? null
                          : 'Egy vagy két számjegyet írj be!',
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
                  onPressed: isNameEmpty || !isCreditValid
                      ? null
                      : () {
                          setState(() {
                            isCreditValid =
                                creditValidation(weightController.text);
                            isNameEmpty = nameController.text.isEmpty;
                          });

                          String name = nameController.text.trim();
                          int weight =
                              int.tryParse(weightController.text) ?? 200;
                          int grade = 5;
                          bool sure = true;
                          int seqnum = subjectList.size();
                          int id = -1;

                          //values depend on what you modify in the dialog
                          if (subject != null) {
                            id = subject.id;
                            name = nameController.text.trim();
                            weight = int.tryParse(weightController.text) ?? 200;
                            grade = subject.grade;
                            sure = subject.sure;
                            seqnum = subject.seqnum;
                          }

                          if (!isNameEmpty && isCreditValid) {
                            //Necessary to create new subject here and also to set seqnum, although it could be handled by subjectlist class, but this way it's consistent
                            Subject newSubject = Subject(
                                newId: id,
                                newName: name,
                                newWeight: weight,
                                newGrade: grade,
                                newSure: sure,
                                newSeqnum: seqnum,
                                newSemester: currentSemester);

                            setState(() {
                              if (subject == null) {
                                //Adding new subject
                                subjectList.addSubject(newSubject);
                              } else {
                                //Editing old subject
                                subjectList.modifySubject(subject, newSubject);
                              }
                              updateAllData();
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

  Future<void> _showEditSubjectDialog(
      BuildContext context, Subject oldSubject) async {
    return _showSubjectDialog(context, subject: oldSubject);
  }
}
