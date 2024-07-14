import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kreditindex_calculator/curricula.dart';
import 'package:kreditindex_calculator/subject.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'credit_division_notifier.dart';
import 'gradient_singleton.dart';

enum ThemeItem { light, dark, system }
enum CurriculumItem {bmeVikMi2022, bmeVikMi2014}

final Map<CurriculumItem, String> curriculumMap = {
  CurriculumItem.bmeVikMi2022 : 'BME VIK mérnökinformatikus 2022',
  CurriculumItem.bmeVikMi2014 : 'BME VIK mérnökinformatikus 2014'
};

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _controller;

  bool isLoading = false;

  int _creditDivisionNumber = 0;
  final int _initialSemesterCount = 11;
  int _semesterCount = 11;
  final String _semesterCountKey = 'semestercount';
  final String _currentSemesterNumberKey = 'currentSemesterNumber';

  late SubjectList subjectList;

  ThemeItem? selectedThemeItem;
  CurriculumItem? selectedCurriculumItem;

  //Switch states for result cards
  bool _showCreditIndexCard = true;
  bool _showSummarizedCreditIndexCard = true;
  bool _showWeightedCreditIndexCard = true;
  bool _showAverageCard = true;

  @override
  void initState() {
    super.initState();

    subjectList = Provider.of<SubjectList>(context, listen: false);

    _controller = TextEditingController();
    _loadSettingsData();
    _controller.addListener(_saveSettingsData);
  }

  void _loadSettingsData() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();

    //loading divider value
    _creditDivisionNumber = prefs.getInt('creditDivisionNumber') ?? 0;

    if (mounted) {
      context
          .read<CreditDivisionNotifier>()
          .setCreditDivisionNumber(_creditDivisionNumber);
    }
    _controller.text = _creditDivisionNumber.toString();

    //loading switch states
    _showCreditIndexCard = prefs.getBool('creditIndexVisible') ?? true;
    _showSummarizedCreditIndexCard =
        prefs.getBool('summarizedCreditIndexVisible') ?? true;
    _showWeightedCreditIndexCard =
        prefs.getBool('weightedCreditIndexVisible') ?? true;
    _showAverageCard = prefs.getBool('averageVisible') ?? true;

    await loadSemesterCount();

    setState(() {
      isLoading = false;
    });
  }

  void _saveSettingsData() async {
    final prefs = await SharedPreferences.getInstance();

    //saving creditDivisionNumber
    int value = int.tryParse(_controller.text) ?? 0;
    setState(() {
      _creditDivisionNumber = value;
    });

    await prefs.setInt('creditDivisionNumber', value);

    if (mounted) {
      context.read<CreditDivisionNotifier>().setCreditDivisionNumber(value);
    }

    //saving switch preferences
    await prefs.setBool('creditIndexVisible', _showCreditIndexCard);
    await prefs.setBool(
        'summarizedCreditIndexVisible', _showSummarizedCreditIndexCard);
    await prefs.setBool(
        'weightedCreditIndexVisible', _showWeightedCreditIndexCard);
    await prefs.setBool('averageVisible', _showAverageCard);
  }

  Future<void> loadSemesterCount() async {
    var prefs = await SharedPreferences.getInstance();
    _semesterCount = prefs.getInt('semestercount') ?? 11;
  }

  Future<void> saveSemesterCount() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_semesterCountKey, _semesterCount);
  }

  //if a newly added semester was selected on the homepage and you delete it from settings, the current semester after going back will be the first
  Future<void> saveCurrentSemesterNumberAfterNewSemesterDeletion() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentSemesterNumberKey, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradientSingleton.getGradientInstance(context)
          ),
          child: AppBar(
            iconTheme: IconThemeData(color: Theme.of(context).primaryIconTheme.color,),
            backgroundColor: Colors.transparent,
            title: Text("Beállítások", style: TextStyle(color: Theme.of(context).primaryIconTheme.color),),
            leading: BackButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Kreditindex számításnál használt osztó értéke:',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      ...showCreditIndexDividerTextField(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Megjelenítendő panelek:',
                        style: TextStyle(fontSize: 18),
                      ),
                      ...showSwitchListTiles(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Téma kiválasztása',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      PopupMenuButton<ThemeItem>(
                        elevation: 3,
                        initialValue: selectedThemeItem,
                        onSelected: (ThemeItem item) {
                          setState(() {
                            selectedThemeItem = item;
                            switch(selectedThemeItem){
                              case ThemeItem.light:
                                AdaptiveTheme.of(context).setLight();
                              case ThemeItem.dark:
                                AdaptiveTheme.of(context).setDark();
                              case ThemeItem.system:
                                AdaptiveTheme.of(context).setSystem();
                              case null:
                                AdaptiveTheme.of(context).setLight();
                            }
                          });
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<ThemeItem>>[
                          const PopupMenuItem<ThemeItem>(
                            value: ThemeItem.light,
                            child: Text('Világos'),
                          ),
                          const PopupMenuItem<ThemeItem>(
                            value: ThemeItem.dark,
                            child: Text('Sötét'),
                          ),
                          const PopupMenuItem<ThemeItem>(
                            value: ThemeItem.system,
                            child: Text('Rendszer'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: double.infinity,),
                      const Text(
                        'Tanterv betöltése',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _showLoadCurriculumDialog(context);
                          },
                          child: Text(
                            'Tantervek megtekintése',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: double.infinity,),
                      const Text(
                        'Újonnan hozzáadott félév(ek) törlése',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      ElevatedButton(
                        //this button is only enabled when there are newly added semesters (>11)
                          onPressed: _semesterCount > _initialSemesterCount
                              ? () {
                            _showDeleteNewlyAddedSemestersDialog(context);
                          }
                              : null,
                          child: const Text(
                            'Új félévek törlése',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: double.infinity,),
                      const Text(
                        'Összes tantárgy törlése',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      ElevatedButton(
                          //this button is only enabled when the subject list is not empty
                          onPressed: subjectList.subjects.isNotEmpty
                              ? () {
                                  _showDeleteAllSubjectsDialog(context);
                                }
                              : null,
                          child: const Text(
                            'Törlés',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteAllSubjectsDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Biztosan törlöd az összes tárgyat?'),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      subjectList.removeAllSubjects();
                      Navigator.of(context).pop();
                    });
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

  Future<void> _showDeleteNewlyAddedSemestersDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Törlés megerősítése'),
            content: const Text('Biztosan törlöd az újonnan hozzáadott féléveket és az ott felvett tárgyakat?'),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      subjectList.removeNewSemesterSubjects(_initialSemesterCount);
                      _semesterCount = _initialSemesterCount;
                      saveSemesterCount();
                      saveCurrentSemesterNumberAfterNewSemesterDeletion();
                      Navigator.of(context).pop();
                    });
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

  Future<void> _showLoadCurriculumDialog(BuildContext context) async {
    List<Subject> selectedSubjectList = [];
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Tantervek'),
                content: SizedBox(
                  width: double.maxFinite,
                  height: 200,
                  child: ListView(
                    children: CurriculumItem.values.map((curriculumItem) {
                      bool isSelected = selectedCurriculumItem == curriculumItem;
                      return ListTile(
                        key: ValueKey(curriculumItem),
                        title: Text(curriculumMap[curriculumItem] ?? 'HIBA'),
                        tileColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
                        onTap: () {
                          setState(() {
                            selectedCurriculumItem = curriculumItem;
                            switch(selectedCurriculumItem) {
                              case CurriculumItem.bmeVikMi2022:
                                selectedSubjectList = Curricula.bmeVikMi2022;
                                break;
                              case CurriculumItem.bmeVikMi2014:
                                selectedSubjectList = Curricula.bmeVikMi2014;
                                break;
                              case null:
                              //do nothing
                                break;
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
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
                      subjectList.setSelectedCurriculumSubjectList(selectedSubjectList);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tantárgyak sikeresen betöltve!'))
                      );
                    },
                    child: const Text('Betölt'),
                  ),
                ],
              );
            }
        );
      },
    );
  }

  List<Widget> showCreditIndexDividerTextField() {
    List<Widget> textField = [
      TextField(
        controller: _controller,
        decoration: InputDecoration(
          errorText: _creditDivisionNumber <= 0
              ? '0-nál nagyobb érték kell'
              : null,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ], // Only numbers can be entered
        onChanged: (value) {
          setState(() {
            // Update the errorText dynamically based on the current input
            if (value.isNotEmpty) {
              int parsedValue = int.tryParse(value) ?? 0;
              _creditDivisionNumber = parsedValue;
              context
                  .read<CreditDivisionNotifier>()
                  .setCreditDivisionNumber(
                  _creditDivisionNumber);
            }
          });
        },
      ),
    ];

    List<Widget> progressIndicator = [
      const SizedBox(width: double.infinity,),
      const CircularProgressIndicator()
    ];

    return isLoading ? progressIndicator : textField;
  }

  List<Widget> showSwitchListTiles() {
    List<Widget> switchTiles = [
      SwitchListTile(
        title:
        const Text('Kreditindex az előző félévvel együtt'),
        value: _showSummarizedCreditIndexCard,
        onChanged: (value) {
          setState(() {
            _showSummarizedCreditIndexCard = value;
            _saveSettingsData();
          });
        },
      ),
      SwitchListTile(
        title: const Text('Kreditindex'),
        value: _showCreditIndexCard,
        onChanged: (value) {
          setState(() {
            _showCreditIndexCard = value;
            _saveSettingsData();
          });
        },
      ),
      SwitchListTile(
        title: const Text('Súlyozott kreditindex'),
        value: _showWeightedCreditIndexCard,
        onChanged: (value) {
          setState(() {
            _showWeightedCreditIndexCard = value;
            _saveSettingsData();
          });
        },
      ),
      SwitchListTile(
        title: const Text('Átlag'),
        value: _showAverageCard,
        onChanged: (value) {
          setState(() {
            _showAverageCard = value;
            _saveSettingsData();
          });
        },
      ),
    ];

    List<Widget> progressIndicator = [
      const SizedBox(width: double.infinity,),
      const CircularProgressIndicator()
    ];

    return isLoading ? progressIndicator : switchTiles;
  }

  @override
  void dispose() {
    _controller.removeListener(_saveSettingsData);
    _controller.dispose();
    super.dispose();
  }
}
