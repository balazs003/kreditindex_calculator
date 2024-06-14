import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kreditindex_calculator/subject.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'credit_division_notifier.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _controller;
  int _creditDivisionNumber = 0;
  late SubjectList subjectList;

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
    final prefs = await SharedPreferences.getInstance();

    //loading divider value
    _creditDivisionNumber = prefs.getInt('creditDivisionNumber') ?? 0;

    if(mounted){
      context.read<CreditDivisionNotifier>().setCreditDivisionNumber(_creditDivisionNumber);
    }
    _controller.text = _creditDivisionNumber.toString();

    //loading switch states
    _showCreditIndexCard = prefs.getBool('creditIndexVisible') ?? true;
    _showSummarizedCreditIndexCard = prefs.getBool('summarizedCreditIndexVisible') ?? true;
    _showWeightedCreditIndexCard = prefs.getBool('weightedCreditIndexVisible') ?? true;
    _showAverageCard = prefs.getBool('averageVisible') ?? true;
  }

  void _saveSettingsData() async {
    final prefs = await SharedPreferences.getInstance();

    //saving creditDivisionNumber
    int value = int.tryParse(_controller.text) ?? 0;
    setState(() {
      _creditDivisionNumber = value;
    });

    await prefs.setInt('creditDivisionNumber', value);

    if(mounted){
      context.read<CreditDivisionNotifier>().setCreditDivisionNumber(value);
    }

    //saving switch preferences
    await prefs.setBool('creditIndexVisible', _showCreditIndexCard);
    await prefs.setBool('summarizedCreditIndexVisible', _showSummarizedCreditIndexCard);
    await prefs.setBool('weightedCreditIndexVisible', _showWeightedCreditIndexCard);
    await prefs.setBool('averageVisible', _showAverageCard);
  }

  @override
  void dispose() {
    _controller.removeListener(_saveSettingsData);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Beállítások"),
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Kreditindex számításnál használt osztó értéke:',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          errorText: _creditDivisionNumber <= 0 ? '0-nál nagyobb érték kell' : null,
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
                              context.read<CreditDivisionNotifier>().setCreditDivisionNumber(_creditDivisionNumber);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch, // Ez biztosítja, hogy a gyerekek maximális szélességűek legyenek
                    children: [
                      const Text(
                        'Megjelenítendő panelek:',
                        style: TextStyle(fontSize: 18),
                      ),
                      SwitchListTile(
                        title: const Text('Kreditindex az előző félévvel együtt'),
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Összes tantárgy törlése',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      ElevatedButton(
                          //this button is only enabled when the subject list is not empty
                          onPressed: subjectList.subjects.isNotEmpty ? () {
                            _showDeleteAllSubjectsDialog(context);
                          } : null,
                          child: const Text(
                            'TÖRLÉS',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )
                      )
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
                    subjectList.removeAllSubjects();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Igen',
                    style: TextStyle(
                      color: Colors.red
                    ),
                  )
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Mégse')
              )
            ],
          );
        }
    );
  }

}
