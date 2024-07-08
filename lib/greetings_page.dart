import 'package:flutter/material.dart';

class GreetingsPage extends StatefulWidget {
  const GreetingsPage({super.key});

  @override
  State<GreetingsPage> createState() => _GreetingsPage();
}

class _GreetingsPage extends State<GreetingsPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 100,),
              Text('ÁtlagoSCH 2.0', style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),),
              Text('')
            ],
          ),
        ),
      )
    );
  }
}