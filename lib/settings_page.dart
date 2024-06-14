import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late int _creditDivisionNumber;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadCreditDivisionNumber();
    _controller.addListener(_saveCreditDivisionNumber);
  }

  Future<void> _loadCreditDivisionNumber() async {
    final prefs = await SharedPreferences.getInstance();
    _creditDivisionNumber = prefs.getInt('creditDivisionNumber') ?? 0;

    if(mounted){
      context.read<CreditDivisionNotifier>().setCreditDivisionNumber(_creditDivisionNumber);
    }
    _controller.text = _creditDivisionNumber.toString();
  }

  void _saveCreditDivisionNumber() async {
    final prefs = await SharedPreferences.getInstance();
    int value = int.tryParse(_controller.text) ?? 0;
    setState(() {
      _creditDivisionNumber = value;
    });
    await prefs.setInt('creditDivisionNumber', value);

    if(mounted){
      context.read<CreditDivisionNotifier>().setCreditDivisionNumber(value);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_saveCreditDivisionNumber);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Beállítások"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Ennyivel osztunk a kreditindex számításakor:',
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
    );
  }
}
