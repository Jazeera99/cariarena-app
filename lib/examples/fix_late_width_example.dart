import 'package:flutter/material.dart';

class FixLateWidthExample extends StatefulWidget {
  const FixLateWidthExample({Key? key}) : super(key: key);

  @override
  _FixLateWidthExampleState createState() => _FixLateWidthExampleState();
}

class _FixLateWidthExampleState extends State<FixLateWidthExample> {
  // Problematic declaration causing LateInitializationError:
  // late double width;

  @override
  Widget build(BuildContext context) {
    // Fix: assign width inside build method
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Fix Late Width Example')),
      body: Center(
        child: Container(
          width: width * 0.8, // Use width safely here
          height: 100,
          color: Colors.blue,
          child: const Center(
            child: Text(
              'Container with width 80% of screen',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
