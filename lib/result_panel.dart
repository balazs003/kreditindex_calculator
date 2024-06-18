import 'package:flutter/material.dart';

class ResultPanel extends StatefulWidget {
  final String name;
  late double initialValue;
  final Color panelColor;

  ResultPanel(
      {super.key,
        required this.name,
        required this.initialValue,
        required this.panelColor});

  get onTap => null;

  @override
  ResultPanelState createState() => ResultPanelState();
}

class ResultPanelState extends State<ResultPanel> {
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
  ClickableResultPanelState createState() => ClickableResultPanelState();
}

class ClickableResultPanelState extends ResultPanelState {
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