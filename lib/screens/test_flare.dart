import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class FlareDemo extends StatefulWidget {
  @override
  _FlareDemoState createState() => _FlareDemoState();
}

class _FlareDemoState extends State<FlareDemo> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: FlareActor('assets/images/Liquid.flr',
            animation: "Untitled",
          ),
        ),
      ),
    );
  }
}